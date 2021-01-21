# Tyk Pro for Kubernetes Helm Chart

This chart provides a full Tyk Installation (API Management Dashboard and API Gateways with Analytics) for Kubernetes with an ingress controller and service-mesh injector.

This means that a single Tyk installation can be used for both "north-south" inbound traffic from the internet to protect and promote your services, as well as internal east-west traffic, enabling you to secure your services in any way you see fit, including mutual TLS.

It also means that you can bring the full features set of the Tyk API Gateway to your internal and external services from a single control plane.

## Important things to remember: Nodes are Segmented

This Helm chart installs Tyk as a *segmented* Gateway service with an external load balancer, this means that the gateways that get deployed are tagged with the `ingress` tag. Tagged gateways like this will only load APIs that have also been tagged as `ingress`.

The reason gateways are sharded is so that the dashboard and the Tyk K8s controller can target different services to different gateways, i.e. services that are exposed to the internet should be routed in the `ingress` gateways, while service-mesh sidecars need to handle private service definitions which are created programmatically, and should not be loaded into the public-facing gateways.

**Prerequisites**

- Redis installed in the cluster or reachable from K8s
- MongoDB installed in the cluster, or reachable from inside K8s

> MongoDB is not required for Tyk Community Edition or Hybrid Gateways

To get started quickly, you can use these rather excellent Redis and MongoDB charts to get going:

	helm repo add bitnami https://charts.bitnami.com/bitnami
	helm repo update
	kubectl create namespace tyk-ingress
	helm install tyk-mongo bitnami/mongodb --set "replicaSet.enabled=true" -n tyk-ingress
	(follow notes from the installation output to get connection details)
	helm install tyk-redis bitnami/redis -n tyk-ingress
	(follow notes from the installation output to get connection details)

> *Important Note regarding TLS:* This helm chart assumes TLS is being used by default, so the gateways will listen on port 443 and load up a dummy certificate. You can set your own default certificate by replacing the files in the certs/ folder.

> *Important Note regarding MongoDB:* This helm chart enables the PodDisruptionBudget for MongoDB with an arbiter replica-count of 1.  If you intend to perform system maintenance on the node where the MongoDB pod is running and this maintenance requires for the node to be drained, this action will be prevented due the replica count being 1.  Increase the replica count in the helm chart deployment to a minimum of 2 to remedy this issue.

## Install Tyk Community Edition
> **Warning**: This is highly experimental, technical support is not available.

To install, *first modify the `values_community_edition.yaml` file to add redis details*:

	helm install tyk-ce -f ./values_community_edition.yaml ./tyk-headless -n tyk-ingress

> **Warning**: Tyk Service Mesh capability is not currently supported with Tyk CE

## Install Tyk Pro
To install, *first modify the `values.yaml` file to add redis and mongo details, and add your license*:

	helm install tyk-pro -f ./values.yaml ./tyk-pro -n tyk-ingress

Follow the instructions in the Notes that follow the installation to install the controller for Service Mesh sidecar injection.

## Installing TIB
The Tyk Identity Broker (TIB) is a micro-service portal that provides a bridge between various Identity Management Systems such as LDAP, Social OAuth (e.g. GPlus, Twitter, GitHub), legacy Basic Authentication providers, to your Tyk installation (https://tyk.io/docs/getting-started/tyk-components/identity-broker/).

Once you have installed `Gateway` and `Dashboard` component you can configure `tib.conf` and `profile.json`, you can read about how to configure them here https://github.com/TykTechnologies/tyk-identity-broker#how-to-configure-tib, and use helm upgrade command to install TIB.

This chart implies there's a ConfigMap with a `profiles.json` definition in it. Please use `tib.configMap.profiles` value to set the name of this ConfigMap (`tyk-tib-profiles-conf` by default).

## Installing MDCB

If you are deploying the Master Data Centre in an MDCB deployment then you can enable to addition of that component in your installation. For more details about the MDCB component see here https://tyk.io/docs/tyk-multi-data-centre/

This enables multicluster, multi Data-Centre API management from a single Dashboard.

**Secrets**

The Tyk owned MDCB registry is private and requires adding users to our organisation which you then define as a secret when pulling the MDCB image. Please contact your account manager to arrange this.

## Install Tyk Hybrid Gateways (This can be used either for Multi-Cloud Gateways or MDCB slaves)
To install, first modify `values_hybrid.yaml` file as follows:
1. Add redis password in `redis.pass` value. It's the value of `$REDIS_PASSWORD` environment variable (the host should be `tyk-redis-master.tyk-ingress.svc.cluster.local` if you used the tyk-ingress as the namespace.
2. Add your RPC key in `tyk_k8s.org_id` value
3. Add your API key in `tyk_k8s.dash_key` value (could be the API key of any dashboard user but better to have a dedicated one)
4. Add your dashboard URL in `tyk_k8s.dash_url` value. If it's a Tyk SaaS account the value `https://admin.cloud.tyk.io` is already set for you.

	helm install tyk-hybrid -f ./values_hybrid.yaml ./tyk-hybrid -n tyk-ingress

To check all the helm installations run:
	`kubectl get secret --all-namespaces -l "owner=helm"`

To uninstall run:
	`helm uninstall tyk-hybrid -n=tyk-ingress`

Follow the instructions in notes to install the ingress controller. Sidecar injection support is coming soon!




## Caveat: Tyk license and the number of gateway nodes

While we recommend the unlimited node Tyk license for Kubernetes deployments, it's still possible to use limited licenses by changing the gateway resource kind to `Deployment` and setting the replica count to the node limit. For example, use the following options for a single node license: `--set gateway.kind=Deployment --set gateway.replicaCount=1` or similar if modifying the `values.yaml`.

Note, however, there may be intermittent issues on the new pods during the rolling update process, when the total number of online gateway pods is more than the license limit.

### Making an API public

You can set a tag for your exposed services in the API Designer, under the "Advanced Options" tab, the section called `Segment Tags (Node Segmentation)` allows you to add new tags. To make an API public, simply add `ingress` to this section, click the "Add" button, and save the API.

If you are using an ingress spec, then the Tyk k8s controller will do this for you.

### How to disable node sharding

If you are using the latest chart, you can set the `enableSharding` value in the `values.yaml` to false.

If you are running an older chart that does not have this value, then you can disable node sharding beforehand by editing the `tyk-pro/configs/tyk_mgmt.conf` file, simply set the value `db_app_conf_options.node_is_segmented` to `false`.

> *Please Note* Doing this means that the service mesh sidecar injector and its related generated APIs will not work correctly, as those services will also be loaded by your ingress gateways.

## Kubernetes Ingress

NB: tyk-k8s has been deprecated. For reference, old documentation may be found here: [Tyk K8s](./tyk-k8s/deprecated.md)

For further detail on how to configure Tyk as an Ingress Gateway, or how to manage APIs using the Kubernetes API, 
 please refer to our [Tyk Operator documentation](https://github.com/TykTechnologies/tyk-operator/).
