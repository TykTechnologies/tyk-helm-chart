## Usage

To enable the ingress controller, simply add the ingress class definition to your ingress annotations:

```yml
apiVersion: networking.k8s.io/v1beta1
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
apiVersion: networking.k8s.io/v1beta1
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

You can also directly modify the service in your Tyk Dashboard, though if the ingress is recreated, the changes may not be retained.

When an ingress is removed, the services will be removed from the API Gateway as well.

### Templates

It's quite likely that you will not want to overload your ingress specifications with annotations that set specific values in your API Definition. To make adding APIs much more flexible, you can make use of a single `template.service.tyk.io/` annotation to specify the name of a template to use when deploying your service to the gateway.

This can be extremely useful if you want to standardise on certain types of service, e.g. "open-public", "closed-public" and "closed-jwt-internal", where you apply different auth schemes, IP white lists and more complex re-usable specifications such as IDP provider details and secrets that you don't want to re-code into each definition.

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
apiVersion: networking.k8s.io/v1beta1
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
apiVersion: apps/v1
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
