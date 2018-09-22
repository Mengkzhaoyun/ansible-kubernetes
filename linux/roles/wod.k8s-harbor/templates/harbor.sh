#!/bin/bash 

set -e  

REGISTRY_LOCAL="{{ REGISTRY_LOCAL }}"
REGISTRY_HARBOR_CHART_REPO="{{ CLOUD_IMAGES['HARBOR-CHART']['NAME'] }}"
REGISTRY_HARBOR_CHART_VERSION="{{ CLOUD_IMAGES['HARBOR-CHART']['VERSION'] }}"

mkdir -p /etc/kubernetes/helm

if ! [[ -e /etc/kubernetes/helm/HARBOR/Chart.yaml ]]; then
  docker pull $REGISTRY_LOCAL$REGISTRY_HARBOR_CHART_REPO:$REGISTRY_HARBOR_CHART_VERSION
  docker run -v /etc/kubernetes/helm/harbor:/data/output --rm $REGISTRY_LOCAL$REGISTRY_HARBOR_CHART_REPO:$REGISTRY_HARBOR_CHART_VERSION
  helm install /etc/kubernetes/helm/harbor --name harbor --namespace devops \
  --set externalDomain="{{ HARBOR['EXTERNALDOMAIN'] }}" \
  --set externalProtocol="{{ HARBOR['EXTERNALPROTOCOL'] }}" \
  --set harborAdminPassword="{{ HARBOR['PASSWORD'] }}" \
  --set adminserver.image.repository={{ REGISTRY_LOCAL }}{{ CLOUD_IMAGES['HARBOR-ADMINSERVER']['NAME'] }} \
  --set adminserver.image.tag={{ REGISTRY_LOCAL }}{{ CLOUD_IMAGES['HARBOR-ADMINSERVER']['VERSION'] }} \
  --set jobservice.image.repository={{ REGISTRY_LOCAL }}{{ CLOUD_IMAGES['HARBOR-JOBSERVICE']['NAME'] }} \
  --set jobservice.image.tag={{ REGISTRY_LOCAL }}{{ CLOUD_IMAGES['HARBOR-JOBSERVICE']['VERSION'] }} \
  --set ui.image.repository={{ REGISTRY_LOCAL }}{{ CLOUD_IMAGES['HARBOR-UI']['NAME'] }} \
  --set ui.image.tag={{ REGISTRY_LOCAL }}{{ CLOUD_IMAGES['HARBOR-UI']['VERSION'] }} \
  --set database.internal.image.repository={{ REGISTRY_LOCAL }}{{ CLOUD_IMAGES['HARBOR-DB']['NAME'] }} \
  --set database.internal.image.tag={{ REGISTRY_LOCAL }}{{ CLOUD_IMAGES['HARBOR-DB']['VERSION'] }} \
  --set registry.image.repository={{ REGISTRY_LOCAL }}{{ CLOUD_IMAGES['HARBOR-REGISTRY']['NAME'] }} \
  --set registry.image.tag={{ REGISTRY_LOCAL }}{{ CLOUD_IMAGES['HARBOR-REGISTRY']['VERSION'] }} \
  --set chartmuseum.image.repository={{ REGISTRY_LOCAL }}{{ CLOUD_IMAGES['HARBOR-CHARTMUSEUM']['NAME'] }} \
  --set chartmuseum.image.tag={{ REGISTRY_LOCAL }}{{ CLOUD_IMAGES['HARBOR-CHARTMUSEUM']['VERSION'] }} \
  --set clair.image.repository={{ REGISTRY_LOCAL }}{{ CLOUD_IMAGES['HARBOR-CLAIR']['NAME'] }} \
  --set clair.image.tag={{ REGISTRY_LOCAL }}{{ CLOUD_IMAGES['HARBOR-CLAIR']['VERSION'] }} \
  --set redis.image.repository={{ REGISTRY_LOCAL }}{{ CLOUD_IMAGES['HARBOR-REDIS']['NAME'] }} \
  --set redis.image.tag={{ REGISTRY_LOCAL }}{{ CLOUD_IMAGES['HARBOR-REDIS']['VERSION'] }} \
  --set redis.password="{{ HARBOR['REDIS-PASSWORD'] }}" \
  --set redis.external.port="{{ HARBOR['REDIS-PORT'] }}" \
  --set redis.external.password="{{ HARBOR['REDIS-PASSWORD'] }}" \
  --set notary.server.image.repository={{ REGISTRY_LOCAL }}{{ CLOUD_IMAGES['HARBOR-NOTARY-SERVER']['NAME'] }} \
  --set notary.server.image.tag={{ REGISTRY_LOCAL }}{{ CLOUD_IMAGES['HARBOR-NOTARY-SERVER']['VERSION'] }} \
  --set notary.signer.image.repository={{ REGISTRY_LOCAL }}{{ CLOUD_IMAGES['HARBOR-SIGNER-SERVER']['NAME'] }} \
  --set notary.signer.image.tag={{ REGISTRY_LOCAL }}{{ CLOUD_IMAGES['HARBOR-SIGNER-SERVER']['VERSION'] }} \
  --set jobservice.secret="{{ HARBOR['SECRET'] }}" \
  --set ui.secret="{{ HARBOR['SECRET'] }}" \
  --set registry.httpSecret="{{ HARBOR['SECRET'] }}"
fi

