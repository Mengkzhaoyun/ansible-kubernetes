#!/bin/bash 

set -e  

REGISTRY_LOCAL="{{ REGISTRY_LOCAL }}"
REGISTRY_DRONE_CHART_REPO="{{ CLOUD_IMAGES['DRONE-CHART']['NAME'] }}"
REGISTRY_DRONE_CHART_VERSION="{{ CLOUD_IMAGES['DRONE-CHART']['VERSION'] }}"

mkdir -p /etc/kubernetes/helm

if ! [[ -e /etc/kubernetes/helm/drone/Chart.yaml ]]; then
  docker pull $REGISTRY_LOCAL$REGISTRY_DRONE_CHART_REPO:$REGISTRY_DRONE_CHART_VERSION
  docker run -v /etc/kubernetes/helm/drone:/data/output --rm $REGISTRY_LOCAL$REGISTRY_DRONE_CHART_REPO:$REGISTRY_DRONE_CHART_VERSION
  helm install /etc/kubernetes/helm/drone --name drone --namespace devops \
  --set gitlab.host="{{ GITLAB['HOST'] }}" \
  --set drone.host="{{ DRONE['HOST'] }}" \
  --set drone.server.image.repository={{ REGISTRY_LOCAL }}{{ CLOUD_IMAGES['DRONE-SERVER']['NAME'] }} \
  --set drone.server.image.tag={{ CLOUD_IMAGES['DRONE-SERVER']['VERSION'] }} \
  --set drone.agent.image.repository={{ REGISTRY_LOCAL }}{{ CLOUD_IMAGES['DRONE-AGENT']['NAME'] }} \
  --set drone.agent.image.tag={{ CLOUD_IMAGES['DRONE-AGENT']['VERSION'] }} 
fi

REGISTRY_LOCAL_IP="${REGISTRY_LOCAL_IP}"
DRONE_HOST={{ DRONE['HOST'] }}
if ! (grep -q ${DRONE_HOST} /etc/hosts) ; then
  echo "${REGISTRY_LOCAL_IP} ${DRONE_HOST}" >> /etc/hosts;
else
  sed -i "/${DRONE_HOST}/c\\${REGISTRY_LOCAL_IP} ${DRONE_HOST}" /etc/hosts
fi