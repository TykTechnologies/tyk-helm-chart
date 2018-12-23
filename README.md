# Tyk Pro Helm Chart [ALPHA]

This will install a Tyk Gateway as a DaemonSet attached to an external LoadBalancer, it will also install a Tyk Dashboard and Pump to handle analytics and management.

**Pre-requisites**

- Redis installed in the cluster or reachable from K8s
- MongoDB installed in the cluster, or reachable from inside K8s

To install, *first modify the `values.yaml` file to add redis and mongo details, and add your license*:

helm install ./tyk-pro

This will then show the pod names like so:

```
==> v1/Pod(related)

NAME                                             READY  STATUS             RESTARTS  AGE
gateway-roiling-kiwi-tyk-pro-8mt7m               0/1    ContainerCreating  0         0s
gateway-roiling-kiwi-tyk-pro-9fc4k               0/1    ContainerCreating  0         0s
gateway-roiling-kiwi-tyk-pro-g7nx2               0/1    ContainerCreating  0         0s
dashboard-roiling-kiwi-tyk-pro-64469bb495-l8jnx  0/1    ContainerCreating  0         0s // <--- this one
pump-roiling-kiwi-tyk-pro-ddc447685-75wbg        0/1    ContainerCreating  0         0s

```


To bootstrap the dashboard, run: 

kubectl exec --namespace=tyk DASHBOARD-POD-NAME /opt/tyk-dashboard/install/bootstrap.sh 127.0.0.1

This will show you output with your username and password:

```

Adding new user
USER AUTHENTICATION CODE: 258c930e7e8f45374ff3c70393baef69
NEW ID: 5c1f2c4c0607da3b623b4072

Setting password
{"Status":"OK","Message":"User password updated","Meta":null}

DONE
====
Login at http://127.0.0.1:3000/
User: 7m1a3giv54@default.com
Pass: t2e0s1T7
```

Next, you need to see what port was assigned:

	martin@lady-sharrow ~/h/tyk-helm> kubectl get services --namespace tyk
	NAME                                 TYPE           CLUSTER-IP   EXTERNAL-IP   PORT(S)          AGE
	dashboard-svc-roiling-kiwi-tyk-pro   NodePort       10.3.0.247   <none>        3000:32315/TCP   8m4s // <-- This one
	gateway-svc-roiling-kiwi-tyk-pro     LoadBalancer   10.3.0.69    <pending>     8080:31793/TCP   8m4s

To access the dashboard in Kubernetes, simply go to:

	http://MASTER-IP:NodePOrt

Here you would use `32315` as your port, the IP should just be your master K8s node.