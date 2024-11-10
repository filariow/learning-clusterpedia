# Clusterpedia demo

1. Create the clusters
    ```bash
    ./00-create-clusters.sh
    ```
1. Install Clusterpedia and create PediaClusters
    ```bash
    ./01-setup.sh
    ```
1. Export kubeconfig
    ```bash
    ./02-export-kubeconfigs.sh
    ```
1. Build kubeconfig
    ```bash
    ./03-build-kubeconfig.sh
    ```
1. Run some queries
    ```bash
    export KUBECONFIG=/tmp/clusterpedia/clusterpedia.kcfg
    kubectl get deployments -A
    kubectl get deployments -A -l "search.clusterpedia.io/clusters in (kind-clusterpedia-member-1)" 
    ```
