#!/usr/bin/env bash

set -e
DASHBOARD_HOSTNAME="$TYK_DASHBOARD_PROTO://$TYK_DASHBOARD_SVC.$TYK_POD_NAMESPACE.svc.cluster.local:$TYK_DB_LISTENPORT"

main(){
  if [[ $# -lt 1 ]]
  then
    syntax_message
  else
    generate_credentials "$DASHBOARD_HOSTNAME"
    exit_reason "$?"
    if [ "$BOOTSTRAP_PORTAL" = "true" ]
    then
      create_portal
    fi
  fi
}

syntax_message(){
  echo 'SYNTAX ERROR: Usage `./bootstrap.sh DASHBOARD_HOSTNAME`'
  exit 1
}

generate_credentials(){
  error=0
  [[ -z "$1" ]] && return "6" || echo ""
  error="$?"
  [[ $error != 0 ]] && return $error
  echo "Creating Organisation"
  ORGDATA=$(create_organisation)
  error="$?"
  [[ $error != 0 ]] && return $error || echo "ORG DATA: $ORGDATA"
  export ORGID=$(org_id "$ORGDATA")
  error="$?"
  [[ $? != 0 ]] && return $error || echo "ORG ID: $ORGID"
  echo ""
  echo "Adding new user"
  export USER_AUTH_CODE=$(create_user $ORGID)
  error=$?
}

exit_reason(){
  case "$1" in
    "3")
      echo "ERROR: Unable to connect to the Dashboard. Please check that you are using the correct hostname."
      exit $1
      ;;
    "4")
      echo "ERROR: Unable to parse JSON"
      exit $1
      ;;
    "5")
      echo "Unexpected error"
      exit $1
      ;;
    "6")
      echo "ERROR: Hostname should not contain port number or protocol"
      ;;
    *)
      echo ""
      ;;
  esac
}

if_present_echo(){
  [[ -z "$1" ]] && return $2 || echo "$1"
}

create_organisation(){
  ORGDATA=$(curl --silent --header "admin-auth: $TYK_ADMIN_SECRET" --header "Content-Type:application/json" --data '{"owner_name": "'"$TYK_ORG_NAME"'", "cname_enabled": true, "cname": "'$TYK_ORG_CNAME'"}' $DASHBOARD_HOSTNAME/admin/organisations 2>&1)
  if_present_echo "$ORGDATA" 3
}

org_id(){
  ORGID=$(echo $1 | jq -r '.Meta')
  if_present_echo $ORGID 4
}

create_user(){
  USER_DATA=$(user_data $1)
  AUTH_CODE=$(echo $USER_DATA | jq -r '.Message')
  USER_ID=$(echo $USER_DATA | jq -r '.Meta.id')
  ## set user password
  response=$(curl --silent --header "authorization: $AUTH_CODE" --header "Content-Type:application/json" $DASHBOARD_HOSTNAME/api/users/$USER_ID/actions/reset --data '{"new_password":"'$TYK_ADMIN_PASSWORD'", "user_permissions": { "IsAdmin": "admin" }}')
  if_present_echo "$AUTH_CODE" 4
}

user_data(){
  user_curl=$(curl --silent --header "admin-auth: $TYK_ADMIN_SECRET" --header "Content-Type:application/json" --data '{"first_name": "'$TYK_ADMIN_FIRST_NAME'", "last_name": "'$TYK_ADMIN_LAST_NAME'", "email_address": "'$TYK_ADMIN_EMAIL'", "active": true, "org_id": "'$1'", "user_permissions": { "IsAdmin": "admin" }}' $DASHBOARD_HOSTNAME/admin/users 2>&1)
  if_present_echo $user_curl 3
}

create_portal(){
  log_message "Creating Portal for organisation $TYK_ORG_NAME"

  log_message "  Creating Portal default settings"
  log_json_result "$(curl $DASHBOARD_HOSTNAME/api/portal/configuration \
    -H "Authorization: $USER_AUTH_CODE" \
    -d "{}" 2>> bootstrap.log)"

  log_message "  Initialising Catalogue"
  result=$(curl $DASHBOARD_HOSTNAME/api/portal/catalogue \
    -H "Authorization: $USER_AUTH_CODE" \
    -d '{"org_id": "'$ORGID'"}' 2>> bootstrap.log)
  catalogue_id=$(echo "$result" | jq -r '.Message')
  log_json_result "$result"

  log_message "  Creating Portal home page"
  log_json_result "$(curl $DASHBOARD_HOSTNAME/api/portal/pages \
    -H "Authorization: $USER_AUTH_CODE" \
    -d '{
    "is_homepage": true,
    "template_name": "",
    "title": "Developer Portal Home",
    "slug": "/",
    "fields": {
      "JumboCTATitle": "Tyk Developer Portal",
      "SubHeading": "Sub Header",
      "JumboCTALink": "#cta",
      "JumboCTALinkTitle": "Your awesome APIs, hosted with Tyk!",
      "PanelOneContent": "Panel 1 content.",
      "PanelOneLink": "#panel1",
      "PanelOneLinkTitle": "Panel 1 Button",
      "PanelOneTitle": "Panel 1 Title",
      "PanelThereeContent": "",
      "PanelThreeContent": "Panel 3 content.",
      "PanelThreeLink": "#panel3",
      "PanelThreeLinkTitle": "Panel 3 Button",
      "PanelThreeTitle": "Panel 3 Title",
      "PanelTwoContent": "Panel 2 content.",
      "PanelTwoLink": "#panel2",
      "PanelTwoLinkTitle": "Panel 2 Button",
      "PanelTwoTitle": "Panel 2 Title"
    }
  }')"
}

log_message(){
  echo "$(date -u) $1"
}

log_json_result(){
  status=$(echo $1 | jq -r '.Status')
  if [ "$status" = "OK" ] || [ "$status" = "Ok" ]
  then
    log_ok
  else
    log_message "  ERROR: $(echo $1 | jq -r '.Message')"
    exit 1
  fi
}

log_ok(){
  log_message "  Ok"
}

if [ "$DASHBOARD_ENABLED" = "true" ] && [ "$BOOTSTRAP_DASHBOARD" = "true" ]
then
  main $DASHBOARD_HOSTNAME
fi

kubectl create secret -n ${TYK_POD_NAMESPACE} generic tyk-operator-conf \
  --from-literal "TYK_AUTH=${USER_AUTH_CODE}" \
  --from-literal "TYK_ORG=${ORGID}" \
  --from-literal "TYK_MODE=pro" \
  --from-literal "TYK_URL=${DASHBOARD_HOSTNAME}"

if [ "$DASHBOARD_ENABLED" = "true" ]
then
  # restart dashboard deployment
  kubectl rollout restart deployment/${TYK_DASHBOARD_DEPLOY}
fi
