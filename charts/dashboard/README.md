# Tyk Dashboard

This chart deploys Tyk dashboard automation for K8s on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes v1.16+
- Tyk Gateway
- Redis
- MongoDB

## Installing the Chart

To install the chart with the release name `tyk-dashboard`:

```console
$ helm repo add dashboard https://cloudsmith.io/~tyk/repos/helm/packages/
$ helm repo update
$ helm install tyk-dashboard dashboard/dashboard -n tyk --version=0.1.0
```

## Uninstalling the Chart

To uninstall/delete the `tyk-dashboard`:

```console
$ helm delete tyk-dashboard -n tyk
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the `dashboard` chart and their default values.

|      Parameter      |                                                                                                                      Description                                                                                                                       |                                                                  Default                                                                  |
|---------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------|
| enabled             | Determines whither or not the dashboard component should be installed.                                                                                                                                                                                 | `true`                                                                                                                                    |
| nameOverride        |                                                                                                                                                                                                                                                        | `""`                                                                                                                                      |
| fullnameOverride    |                                                                                                                                                                                                                                                        | `""`                                                                                                                                      |
| securityContext     |                                                                                                                                                                                                                                                        | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["all"]},"privileged":false,"readOnlyRootFilesystem":true,"runAsNonRoot":true}` |
| hostName            | The hostname to bind the Dashboard to.                                                                                                                                                                                                                 | `tyk-dashboard.local`                                                                                                                     |
| tls                 | If set to true the Dashboard will use SSL connection. You will also need to set the: - TYK_DB_SERVEROPTIONS_CERTIFICATE_CERTFILE - TYK_DB_SERVEROPTIONS_CERTIFICATE_KEYFILE variables in extraEnvs object array to define your SSL cert and key files. | `false`                                                                                                                                   |
| license             | Dashboard license.                                                                                                                                                                                                                                     | `""`                                                                                                                                      |
| bootstrap.enabled   |                                                                                                                                                                                                                                                        | `true`                                                                                                                                    |
| bootstrap.adminUser |                                                                                                                                                                                                                                                        | `{"email":"default@exmaple.com","firstName":"admin","lastName":"user","password":""}`                                                     |
| bootstrap.org       | Dashboard Organisation information.                                                                                                                                                                                                                    | `{"cname":"tyk-portal.local","name":"Default Org"}`                                                                                       |
| replicaCount        |                                                                                                                                                                                                                                                        | `1`                                                                                                                                       |
| containerPort       |                                                                                                                                                                                                                                                        | `3000`                                                                                                                                    |
| image               |                                                                                                                                                                                                                                                        | `{"pullPolicy":"Always","repository":"tykio/tyk-dashboard","tag":"v3.2.1"}`                                                               |
| service             |                                                                                                                                                                                                                                                        | `{"port":3000,"type":"NodePort"}`                                                                                                         |
| ingress             | Creates an ingress object in k8s. Will require an ingress-controller and annotation to that ingress controller.                                                                                                                                        | `{"annotations":{},"enabled":false,"hosts":["tyk-dashboard.local"],"path":"/","tls":[]}`                                                  |
| portal              |                                                                                                                                                                                                                                                        | `{"enabled":true,"ingress":{"annotations":{},"enabled":false,"hosts":["tyk-portal.local"],"tls":[]},"path":"/"}`                          |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example:

```console
$ helm install tyk-dashboard dashboard/dashboard -n tyk --version=0.1.0 --set securityContext={"allowPrivilegeEscalation":false,"capabilities":{"drop":["all"]},"privileged":false,"readOnlyRootFilesystem":true,"runAsNonRoot":true}
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while
installing the chart. For example:

```console
$ helm install tyk-dashboard dashboard/dashboard -n tyk --version=0.1.0 --values values.yaml
```