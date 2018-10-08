#!/bin/bash 

set -e  

REGISTRY_LOCAL="{{ REGISTRY_LOCAL }}"
REGISTRY_GITLAB_CHART_REPO="{{ CLOUD_IMAGES['GITLAB-CHART']['NAME'] }}"
REGISTRY_GITLAB_CHART_VERSION="{{ CLOUD_IMAGES['GITLAB-CHART']['VERSION'] }}"

mkdir -p /etc/kubernetes/helm

if ! [[ -e /etc/kubernetes/helm/gitlab/Chart.yaml ]]; then
  docker pull $REGISTRY_LOCAL$REGISTRY_GITLAB_CHART_REPO:$REGISTRY_GITLAB_CHART_VERSION
  docker run -v /etc/kubernetes/helm/gitlab:/data/output --rm $REGISTRY_LOCAL$REGISTRY_GITLAB_CHART_REPO:$REGISTRY_GITLAB_CHART_VERSION
  helm install /etc/kubernetes/helm/gitlab --name gitlab --namespace devops \
  --set gitlab.host="{{ GITLAB['HOST'] }}" \
  --set gitlab.password="{{ GITLAB['PASSWORD'] }}" \
  --set gitlab.repository={{ REGISTRY_LOCAL }}{{ CLOUD_IMAGES['GITLAB']['NAME'] }} \
  --set gitlab.tag={{ CLOUD_IMAGES['GITLAB']['VERSION'] }} \
  --set postgresql.repository={{ REGISTRY_LOCAL }}{{ CLOUD_IMAGES['GITLAB-POSTGRESQL']['NAME'] }} \
  --set postgresql.tag={{ CLOUD_IMAGES['GITLAB-POSTGRESQL']['VERSION'] }} \
  --set redis.repository={{ REGISTRY_LOCAL }}{{ CLOUD_IMAGES['GITLAB-REDIS']['NAME'] }} \
  --set redis.tag={{ CLOUD_IMAGES['GITLAB-REDIS']['VERSION'] }}
fi

REGISTRY_LOCAL_IP="${REGISTRY_LOCAL_IP}"
GITLAB_HOST={{ GITLAB['HOST'] }}
if ! (grep -q ${GITLAB_HOST} /etc/hosts) ; then
  echo "${REGISTRY_LOCAL_IP} ${GITLAB_HOST}" >> /etc/hosts;
else
  sed -i "/${GITLAB_HOST}/c\\${REGISTRY_LOCAL_IP} ${GITLAB_HOST}" /etc/hosts
fi
