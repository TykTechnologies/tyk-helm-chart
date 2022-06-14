# Tyk Helm Chart
Tyk provides 3 different helm charts in this repo. Please visit the respective pages for each chart to learn how to install the chart and find out all the information relevant to that chart.  
- [Tyk Pro](https://github.com/TykTechnologies/tyk-helm-chart/tree/master/tyk-pro)
- [Tyk Hybrid](https://github.com/TykTechnologies/tyk-helm-chart/tree/master/tyk-hybrid)
- [Tyk Headless](https://github.com/TykTechnologies/tyk-helm-chart/tree/master/tyk-headless)

## Redis and MongoDB or PostgreSQL
- Redis is required for all of the Tyk installations it must be installed in the cluster or reachable from inside K8s.
- MongoDB or PostgreSQL are only required for the tyk-pro installation and must be installed in the cluster, or reachable from inside K8s. If you are using the mongo or sql pumps in the tyk-headless installation you will require mongo or postgres installed for that as well.

For Redis you can use these rather excellent charts provided by Bitnami:

	helm repo add bitnami https://charts.bitnami.com/bitnami
	helm repo update
	kubectl create namespace tyk

	helm install tyk-redis bitnami/redis -n tyk
	(follow notes from the installation output to get connection details and update them in `values.yaml` file)


For Mongo or PostgreSQL you can use these rather excellent charts provided by Bitnami:

	helm install tyk-mongo bitnami/mongodb --version {HELM_CHART_VERSION} --set "replicaSet.enabled=true" -n tyk
	(follow notes from the installation output to get connection details and update them in `values.yaml` file)

>**_NOTE_**: [Here](https://tyk.io/docs/planning-for-production/redis-mongodb/#supported-versions) is list of supported mongo versions. Please make sure you are installing mongo helm chart that matches these version.

	helm install tyk-postgres bitnami/postgresql --set "auth.database=tyk_analytics" -n tyk
	(follow notes from the installation output to get connection details and update them in `values.yaml` file)

>**Important Note regarding MongoDB:** This helm chart enables the PodDisruptionBudget for MongoDB with an arbiter replica-count of 1.  If you intend to perform system maintenance on the node where the MongoDB pod is running and this maintenance requires for the node to be drained, this action will be prevented due the replica count being 1.  Increase the replica count in the helm chart deployment to a minimum of 2 to remedy this issue.

Another option for Redis and MongoDB, if you want to get started quickly is to use our simple charts. **Please note that these provided charts must not ever be used in production and for anything but a quick start evaluation only, use external DBs or Official Helm charts for MongoDB and Redis in any other case.**
We provide these charts so you can quickly have Tyk running however they are not meant for long term storage of data for example.

	kubectl create namespace tyk
	helm repo add tyk-helm https://helm.tyk.io/public/helm/charts/
	helm repo update

#### Redis
	helm install redis tyk-helm/simple-redis -n tyk

#### MongoDB
	helm install mongo tyk-helm/simple-mongodb -n tyk

## TLS
You can turn on the tls option under the gateway section in the values.yaml files which will make the gateways listen on port 443 and load up a dummy certificate. You can set your own default certificate by replacing the files in the certs/ folder.

## Kubernetes Ingress
NB: tyk-k8s has been deprecated. For reference, old documentation may be found here: [Tyk K8s](https://github.com/TykTechnologies/tyk-k8s)

For further detail on how to configure Tyk as an Ingress Gateway, or how to manage APIs in Tyk using the Kubernetes API, please refer to our [Tyk Operator documentation](https://github.com/TykTechnologies/tyk-operator/). The Tyk operator can be installed along this chart and works with all installation types.

## Mounting Files
To mount files to any of the Tyk stack components, add the following to the mounts array in the section of that component:

    - name: aws-mongo-ssl-cert
      filename: rds-combined-ca-bundle.pem
      mountPath: /etc/certs

## Applying SSL Certs to Gateway and Dashboard Services
To apply SSL certs to the Gateway and Dashboard services you need to create a k8s secret in the same namespace as these services and then provide that service with the list of certs you want to apply.

To create the specific k8s secret we can use the command in the certs folder of any of the 3 charts 
```
kubectl create secret tls tyk-headless-default-cert --cert cert.pem --key key.pem -n tyk
```

Then inside our values.yaml file under the gateway/dash we need to add the following block of code:

```
  certificates:
    - name: gateway-cert
      certSecret: tyk-headless-default-cert
      keySecret: tyk-headless-default-cert
      certFilename: tls.crt
      keyFilename: tls.key
```

Lastly, if using a self-signed certificate we need to also provide the CA file so that the bootstrap process
will be done correctly and securely. This can be done using the command below with the appropriate CA filename:

```
kubectl -n tyk create configmap {{.Values.certificates.caConfigMapName}} --from-file=tykCA.pem
```

> **_NOTE_**: The name of the configmap must be replaced with the actual value set for .Values.certificates.caConfigMapName
> in the yaml file (e.g. ca-pemstore)


Furthermore, the name of the CA file should be also included in the values.yaml file
under `.Values.certificates.caBundleFilename`

> **_NOTE_**: For the above to work, the self signed certificate should be created using the following ext file:

```
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
extendedKeyUsage=serverAuth,clientAuth
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names
[alt_names]
DNS.1 = tyk.local
DNS.2 = dashboard.tyk.local
DNS.3 = gateway.tyk.local
DNS.4 = dashboard-svc-tyk-pro.tyk
DNS.5 = gateway-svc-tyk-pro.tyk
DNS.6 = dashboard-svc-tyk-pro.tyk.svc.cluster.local
```

For more details regarding how to generate a self signed certificate, please visit this
[guide](https://github.com/TykTechnologies/tyk-k8s-integrations/tree/main/integrations/ssl)


