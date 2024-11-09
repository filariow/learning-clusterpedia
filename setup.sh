#!/bin/sh

set -e

export KUBECONFIG=/tmp/clusterpedia.kcfg

helm repo add clusterpedia https://clusterpedia-io.github.io/clusterpedia-helm/ --force-update
helm repo update
helm install --kube-context=kind-clusterpedia \
  clusterpedia clusterpedia/clusterpedia \
  --namespace clusterpedia \
  --kube-context kind-clusterpedia \
  --create-namespace \
  --set persistenceMatchNode=None \
  --set installCRDs=true

sleep 20

for i in {1..2}; do
  kubectl apply \
    -f 'https://raw.githubusercontent.com/clusterpedia-io/clusterpedia/main/examples/clusterpedia_synchro_rbac.yaml' \
    --context "kind-clusterpedia-member-${i}"

  SYNCHRO_CA=$(kubectl get configmaps --context "kind-clusterpedia-member-${i}" kube-root-ca.crt -o jsonpath='{.data.ca\.crt}' | base64 -w 0)
  SYNCHRO_TOKEN=$(kubectl -n default --context "kind-clusterpedia-member-${i}" create token clusterpedia-synchro | base64 -w 0 )

  cat << EOF | kubectl apply -f - --context kind-clusterpedia
apiVersion: cluster.clusterpedia.io/v1alpha2
kind: PediaCluster
metadata:
  name: kind-clusterpedia-member-${i}
spec:
  apiserver: https://clusterpedia-member-${i}-control-plane:6443
  caData: ${SYNCHRO_CA}
  tokenData: ${SYNCHRO_TOKEN}
  syncResources:
  - group: apps
    resources:
     - deployments
  - group: ""
    resources:
     - pods
     - configmaps
  - group: cert-manager.io
    versions:
      - v1
    resources:
      - certificates
EOF

done


