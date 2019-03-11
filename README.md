# Tyk Pro for Kubernetes Helm Chart

This chart provides a full Tyk Installation (API Management Dashboard and API Gateways with Analytics) for Kubernetes with an ingress controller and service-mesh injector.

This means that a single Tyk installation can be used for both "north-south" inbound traffic from the internet to protect and promote your services, as well as internal east-west traffic, enabling you to secure your services in any way you see fit, including mutual TLS. 

It also means that yo can bring the full features et of the Tyk API Gateway to your internal and external services rom a single control plane.

**Pre-requisites**

- Redis installed in the cluster or reachable from K8s
- MongoDB installed in the cluster, or reachable from inside K8s

To get started quickly, you can use these rather excellent Redis and MongoDB charts to get goig:

	helm repo add tc http://trusted-charts.stackpoint.io
	helm repo update
	helm install tc/redis --name redis --namespace=redis --set usePassword=false
	helm install tc/mongodb-replicaset --name mongodb --namespace=mongodb 

> *Important Note regarding TLS:* This helm chart assumes TLS is being used by default, so the gateways will listen on port 443 and load up a dummy certificate. You can set your own default certificate by replacing the files in the certs/ folder.

To install, *first modify the `values.yaml` file to add redis and mongo details, and add your license*:

	helm install -f ./values.yaml ./tyk-pro

Follow the instructions in the Notes that follow the installation to install the controller.

## Important things to remember: Nodes are Segmented

This Helm chart installs Tyk as a *segmented* Gateway service with an external load balancer, this means that the gateways that get deployed are tagged with the `ingress` tag. Tagged gateways like this will only load APIs that have also been tagged as `ingress`.

You can set this tag for your exposed services in the API Designer, under the "Advanced Options" tab, the section called `Segment Tags (Node Segmentation)` allows you to add new tags. To make an API public, simply add `ingress` to this section, click the "Add" button, and save the API.

### How to disable node sharding

If you do not want this behaviour, then you can disable node sharding before hand by editing the `tyk-pro/configs/tyk_mgmt.conf` file, simply set the value `db_app_conf_options.node_is_segmented` to `false`. 

> *Please Note* Doing this means that the service mesh sidecar injector and it's related generated APIs will not work correctly, as those services will also be loaded by your ingress gateways".

## Using the Ingress Controller

To enable the ingress controller, simply add the ingress class defintiion to your ingress annotations:

	apiVersion: extensions/v1beta1
	kind: Ingress
	metadata:
	  name: cafe-ingress
	  annotations:
	    kubernetes.io/ingress.class: tyk
	spec:
	  rules:
	  - host: cafe.example.com

By default Tyk will create an Open API (no security enabled), however you can set any property in the API Definition using the following annotations (remember that all annotations are treated as strings:

- `bool.service.tyk.io/{path}: value`: Set a value to `"true"` or `"false"` 
- `string.service.tyk.io/{path}: value`: Set a value that is a string literal, e.g. "name"
- `num.service.tyk.io/{path}: value`: Set a value that is a number (assumes an int)
- `object.service.tyk.io/{path}: value`: Set a whole json object

Here's an example:

	apiVersion: extensions/v1beta1
	kind: Ingress
	metadata:
	  name: cafe-ingress
	  annotations:
	    kubernetes.io/ingress.class: tyk
	    bool.service.tyk.io/use-keyless": "false",
		string.service.tyk.io/proxy.target-url": "http://foo.bar/bazington",
		num.service.tyk.io/cache_options.cache-timeout": "20",
		object.service.tyk.io/version_data.versions.Default.extended-paths": '{"hard_timeouts":[{"path":"{all}","method":"GET","timeout":60,"fromDashboard":true}]}',
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

You can also directly modify the service in your Tyk Dasboard, though if the ingress is recreated, the changes may not be retained.

When an ingress is removed, the services will be removed from the API Gateway as well.

### TLS

Tyk supports the TLS section for the ingress controller. If you set a TLS entry with a secret, the controller will retrieve the certificate from K8s and load it into the encrypted certificate store in Tyk and dynamically load it into the ingress. You can manage the certificate from within Tyk Dashboard.

## Using the injector

The service mesh injector will create two services: 

1. An inbound service for the container - this is only loaded into the sidecar for the service and handles all inbound requests for the service from the mesh
2. The mesh endpoint, this is the route that is circulated to all sidecars as the route to the service in (1)

Setting up a service to use the injector is very simple, simply add the inject annotation to your Deployment:

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

By default, the injector will create the service route on /{pod.Name}, however you can specify the route to advertise using the `injector.tyk.io/route` instruction, this will set the `proxy.listen_path` in the Tyk API Definition.

By default the service is open (as with the ingress), however you can use the same service annotations as the ingress to set options on the created service. *Note*: The changes only affect the `inbound` service, not the mesh service. This means rate limits, quotas, and security policies are applied in the inbound side-car as opposed to the sender side-car.