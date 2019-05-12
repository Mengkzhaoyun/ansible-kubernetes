#!/bin/bash

set -e

RKT_ACI_ETCD="${RKT_ACI_ETCD:-etcd-v3.2.0.aci}"

REGISTRY_LOCAL="${REGISTRY_LOCAL:-}"

REGISTRY_ETCD_REPO="${REGISTRY_ETCD_REPO:-}"
REGISTRY_ETCD_VERSION="${REGISTRY_ETCD_VERSION:-}"

REGISTRY_ETCDCTL_REPO="${REGISTRY_ETCDCTL_REPO:-}"
REGISTRY_ETCDCTL_VERSION="${REGISTRY_ETCDCTL_VERSION:-}"

TOOLS_ETCDCTL="${TOOLS_ETCDCTL:-${REGISTRY_ETCDCTL_REPO}-${REGISTRY_ETCDCTL_VERSION}}"

mkdir -p /etc/kubernetes/downloads
mkdir -p /etc/kubernetes/data

if [[ -e /etc/kubernetes/downloads/$RKT_ACI_ETCD ]]; then
	echo 'etcd aci is already exist!'
else
  rkt --insecure-options=http,image fetch docker://$REGISTRY_LOCAL$REGISTRY_ETCD_REPO:$REGISTRY_ETCD_VERSION
  REGISTRY_LOCAL_RKT=$(echo $REGISTRY_LOCAL | sed 's/:/_/g')
  rkt image export $REGISTRY_LOCAL_RKT$REGISTRY_ETCD_REPO:$REGISTRY_ETCD_VERSION /etc/kubernetes/downloads/$REGISTRY_ETCD_REPO-$REGISTRY_ETCD_VERSION.aci
fi

if ! [ -x "$(command -v etcdctl)" ]; then
  if ! [[ -e /etc/kubernetes/downloads/$TOOLS_ETCDCTL ]]; then
    docker run -v /etc/kubernetes/downloads:/data/output --rm $REGISTRY_LOCAL$REGISTRY_ETCDCTL_REPO:$REGISTRY_ETCDCTL_VERSION
    cd /etc/kubernetes/downloads && tar -xzf /etc/kubernetes/downloads/$TOOLS_ETCDCTL.tgz
    rm -rf /etc/kubernetes/downloads/$TOOLS_ETCDCTL.tgz    
  fi
  chmod 0744 /etc/kubernetes/downloads/$TOOLS_ETCDCTL
  rm -rf /usr/bin/etcdctl
  ln -s /etc/kubernetes/downloads/$TOOLS_ETCDCTL /usr/bin/etcdctl
fi