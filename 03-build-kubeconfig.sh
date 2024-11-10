#!/bin/sh

cp /tmp/clusterpedia/clusterpedia-host.kcfg /tmp/clusterpedia/clusterpedia.kcfg
sed -i \
  's/kind-clusterpedia-host/clusterpedia/g' \
  '/tmp/clusterpedia/clusterpedia.kcfg'

kubectl config set-cluster clusterpedia \
  --kubeconfig=/tmp/clusterpedia/clusterpedia.kcfg \
  --server="$(kubectl config view --minify \
    -o jsonpath='{.clusters[0].cluster.server}' \
    --kubeconfig="/tmp/clusterpedia/clusterpedia-host.kcfg")/apis/clusterpedia.io/v1beta1/resources"
kubectl config set-context clusterpedia --kubeconfig=/tmp/clusterpedia/clusterpedia.kcfg

KUBECONFIG=/tmp/clusterpedia/clusterpedia.kcfg:/tmp/clusterpedia/clusterpedia-host.kcfg:/tmp/clusterpedia/clusterpedia-member-1.kcfg:/tmp/clusterpedia/clusterpedia-member-2.kcfg \
  kubectl config view --flatten > /tmp/clusterpedia/clusterpedia-all.kcfg
kubectl config set-context clusterpedia --kubeconfig=/tmp/clusterpedia/clusterpedia-all.kcfg
