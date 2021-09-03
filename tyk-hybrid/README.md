## Tyk Hybrid
Provides a Tyk Installation for Hybrid Gateways connected to Tyk Cloud or MDCB Hybrid Gateways

[Installation](https://tyk.io/docs/apim/open-source/installation/) || [Documentation](https://tyk.io/docs) || [Community Forum](https://community.tyk.io/) || [Releases](https://hub.docker.com/r/tykio/tyk-gateway/tags?page=1&ordering=last_updated)

---

## Prerequisites
Redis should already be installed or accessible by the gateway.

Check [Tyk Hybrid Helm chart Installation](https://tyk.io/docs/tyk-cloud/environments-deployments/hybrid-gateways/#installing-hybrid-gateways-in-a-kubernetes-cluster) for the full details.

### Installation

    helm repo add tyk-helm https://helm.tyk.io/public/helm/charts/
    helm repo update


Before we proceed with installation of the chart we need to set some custom values. To see what options are configurable on a chart and save that options to a custom values.yaml file run:

   helm show values tyk-helm/tyk-hybrid > values.yaml


*For Tyk-hybrid chart we need to modify following values in your custom values.yaml file:*
1. Add your dashboard users organisation ID in `gateway.rpc.rpcKey` value
2. Add your dashboard users API key in `gateway.rpc.apiKey` value
3. Add your connection string to allow the Hybrid gateway to connect to your control plane in `gateway.rpc.connString`. On the Tyk Cloud Console find this value in the endpoints panel for your control plane deployment.

Then we can install the chart using our custom values file:

    helm install tyk-hybrid tyk-helm/tyk-hybrid -f values.yaml -n tyk --create-namespace

> If you are using hybrid gateway with the Tyk Classic Cloud use the rpc settings block commented out in the `values.yaml`
