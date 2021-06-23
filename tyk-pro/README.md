## Tyk Pro
Provides a full Tyk Installation API Management Dashboard and API Gateways with Analytics)

### Installation
To install, *first modify the `values.yaml` file and add your license*. Then run the following command from the root of the repository:

	helm install tyk-pro ./tyk-pro -n tyk --wait

> Please note the --wait argument is important for successful dashboard bootstrap.

Follow the instructions in the Notes that follow the installation to find your Tyk login credentials.

### Tyk Developer Portal
You can enable the bootstraping of the Developer Portal using the `portal.bootstrap` option in `values.yaml`.

## Installing TIB
TIB is not necessary to install for this chart as it's functionality is included in the Tyk Dashboard API Manager. However, if you want to run it seperately from the Dashboard you can do so.

The Tyk Identity Broker (TIB) is a micro-service portal that provides a bridge between various Identity Management Systems such as LDAP, Social OAuth (e.g. GPlus, Twitter, GitHub), legacy Basic Authentication providers, to your Tyk installation (https://tyk.io/docs/getting-started/tyk-components/identity-broker/).

Once you have installed the `Gateway` and `Dashboard` components you can configure TIB by adding its configuration environemnt variables under the `tib.extraEnvs` section  and updaring the `profile.json` under the configs folder, you can read about how to configure them here https://github.com/TykTechnologies/tyk-identity-broker#how-to-configure-tib. Once you complete your modifications you can run the following command from the root of the repository to update the helm chart if you had already installed it:

	helm upgrade tyk-pro ./tyk-pro -n tyk

This chart implies there's a ConfigMap with a `profiles.json` definition in it. Please use `tib.configMap.profiles` value to set the name of this ConfigMap (`tyk-tib-profiles-conf` by default).

## Installing MDCB
If you are deploying the Master Data Centre in an MDCB deployment then you can set the `mdcb.enabled` option in the `values.yaml` to `true` to add of the MDCB component to your installation. For more details about the MDCB component see here https://tyk.io/docs/tyk-multi-data-centre/

This enables multicluster, multi Data-Centre API management from a single Dashboard.

**Secrets**
The Tyk owned MDCB registry is private and requires adding users to our organisation which you then define as a secret when pulling the MDCB image. Please contact your account manager to arrange this.

## Caveat: Tyk license and the number of gateway nodes
Different Tyk Pro Licenses allow for different numbers of Gateway nodes to connect to a single Dashboard instance - ensure that your Gateway pods will not scale beyond this number by setting the gateway resource kind to `Deployment` and setting the replica count to the node limit. For example, use the following options for a single node license: `--set gateway.kind=Deployment --set gateway.replicaCount=1` or similar if modifying the `values.yaml`.

Note, however, there may be intermittent issues on the new pods during the rolling update process, when the total number of online gateway pods is more than the license limit with lower amounts of Licensed nodes.

## Sharding
Sharding is adding the ability for you to decide which of your APIs are loaded on which gateways. This option is turned off by default, however, you can turn it on by updating the `gateway.sharding.enabled` option. Once you do that you will need to also populate the `gateway.sharding.tags` value which the tags that you want that gateway to load. (ex. tags: "external,ingress".) You can then add those tags to your APIs in the API Designer, under the "Advanced Options" tab, and `Segment Tags (Node Segmentation)` section in the dashboard.

## Istio Service Mesh Ingress gateway
To use Tyks gateways as the ingress to your Istio Service Mesh simply change `gateway.enableIstioIngress: true` in the values.yaml. Ensure you are using an Istio manifest which disables the default Istio Ingress gateway.