## Tyk Community Edition
Provides a Tyk Installation for Community Edition Gateways

## Installation
	helm repo add tyk-helm https://helm.tyk.io/public/helm/charts/
	helm repo update
	helm install tyk-ce tyk-helm/tyk-headless --version 0.9.1 -n tyk
