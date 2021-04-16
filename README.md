# Tyk Helm Chart
Tyk provides 3 different helm charts in this repo. Please visit the respective pages for each chart to learn how to install the chart and find out all the information relevant to that chart.  
- [Tyk Pro](https://github.com/TykTechnologies/tyk-helm-chart/tree/master/tyk-pro)
- [Tyk Hybrid](https://github.com/TykTechnologies/tyk-helm-chart/tree/master/tyk-hybrid)
- [Tyk Headless](https://github.com/TykTechnologies/tyk-helm-chart/tree/master/tyk-headless)

**Note: All helm commands should be run from the root of the repo.**

For further detail on how to configure Tyk as an Ingress Gateway, or how to manage APIs in Tyk using the Kubernetes API, please refer to our [Tyk Operator documentation](https://github.com/TykTechnologies/tyk-operator/). The Tyk operator can be installed along this chart and works with all installation types.

## Redis and MongoDB
- Redis is required for all of the Tyk installations it must be installed in the cluster or reachable from inside K8s.
- MongoDB is only required for the tyk-pro installation and must be installed in the cluster, or reachable from inside K8s. If you are using the mongo pumps in the tyk-headless installation you will require mongo installed for that as well. 

To get started quickly, you can use mongo.yaml and redis.yaml manifests to install MongoDB and Redis inside your kubernetes cluster.
**Please note that these provided manifests must not ever be used in production and for anything but a quick start evaluation only, use external DBs or Official Helm charts for MongoDB and Redis in any other case.**
We provide these manifests so you can quickly have Tyk running however they are not meant for long term storage of data for example.

	kubectl create namespace tyk
	kubectl apply -f deploy/dependencies/mongo.yaml -n tyk
	kubectl apply -f deploy/dependencies/redis.yaml -n tyk

Another option for Redis and MongoDB could be charts provided by Bitnami:

	helm repo add bitnami https://charts.bitnami.com/bitnami
	helm repo update
	kubectl create namespace tyk
	helm install tyk-mongo bitnami/mongodb --set "replicaSet.enabled=true" -n tyk
	(follow notes from the installation output to get connection details and update them in `values.yaml` file)
	helm install tyk-redis bitnami/redis -n tyk
	(follow notes from the installation output to get connection details and update them in `values.yaml` file)

*Important Note regarding MongoDB:* This helm chart enables the PodDisruptionBudget for MongoDB with an arbiter replica-count of 1.  If you intend to perform system maintenance on the node where the MongoDB pod is running and this maintenance requires for the node to be drained, this action will be prevented due the replica count being 1.  Increase the replica count in the helm chart deployment to a minimum of 2 to remedy this issue.

## TLS
You can turn on the tls option under the gateway section in the values.yaml files which will make the gateways listen on port 443 and load up a dummy certificate. You can set your own default certificate by replacing the files in the certs/ folder.

## Kubernetes Ingress
NB: tyk-k8s has been deprecated. For reference, old documentation may be found here: [Tyk K8s](https://github.com/TykTechnologies/tyk-k8s)

For further detail on how to configure Tyk as an Ingress Gateway, or how to manage APIs using the Kubernetes API, please refer to our [Tyk Operator documentation](https://github.com/TykTechnologies/tyk-operator/).

