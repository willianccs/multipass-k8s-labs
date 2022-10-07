#!/usr/bin/env bash

set -x 

echo "Starting multipass-k8s-labs"
echo "Creating VMs..."
multipass launch --name control-plane -c 2 -m 2G -d 10G focal
multipass launch --name worker-01 -c 2 -m 2G -d 5G focal
sleep 3
echo "Copying script to VMs..."
for this in control-plane worker-01
do
  multipass transfer 2-install.sh "${this}":/tmp
  multipass exec "${this}" -- sh -c 'chmod +x /tmp/2-install.sh'
done
echo "Done"

