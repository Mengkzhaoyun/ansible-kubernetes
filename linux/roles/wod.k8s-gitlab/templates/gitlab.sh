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
  --set gitlab.repository={{ REGISTRY_LOCAL }}{{ CLOUD_IMAGES['GITLAB']['NAME'] }} \
  --set gitlab.tag={{ REGISTRY_LOCAL }}{{ CLOUD_IMAGES['GITLAB']['VERSION'] }} \
  --set gitlab.host="{{ GITLAB['HOST'] }}" \
  --set gitlab.sshport="{{ GITLAB['SSHPORT'] }}" \
  --set postgresql.repository={{ REGISTRY_LOCAL }}{{ CLOUD_IMAGES['GITLAB-POSTGRESQL']['VERSION'] }} \
  --set postgresql.tag={{ REGISTRY_LOCAL }}{{ CLOUD_IMAGES['GITLAB-POSTGRESQL']['NAME'] }} \
  --set redis.repository={{ REGISTRY_LOCAL }}{{ CLOUD_IMAGES['GITLAB-REDIS']['VERSION'] }} \
  --set redis.tag={{ REGISTRY_LOCAL }}{{ CLOUD_IMAGES['GITLAB-REDIS']['NAME'] }}
fi

