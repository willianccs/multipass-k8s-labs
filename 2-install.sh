#!/usr/bin/env bash

set -euox pipefail

## Setup OS requisites
# First disable swap
sudo swapoff -a

# And then to disable swap on startup in /etc/fstab
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

# Enable modules
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF
sudo swapoff -a
sudo modprobe overlay
sudo modprobe br_netfilter

# Setup required sysctl params, these persist across reboots.
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF

# Apply sysctl params without reboot
sudo sysctl --system

# Install containerd
sudo apt-get update && sudo apt-get install -y containerd apt-transport-https curl ca-certificates

# Configure containerd
sudo mkdir -p /etc/containerd
sudo containerd config default | sudo tee /etc/containerd/config.toml

# Restart containerd
sudo systemctl restart containerd

# Install kubernetes
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
K8S_VERSION="${K8S_VERSION:-1.24.6-00}"
sudo apt-get install -y kubelet="${K8S_VERSION}" kubeadm="${K8S_VERSION}" kubectl="${K8S_VERSION}"
sudo apt-mark hold kubelet kubeadm kubectl
sudo systemctl daemon-reload
sudo systemctl restart kubelet
sleep 5
# Fix DNS issue: https://kubernetes.io/docs/tasks/administer-cluster/dns-debugging-resolution/#known-issues
echo 'KUBELET_EXTRA_ARGS="--resolv-conf=/run/systemd/resolve/resolv.conf"' | sudo tee -a /var/lib/kubelet/kubeadm-flags.env
sudo systemctl restart kubelet

# For your convenience, the base system and the cluster nodes, have the following additional command-line tools:
# Install additional command-line tools
sudo apt-get update && sudo apt-get install -y jq tmux curl wget man

# Autocomplete and alias
source <(kubectl completion bash)
echo "source <(kubectl completion bash)" >>~/.bashrc
echo "alias k='kubectl'" >>~/.bashrc

# vimrc
cat <<EOF | tee $HOME/.vimrc
set tabstop=2
set shiftwidth=2
set expandtab
syntax on
filetype indent plugin on
set ruler
EOF

# Only control-plane node
if [[ ! "$(hostname)" =~ "worker" ]]; then
    sudo kubeadm init
    mkdir -p $HOME/.kube
    sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
    sudo chown $(id -u):$(id -g) $HOME/.kube/config
    # Only root
    #export KUBECONFIG=/etc/kubernetes/admin.conf
    # Install CNI
    # https://www.weave.works/docs/net/latest/kubernetes/kube-addon/#-installation
    #kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"
    kubectl apply -f https://github.com/weaveworks/weave/releases/download/v2.8.1/weave-daemonset-k8s.yaml
fi
