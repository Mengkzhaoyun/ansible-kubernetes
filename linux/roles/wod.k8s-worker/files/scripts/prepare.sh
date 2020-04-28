#!/bin/bash

set -e

REGISTRY_LOCAL="${REGISTRY_LOCAL:-}"
REGISTRY_KUBELET_REPO="${REGISTRY_KUBELET_REPO:-}"
REGISTRY_KUBELET_VERSION="${REGISTRY_KUBELET_VERSION:-}"

mkdir -p /etc/kubernetes/downloads
mkdir -p /etc/kubernetes/config
mkdir -p /opt/bin

if [[ -e /etc/kubernetes/downloads/$REGISTRY_KUBELET_REPO-$REGISTRY_KUBELET_VERSION ]]; then
	echo 'kubelet is already exist!'
else
  rm -rf /opt/bin/kubelet
  docker run -v /etc/kubernetes/downloads:/data/output --rm --entrypoint=bash $REGISTRY_LOCAL$REGISTRY_KUBELET_REPO:$REGISTRY_KUBELET_VERSION -c 'cp /usr/local/bin/kubelet /data/output/kubelet'
  mv /etc/kubernetes/downloads/kubelet /etc/kubernetes/downloads/$REGISTRY_KUBELET_REPO-$REGISTRY_KUBELET_VERSION
  chmod +x /etc/kubernetes/downloads/$REGISTRY_KUBELET_REPO-$REGISTRY_KUBELET_VERSION
  ln -s /etc/kubernetes/downloads/$REGISTRY_KUBELET_REPO-$REGISTRY_KUBELET_VERSION /opt/bin/kubelet
fi