# RethinkDB Cluster for Kubernetes

MIT Licensed by Ross Kukulinski [@RossKukulinski](https://twitter.com/rosskukulinski)

Docker image can be found [here](https://github.com/rosskukulinski/rethinkdb-kubernetes).

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

It's important to note that the default admin interface IS exposed via public LoadBalancer.  This is for demonstration purposes only.  I would recommend changing the admin service to ```type: ClusterIP``` and use a TLS & password protected proxy (like nginx) to publicly expose the admin interface.

## New to Kubernetes?
1. Create a project on https://console.cloud.google.com
2. Set `gcloud` to your project `gcloud config set <project-name>`
3. Create a cluster via the Console: Compute > Container Engine > Container Clusters > New container cluster. 
Leaving all other options default - You should get a Kubernetes cluster with three nodes, ready to receive your container image.
4. Set `gcloud` to point to your container - `gcloud container clusters get-credentials --zone <cluster-zone> <cluster-name>`



## Quickstart without persistent storage

Launch Services and Deployments

```
kubectl apply -f rethinkdb-rbac.yaml
kubectl apply -f rethinkdb-quickstart.yml
```

Once Rethinkdb pods are running, access the Admin service

```
kubectl describe service rethinkdb-admin
```

To find the external IP to connect to, locate at the `EXTERNAL-IP` column under the `rethinkdb-driver` row after running
```
kubectl get service
```

Scale up the number of Rethinkdb replicas

```
kubectl scale deployment/rethinkdb-replica --replicas=5
```

Observe your pods

```
kubectl get pods
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
