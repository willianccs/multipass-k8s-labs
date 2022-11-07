#!/usr/bin/env bash

# Install Helm
# Ref: https://helm.sh/docs/intro/install/#from-script
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# Install NGINX Ingress Controller
# Ref: https://kubernetes.github.io/ingress-nginx/deploy/#quick-start
helm upgrade --install ingress-nginx ingress-nginx \
  --repo https://kubernetes.github.io/ingress-nginx \
  --namespace ingress-nginx --create-namespace

# CIS Benchmark

## Install

- [kube-bench](https://github.com/aquasecurity/kube-bench)

You can manually download and extract the kube-bench binary:
> https://github.com/aquasecurity/kube-bench/blob/main/docs/installation.md

```sh

curl -L https://github.com/aquasecurity/kube-bench/releases/download/v0.6.2/kube-bench_0.6.2_linux_amd64.tar.gz -o kube-bench_0.6.2_linux_amd64.tar.gz
sudo tar -xvf kube-bench_0.6.2_linux_amd64.tar.gz -C /opt
```

Now you can then run kube-bench directly:

```sh
kube-bench
```

If you manually downloaded the kube-bench binary (using curl command above), you have to specify the location of configuration directory and file. For example:

```sh
cd /opt
sudo ./kube-bench --config-dir `pwd`/cfg --config `pwd`/cfg/config.yaml 
```

# OPA (Open Policy Agent)

## Install

> https://github.com/open-policy-agent/gatekeeper

- [Deploying via Helm](https://open-policy-agent.github.io/gatekeeper/website/docs/install/#deploying-via-helm)

```sh
helm repo add gatekeeper https://open-policy-agent.github.io/gatekeeper/charts
helm install gatekeeper/gatekeeper --name-template=gatekeeper --namespace gatekeeper-system --create-namespace
```

Example:

```sh
ubuntu@control-plane:/opt$ helm install gatekeeper/gatekeeper --name-template=gatekeeper --namespace gatekeeper-system --create-namespace
W1106 16:56:12.339431    4791 warnings.go:70] policy/v1beta1 PodSecurityPolicy is deprecated in v1.21+, unavailable in v1.25+
W1106 16:56:30.506816    4791 warnings.go:70] policy/v1beta1 PodSecurityPolicy is deprecated in v1.21+, unavailable in v1.25+
NAME: gatekeeper
LAST DEPLOYED: Sun Nov  6 16:56:12 2022
NAMESPACE: gatekeeper-system
STATUS: deployed
REVISION: 1
TEST SUITE: None
---
ubuntu@control-plane:/opt$ k get crd
NAME                                                 CREATED AT
assign.mutations.gatekeeper.sh                       2022-11-06T19:56:11Z
assignmetadata.mutations.gatekeeper.sh               2022-11-06T19:56:12Z
configs.config.gatekeeper.sh                         2022-11-06T19:56:12Z
constraintpodstatuses.status.gatekeeper.sh           2022-11-06T19:56:12Z
constrainttemplatepodstatuses.status.gatekeeper.sh   2022-11-06T19:56:12Z
constrainttemplates.templates.gatekeeper.sh          2022-11-06T19:56:12Z
expansiontemplate.expansion.gatekeeper.sh            2022-11-06T19:56:12Z
modifyset.mutations.gatekeeper.sh                    2022-11-06T19:56:12Z
mutatorpodstatuses.status.gatekeeper.sh              2022-11-06T19:56:12Z
providers.externaldata.gatekeeper.sh                 2022-11-06T19:56:12
```

> TODO: examples yamls rules (constraint.templates)

# Runtime Security

## [Falco] Install

> https://falco.org/docs/getting-started/installation/

```sh
sudo -i
curl -s https://falco.org/repo/falcosecurity-3672BA8F.asc | apt-key add -
echo "deb https://download.falco.org/packages/deb stable main" | tee -a /etc/apt/sources.list.d/falcosecurity.list
apt-get update -y
apt-get -y install linux-headers-$(uname -r)
apt-get install -y falco
```

## [Falco] Running

> https://falco.org/docs/getting-started/running/

### [Falco] Arguments

> https://falco.org/docs/getting-started/running/arguments/

## [Falco] Rules

> https://falco.org/docs/rules/

- Default rules:

```sh
root@control-plane:~# cd /etc/falco/
root@control-plane:/etc/falco# ls
aws_cloudtrail_rules.yaml  falco.yaml  falco_rules.local.yaml  falco_rules.yaml  k8s_audit_rules.yaml  rules.available  rules.d
```

- [Supported fields](https://falco.org/docs/rules/supported-fields/)


## [Trivy] Install

> https://aquasecurity.github.io/trivy/v0.34/getting-started/installation/#install-script 

```sh
curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b /usr/local/bin v0.34.0
```

## [Trivy] Running

- Scan images

```sh
trivy image --severity HIGH,CRITICAL [YOUR_IMAGE_NAME]
```

- Dockerfile

```sh
trivy config [DOCKERFILE]
```

- Kubernetes

```sh
  # cluster scanning
  $ trivy k8s --report summary cluster

  # namespace scanning:
  $ trivy k8s -n kube-system --report summary all

  # resources scanning:
  $ trivy k8s --report=summary deploy
  $ trivy k8s --namespace=kube-system --report=summary deploy,configmaps

  # resource scanning:
  $ trivy k8s deployment/orion
```

# Audit

> https://kubernetes.io/docs/tasks/debug/debug-cluster/audit/

Stages:
1. RequestReceived
2. ResponseStarted
3. ResponseComplete
4. Panic

Audit Policy:
1. None
2. Metadata
3. Request
4. RequestReponse

# ImagePolicyWebhook

> https://kubernetes.io/docs/reference/access-authn-authz/admission-controllers/#imagepolicywebhook

## Mock

```sh
openssl req -x509 -nodes -new -keyout webhook.pem -out webhook.pem  # CN=test-webhook.com
openssl req -x509 -nodes -new -keyout apiserver-client-key.pem -out apiserver-client.pem  # CN=api-server.com
```

*IMPORTANT* Enable admission on kube-apiserver.yaml

# Syscalls e /proc

```sh
strace $PROGRAM (example `ls`)
strace -p $PID

# Summary
strace -c $PROGRAM

# List process with tree
ps auxf

# alternative command
pstree 

# With PID
pstree -p 

# Network
ss

# active ports
ss -l 

# TCP
ss -lt (TCP)

# UDP
ss -lu (UDP)

# open and listening
ss -ltp

```


