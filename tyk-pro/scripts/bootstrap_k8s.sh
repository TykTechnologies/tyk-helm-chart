#!/bin/bash

set -e

apk --no-cache add curl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

NAMESPACE=tyk

kubectl exec -it -n ${NAMESPACE} svc/dashboard-svc-tyk-pro -- ./tyk-analytics bootstrap --conf=/etc/tyk-dashboard/tyk_analytics.conf > bootstrapped

TYK_AUTH=$(awk -F ':' '/USER AUTHENTICATION CODE: /{ print $2 }' bootstrapped | tr -d '[:space:]')
TYK_ORG=$(awk -F ':' '/ORG ID: /{ print $2 }' bootstrapped | tr -d '[:space:]')
TYK_MODE=pro
TYK_URL=http://dashboard-svc-tyk-pro.tyk.svc.cluster.local:3000
TYK_USER=$(awk -F ':' '/User: /{ print $2 }' bootstrapped | tr -d '[:space:]')
TYK_PASS=$(awk -F ':' '/Pass: /{ print $2 }' bootstrapped | tr -d '[:space:]')

kubectl create secret -n ${NAMESPACE} generic tyk-operator-conf \
  --from-literal "TYK_AUTH=${TYK_AUTH}" \
  --from-literal "TYK_ORG=${TYK_ORG}" \
  --from-literal "TYK_MODE=${TYK_MODE}" \
  --from-literal "TYK_URL=${TYK_URL}"

kubectl create secret -n ${NAMESPACE} generic tyk-login-details \
  --from-literal "TYK_USER=${TYK_USER}" \
  --from-literal "TYK_PASS=${TYK_PASS}"
