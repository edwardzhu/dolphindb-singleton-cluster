# DolphinDB Singleton Cluster

This solution is to build a helm package for deploying a DolphinDB cluster as a single `StatefulSet` on a Kubernetes cluster.

## Architecture

![architecture](img/AWS%20Dolphindb%20Singleton.drawio.png)

* `controller`: single controller of the cluster.
* `exporter`: node-exporter service for `Prometheus`.
* `controller-cleaner`: the schedule cleaner of the data, core folder in the `controller`.
* `agent-{i}`: the agent of the cluster. Each agent contains a generated datanode.
* `agent-cleaner-{i}`: the cleanter of the agent. Each agent maps to a cleaner.

## Values

### `global` Section

* `registry`: The custom registry. By default, it is empty. It means, use default docker hub repository.
* `repository`: The image name of the dolphinDB.
* `storageClass`: The storage class of the `data`, `core` and `log` storage.
* `allNamespace`: Allow you add the namespace or `all` as postfix of some resources. By default, it is `false` to use the exact namesapce.
* `serviceType`: 