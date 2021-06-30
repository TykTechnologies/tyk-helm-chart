## Tyk Hybrid
Provides a Tyk Installation for Hybrid Gateways connected to Tyk Cloud or MDCB Hybrid Gateways

### Installation
```
helm repo add tyk-helm https://helm.tyk.io/public/helm/charts/
helm repo update
```

Before we proceed with installation of the chart we need to set some custom values. To see what options are configurable on a chart use:
```
helm show values tyk-helm/tyk-hybrid
```

*For Tyk-hybrid chart we need to set custom values as per list below:*
1. Add your dashboard users organisation ID in `gateway.rpc.rpcKey` value
2. Add your dashboard users API key in `gateway.rpc.apiKey` value
3. Add your connection string to allow the Hybrid gateway to connect to your control plane in `gateway.rpc.connString`. On the Tyk Cloud Console find this value in the endpoints panel for your control plane deployment.

You can then override any of these settings in a YAML formatted file, and then pass that file during installation.
```
echo '{gateway.rpc.rpcKey: example-rpcKey, gateway.rpc.apiKey: example-apiKey, gateway.rpc.connString: example-connString}' > values.yaml
```
Then we can install the chart using our custom values:
```
helm install tyk-hybrid tyk-helm/tyk-hybrid -f values.yaml -n tyk
```
> If you are using hybrid gateway with the Tyk Classic Cloud use the rpc settings block commented out in the `values.yaml`.
