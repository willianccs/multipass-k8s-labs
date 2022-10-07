# Kubernetes Cluster using Multipass

You can use [Multipass](https://multipass.run/) to create Ubuntu VMs and then set up a Kubernetes cluster.
This is useful for studying purposes for example, CKA-CKAD-CKS certifications.

## Instructions

These are the links to install and create kubernetes cluster:
1. [Install Container runtimes](https://kubernetes.io/docs/setup/production-environment/container-runtimes/)
2. [Install kubeadm](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/)
3. [Create a cluster with kubeadm](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/)

### Step 1. Multipass

Multipass is a tool to launch and manage VMs with a single command. It’s designed for developers who want a fresh Ubuntu environment with a single command and works on Linux, Windows and macOS.

On Linux it’s available as a snap:

``` sh
sudo snap install multipass --beta --classic`
```

See [install Multipass](https://multipass.run/install) for more details.

### Step 2. Clone repository

```
git clone https://github.com/willianccs/multipass-k8s-labs.git
cd multipass-k8s-labs/
```

### Step 3. Create two Ubuntu VMs on you host

``` sh
./1-multipass-start.sh
```

### Step 4. Creating a cluster

You can override the agents versions with the environment variable: `K8S_VERSION` 
> Default: 1.24.6-00

#### 4.1 Setup control-plane node

```
# default version
multipass exec control-plane -- /tmp/2-install.sh
---
# specific version
multipass exec control-plane -- sh -c 'K8S_VERSION=1.25.2-00 /tmp/2-install.sh'
```

#### 4.1.2 Copy join command

Copy the output like this, and prepare to run it in Step 4.2.1

```
kubeadm join 192.168.64.3:6443 --token al0kvi.x60mi1xj4zesqnq3     --discovery-token-ca-cert-hash sha256:f4ff0c7684bbac599a8208b94bb28e451023662ab51bc1ce16f60a855a85e2a5
```

#### 4.2 Setup worker nodes

```
# default version
multipass exec worker-01 -- /tmp/2-install.sh
---
# specific version
multipass exec worker-01 -- sh -c 'K8S_VERSION=1.25.2-00 /tmp/2-install.sh'
```

#### 4.2.1 Joining nodes

Then run what you copied from Step 4.1.2, something like this...

```
multipass exec worker-01 -- sh -c 'sudo kubeadm join 10.19.157.152:6443 --token 4kar3x.1d85mu95f7v90a08 --discovery-token-ca-cert-hash sha256:d3d8f62c208d515b169730b8ed594231a6659aa42e886548f565ff27bb788f3a'
```

... if you didn't remember or have copy, create a new token with the command:

```sh
multipass exec control-plane -- sh -c 'kubeadm token create --print-join-command'
```

### Step 5 Use an instance

To open a shell prompt on an existing instance, execute the following command: `multipass shell <VM_NAME>`

#### Step 5.1 On second window, control-plane

```
multipass shell control-plane

## Inside VM control-plane
$ kubectl get nodes
NAME            STATUS     ROLES           AGE   VERSION
control-plane   Ready      control-plane   69m   v1.24.6
worker-01       Ready      <none>          21s   v1.24.6

$ kubectl run nginx --image=nginx
pod/nginx created

$ kubectl get pods -w
NAME    READY   STATUS              RESTARTS   AGE
nginx   0/1     ContainerCreating   0          11s
nginx   1/1     Running             0          12s
```

### Step 6. Destroy

After you complete practice, you can delete the VMs. Assume you are still on the same directory as Step 1.

```
./destroy.sh
```

