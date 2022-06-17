#!/usr/bin/env bash

if [[ -z ${TYK_DB_LICENSEKEY} ]]
then
    echo "Dashboard license is empty. Please provide your dashboard license by setting (.Values.dash.license)." 1>&2
    exit 1
fi

apk --no-cache add jq

check_jwt_type() {
    typ=$(jq -R 'split(".") | .[0] | @base64d | fromjson | .typ  ' <<< ${1} | xargs echo | awk '{print tolower($0)}')
    if [[ $typ != "jwt" ]]
    then
        echo "Expected type of the dashboard license 'jwt', got '${typ}'" 1>&2
        exit 1
    fi
}

check_expiry_date() {
    token_exp=$(jq -R 'split(".") | .[1] | @base64d | fromjson | .exp ' <<< ${1})
    current_date=$(date +%s)

    if [ $current_date -gt $token_exp ]
    then
        echo "Your dashboard license has expired at $(date -r ${token_exp})." 1>&2
        exit 1
    fi
}

wait_for_liveness () {
  attempt_count=0
  pass="pass"

  echo "Waiting for Gateway, Dashboard and Redis to be up and running"

  while true
  do
   attempt_count=$((attempt_count+1))

   # Check Gateway, Redis and Dashboard status
   local hello=$(CURL_CA_BUNDLE=$CURL_CA_BUNDLE_TYK curl "$GATEWAY_ADDRESS"/hello -s)
   local gw_status=$(echo "$hello" | jq -r '.status')
   local dash_status=$(echo "$hello" | jq -r '.details.dashboard.status')
   local redis_status=$(echo "$hello" | jq -r '.details.redis.status')

   if [[ "$gw_status" = "$pass" ]] && [[ "$dash_status" = "$pass" ]] && [[ "$redis_status" = "$pass" ]]
   then
     echo "Attempt $attempt_count succeeded: Gateway, Dashboard and Redis all running";
     break
   else
     echo "Attempt $attempt_count unsuccessful: gw status = '$gw_status', dashboard status = '$dash_status', redis status = '$redis_status'"
   fi

   sleep 2
  done
}

check_jwt_type $TYK_DB_LICENSEKEY
check_expiry_date $TYK_DB_LICENSEKEY

set -e
apk --no-cache add curl
wait_for_liveness

curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

while [[ $(kubectl get pod -n $TYK_POD_NAMESPACE -l app=$TYK_DASHBOARD_DEPLOY -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}') != "True" ]]; do sleep 10; done && \
/opt/scripts/bootstrap.sh
