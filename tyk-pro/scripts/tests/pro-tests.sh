apk --no-cache add curl jq

TYK_DB_ADDR="$TYK_DASHBOARD_PROTO://$TYK_DASHBOARD_SVC.$TYK_POD_NAMESPACE.svc.cluster.local:$TYK_DB_LISTENPORT"
TYK_GW_ADDR="$TYK_GATEWAY_PROTO://$TYK_GATEWAY_SVC.$TYK_POD_NAMESPACE.svc.cluster.local:$TYK_GW_LISTENPORT"

checkGatewayAndDashboard() {
  healthCheck="$(curl --fail -sS ${TYK_GW_ADDR}/hello 2>/dev/null)"
   if [[ $? -ne 0 ]]; then
     echo "failed to check liveness of GW"
     exit $?
   fi

  redisStatus=$(echo "${healthCheck}" | jq -r '.details.redis.status')
  if [[ "${redisStatus}" != "pass" ]]
  then
    echo "Gateway's Redis connection is not ready."
    echo "${healthCheck}"
    exit 1
  fi

  dashboardStatus=$(echo "${healthCheck}" | jq -r '.details.dashboard.status')
  if [[ "${dashboardStatus}" != "pass" ]]
  then
    echo "Dashboard connection is not ready."
    echo "${healthCheck}"
    exit 1
  fi

  echo "All components required for the Tyk Gateway to work are available"
}

createKeylessAPI() {
  reqBody='{
    "api_definition": {
       "name": "Hello-World2",
       "use_keyless": true,
       "org_id": "%s",
       "version_data": {
         "not_versioned": true,
         "versions": {
           "Default": {
             "name": "Default",
             "use_extended_paths": true
           }
         }
       },
       "proxy": {
         "listen_path": "/hello-world/",
         "target_url": "http://httpbin.org:8080/",
         "strip_listen_path": true
       },
       "active": true
      }
  }'

  reqBody=$(printf "$reqBody" "$ORGID")

  response=$(curl --fail-with-body -sS -H "Authorization: ${AUTH_CODE}" -H "Content-Type: application/json" -X POST \
    -d "$reqBody" ${TYK_DB_ADDR}/api/apis)
  if [[ $? -ne 0 ]]; then
    echo "failed to create API, $response"
    clean 1
  fi

  echo "$response"
  export API_ID=$(echo "$response" | jq -r '.Meta ')
}

createPolicy() {
  reqBody='{}'

  reqBody='{
   "name": "new policy",
   "quota_max": 60,
   "quota_renewal_rate": 60,
   "allowance": 100,
   "rate": 100,
   "per": 5
  }'

  response=$(curl --fail-with-body -sS -X POST -H "Authorization: ${AUTH_CODE}" -H "Content-Type: application/json" \
    -X POST -d "$reqBody" ${TYK_DB_ADDR}/api/portal/policies)
  if [[ $? -ne 0 ]]; then
    echo "failed to create Policy, $response"
    clean 1
  fi

  echo "Policy is created successfully"
}

createOrganisation(){
  reqBody='{"owner_name": "helm-test-org", "cname_enabled": true, "cname": "tyk-portal.local%s"}'
  reqBody=$(printf "$reqBody" "$RANDOM")
  response=$(curl --fail-with-body -sS -H "admin-auth: $TYK_AUTH" -H "Content-Type:application/json" --data "$reqBody" \
    $TYK_DB_ADDR/admin/organisations)

  if [[ $? -ne 0 ]]; then
    echo "failed to create organisation, $response"
    exit $?
  fi

  export ORGID=$(echo "$response" | jq -r '.Meta')
}

clean() {
  curl --fail -X DELETE -H "Authorization: ${AUTH_CODE}" ${TYK_DB_ADDR}/api/users/${USER_ID}

  if [[ $? -ne 0 ]]; then
    echo "failed to delete user"
    exit $?
  fi

  curl -XDELETE ${TYK_DB_ADDR}/admin/organisations/$ORGID -H "admin-auth: $TYK_AUTH"
  if [[ $? -ne 0 ]]; then
    echo "failed to delete organisation"
    exit $?
  fi

  exit $1
}

createUser() {
  reqBody='{"first_name": "test", "last_name": "helm", "email_address": "test-helm@mail.com", "active": true, "org_id": "%s", "user_permissions": { "IsAdmin": "admin" }}'
  reqBody=$(printf "$reqBody" "$ORGID")

  response=$(curl --fail -sS -H "admin-auth: $TYK_AUTH" -H "Content-Type:application/json" -d "$reqBody" $TYK_DB_ADDR/admin/users 2>&1)
  if [[ $? -ne 0 ]]; then
    echo "failed to create user"
    clean $?
  fi

  export AUTH_CODE=$(echo $response | jq -r '.Message')
  export USER_ID=$(echo $response | jq -r '.Meta.id')

  response=$(curl --silent --header "Authorization: $AUTH_CODE" --header "Content-Type:application/json" $TYK_DB_ADDR/api/users/$USER_ID/actions/reset --data '{"new_password":"1234testing", "user_permissions": { "IsAdmin": "admin" }}')
  if [[ $? -ne 0 ]]; then
    echo "failed to update user"
    clean $?
  fi
  echo "USER_ID $USER_ID"
}

main() {
  createOrganisation
  createUser
  checkGatewayAndDashboard
  createKeylessAPI
  createPolicy
  clean $?
}

main