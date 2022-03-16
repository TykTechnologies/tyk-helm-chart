#!/usr/bin/env bash
set -ex

gcloud container clusters get-credentials platform --zone europe-west2-a --project firefly-devops-2018
#helm upgrade --install tyk-hybrid ./tyk-hybrid -f ./tyk-hybrid/values-with-ingress.yaml --set redis.pass=$TYK_REDIS_KEY \
#--set gateway.hostName=tyk-platform.paymentsense.tech --set gateway.rpc.connString=$TYK_CONN_STRING \
#--set gateway.rpc.rpcKey=$TYK_ORG_ID --set gateway.rpc.apiKey=$TYK_API_ACCESS_KEY \
#--set gateway.ingress.annotations.kubernetes.io/ingress.global-static-ip-name=platform-tyk-nginx -n tyk --wait

echo $TYK_ORG_ID
echo $TYK_CONN_STRING
echo $TYK_API_ACCESS_KEY
echo $TYK_REDIS_KEY