# Tyk Helm Chart - OpenShift
To install Tyk using our helm chart on OpenShift please follow this guide:

1. Create tyk namespace: `kubectl create ns tyk`

2. Find the user and group UID range for the OpenShift project.
```
kubectl describe ns tyk | grep uid-range
```

3. Expose Redis and Mongo/Postgres configuration:

Redis:
```
helm show values bitnami/redis > redis.yaml
```

Mongo or Postgres:
```
helm show values bitnami/mongodb --version 11.2.0 > mongo.yaml
```
```
helm show values bitnami/postgresql > postgres.yaml
```

4. Modify yaml files and update all the `fsGroup`, `runAsUser` values and set them to a value in the range of the OpenShift project ex. `1000640000`

5. Install the databases:

Redis:
```
helm install tyk-redis bitnami/redis -f redis.yaml -n tyk
```

Mongo or Postgres:
```
helm install tyk-mongo bitnami/mongodb --version 11.2.0 --set "replicaSet.enabled=true" -f mongo.yaml -n tyk
```
```
helm install tyk-postgres bitnami/postgresql --set "auth.database=tyk_analytics" -f postgres.yaml -n tyk
```

6. Update your values.yaml:

- Update all the `fsGroup`, `runAsUser` values under each of the Tyk component sections to a value within the range OpenShift expects ex. `1000640000`
- Update Redis, Mongo/Postgres connection strings

For `tyk-pro`
- Add Dashboard licenses
- Disable the `bootstrap` option at the top of the `values.yaml` as the bootstrapping is currently not supported with the OpenShift installation.

7. Install Tyk: `helm install tyk-pro ./tyk-pro/ -f ./tyk-pro/values.yaml -n tyk`
TODO: update this notation before merging^

