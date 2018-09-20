#!/bin/bash 

set -e  

TOOLS_HELM="{{ CLOUD_IMAGES['HELM']['NAME'] }}-{{ CLOUD_IMAGES['HELM']['VERSION'] }}"
REGISTRY_LOCAL="{{ REGISTRY_LOCAL }}"
REGISTRY_HELM_REPO="{{ CLOUD_IMAGES['HELM']['NAME'] }}"
REGISTRY_HELM_VERSION="{{ CLOUD_IMAGES['HELM']['VERSION'] }}"

mkdir -p /etc/kubernetes/downloads
mkdir -p /opt/bin

if ! [ -x "$(command -v helm)" ]; then
  if ! [[ -e /etc/kubernetes/downloads/$TOOLS_HELM ]]; then
    docker run -v /etc/kubernetes/downloads:/data/output --rm $REGISTRY_LOCAL$REGISTRY_HELM_REPO:$REGISTRY_HELM_VERSION
    cd /etc/kubernetes/downloads && tar -xzf /etc/kubernetes/downloads/$TOOLS_HELM.tgz
    rm -rf /etc/kubernetes/downloads/$TOOLS_HELM.tgz
  fi
  chmod 0744 /etc/kubernetes/downloads/$TOOLS_HELM
  rm -rf /opt/bin/helm
  ln -s /etc/kubernetes/downloads/$TOOLS_HELM /opt/bin/helm
  /opt/bin/helm config set-cluster kubernetes --server=http://127.0.0.1:8080
  /opt/bin/helm config set-context kubernetes --cluster=kubernetes
  /opt/bin/helm config use-context kubernetes
fi

if ! [ -x "$(command -v helm)" ]; then
  ln -s /opt/bin/helm /usr/bin/helm
fi