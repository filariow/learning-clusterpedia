#!/bin/sh

export KUBECONFIG=/tmp/clusterpedia.kcfg

kind create cluster --name clusterpedia-member-1
kind create cluster --name clusterpedia-member-2

kind create cluster --name clusterpedia
