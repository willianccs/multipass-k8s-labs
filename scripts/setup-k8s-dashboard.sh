#!/user/bin/env bash

# https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.6.1/aio/deploy/recommended.yaml

# To create a token for this demo, you can follow the steps forward.
# Warning: The sample user created in the tutorial will have administrative privileges and is for educational purposes only.
#
#kubectl create clusterrolebinding binding-bash --serviceaccount default:admin-dash --clusterrole cluster-admin
#kubectl create token admin-dash

# Command line proxy
# You can enable access to the Dashboard using the kubectl command-line tool, by running the following command:
#kubectl proxy

# Kubectl will make Dashboard available at http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/.
