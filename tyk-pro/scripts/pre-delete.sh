#!/usr/bin/env bash

set -e

apk --no-cache add curl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

if kubectl get secret -n "$TYK_POD_NAMESPACE" "$OPERATOR_SECRET_NAME"; then
    echo "$OPERATOR_SECRET_NAME exists in $TYK_POD_NAMESPACE namespace, deleting $OPERATOR_SECRET_NAME"
    kubectl delete secret -n "$TYK_POD_NAMESPACE" "$OPERATOR_SECRET_NAME"
else
    echo "$OPERATOR_SECRET_NAME does not exists in $TYK_POD_NAMESPACE namespace, skipping delete operation."
fi
