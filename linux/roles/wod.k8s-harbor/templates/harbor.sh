#!/bin/bash 

set -e  

function require_ev_all() {
  for rev in $@ ; do
    if [[ -z "${!rev}" ]]; then
      echo ${rev} is not set
      exit 1
    fi
  done
}

require_ev_all REGISTRY_LOCAL_IP

REGISTRY_LOCAL="{{ REGISTRY_LOCAL }}"
REGISTRY_HARBOR_CHART_REPO="{{ CLOUD_IMAGES['HARBOR-CHART']['NAME'] }}"
REGISTRY_HARBOR_CHART_VERSION="{{ CLOUD_IMAGES['HARBOR-CHART']['VERSION'] }}"

mkdir -p /etc/kubernetes/helm

if ! [[ -e /etc/kubernetes/helm/harbor/Chart.yaml ]]; then
  docker pull $REGISTRY_LOCAL$REGISTRY_HARBOR_CHART_REPO:$REGISTRY_HARBOR_CHART_VERSION
  docker run -v /etc/kubernetes/helm/harbor:/data/output --rm $REGISTRY_LOCAL$REGISTRY_HARBOR_CHART_REPO:$REGISTRY_HARBOR_CHART_VERSION
  helm install /etc/kubernetes/helm/harbor --name harbor --namespace devops \
  --set externalDomain="{{ HARBOR['HOST'] }}" \
  --set harborAdminPassword="{{ HARBOR['PASSWORD'] }}" \
  --set registry.filesystem.rootdirectory="/data/devops/harbor/registry" \
  --set registry.nodeSelector."kubernetes\.io/hostname"="{{ HOST_IP }}" \
  --set busybox.image.repository={{ REGISTRY_LOCAL }}{{ K8S_IMAGES['BUSYBOX']['NAME'] }} \
  --set busybox.image.tag={{ K8S_IMAGES['BUSYBOX']['VERSION'] }} \
  --set adminserver.image.repository={{ REGISTRY_LOCAL }}{{ CLOUD_IMAGES['HARBOR-ADMINSERVER']['NAME'] }} \
  --set adminserver.image.tag={{ CLOUD_IMAGES['HARBOR-ADMINSERVER']['VERSION'] }} \
  --set jobservice.image.repository={{ REGISTRY_LOCAL }}{{ CLOUD_IMAGES['HARBOR-JOBSERVICE']['NAME'] }} \
  --set jobservice.image.tag={{ CLOUD_IMAGES['HARBOR-JOBSERVICE']['VERSION'] }} \
  --set ui.image.repository={{ REGISTRY_LOCAL }}{{ CLOUD_IMAGES['HARBOR-UI']['NAME'] }} \
  --set ui.image.tag={{ CLOUD_IMAGES['HARBOR-UI']['VERSION'] }} \
  --set database.internal.image.repository={{ REGISTRY_LOCAL }}{{ CLOUD_IMAGES['HARBOR-DB']['NAME'] }} \
  --set database.internal.image.tag={{ CLOUD_IMAGES['HARBOR-DB']['VERSION'] }} \
  --set registry.image.repository={{ REGISTRY_LOCAL }}{{ CLOUD_IMAGES['HARBOR-REGISTRY']['NAME'] }} \
  --set registry.image.tag={{ CLOUD_IMAGES['HARBOR-REGISTRY']['VERSION'] }} \
  --set chartmuseum.image.repository={{ REGISTRY_LOCAL }}{{ CLOUD_IMAGES['HARBOR-CHARTMUSEUM']['NAME'] }} \
  --set chartmuseum.image.tag={{ CLOUD_IMAGES['HARBOR-CHARTMUSEUM']['VERSION'] }} \
  --set clair.image.repository={{ REGISTRY_LOCAL }}{{ CLOUD_IMAGES['HARBOR-CLAIR']['NAME'] }} \
  --set clair.image.tag={{ CLOUD_IMAGES['HARBOR-CLAIR']['VERSION'] }} \
  --set redis.image.repository={{ REGISTRY_LOCAL }}{{ CLOUD_IMAGES['HARBOR-REDIS']['NAME'] }} \
  --set redis.image.tag={{ CLOUD_IMAGES['HARBOR-REDIS']['VERSION'] }} \
  --set notary.server.image.repository={{ REGISTRY_LOCAL }}{{ CLOUD_IMAGES['HARBOR-NOTARY-SERVER']['NAME'] }} \
  --set notary.server.image.tag={{ CLOUD_IMAGES['HARBOR-NOTARY-SERVER']['VERSION'] }} \
  --set notary.signer.image.repository={{ REGISTRY_LOCAL }}{{ CLOUD_IMAGES['HARBOR-SIGNER-SERVER']['NAME'] }} \
  --set notary.signer.image.tag={{ CLOUD_IMAGES['HARBOR-SIGNER-SERVER']['VERSION'] }}
fi

REGISTRY_LOCAL_IP="${REGISTRY_LOCAL_IP}"
HARBOR_HOST={{ HARBOR['HOST'] }}
if ! (grep -q ${HARBOR_HOST} /etc/hosts) ; then
  echo "${REGISTRY_LOCAL_IP} ${HARBOR_HOST}" >> /etc/hosts;
else
  sed -i "/${HARBOR_HOST}/c\\${REGISTRY_LOCAL_IP} ${HARBOR_HOST}" /etc/hosts
fi