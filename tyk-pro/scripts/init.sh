#!/usr/bin/env bash

set -e

apk --no-cache add curl jq
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

/opt/scripts/wait-for-it.sh -t 120 $TYK_DASHBOARD_SVC.$TYK_POD_NAMESPACE.svc.cluster.local:$TYK_DB_LISTENPORT && \
/opt/scripts/bootstrap.sh
