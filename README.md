# Tyk Pro for Kubernetes Helm Chart

This chart provides a full Tyk Installation (API Management Dashboard and API Gateways with Analytics) for Kubernetes with an ingress controller and service-mesh injector.

This means that a single Tyk installation can be used for both "north-south" inbound traffic from the internet to protect and promote your services, as well as internal east-west traffic, enabling you to secure your services in any way you see fit, including mutual TLS. 

It also means that you can bring the full features set of the Tyk API Gateway to your internal and external services from a single control plane.

**Prerequisites**

- Redis installed in the cluster or reachable from K8s
- MongoDB installed in the cluster, or reachable from inside K8s

> MongoDB is not required for Tyk Community Edition or Hybrid Gateways

To get started quickly, you can use these rather excellent Redis and MongoDB charts to get going:

	helm repo add tc http://trusted-charts.stackpoint.io
	helm repo update
	helm install tc/redis --name redis --namespace=redis --set usePassword=false
	helm install tc/mongodb-replicaset --name mongodb --namespace=mongodb 

> *Important Note regarding TLS:* This helm chart assumes TLS is being used by default, so the gateways will listen on port 443 and load up a dummy certificate. You can set your own default certificate by replacing the files in the certs/ folder.

## Install Tyk Community Edition
To install, *first modify the `values_community_edition.yaml` file to add redis details*:

	helm install -f ./values_community_edition.yaml ./tyk-headless

> **Warning**: Tyk Service Mesh capability is not currently supported with Tyk CE

## Install Tyk Pro
To install, *first modify the `values.yaml` file to add redis and mongo details, and add your license*:

	helm install -f ./values.yaml ./tyk-pro

Follow the instructions in the Notes that follow the installation to install the controller for Service Mesh sidecar injection.

