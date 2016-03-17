# Simple RethinkDB Cluster for Kubernetes

This is based on the original work in [github.com/kubernetes/kubernetes](https://github.com/kubernetes/kubernetes/tree/master/examples/rethinkdb), but has been adapted to utilize a newer version of RethinkDB (2.2.5) and to support proxies.

Docker Automated Build: rosskukulinski/rethinkdb-kubernetes:2.2.5
https://hub.docker.com/r/rosskukulinski/rethinkdb-kubernetes


It's important to note that the admin interface IS exposed via public LoadBalancer.  This is for demonstration purposes only.  I would recommend changing the admin service to ```type: ClusterIP``` and use an SSL & password protected proxy (like Nginx) to publicly expose the admin interface.

## Quickstart without persistent storage

```
kubectl create -f driver.svc.yml
kubectl create -f cluster.svc.yml
kubectl create -f admin.svc.yml
kubectl create -f rethinkdb-replica.rc.yml
# Wait for first replica to come up
sleep 30
kubectl scale rc rethinkdb-replica --replicas=3
kubectl create -f rethinkdb-proxy.rc.yml
kubectl create -f rethinkdb-admin.rc.yml
```

## Quickstart with persistent storage (recommended)

Due to the way persistent volumes are handled in Kubernetes, we have to have one RC per replica, each with its own persistent volume.  The RC is used to create a new pod should there be any issues.

This assumes you have created three persistent volumes in GKE:
rethinkdb-storage-1
rethinkdb-storage-2
rethinkdb-storage-3

```
kubectl create -f driver.svc.yml
kubectl create -f cluster.svc.yml
kubectl create -f admin.svc.yml
kubectl create -f rethinkdb-replica.rc.1.yml
# Wait for first replica to come up
kubectl create -f rethinkdb-replica.rc.2.yml
kubectl create -f rethinkdb-replica.rc.3.yml
kubectl create -f rethinkdb-proxy.rc.yml
kubectl create -f rethinkdb-admin.rc.yml
```
