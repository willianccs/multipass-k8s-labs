#!/usr/bin/env bash

set -eo pipefail 
# only for debug purposes
#set -x 

echo "Starting multipass-k8s-labs"
## Networks
# By default multipass uses the qemu backend driver. https://multipass.run/docs/set-command
# Currently only the LXD driver supports the networks command on Linux. https://multipass.run/docs/networks-command
# Check which backend you are using with `multipass get local.driver` if it doesn't return lxd you need to make sure lxd is installed \
# and set it as the driver `multipass set local.driver=lxd`
# Good refs: 
# https://gist.github.com/ynott/f4bdc89b940522f2a0e4b32790ddb731
# https://www.rootisgod.com/2022/Using-Multipass-Like-a-Personal-Cloud-Service/
# ```sh
# sudo snap install lxd
# sudo snap set lxd daemon.user.group=users
# sudo sudo snap set lxd daemon.user.group=users
# sudo sudo snap connect multipass:lxd lxd
# multipass set local.driver=lxd
# sudo systemctl restart snap.multipass.multipassd.service
# ```
echo "Creating VMs..."
multipass launch --name control-plane -c 2 -m 2G -d 10G focal || exit 1
multipass launch --name worker-01 -c 2 -m 2G -d 10G focal || exit 1
sleep 3
echo "Copying script to VMs..."
for this in control-plane worker-01
do
  multipass transfer 2-install.sh "${this}":/tmp
  multipass exec "${this}" -- sh -c 'chmod +x /tmp/2-install.sh'
done
echo "Done"

