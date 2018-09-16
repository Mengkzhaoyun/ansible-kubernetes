#!/bin/bash

set -e

HTTP_SERVER="${HTTP_SERVER:-http://k8s.spacecig.com/softs/kubernetes}"
RKT_ACI_NGINX="${RKT_ACI_NGINX:-nginx:1.13.3-alpine}"
REGISTRY_REMOTE="${REGISTRY_REMOTE:-}"
REGISTRY_REMOTE_SPLIT="${REGISTRY_REMOTE_SPLIT:-}"
REGISTRY_REPO_REGISTRY="${REGISTRY_REPO_REGISTRY:-}"
REGISTRY_VERSION_REGISTRY="${REGISTRY_VERSION_REGISTRY:-}"

mkdir -p /etc/kubernetes/downloads
mkdir -p /etc/kubernetes/nginx
mkdir -p /etc/kubernetes/nginx-pod

if [[ -e /etc/kubernetes/downloads/$RKT_ACI_NGINX.aci ]]; then
	echo 'nginx aci is already exist!'
else
  if [[ -n "${REGISTRY_REMOTE:-}" ]]; then
    rkt --insecure-options=image fetch docker://$REGISTRY_REMOTE$REGISTRY_REPO_REGISTRY$REGISTRY_REMOTE_SPLIT$REGISTRY_VERSION_REGISTRY
    rkt image export $REGISTRY_REMOTE$REGISTRY_REPO_REGISTRY$REGISTRY_REMOTE_SPLIT$REGISTRY_VERSION_REGISTRY /etc/kubernetes/downloads/$REGISTRY_REPO_REGISTRY-$REGISTRY_VERSION_REGISTRY.aci
  else
    curl $HTTP_SERVER/$RKT_ACI_NGINX.tgz > /etc/kubernetes/downloads/$RKT_ACI_NGINX.tgz
    cd /etc/kubernetes/downloads && tar -xzf /etc/kubernetes/downloads/$RKT_ACI_NGINX.tgz
    rm -rf /etc/kubernetes/downloads/$RKT_ACI_NGINX.tgz
    echo 'nginx aci download completed!'
  fi
fi
