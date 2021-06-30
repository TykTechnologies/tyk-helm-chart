## Tyk Hybrid
Provides a Tyk Installation for Hybrid Gateways connected to Tyk Cloud or MDCB Hybrid Gateways

### Installation
```
helm repo add tyk-helm https://helm.tyk.io/public/helm/charts/
helm repo update
```

Before we proceed with installation of the chart we need to set some custom values. To see what options are configurable on a chart and save that options to a custom values.yaml file run:
```
helm show values tyk-helm/tyk-hybrid > values.yaml
```

*For Tyk-hybrid chart we need to modify following values in your custom values.yaml file:*
1. Add your dashboard users organisation ID in `gateway.rpc.rpcKey` value
2. Add your dashboard users API key in `gateway.rpc.apiKey` value
3. Add your connection string to allow the Hybrid gateway to connect to your control plane in `gateway.rpc.connString`. On the Tyk Cloud Console find this value in the endpoints panel for your control plane deployment.

Then we can install the chart using our custom values file:
```
helm install tyk-hybrid tyk-helm/tyk-hybrid -f values.yaml -n tyk
```
> If you are using hybrid gateway with the Tyk Classic Cloud use the rpc settings block commented out in the `values.yaml`.
