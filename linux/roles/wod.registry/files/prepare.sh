#!/bin/bash

set -e

HTTP_SERVER="${HTTP_SERVER:-https://dl.wodcloud.com/k8s}"
RKT_ACI_REGISTRY="${RKT_ACI_REGISTRY:-registry-2.7.1.aci}"

mkdir -p /etc/kubernetes/downloads
mkdir -p /etc/kubernetes/data

if [[ -e /etc/kubernetes/downloads/$RKT_ACI_REGISTRY ]]; then
	echo 'registry aci is already exist!'
else
  curl $HTTP_SERVER/$RKT_ACI_REGISTRY.tgz > /etc/kubernetes/downloads/$RKT_ACI_REGISTRY.tgz
  cd /etc/kubernetes/downloads && tar -xzf /etc/kubernetes/downloads/$RKT_ACI_REGISTRY.tgz
  rm -rf /etc/kubernetes/downloads/$RKT_ACI_REGISTRY.tgz
  echo 'registry aci download completed!'
fi