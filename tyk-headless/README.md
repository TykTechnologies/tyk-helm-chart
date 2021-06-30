## Tyk Community Edition
Provides a Tyk Installation for Community Edition Gateways

## YouTube: Install Tyk on Kubernetes

[![Install Tyk on Kubernetes](https://img.youtube.com/vi/mkyl38sBAF0/0.jpg)](https://www.youtube.com/watch?v=mkyl38sBAF0)

## Installation
	helm repo add tyk-helm https://helm.tyk.io/public/helm/charts/
	helm repo update
	helm install tyk-ce tyk-helm/tyk-headless -n tyk
