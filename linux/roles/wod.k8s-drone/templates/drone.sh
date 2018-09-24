#!/bin/bash 

set -e  

REGISTRY_LOCAL="{{ REGISTRY_LOCAL }}"
REGISTRY_DRONE_CHART_REPO="{{ CLOUD_IMAGES['DRONE-CHART']['NAME'] }}"
REGISTRY_DRONE_CHART_VERSION="{{ CLOUD_IMAGES['DRONE-CHART']['VERSION'] }}"

mkdir -p /etc/kubernetes/helm

if ! [[ -e /etc/kubernetes/helm/DRONE/Chart.yaml ]]; then
  docker pull $REGISTRY_LOCAL$REGISTRY_DRONE_CHART_REPO:$REGISTRY_DRONE_CHART_VERSION
  docker run -v /etc/kubernetes/helm/drone:/data/output --rm $REGISTRY_LOCAL$REGISTRY_DRONE_CHART_REPO:$REGISTRY_DRONE_CHART_VERSION
  helm install /etc/kubernetes/helm/drone --name drone --namespace devops \
  --set gitlab.host="https://{{ GITLAB['HOST'] }}" \
  --set drone.server.image.repository={{ REGISTRY_LOCAL }}{{ CLOUD_IMAGES['DRONE-SERVER']['NAME'] }} \
  --set drone.server.image.tag={{ CLOUD_IMAGES['DRONE-SERVER']['VERSION'] }} \
  --set drone.agent.image.repository={{ REGISTRY_LOCAL }}{{ CLOUD_IMAGES['DRONE-AGENT']['NAME'] }} \
  --set drone.agent.image.tag={{ CLOUD_IMAGES['DRONE-AGENT']['VERSION'] }} \
  --set drone.server.host="{{ DRONE['HOST'] }}" 
fi

