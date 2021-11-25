#

## Tyk Pump - This chart deploys the open source Tyk Pump.

## TL;DR;

```console
$ helm repo add tyk-helm https://helm.tyk.io/public/helm/charts/
$ helm repo update
$ helm install tyk-pump tyk-helm/tyk-pump -n tyk --version=1.0.0
```

## Introduction

This chart deploys Tyk pump automation for K8s on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes v1.16+
- Tyk Gateway
- Redis ([bitnami install](https://tyk.io/docs/tyk-oss/ce-helm-chart/#step-4---installing-redis))
- MongoDB

## Installing the Chart

To install the chart with the release name `tyk-pump`:

```console
$ helm install tyk-pump tyk-helm/tyk-pump -n tyk --version=1.0.0
```

The command deploys Tyk pump automation for K8s on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `tyk-pump`:

```console
$ helm delete tyk-pump -n tyk
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the `tyk-pump` chart and their default values.

|                 Parameter                  |                                                                                                                                           Description                                                                                                                                           |              Default              |
|--------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-----------------------------------|
| replicaCount                               |                                                                                                                                                                                                                                                                                                 | `1`                               |
| containerPort                              |                                                                                                                                                                                                                                                                                                 | `9090`                            |
| image.repository                           |                                                                                                                                                                                                                                                                                                 | `docker.tyk.io/tyk-pump/tyk-pump` |
| image.pullPolicy                           |                                                                                                                                                                                                                                                                                                 | `IfNotPresent`                    |
| image.tag                                  | Overrides the image tag whose default is the chart appVersion.                                                                                                                                                                                                                                  | `v1.4.0`                          |
| service.type                               |                                                                                                                                                                                                                                                                                                 | `NodePort`                        |
| service.port                               |                                                                                                                                                                                                                                                                                                 | `9090`                            |
| service.externalTrafficPolicy              |                                                                                                                                                                                                                                                                                                 | `Local`                           |
| service.annotations                        |                                                                                                                                                                                                                                                                                                 | `{}`                              |
| imagePullSecrets                           |                                                                                                                                                                                                                                                                                                 | `[]`                              |
| nameOverride                               |                                                                                                                                                                                                                                                                                                 | `""`                              |
| fullnameOverride                           |                                                                                                                                                                                                                                                                                                 | `""`                              |
| secrets.useSecretName                      | If you don't want to store plaintext secrets in the Helm value file and would rather provide the k8s Secret externally please populate the value below                                                                                                                                          | `""`                              |
| podAnnotations                             |                                                                                                                                                                                                                                                                                                 | `{}`                              |
| podSecurityContext                         |                                                                                                                                                                                                                                                                                                 | `{}`                              |
| securityContext                            |                                                                                                                                                                                                                                                                                                 | `{}`                              |
| resources                                  |                                                                                                                                                                                                                                                                                                 | `{}`                              |
| autoscaling.enabled                        |                                                                                                                                                                                                                                                                                                 | `false`                           |
| autoscaling.minReplicas                    |                                                                                                                                                                                                                                                                                                 | `1`                               |
| autoscaling.maxReplicas                    |                                                                                                                                                                                                                                                                                                 | `100`                             |
| autoscaling.targetCPUUtilizationPercentage |                                                                                                                                                                                                                                                                                                 | `80`                              |
| nodeSelector                               |                                                                                                                                                                                                                                                                                                 | `{}`                              |
| tolerations                                |                                                                                                                                                                                                                                                                                                 | `[]`                              |
| affinity                                   |                                                                                                                                                                                                                                                                                                 | `{}`                              |
| extraEnvs                                  |                                                                                                                                                                                                                                                                                                 | `[]`                              |
| extraMounts                                |                                                                                                                                                                                                                                                                                                 | `[]`                              |
| redis.storage.database                     |                                                                                                                                                                                                                                                                                                 | `0`                               |
| mongo.useSSL                               | If your MongoDB has a password you can add the username and password to the url mongoURL: mongodb://root:pass@tyk-mongo-mongodb.tyk.svc.cluster.local:27017/tyk_analytics?authSource=admin Enables SSL for MongoDB connection. MongoDB instance will have to support that. Default value: false | `false`                           |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example:

```console
$ helm install tyk-pump tyk-helm/tyk-pump -n tyk --version=1.0.0 --set replicaCount=1
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while
installing the chart. For example:

```console
$ helm install tyk-pump tyk-helm/tyk-pump -n tyk --version=1.0.0 --values values.yaml
```
