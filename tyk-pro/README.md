## Tyk Self-managed
This chart provides a full Tyk API Management platform including Tyk Manager (Tyk dashboard), Tyk Gateway (OSS), Tyk pump
and MDCB (Multi Data-centre Bridge).

---

[Installation](https://tyk.io/docs/apim/open-source/installation/) || [Documentation](https://tyk.io/docs) || [Community Forum](https://community.tyk.io/)

---

## Prerequisites
Redis and MongoDB should already be installed or accessible by the gateway.

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

### Kind as local k8s cluster
If you decide to use [*KIND*](https://kind.sigs.k8s.io/) as local k8s cluster you can rely on the following configuration in order to reach Tyk Gateway and Tyk Dashboard:

    cat << EOF > kind-config.yaml
    kind: Cluster
    name: tyk-pro-cluster
    apiVersion: kind.x-k8s.io/v1alpha4
    nodes:
    - role: control-plane
      extraPortMappings:
      - containerPort: 30001
        hostPort: 3000
        listenAddress: "0.0.0.0"
        protocol: TCP
      - containerPort: 30002
        hostPort: 8080
        listenAddress: "0.0.0.0"
        protocol: TCP
    EOF

When creating the cluster please specify the config file as following:
    kind create cluster --config=kind-config.yaml

Then you can access *Tyk-Gateway* on http://localhost:13000 and *Tyk-Dashboard* on http://localhost:18080