## Installing TIB
The Tyk Identity Broker (TIB) is a microservice portal that provides a bridge between various Identity Management Systems such as LDAP, Social OAuth (e.g. GPlus, Twitter, GitHub), legacy Basic Authentication providers, to your Tyk installation (https://tyk.io/docs/concepts/tyk-components/identity-broker/).

Once you have installed `Gateway` and `Dashboard` component you can configure `tib.conf` and `profile.json`, you can read about how to configure them here https://github.com/TykTechnologies/tyk-identity-broker#how-to-configure-tib, and use helm upgrade command to install TIB.


## Install Tyk Hybrid Gateways (This can be used either for Multi-Cloud Gateways or MDCB slaves)
To install, *first modify the `values_hybrid.yaml` file to add redis details, your RPC key, API key and Dashboard URL*:

	helm install -f ./values_hybrid.yaml ./tyk-hybrid

Follow the instructions in notes to install the ingress controller. Sidecar injection support is coming soon!


## Important things to remember: Nodes are Segmented

This Helm chart installs Tyk as a *segmented* Gateway service with an external load balancer, this means that the gateways that get deployed are tagged with the `ingress` tag. Tagged gateways like this will only load APIs that have also been tagged as `ingress`.

The reason gateways are sharded is so that the dashboard and the Tyk K8s controller can target different services to different gateways, i.e. services that are exposed to the internet should be routed in the `ingress` gateways, while service-mesh sidecars need to handle private service definitions which are created programatically, and should not be loaded into the public-facing gateways.

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

## Using the Ingress Controller

To enable the ingress controller, simply add the ingress class defintiion to your ingress annotations:

```yml
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: cafe-ingress
  annotations:
    kubernetes.io/ingress.class: tyk
spec:
  rules:
    - host: cafe.example.com
```

By default Tyk will create an open API (no security enabled), however you can set any property in the API Definition using the following annotations (remember that all annotations are treated as strings):

- `bool.service.tyk.io/{path}: value`: Set a value to `"true"` or `"false"` 
- `string.service.tyk.io/{path}: value`: Set a value that is a string literal, e.g. "name"
- `num.service.tyk.io/{path}: value`: Set a value that is a number (assumes an int)
- `object.service.tyk.io/{path}: value`: Set a whole json object

Here's an example:

```yml
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: cafe-ingress
  annotations:
    kubernetes.io/ingress.class: tyk
    bool.service.tyk.io/use-keyless": "false"
    string.service.tyk.io/proxy.target-url": "http://foo.bar/bazington"
    num.service.tyk.io/cache_options.cache-timeout": "20"
    object.service.tyk.io/version_data.versions.Default.extended-paths": '{"hard_timeouts":[{"path":"{all}","method":"GET","timeout":60,"fromDashboard":true}]}'
spec:
  rules:
  - host: cafe.example.com
    http:
      paths:
      - path: /tea
        backend:
          serviceName: tea-svc
          servicePort: 80
      - path: /coffee
        backend:
          serviceName: coffee-svc
          servicePort: 80
```

You can also directly modify the service in your Tyk Dasboard, though if the ingress is recreated, the changes may not be retained.

When an ingress is removed, the services will be removed from the API Gateway as well.

### Templates

It's quite likely that you will not want to overload your ingress specifications with annotations that set specific values in your API Definition. To make adding APIs much more flexible, you can make use of a single `template.service.tyk.io/` annotation to specify the name of a template to use when deploying your service to the gateway.

This can be extremely useful if you want to standardise on certain types of service, e.g. "open-public", "closed-public" and "closed-jwt-internal", where you apply different auth scehemes, IP white lists and more complex re-usable specifications such as IDP provider details and secrets that you don;t want to re-code into each definition.

Templates currently must have a .json filetype to be loaded into the controller and parsed.

To use templates, you will need to re-deploy the tyk-k8s container and add volume mounts for your templates:

```yml
### --- deployment-tyk-k8s.yaml
### --- there's other stuff up here

spec:
  {{ if .Values.rbac }}serviceAccountName: tyk-k8s {{ end }}
  containers:
  - name: tyk-k8s
  image: "{{ .Values.tyk_k8s.image.repository }}:{{ .Values.tyk_k8s.image.tag }}"
  imagePullPolicy: {{ .Values.tyk_k8s.image.pullPolicy }}
  workingDir: "/opt/tyk-k8s"
  command: ["/opt/tyk-k8s/tyk-k8s", "start"]
  ports:
    - containerPort: 443
      volumeMounts:
        - name: tyk-k8s-conf
          mountPath: /etc/tyk-k8s
        - name: webhook-certs
          mountPath: /etc/tyk-k8s/certs

        ### Custom templates:
        - name: tyk-k8s-templates
          mountPath: /etc/tyk-k8s-templates
      resources:
        {{ toYaml .Values.resources | indent 12 }}
      volumes:
        - name: tyk-k8s-conf
          configMap:
            name: tyk-k8s-conf
            items:
            - key: tyk_k8s.yaml
              path: tyk-k8s.yaml

### Custom templates:        
        - name: tyk-k8s-templates
          configMap:
            name: token-auth
            items:
              - key: token-auth.json # these should be real filenames ending .json
                path: token-auth.json
```

You will also need to update the config file for tyk-k8s:

```yml
### configmap-tyk-k8s.yaml

Tyk:
  url: "{{ .Values.tyk_k8s.dash_url }}"
  secret: "{{ .Values.tyk_k8s.dash_key }}"
  org_id: "{{ .Values.tyk_k8s.org_id }}"

# Add this line
  templates: "/etc/tyk-k8s-templates" 
```

Templates are added as config maps, to convert an API definition to a template, simply encapsulate it in template tags, like this:

```
{{ define "tokenAuth"}}
{
  "name": "{{.Name}}{{ range $i, $e := .GatewayTags }} #{{$e}}{{ end }}",
  ...
}
{{ end }}
```

Once you have created them, add the to the namespace as config maps:

```
kubectl create configmap token-auth --from-file=token-auth.json --namespace {namespace}
```

Once these template configMaps have been added, and your tyk-k8s service is running, you can set up your service definitions very easily by adding a single annotation:

```yml
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: cafe-ingress
  annotations:
    kubernetes.io/ingress.class: tyk
    template.service.tyk.io: tokenAuth
  spec:
    rules:
      - host: cafe.example.com
        http:
          paths:
            - path: /tea
              backend:
                serviceName: tea-svc
                servicePort: 80
            - path: /coffee
              backend:
                serviceName: coffee-svc
                servicePort: 80
```

For a sample template, please see the [token auth template in the controller repository](https://raw.githubusercontent.com/TykTechnologies/tyk-k8s/master/templates/token-auth.json).

### TLS

Tyk supports the TLS section for the ingress controller. If you set a TLS entry with a secret, the controller will retrieve the certificate from K8s and load it into the encrypted certificate store in Tyk and dynamically load it into the ingress. You can manage the certificate from within Tyk Dashboard.

TLS can also be disabled by setting `gateway.tls` option to `false`. In this case the gateway will run with HTTP listener. This is useful, e.g. in case TLS is terminated externally (such as on a cloud provider's load balancer).

## Using the service-mesh injector

The service mesh injector will create two services: 

1. An inbound service for the container - this is only loaded into the sidecar for the service and handles all inbound requests for the service from the mesh
2. The mesh endpoint, this is the route that is circulated to all sidecars as the route to the service in (1)

Setting up a service to use the injector is very simple, simply add the inject annotation to your Deployment:

```yml
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: sleep
  spec:
    replicas: 1
    template:
      metadata:
        annotations:
          injector.tyk.io/inject: "true"
          injector.tyk.io/route: "/sleep"
        labels:
          app: sleep
        spec:
          containers:
            - name: sleep
              image: tutum/curl
              command: ["/bin/sleep","infinity"]
              imagePullPolicy: IfNotPresent
```

By default, the injector will create the service route on /{pod.Name}, however you can specify the route to advertise using the `injector.tyk.io/route` instruction, this will set the `proxy.listen_path` in the Tyk API Definition.

By default the service is open (as with the ingress), however you can use the same service annotations as the ingress to set options on the created service. *Note*: The changes only affect the `inbound` service, not the mesh service. This means rate limits, quotas, and security policies are applied in the inbound side-car as opposed to the sender side-car.
