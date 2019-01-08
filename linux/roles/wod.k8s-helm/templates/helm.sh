#!/bin/bash 

set -e  

HTTP_SERVER="${HTTP_SERVER:-https://dl.wodcloud.com/k8s}"
TOOLS_HELM="{{ CLOUD_IMAGES['HELM']['NAME'] }}-{{ CLOUD_IMAGES['HELM']['VERSION'] }}"
REGISTRY_LOCAL="{{ REGISTRY_LOCAL }}"
REGISTRY_HELM_REPO="{{ CLOUD_IMAGES['HELM']['NAME'] }}"
REGISTRY_HELM_VERSION="{{ CLOUD_IMAGES['HELM']['VERSION'] }}"
REGISTRY_TILLER_REPO="{{ CLOUD_IMAGES['TILLER']['NAME'] }}"
REGISTRY_TILLER_VERSION="{{ CLOUD_IMAGES['TILLER']['VERSION'] }}"

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
  if ! [[ -e /etc/kubernetes/addons/kube-system/rbac-tiller.yml ]]; then
    /opt/bin/kubectl create serviceaccount --namespace kube-system tiller
    /opt/bin/kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller
  fi
  /opt/bin/helm init --upgrade -i $REGISTRY_LOCAL$REGISTRY_TILLER_REPO:$REGISTRY_TILLER_VERSION --service-account tiller --stable-repo-url $HTTP_SERVER/charts
fi

if ! [ -x "$(command -v helm)" ]; then
  ln -s /opt/bin/helm /usr/bin/helm
fi