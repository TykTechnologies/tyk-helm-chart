#!/usr/bin/env bash

set -e

apk --no-cache add curl jq
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

while [[ $(kubectl get po -n {{ .Release.Namespace }} -l app={{ include "dashboard.fullname" . }} -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}') != "True" ]]; do sleep 10; done &&
  /opt/scripts/bootstrap.sh
