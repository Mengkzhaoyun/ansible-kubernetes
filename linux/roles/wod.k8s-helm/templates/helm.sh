#!/bin/bash 

set -e  

HTTP_SERVER="${HTTP_SERVER:-https://dl.wodcloud.com/k8s}"
TOOLS_HELM="{{ K8S_IMAGES['HELM']['NAME'] }}-{{ K8S_IMAGES['HELM']['VERSION'] }}"
REGISTRY_LOCAL="{{ REGISTRY_LOCAL }}"
REGISTRY_HELM_REPO="{{ K8S_IMAGES['HELM']['NAME'] }}"
REGISTRY_HELM_VERSION="{{ K8S_IMAGES['HELM']['VERSION'] }}"
REGISTRY_TILLER_REPO="{{ K8S_IMAGES['TILLER']['NAME'] }}"
REGISTRY_TILLER_VERSION="{{ K8S_IMAGES['TILLER']['VERSION'] }}"

mkdir -p /etc/kubernetes/downloads
mkdir -p /opt/bin

if ! [[ -e /etc/kubernetes/downloads/$TOOLS_HELM ]]; then

  docker run -v /etc/kubernetes/downloads:/data/output --rm $REGISTRY_LOCAL$REGISTRY_HELM_REPO:$REGISTRY_HELM_VERSION
  cd /etc/kubernetes/downloads && tar -xzf /etc/kubernetes/downloads/$TOOLS_HELM.tgz
  rm -rf /etc/kubernetes/downloads/$TOOLS_HELM.tgz

  chmod 0744 /etc/kubernetes/downloads/$TOOLS_HELM
  rm -rf /opt/bin/helm
  ln -s /etc/kubernetes/downloads/$TOOLS_HELM /opt/bin/helm

  if ! [[ -e /etc/kubernetes/addons/kube-system/rbac-tiller.yml ]]; then
    /opt/bin/kubectl create serviceaccount --namespace kube-system tiller
    /opt/bin/kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller
  fi    

  /opt/bin/helm init --upgrade -i $REGISTRY_LOCAL$REGISTRY_TILLER_REPO:$REGISTRY_TILLER_VERSION --service-account tiller --stable-repo-url $HTTP_SERVER/charts    

else
  
  /opt/bin/kubectl get serviceaccount --namespace kube-system tiller &> /dev/null
  if [[ $? == 0 ]];then
    /opt/bin/helm init --upgrade -i $REGISTRY_LOCAL$REGISTRY_TILLER_REPO:$REGISTRY_TILLER_VERSION --service-account tiller --stable-repo-url $HTTP_SERVER/charts
  else
    /opt/bin/kubectl create serviceaccount --namespace kube-system tiller
    /opt/bin/kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller  
  fi
  
fi

if ! [ -x "$(command -v helm)" ]; then
  ln -s /opt/bin/helm /usr/bin/helm
fi