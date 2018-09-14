#!/bin/bash

set -e

HTTP_SERVER="${HTTP_SERVER:-http://k8s.spacecig.com/softs/kubernetes}"
RKT_ACI_NGINX="${RKT_ACI_NGINX:-nginx-1.15.3}"
REGISTRY_REMOTE="${REGISTRY_REMOTE:-}"
REGISTRY_REMOTE_SPLIT="${REGISTRY_REMOTE_SPLIT:-}"
REGISTRY_REPO_NGINX="${REGISTRY_REPO_NGINX:-}"
REGISTRY_VERSION_NGINX="${REGISTRY_VERSION_NGINX:-}"

mkdir -p /etc/kubernetes/downloads
mkdir -p /etc/kubernetes/data

if [[ -e /etc/kubernetes/downloads/$RKT_ACI_NGINX.aci ]]; then
	echo 'nginx aci is already exist!'
else
  if [[ -n "${REGISTRY_REMOTE:-}" ]]; then
    rkt --insecure-options=image fetch docker://$REGISTRY_REMOTE$REGISTRY_REPO_NGINX$REGISTRY_REMOTE_SPLIT$REGISTRY_VERSION_NGINX
    rkt image export $REGISTRY_REMOTE$REGISTRY_REPO_NGINX$REGISTRY_REMOTE_SPLIT$REGISTRY_VERSION_NGINX /etc/kubernetes/downloads/$REGISTRY_REPO_NGINX-$REGISTRY_VERSION_NGINX.aci
  else
    curl $HTTP_SERVER/$RKT_ACI_NGINX.tgz > /etc/kubernetes/downloads/$RKT_ACI_NGINX.tgz
    cd /etc/kubernetes/downloads && tar -xzf /etc/kubernetes/downloads/$RKT_ACI_NGINX.tgz
    rm -rf /etc/kubernetes/downloads/$RKT_ACI_NGINX.tgz
    echo 'nginx aci download completed!'
  fi
fi
