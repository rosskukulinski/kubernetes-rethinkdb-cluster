# RethinkDB Cluster for Kubernetes

MIT Licensed by Ross Kukulinski [@RossKukulinski](https://twitter.com/rosskukulinski)

## Overview

This repository contains Kubernetes configurations to easily deploy RethinkDB.
The quickstart provides a non-persistent disk configuration for development
and testing.  There is also a GKE / GCE configuration which supports
persistent volume backed replicas.

By default, all RethinkDB Replicas are configured with Resource Limits and Requests for:

* 256Mi memory
* 100m cpu

In addition, RethinkDB Replicas are configured with a 100Mi cache-size.  All
of these settings can be tuned for your specific needs.

## Background
This is based on the original work in [github.com/kubernetes/kubernetes](https://github.com/kubernetes/kubernetes/tree/master/examples/rethinkdb), but has been adapted to utilize newer versions of RethinkDB (2.3+) as well as supporting proxies.

Docker Automated Build: rosskukulinski/rethinkdb-kubernetes:2.3.5
https://hub.docker.com/r/rosskukulinski/rethinkdb-kubernetes

It's important to note that the default admin interface IS exposed via public LoadBalancer.  This is for demonstration purposes only.  I would recommend changing the admin service to ```type: ClusterIP``` and use a TLS & password protected proxy (like nginx) to publicly expose the admin interface.

## Quickstart without persistent storage

Launch Services and Deployments

```
kubectl create -f rethinkdb-quickstart.yml
```

Once Rethinkdb pods are running, access the Admin service

```
kubectl describe service rethinkdb-admin
```

Scale up the number of Rethinkdb replicas

```
kubectl scale deployment/rethinkdb-replica --replicas=5
```

## GKE/GCE Configuration with persistent storage (recommended)

Due to the way persistent volumes are handled in Kubernetes, we have to have one RC per replica, each with its own persistent volume.  The RC is used to create a new pod should there be any issues.

This assumes you have created three persistent volumes in GKE:
rethinkdb-storage-1
rethinkdb-storage-2
rethinkdb-storage-3


Create the RethinkDB Services and first replica

```
kubectl create -f rethinkdb-services.yml
kubectl create -f rethinkdb-replica.1.yml
```
Wait for first replica to come up before launching the other replicas

```
kubectl create -f rethinkdb-replica.2.yml
kubectl create -f rethinkdb-replica.3.yml
kubectl create -f rethinkdb-proxy.yml
kubectl create -f rethinkdb-admin.yml
```
