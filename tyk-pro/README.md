## Tyk Self-managed
> [!WARNING]  
> `tyk-pro` has been deprecated. Please use our new Helm Chart for Tyk Stack at [tyk-stack](https://github.com/TykTechnologies/tyk-charts/tree/main/tyk-stack) or Tyk Control Plane at [tyk-control-plane](https://github.com/TykTechnologies/tyk-charts/tree/main/tyk-control-plane) instead.
> We recommend all users to migrate to the new Helm Chart. Please review the [Configuration](https://tyk.io/docs/product-stack/tyk-charts/tyk-stack-chart/#configuration) section of the new helm chart and cross-check with your existing configurations while planning for migration.

This chart provides a full Tyk API Management platform including Tyk Manager (Tyk dashboard), Tyk Gateway (OSS), Tyk pump
and MDCB (Multi Data-centre Bridge).

---

[Installation](https://tyk.io/docs/apim/open-source/installation/) || [Documentation](https://tyk.io/docs) || [Community Forum](https://community.tyk.io/)

---

## Prerequisites
Redis and MongoDB or PostgreSQL should already be installed or accessible by the gateway.

Check [Tyk Self-managed Helm chart Installation](https://tyk.io/docs/tyk-self-managed/tyk-helm-chart/) for the full details.

### Installation

    helm repo add tyk-helm https://helm.tyk.io/public/helm/charts/
    helm repo update

Before we proceed with installation of the chart we need to set some custom values.
To see what options are configurable on a chart and save that options to a custom values.yaml file run:

    helm show values tyk-helm/tyk-pro > values.yaml

For *Tyk Self-managed* chart we need to set the following in `values.yaml` or with `--set {field-name}={field-value}`with the helm install command:

|  | Description             | Field name          |
|--|-------------------------|---------------------|
|1.| License key             | `dash.license`      |
|2.| Mongodb root password   | in `mongo.mongoURL` |
|3.| Redis password          | `redis.pass`        |


Then we can install the chart using our custom values:

    helm install tyk-pro tyk-helm/tyk-pro -f values.yaml -n tyk --create-namespace --wait

> Please note the --wait argument is important for successful dashboard bootstrap.

Follow the instructions in the Notes that follow the installation to find your Tyk login credentials.

### Other component
Please refer to Tyk official docs for details about installation and setting [*TIB*](https://tyk.io/docs/tyk-self-managed/tyk-helm-chart/#tyk-identity-broker-tib),
[*Tyk Developer portal*](https://tyk.io/docs/tyk-self-managed/tyk-helm-chart/#tyk-developer-portal),
[*MDCB*](https://tyk.io/docs/tyk-self-managed/tyk-helm-chart/#installing-tyk-self-managed-control-plane) and
[*Istio*](https://tyk.io/docs/tyk-self-managed/istio/).
