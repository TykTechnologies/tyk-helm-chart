## Tyk OSS Gateway
This chart deploys the open source Tyk Gateway.

---

[Installation](https://tyk.io/docs/apim/open-source/installation/) || [Documentation](https://tyk.io/docs) || [Community Forum](https://community.tyk.io/) || [Releases](https://hub.docker.com/r/tykio/tyk-gateway/tags?page=1&ordering=last_updated)

---

## Prerequisites
Redis should already be installed or accessible by the gateway.

Check [Tyk OSS Helm chart Installation](https://tyk.io/docs/tyk-oss/ce-helm-chart/) for the full details.

## Installation

	helm repo add tyk-helm https://helm.tyk.io/public/helm/charts/
	helm repo update
	kubectl create namespace tyk
	helm install tyk-ce tyk-helm/tyk-headless -n tyk --create-namespace
