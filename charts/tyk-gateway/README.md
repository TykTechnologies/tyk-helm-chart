# 

[Tyk Gateway](https://github.com/TykTechnologies/tyk-helm-chart) - This chart deploys the open source Tyk Gateway.

## TL;DR;

```console
$ helm repo add tyk-helm https://helm.tyk.io/public/helm/charts/
$ helm repo update
$ helm install tyk-gateway tyk-helm/tyk-gateway -n tyk --version=1.0.0
```

## Introduction

This chart deploys Tyk gateway automation for K8s on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes v1.16+
- Redis

## Installing the Chart

To install the chart with the release name `tyk-gateway`:

```console
$ helm install tyk-gateway tyk-helm/tyk-gateway -n tyk --version=1.0.0
```

The command deploys Tyk gateway automation for K8s on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `tyk-gateway`:

```console
$ helm delete tyk-gateway -n tyk
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the `tyk-gateway` chart and their default values.

|                 Parameter                  |                                                                      Description                                                                       |       Default       |
|--------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------|---------------------|
| nameOverride                               |                                                                                                                                                        | `""`                |
| fullnameOverride                           |                                                                                                                                                        | `""`                |
| secrets.APISecret                          | tyk.conf node_secret tyk.conf secret                                                                                                                   | `CHANGEME`          |
| secrets.useSecretName                      | If you don't want to store plaintext secrets in the Helm value file and would rather provide the k8s Secret externally please populate the value below | `""`                |
| podAnnotations                             |                                                                                                                                                        | `{}`                |
| podSecurityContext                         |                                                                                                                                                        | `{}`                |
| hostName                                   | The hostname to bind the Gateway to.                                                                                                                   | `tyk-gw.local`      |
| tls                                        | When true, sets the gateway protocol to HTTPS.                                                                                                         | `false`             |
| securityContext.readOnlyRootFilesystem     |                                                                                                                                                        | `true`              |
| securityContext.runAsNonRoot               |                                                                                                                                                        | `true`              |
| securityContext.allowPrivilegeEscalation   |                                                                                                                                                        | `false`             |
| securityContext.privileged                 |                                                                                                                                                        | `false`             |
| replicaCount                               |                                                                                                                                                        | `1`                 |
| containerPort                              |                                                                                                                                                        | `8080`              |
| image.repository                           |                                                                                                                                                        | `tykio/tyk-gateway` |
| image.tag                                  |                                                                                                                                                        | `v3.2.1`            |
| image.pullPolicy                           |                                                                                                                                                        | `Always`            |
| service.type                               |                                                                                                                                                        | `NodePort`          |
| service.port                               |                                                                                                                                                        | `8080`              |
| service.externalTrafficPolicy              |                                                                                                                                                        | `Local`             |
| service.annotations                        |                                                                                                                                                        | `{}`                |
| control.enabled                            |                                                                                                                                                        | `false`             |
| control.containerPort                      |                                                                                                                                                        | `9696`              |
| control.port                               |                                                                                                                                                        | `9696`              |
| control.type                               |                                                                                                                                                        | `ClusterIP`         |
| control.annotations                        |                                                                                                                                                        | `{}`                |
| ingress.enabled                            |                                                                                                                                                        | `false`             |
| ingress.annotations                        |                                                                                                                                                        | `{}`                |
| ingress.tls                                |                                                                                                                                                        | `[]`                |
| resources                                  |                                                                                                                                                        | `{}`                |
| autoscaling.enabled                        |                                                                                                                                                        | `false`             |
| autoscaling.minReplicas                    |                                                                                                                                                        | `1`                 |
| autoscaling.maxReplicas                    |                                                                                                                                                        | `100`               |
| autoscaling.targetCPUUtilizationPercentage |                                                                                                                                                        | `80`                |
| nodeSelector                               |                                                                                                                                                        | `{}`                |
| affinity                                   |                                                                                                                                                        | `{}`                |
| extraEnvs                                  |                                                                                                                                                        | `[]`                |
| mounts                                     |                                                                                                                                                        | `[]`                |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example:

```console
$ helm install tyk-gateway tyk-helm/tyk-gateway -n tyk --version=1.0.0 --set secrets.APISecret=CHANGEME
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while
installing the chart. For example:

```console
$ helm install tyk-gateway tyk-helm/tyk-gateway -n tyk --version=1.0.0 --values values.yaml
```
