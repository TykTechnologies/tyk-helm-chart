## Tyk OSS Gateway

> [!WARNING]  
> `tyk-headless` will be deprecated soon. Please use our new Helm Chart for Tyk open source at [tyk-oss](https://github.com/TykTechnologies/tyk-charts/tree/main/tyk-oss) instead.
> We recommend all users to migrate to the new Helm Chart. Please review the [Configuration](https://tyk.io/docs/tyk-oss/ce-helm-chart-new/#configuration) section of the new helm chart and cross-check with your existing configurations while planning for migration.

This chart deploys the open source Tyk Gateway and Pump.

---

[Installation](https://tyk.io/docs/apim/open-source/installation/) || [Documentation](https://tyk.io/docs) || [Community Forum](https://community.tyk.io/) || [Releases](https://hub.docker.com/r/tykio/tyk-gateway/tags?page=1&ordering=last_updated)

---

## Prerequisites
Redis should already be installed or accessible by the gateway.

Check [Tyk OSS Helm chart Installation](https://tyk.io/docs/tyk-oss/ce-helm-chart/) for the full details.

## Installation
```bash
helm repo add tyk-helm https://helm.tyk.io/public/helm/charts/
helm repo update
kubectl create namespace tyk
helm install tyk-headless tyk-helm/tyk-headless -n tyk
```

## Pump Installation
By default pump installation is disabled. You can enable it by setting `pump.enabled` to `true` in `values.yaml` file.
Alternatively, you can use `--set pump.enabled=true` while doing helm install.

## Pump Configuration
### Mongo Pump

To configure mongo pump, do following changings in `values.yaml` file:
1. Set `backend` to `mongo`.
2. Set connection string in `mongo.mongoURL`.


### Postgres Pump
To configure postgres pump, do following changings in `values.yaml` file:
1. Set `backend` to `postgres`.
2. Set connection string parameters in `postgres` section.
