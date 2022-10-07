#!/usr/bin/env bash

echo "Destroying multipass-k8s-labs..."
multipass stop --all
multipass delete --all
multipass purge
echo "Done"

