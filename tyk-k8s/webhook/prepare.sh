#!/bin/bash
webhook/create-signed-cert.sh
cat ./webhook/mutatingwebhook.yaml | ./webhook/webhook-patch-ca-bundle.sh > ./webhook/mutatingwebhook-ca-bundle.yaml
