apk --no-cache add curl jq

TYK_GW_ADDR="http://gateway-svc-tyk-headless.tyk.svc.cluster.local:443"
DASHBOARD_HOSTNAME="$TYK_DASHBOARD_PROTO://$TYK_DASHBOARD_SVC.$TYK_POD_NAMESPACE.svc.cluster.local:$TYK_DB_LISTENPORT"
TYK_GW_SECRET=${TYK_GW_SECRET}

checkGateway() {
  healthCheck="$(curl -sS ${TYK_GW_ADDR}/hello 2>/dev/null)"
  result=$(echo "${healthCheck}" | jq -r '.details.redis.status')

  if [[ "${result}" != "pass" ]]
  then
    echo "All components required for the Tyk Gateway to work are not available"
    echo "${healthCheck}"
    exit 1
  fi

  echo "All components required for the Tyk Gateway to work are available"
}

createKeylessAPI() {
    curl -sS -H "x-tyk-authorization: ${TYK_GW_SECRET}" -H "Content-Type: application/json" -X POST \
      -d '{
        "name": "Hello-World",
        "use_keyless": true,
        "api_id": "random",
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
    }' ${TYK_GW_ADDR}/tyk/apis

    if [[ $? -ne 0 ]]; then
      echo "fail to create API"
      exit 1
    fi

    echo "API is created successfully"

    reloadGateway
}

createPolicy() {
    curl -X POST -H "x-tyk-authorization: ${TYK_GW_SECRET}" \
      -s \
      -H "Content-Type: application/json" \
      -X POST \
      -d '{
        "allowance": 1000,
        "rate": 1000,
        "per": 1,
        "expires": -1,
        "quota_max": -1,
        "org_id": "1",
        "quota_renews": 1449051461,
        "quota_remaining": -1,
        "quota_renewal_rate": 60,
        "access_rights": {
          "random": {
            "api_id": "random",
            "api_name": "Hello-World",
            "versions": ["Default"]
          }
        },
        "meta_data": {}
      }' ${TYK_GW_ADDR}/tyk/keys/create

    if [[ $? -ne 0 ]]; then
      echo "failed to create Policy"
      exit 1
    fi

    echo "Policy is created successfully"

    reloadGateway
}

reloadGateway() {
  curl -H "x-tyk-authorization: ${TYK_GW_SECRET}" -s ${TYK_GW_ADDR}/tyk/reload/group

  if [[ $? -ne 0 ]]; then
    echo "failed to reload Gateway"
    exit 1
  fi

  echo "Tyk Gateway is reloaded successfully"
}

clean() {
  curl -X DELETE -H "x-tyk-authorization: ${TYK_GW_SECRET}" -s ${TYK_GW_ADDR}/tyk/apis/random

  if [[ $? -ne 0 ]]; then
    echo "failed to delete API"
    exit 1
  fi

  echo "API deleted successfully"
}

main() {
  checkGateway
  createKeylessAPI
  createPolicy
  clean
}

main