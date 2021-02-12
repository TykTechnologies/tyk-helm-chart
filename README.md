# Tyk Pro for Kubernetes Helm Chart

This chart provides a full Tyk Installation (API Management Dashboard and API Gateways with Analytics) for Kubernetes.

This means that a single Tyk installation can be used for both "north-south" inbound traffic from the internet to protect and promote your services, as well as internal east-west traffic, enabling you to secure your services in any way you see fit, including mutual TLS.

It also means that you can bring the full features set of the Tyk API Gateway to your internal and external services from a single control plane.

**Prerequisites**

- Redis installed in the cluster or reachable from K8s
- MongoDB installed in the cluster, or reachable from inside K8s

> MongoDB is not required for Tyk Community Edition or Hybrid Gateways

To get started quickly, you can use mongo.yaml and redis.yaml to install MongoDB and Redis inside your k8s cluster, but please note that we don't recommend to use DB's or Redis inside k8s, as this are external entities. We're providing this Mongo and Redis charts as an example, so you can quickly have Tyk Pro running.

	kubectl create namespace tyk
	kubectl apply -f mongo.yaml -n tyk
	kubectl apply -f redis.yaml -n tyk

> *Important Note regarding TLS:* This helm chart assumes TLS is being used by default, so the gateways will listen on port 443 and load up a dummy certificate. You can set your own default certificate by replacing the files in the certs/ folder.

## Install Tyk Community Edition
> **Warning**: This is highly experimental, technical support is not available.

To install, *first modify the `values_community_edition.yaml` file to add redis details*:

	helm install tyk-ce -f ./values_community_edition.yaml ./tyk-headless -n tyk


## Install Tyk Pro
To install, *first modify the `values.yaml` file to add your license*:

	helm install tyk-pro -f ./values.yaml ./tyk-pro -n tyk --wait

Follow the instructions in the Notes that follow the installation to find your Tyk login credentials.

## Installing TIB
The Tyk Identity Broker (TIB) is a microservice portal that provides a bridge between various Identity Management Systems such as LDAP, Social OAuth (e.g. GPlus, Twitter, GitHub), legacy Basic Authentication providers, to your Tyk installation (https://tyk.io/docs/getting-started/tyk-components/identity-broker/).

Once you have installed `Gateway` and `Dashboard` component you can configure `tib.conf` and `profile.json`, you can read about how to configure them here https://github.com/TykTechnologies/tyk-identity-broker#how-to-configure-tib, and use helm upgrade command to install TIB.

This chart implies there's a ConfigMap with a `profiles.json` definition in it. Please use `tib.configMap.profiles` value to set the name of this ConfigMap (`tyk-tib-profiles-conf` by default).

## Installing MDCB

If you are deploying the Master Data Centre in an MDCB deployment then you can enable to addition of that component in your installation. For more details about the MDCB component see here https://tyk.io/docs/tyk-multi-data-centre/

This enables multicluster, multi Data-Centre API management from a single Dashboard.

**Secrets**

The Tyk owned MDCB registry is private and requires adding users to our organisation which you then define as a secret when pulling the MDCB image. Please contact your account manager to arrange this.

## Install Tyk Hybrid Gateways (This can be used either for Multi-Cloud Gateways or MDCB slaves)

	helm install tyk-hybrid -f ./values_hybrid.yaml ./tyk-hybrid -n tyk

To check all the helm instalations run:
	`kubectl get secret --all-namespaces -l "owner=helm"`

To uninstall run:
	`helm uninstall tyk-hybrid -n=tyk`

## Caveat: Tyk license and the number of gateway nodes

While we recommend the unlimited node Tyk license for Kubernetes deployments, it's still possible to use limited licenses by changing the gateway resource kind to `Deployment` and setting the replica count to the node limit. For example, use the following options for a single node license: `--set gateway.kind=Deployment --set gateway.replicaCount=1` or similar if modifying the `values.yaml`.

Note, however, there may be intermittent issues on the new pods during the rolling update process, when the total number of online gateway pods is more than the license limit.

### Making an API public

You can set a tag for your exposed services in the API Designer, under the "Advanced Options" tab, the section called `Segment Tags (Node Segmentation)` allows you to add new tags. To make an API public, simply add `ingress` to this section, click the "Add" button, and save the API.

### How to disable node sharding

If you are using the latest chart, you can set the `enableSharding` value in the `values.yaml` to false.

If you are running an older chart that does not have this value, then you can disable node sharding beforehand by editing the `tyk-pro/configs/tyk_mgmt.conf` file, simply set the value `db_app_conf_options.node_is_segmented` to `false`.

## Kubernetes Ingress

NB: tyk-k8s has been deprecated. For reference, old documentation may be found here: [Tyk K8s](https://github.com/TykTechnologies/tyk-k8s)

For further detail on how to configure Tyk as an Ingress Gateway, or how to manage APIs using the Kubernetes API, please refer to our [Tyk Operator documentation](https://github.com/TykTechnologies/tyk-operator/).
