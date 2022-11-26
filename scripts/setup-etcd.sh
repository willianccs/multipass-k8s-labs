#!/usr/bin/env bash

set -eo pipefail

echo "Dowload and extract the latest version"
cd /tmp || exit 1
RELEASE=$(curl -s https://api.github.com/repos/etcd-io/etcd/releases/latest | grep tag_name | cut -d '"' -f 4)
export RELEASE
wget "https://github.com/etcd-io/etcd/releases/download/${RELEASE}/etcd-${RELEASE}-linux-amd64.tar.gz"
tar xvf "etcd-${RELEASE}-linux-amd64.tar.gz"
cd "etcd-${RELEASE}-linux-amd64" || exit 1

echo "Move etcd and etcdctl binary files to /usr/local/bin directory"
sudo mv etcd etcdctl /usr/local/bin

echo "Create Etcd configuration file and data directory"
sudo mkdir -p /var/lib/etcd/
sudo mkdir /etc/etcd

echo "Create etcd system user"
sudo groupadd --system etcd
sudo useradd -s /sbin/nologin --system -g etcd etcd

#echo "Set /var/lib/etcd/ directory ownership to etcd user"
# CIS benchmark: [FAIL] 1.1.12 Ensure that the etcd data directory ownership is set to etcd:etcd (Automated)
# sudo chown -R etcd:etcd /var/lib/etcd/
