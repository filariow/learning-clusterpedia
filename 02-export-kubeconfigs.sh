#!/bin/sh

mkdir /tmp/clusterpedia/
kind get kubeconfig --name clusterpedia-host  > /tmp/clusterpedia/clusterpedia-host.kcfg
kind get kubeconfig --name clusterpedia-member-1 > /tmp/clusterpedia/clusterpedia-member-1.kcfg
kind get kubeconfig --name clusterpedia-member-2 > /tmp/clusterpedia/clusterpedia-member-2.kcfg
