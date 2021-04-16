## Tyk Pro
Provides a Tyk Installation for Hybrid Gateways connected to Tyk Cloud or MDCB Hybrid Gateways

### Installation
To install, *first modify `values.yaml` file inside tyk-hybrid chart as follows:*
1. Add your dashboard users organisation ID in `gateway.rpc.rpcKey` value
2. Add your dashboard users API key in `gateway.rpc.apiKey` value
3. Add your connection string to allow the Hybrid gateway to connect to your control plane in `gateway.rpc.connString`. On the Tyk Cloud Console find this value in the endpoints panel for your control plane deployment. 

Then run the following command from the root of the repository:

	helm install tyk-hybrid ./tyk-hybrid -n tyk

> If you are using hybrid gateway with the Tyk Classic Cloud use the rpc settings block commented out in the `values.yaml`.