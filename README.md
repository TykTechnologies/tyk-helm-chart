# Tyk Helm Chart
Tyk provides 3 different helm charts in this repo. Please visit the respective pages for each chart to learn how to install the chart and find out all the information relevant to that chart.  
- [Tyk Pro](https://github.com/TykTechnologies/tyk-helm-chart/tree/master/tyk-pro)
- [Tyk Hybrid](https://github.com/TykTechnologies/tyk-helm-chart/tree/master/tyk-hybrid)
> [!WARNING]  
> `tyk-hybrid` will be deprecated soon. Please use our new Helm Chart for Tyk Hybrid Data Plane at [tyk-data-plane](https://github.com/TykTechnologies/tyk-charts/tree/main/tyk-data-plane) instead.
> We recommend all users to migrate to the new Helm Chart. Please review the [Configuration](https://tyk.io/docs/tyk-cloud/environments-deployments/hybrid-gateways-helm/#configuration) section of the new helm chart and cross-check with your existing configurations while planning for migration.

- [Tyk Headless](https://github.com/TykTechnologies/tyk-helm-chart/tree/master/tyk-headless)
> [!WARNING]  
> `tyk-headless` will be deprecated soon. Please use our new Helm Chart for Tyk open source at [tyk-oss](https://github.com/TykTechnologies/tyk-charts/tree/main/tyk-oss) instead.
> We recommend all users to migrate to the new Helm Chart. Please review the [Configuration](https://tyk.io/docs/tyk-oss/ce-helm-chart-new/#configuration) section of the new helm chart and cross-check with your existing configurations while planning for migration.

## Redis and MongoDB or PostgreSQL
- Redis is required for all of the Tyk installations it must be installed in the cluster or reachable from inside K8s.
- MongoDB or PostgreSQL are only required for the tyk-pro installation and must be installed in the cluster, or reachable from inside K8s. If you are using the MongoDB or SQL pumps in the tyk-headless installation you will require MongoDB or PostgreSQL installed for that as well.

For Redis you can use these rather excellent charts provided by Bitnami:
```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
kubectl create namespace tyk

helm install tyk-redis bitnami/redis -n tyk
(follow notes from the installation output to get connection details and update them in `values.yaml` file)
```

For Mongo or PostgreSQL you can use these rather excellent charts provided by Bitnami:
```bash
helm install tyk-mongo bitnami/mongodb --version {HELM_CHART_VERSION} --set "replicaSet.enabled=true" -n tyk
(follow notes from the installation output to get connection details and update them in `values.yaml` file)
```

>**_NOTE_**: [Here](https://tyk.io/docs/planning-for-production/database-settings/) is list of supported MongoDB versions. Please make sure you are installing mongo helm chart that matches these version.

```bash
helm install tyk-postgres bitnami/postgresql --set "auth.database=tyk_analytics" -n tyk
(follow notes from the installation output to get connection details and update them in `values.yaml` file)
```

*Important Note regarding MongoDB:* This helm chart enables the PodDisruptionBudget for MongoDB with an arbiter replica-count of 1.  If you intend to perform system maintenance on the node where the MongoDB pod is running and this maintenance requires for the node to be drained, this action will be prevented due the replica count being 1.  Increase the replica count in the helm chart deployment to a minimum of 2 to remedy this issue.

Another option for Redis and MongoDB, if you want to get started quickly is to use our simple charts. **Please note that these provided charts must not ever be used in production and for anything but a quick start evaluation only, use external DBs or Official Helm charts for MongoDB and Redis in any other case.**
We provide these charts so you can quickly have Tyk running however they are not meant for long term storage of data for example.

```bash
kubectl create namespace tyk
helm repo add tyk-helm https://helm.tyk.io/public/helm/charts/
helm repo update
```

#### Redis

```bash
helm install redis tyk-helm/simple-redis -n tyk
```

#### MongoDB
```bash
helm install mongo tyk-helm/simple-mongodb -n tyk
```

## TLS
You can turn on the tls option under the gateway section in the values.yaml files which will make the gateways listen on port 443 and load up a dummy certificate. It is recommended that you set your own default certificate by replacing the files in the certs/ folder. 

> **Warning**
> The default certificate should not be used in production environments

## Kubernetes Ingress
NB: tyk-k8s has been deprecated. For reference, old documentation may be found here: [Tyk K8s](https://github.com/TykTechnologies/tyk-k8s)

For further detail on how to configure Tyk as an Ingress Gateway, or how to manage APIs in Tyk using the Kubernetes API, please refer to our [Tyk Operator documentation](https://tyk.io/docs/tyk-operator/). The Tyk Operator can be installed along this chart and works with all installation types.

## Mounting Files
To mount files to any of the Tyk stack components, add the following to the mounts array in the section of that component:

    - name: aws-mongo-ssl-cert
      filename: rds-combined-ca-bundle.pem
      mountPath: /etc/certs
