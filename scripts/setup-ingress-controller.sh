#!/usr/bin/env bash

# https://kubernetes.github.io/ingress-nginx/deploy/#bare-metal-clusters
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.5.1/deploy/static/provider/baremetal/deploy.yaml
