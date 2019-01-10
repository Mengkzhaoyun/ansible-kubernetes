#!/bin/bash

set -e

HTTP_SERVER="${HTTP_SERVER:-https://dl.wodcloud.com/k8s}"
RKT_ACI_REGISTRY="${RKT_ACI_REGISTRY:-registry-2.6.2.aci}"
RKT_ACI_REGISTRY_DATA="${RKT_ACI_REGISTRY_DATA:-registry-data-v1.9.0}"
REGISTRY_REMOTE="${REGISTRY_REMOTE:-}"
REGISTRY_REMOTE_SPLIT="${REGISTRY_REMOTE_SPLIT:-}"
REGISTRY_REPO_REGISTRY="${REGISTRY_REPO_REGISTRY:-}"
REGISTRY_VERSION_REGISTRY="${REGISTRY_VERSION_REGISTRY:-}"
REGISTRY_DATA_PATH="${REGISTRY_DATA_PATH:-}"

mkdir -p /etc/kubernetes/downloads
mkdir -p /etc/kubernetes/data

if [[ -e /etc/kubernetes/downloads/$RKT_ACI_REGISTRY ]]; then
	echo 'registry aci is already exist!'
else
  if [[ -n "${REGISTRY_REMOTE:-}" ]]; then
    rkt --insecure-options=image fetch docker://$REGISTRY_REMOTE$REGISTRY_REPO_REGISTRY$REGISTRY_REMOTE_SPLIT$REGISTRY_VERSION_REGISTRY
    rkt image export $REGISTRY_REMOTE$REGISTRY_REPO_REGISTRY$REGISTRY_REMOTE_SPLIT$REGISTRY_VERSION_REGISTRY /etc/kubernetes/downloads/$REGISTRY_REPO_REGISTRY-$REGISTRY_VERSION_REGISTRY.aci
  else
    curl $HTTP_SERVER/$RKT_ACI_REGISTRY.tgz > /etc/kubernetes/downloads/$RKT_ACI_REGISTRY.tgz
    cd /etc/kubernetes/downloads && tar -xzf /etc/kubernetes/downloads/$RKT_ACI_REGISTRY.tgz
    rm -rf /etc/kubernetes/downloads/$RKT_ACI_REGISTRY.tgz
    echo 'registry aci download completed!'
  fi
fi

if [[ -e $REGISTRY_DATA_PATH/docker ]]; then
	echo 'registry data ready!'
else
  if [[ -n "${REGISTRY_REMOTE:-}" ]]; then
    echo 'registry data from remote!'
  else
    curl $HTTP_SERVER/$RKT_ACI_REGISTRY_DATA.tgz >/etc/kubernetes/downloads/$RKT_ACI_REGISTRY_DATA.tgz
    cd /etc/kubernetes/downloads && tar -xzf /etc/kubernetes/downloads/$RKT_ACI_REGISTRY_DATA.tgz
    rm -rf /etc/kubernetes/downloads/$RKT_ACI_REGISTRY_DATA.tgz
    mkdir -p $REGISTRY_DATA_PATH
    mv -n /etc/kubernetes/downloads/data/docker $REGISTRY_DATA_PATH
    rm -rf /etc/kubernetes/downloads/data
  fi
fi
