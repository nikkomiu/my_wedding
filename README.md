# My Wedding

[![build status](https://gitlab.com/nikko.miu/my_wedding/badges/master/build.svg)](https://gitlab.com/nikko.miu/my_wedding/commits/master)
[![coverage report](https://gitlab.com/nikko.miu/my_wedding/badges/master/coverage.svg)](https://gitlab.com/nikko.miu/my_wedding/commits/master)

## Kubernetes Configuration

Our Wedding application is designed to be run in a Kubernetes environment. The service requirements of running Our Wedding in a Kubernetes cluster are:

- PostgreSQL
- NFS Server

There are Kubernetes definitions for both of these services located at `deploy/kube/nfs-server/` and `deploy/kube/postgres/`. However, the recommendation is that these services are run outside of the Kubernetes cluster.

## Gitlab Secrets

To be able to pull images from Gitlab you must create a Docker config secret. You can create it using:

```bash
kubectl create secret \
  docker-registry myregistrykey \
  --docker-server=registry.gitlab.com \
  --docker-username=DOCKER_USER \
  --docker-password=DOCKER_PASSWORD \
  --docker-email=DOCKER_EMAIL
```

## NFS Server

In a Kubernetes cluster the NFS server is required to manage storage for all of the application containers. This is due to the Kuberentes spec for attached storage located [here](http://kubernetes.io/docs/user-guide/persistent-volumes/#access-modes). The spec (currently) only allows for multiple read write container access policies on NFS, GlusterFS, CephFS, and AzureFile. Of those the simplest and easiest to implement solution is an NFS server.

### Persistent Volumes

There is currently one `pv.yaml` file that contains all of the Persistent Volumes that will be associated with the NFS server.

**Note:** You must change the server IP address to the IP address of the Service definition for the NFS server. Currently there does not appear to be a way around this.

### Busybox

The busybox server is not needed to make the NFS server work. It is simply a testing Replication Controller to verify the NFS server is working with multiple nodes writing to a file on the NFS disk.

**Note:** In order to use the Busybox testing containers you must create a Persistent Volume Claim called `nfs`. Without this claim Busybox can not be created.

## PostgreSQL

The configuration files for PostgreSQL are located at `deploy/kube/postgres/`

### Secrets

**Before you begin:** Make sure you update the `secret.yaml` file to use your application secrets.

To set values for the `secret.yaml` file you will need to encode the data in `base64` format.

```bash
echo -n "mysecretstring" | base64
```

## Our Wedding

The configuration files for the application are located at `deploy/kube/our-wedding/`

### Secrets

**Before you begin:** Make sure you update the `secret.yaml` file to use your application secrets.

To set values for the `secret.yaml` file you will need to encode the data in `base64` format.

```bash
echo -n "mysecretstring" | base64
```
