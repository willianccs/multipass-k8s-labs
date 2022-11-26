#!/usr/bin/env bash
#shellcheck disable=SC2016

KUBE_BENCH_VERSION="0.6.2"

curl -L https://github.com/aquasecurity/kube-bench/releases/download/v"${KUBE_BENCH_VERSION}"/kube-bench_"${KUBE_BENCH_VERSION}"_linux_amd64.tar.gz -o kube-bench_"${KUBE_BENCH_VERSION}"_linux_amd64.tar.gz
sudo tar -xvf kube-bench_"${KUBE_BENCH_VERSION}"_linux_amd64.tar.gz -C /opt

echo "Now you can then run kube-bench directly:"
echo "cd /opt"
echo 'sudo ./kube-bench --config-dir $(pwd)/cfg --config $(pwd)/cfg/config.yaml | tee /tmp/kube-bench-report.log'
