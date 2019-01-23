# Tyk Pro Helm Chart

This will install a Tyk Gateway as a DaemonSet attached to an external LoadBalancer, it will also install a Tyk Dashboard and Pump to handle analytics and management.

**Pre-requisites**

- Redis installed in the cluster or reachable from K8s
- MongoDB installed in the cluster, or reachable from inside K8s

To install, *first modify the `values.yaml` file to add redis and mongo details, and add your license*:

	helm install -f ./values.yaml ./tyk-pro

Follow the instructions in the Notes that follow the installation to install the controller