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
* `serviceType`: The service type of public service. By default, it is `NodePort`.
* `serviceName`: The name of the statefulset. If missing, use "dolphindb-singleton-&lt;namespace&gt;".
* `agentNum`: The number of agents in the cluster. By default, the value is 2.
* `datanodeRestartInterval`: The settings of the [datanodeRestartInterval](https://docs.dolphindb.cn/en/help200/DatabaseandDistributedComputing/Configuration/ClusterMode.html?highlight=datanodeRestartInterval) parameter in the controller configuration.
* `chunkCacheEngineMemSize`: The settings of the [chunkCacheEngineMemSize](https://docs.dolphindb.cn/en/help200/DatabaseandDistributedComputing/Configuration/StandaloneMode.html?highlight=chunkCacheEngineMemSize) parameter in the cluster configuration.
* `cleanerTag`: The docker tag of `dolphindb-cleaner` from [https://hub.docker.com/r/dolphindb/dolphindb-cleaner](https://hub.docker.com/r/dolphindb/dolphindb-cleaner).
* `exporterTag`: The node-exporter tag of `dolphindb-exporter` from [https://hub.docker.com/r/dolphindb/dolphindb-exporter](https://hub.docker.com/r/dolphindb/dolphindb-exporter).
* `affinity` section: The affinity settings of the `StatefulSet` template.

### `license` Section

* `content`: The content of the license.

### `dolphindb` Section

* `imageTags`: The docker tag of [dolphindb/dolphindb](https://hub.docker.com/r/dolphindb/dolphindb).

### `controller` Section

* `port`: The port of the controller. **NOTE**: the port should be different with agent, datanode and compute node.
* `logSize`: The initial size of the log storage.
* `dataSize`: The initial size of the data storage.
* `logLimit`: The log size limitation.
* `storageClass`: The storage class of the mounted `data`, `core` and `log` storage.
* `resources` section: The limitation and request of the container.

### `agent` Section

* `port`: The port of the agent. **NOTE**: the port should be different with controller, datanode and compute node.
* `datanodePort`: The port of the data node.
* `dataSize`: The initial size of the data storage.
* `logSize`: The initial size of the log storage.
* `storageClass`: The storage class of the mounted `data`, `core` and `log` storage.
* `resources` section: The limitation and request of the container.
