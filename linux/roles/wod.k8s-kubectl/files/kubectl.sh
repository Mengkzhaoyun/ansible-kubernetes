#!/bin/bash 

set -e  

HTTP_SERVER="${HTTP_SERVER:-https://dl.wodcloud.com/k8s}"
REGISTRY_REMOTE="${REGISTRY_REMOTE:-}"
REGISTRY_KUBECTL_REPO="${REGISTRY_KUBECTL_REPO:-}"
REGISTRY_KUBECTL_VERSION="${REGISTRY_KUBECTL_VERSION:-}"
TOOLS_KUBECTL="${TOOLS_KUBECTL:-${REGISTRY_KUBECTL_REPO}-${REGISTRY_KUBECTL_VERSION}}"

mkdir -p /etc/kubernetes/downloads
mkdir -p /opt/bin

if ! [[ -e /etc/kubernetes/downloads/$TOOLS_KUBECTL ]]; then

  docker run -v /etc/kubernetes/downloads:/data/output --rm $REGISTRY_REMOTE$REGISTRY_KUBECTL_REPO:$REGISTRY_KUBECTL_VERSION

  cd /etc/kubernetes/downloads && tar -xzf /etc/kubernetes/downloads/$TOOLS_KUBECTL.tgz

  rm -rf /etc/kubernetes/downloads/$TOOLS_KUBECTL.tgz 

  chmod 0744 /etc/kubernetes/downloads/$TOOLS_KUBECTL
  rm -rf /opt/bin/kubectl
  ln -s /etc/kubernetes/downloads/$TOOLS_KUBECTL /opt/bin/kubectl  

  /opt/bin/kubectl config set-cluster kubernetes --server=http://127.0.0.1:8080
  /opt/bin/kubectl config set-context kubernetes --cluster=kubernetes
  /opt/bin/kubectl config use-context kubernetes      
fi

if ! [ -x "$(command -v kubectl)" ]; then
  ln -s /opt/bin/kubectl /usr/bin/kubectl
fi