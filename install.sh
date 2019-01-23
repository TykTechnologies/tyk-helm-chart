#!/bin/bash
set -e

helm install -f ./values.yaml ./tyk-pro

echo NODE_PORT=$(kubectl get --namespace {{ .Values.nameSpace }} -o jsonpath="{.spec.ports[0].nodePort}" services dashboard-{{ include "tyk-pro.fullname" . }})
echo NODE_IP=$(kubectl get nodes --selector=kubernetes.io/role!=master -o jsonpath={.items[0].status.addresses[?\(@.type==\"ExternalIP\"\)].address})
echo DASH_URL=http://$NODE_IP:$NODE_PORT

exit

./tyk-pro/scripts/bootstrap_k8s.sh $NODE_IP:$NODE_PORT {{ .Values.secrets.AdminSecret }} {{ .Values.nameSpace }}

mv ./tyk-pro/secret.tpl ./tyk-k8s/templates

./tyk-k8s/webhook/create-signed-cert.sh {{ .Values.nameSpace }}
cat ./webhook/mutatingwebhook.yaml | ./webhook/webhook-patch-ca-bundle.sh > ./webhook/mutatingwebhook-ca-bundle.yaml

helm install -f ./values.yaml ./tyk-k8s

kubectl create -f ./tyk-k8s/webhook/mutatingwebhook-ca-bundle.yaml