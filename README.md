# Tyk Pro for Kubernetes Helm Chart

This chart provides a full Tyk Installation (API Management Dashboard and API Gateways with Analytics) for Kubernetes.

For further detail on how to configure Tyk as an Ingress Gateway, or how to manage APIs in Tyk using the Kubernetes API, please refer to our [Tyk Operator documentation](https://github.com/TykTechnologies/tyk-operator/). The operator can be installed along this chart and works with all installation types.

**Prerequisites**

- Redis installed in the cluster or reachable from inside K8s
- MongoDB installed in the cluster, or reachable from inside K8s

> MongoDB is not required for Tyk Community Edition or Hybrid Gateways installations

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


> *Important Note regarding TLS:* This helm chart assumes TLS is being used by default, so the gateways will listen on port 443 and load up a dummy certificate. You can set your own default certificate by replacing the files in the certs/ folder.

> *Important Note regarding MongoDB:* This helm chart enables the PodDisruptionBudget for MongoDB with an arbiter replica-count of 1.  If you intend to perform system maintenance on the node where the MongoDB pod is running and this maintenance requires for the node to be drained, this action will be prevented due the replica count being 1.  Increase the replica count in the helm chart deployment to a minimum of 2 to remedy this issue.

## Install Tyk Community Edition


	helm install tyk-ce ./tyk-headless -n tyk


## Install Tyk Pro
To install, *first modify the `values.yaml` file inside tyk-pro chart to add your license*:

	helm install tyk-pro ./tyk-pro -n tyk --wait

> Please note when installing the Tyk Pro chart the --wait argument is important for successful dashboard bootstrap.

Follow the instructions in the Notes that follow the installation to find your Tyk login credentials.

### Tyk Developer Portal

Once the Tyk Stack is up and running, take the following steps in order to bootstrap the Tyk Developer Portal:
1. Set the portal domain via the Dashboard UI
2. Restart the Dashboard containers
3. Create a Default home page through the UI

## Install Tyk Hybrid Gateways (This can be used either for Hybrid Gateways connected to Tyk Cloud or MDCB Hybrid Gateways)

To install, *first modify `values.yaml` file inside tyk-hybrid chart as follows:*
1. Add your dashboard users organisation ID in `gateway.rpc.rpcKey` value
2. Add your dashboard users API key in `gateway.rpc.apiKey` value
3. Add your connection string to allow the Hybrid gateway to connect to your control plane in `gateway.rpc.connString`. On the Tyk Cloud Console find this value in the endpoints panel for your control plane deployment.

	`helm install tyk-hybrid ./tyk-hybrid -n tyk`

> If you are using hybrid gateway with the Tyk Classic Cloud use the rpc settings block commented out in the values yaml


## Installing TIB

TIB is not necessary to install for Pro installations and it's functionality is included in the Tyk Dashboard API Manager.

The Tyk Identity Broker (TIB) is a micro-service portal that provides a bridge between various Identity Management Systems such as LDAP, Social OAuth (e.g. GPlus, Twitter, GitHub), legacy Basic Authentication providers, to your Tyk installation (https://tyk.io/docs/getting-started/tyk-components/identity-broker/).

Once you have installed `Gateway` and `Dashboard` component you can configure `tib.conf` and `profile.json`, you can read about how to configure them here https://github.com/TykTechnologies/tyk-identity-broker#how-to-configure-tib, and use helm upgrade command to install TIB.

This chart implies there's a ConfigMap with a `profiles.json` definition in it. Please use `tib.configMap.profiles` value to set the name of this ConfigMap (`tyk-tib-profiles-conf` by default).

## Installing MDCB

If you are deploying the Master Data Centre in an MDCB deployment then you can enable to addition of that component in your installation. For more details about the MDCB component see here https://tyk.io/docs/tyk-multi-data-centre/

This enables multicluster, multi Data-Centre API management from a single Dashboard.

**Secrets**

The Tyk owned MDCB registry is private and requires adding users to our organisation which you then define as a secret when pulling the MDCB image. Please contact your account manager to arrange this.



## Caveat: Tyk license and the number of gateway nodes

Different Tyk Pro Licenses allow for different numbers of Gateway nodes to connect to a single Dashboard instance - ensure that your Gateway pods will not scale beyond this number by setting the gateway resource kind to `Deployment` and setting the replica count to the node limit. For example, use the following options for a single node license: `--set gateway.kind=Deployment --set gateway.replicaCount=1` or similar if modifying the `values.yaml`.

Note, however, there may be intermittent issues on the new pods during the rolling update process, when the total number of online gateway pods is more than the license limit with lower amounts of Licensed nodes.

### Making an API public

You can set a tag for your exposed services in the API Designer, under the "Advanced Options" tab, the section called `Segment Tags (Node Segmentation)` allows you to add new tags. To make an API public, simply add `ingress` to this section, click the "Add" button, and save the API.

Disabling this capability is detailed in the point below.

## Kubernetes Ingress

NB: tyk-k8s has been deprecated. For reference, old documentation may be found here: [Tyk K8s](https://github.com/TykTechnologies/tyk-k8s)

For further detail on how to configure Tyk as an Ingress Gateway, or how to manage APIs using the Kubernetes API, please refer to our [Tyk Operator documentation](https://github.com/TykTechnologies/tyk-operator/).

## Istio Service Mesh Ingress gateway

To use Tyks gateways as the ingress to your Istio Service Mesh simply change `gateway.enableIstioIngress: true` in the values.yaml. Ensure you are using an Istio manifest which disables the default Istio Ingress gateway.
