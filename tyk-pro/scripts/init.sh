#!/usr/bin/env bash

set -e

apk --no-cache add curl jq
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

while [[ $(kubectl get pod -n $TYK_POD_NAMESPACE -l app=$TYK_DASHBOARD_DEPLOY -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}') != "True" ]]; do sleep 10; done && \
/opt/scripts/bootstrap.sh
