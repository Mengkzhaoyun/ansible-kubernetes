#!/bin/bash 

set -e  

REGISTRY_LOCAL="{{ REGISTRY_LOCAL }}"
REGISTRY_TRAEFIK_CHART_REPO="{{ CLOUD_IMAGES['TRAEFIK-CHART']['NAME'] }}"
REGISTRY_TRAEFIK_CHART_VERSION="{{ CLOUD_IMAGES['TRAEFIK-CHART']['VERSION'] }}"

mkdir -p /etc/kubernetes/helm

if ! [[ -e /etc/kubernetes/helm/traefik/Chart.yaml ]]; then
  docker pull $REGISTRY_LOCAL$REGISTRY_TRAEFIK_CHART_REPO:$REGISTRY_TRAEFIK_CHART_VERSION
  docker run -v /etc/kubernetes/helm/traefik:/data/output --rm $REGISTRY_LOCAL$REGISTRY_TRAEFIK_CHART_REPO:$REGISTRY_TRAEFIK_CHART_VERSION
  helm install /etc/kubernetes/helm/traefik --name traefik --namespace kube-system \
  --set image.repository={{ REGISTRY_LOCAL }}{{ CLOUD_IMAGES['TRAEFIK-NODE']['NAME'] }} \
  --set image.tag={{ CLOUD_IMAGES['TRAEFIK-NODE']['VERSION'] }} \
fi