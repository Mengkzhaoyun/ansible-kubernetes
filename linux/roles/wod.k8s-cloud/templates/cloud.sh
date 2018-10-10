#!/bin/bash 

set -e  

REGISTRY_LOCAL="{{ REGISTRY_LOCAL }}"
REGISTRY_CLOUD_CHART_REPO="{{ CLOUD_IMAGES['CLOUD-CHART']['NAME'] }}"
REGISTRY_CLOUD_CHART_VERSION="{{ CLOUD_IMAGES['CLOUD-CHART']['VERSION'] }}"

mkdir -p /etc/kubernetes/helm

if ! [[ -e /etc/kubernetes/helm/cloud/Chart.yaml ]]; then
  docker pull $REGISTRY_LOCAL$REGISTRY_CLOUD_CHART_REPO:$REGISTRY_CLOUD_CHART_VERSION
  docker run -v /etc/kubernetes/helm/cloud:/data/output --rm $REGISTRY_LOCAL$REGISTRY_CLOUD_CHART_REPO:$REGISTRY_CLOUD_CHART_VERSION
  helm install /etc/kubernetes/helm/cloud --name cloud --namespace cloud \
  --set host="{{ CLOUD['HOST'] }}" \
  --set gitlab.host="{{ GITLAB['HOST'] }}" \
  --set redis.repository={{ REGISTRY_LOCAL }}{{ CLOUD_IMAGES['CLOUD-REDIS']['NAME'] }} \
  --set redis.tag={{ CLOUD_IMAGES['CLOUD-REDIS']['VERSION'] }} \
  --set mysql.image.repository={{ REGISTRY_LOCAL }}{{ CLOUD_IMAGES['CLOUD-MYSQL']['NAME'] }} \
  --set mysql.image.tag={{ CLOUD_IMAGES['CLOUD-MYSQL']['VERSION'] }} \
  --set mysql.initImage.repository={{ REGISTRY_LOCAL }}{{ CLOUD_IMAGES['CLOUD-INITMYSQL']['NAME'] }} \
  --set mysql.initImage.tag={{ CLOUD_IMAGES['CLOUD-INITMYSQL']['VERSION'] }} \
  --set harbor.password="{{ HARBOR['PASSWORD'] }}" \
  --set harbor.registory="{{ HARBOR['HOST'] }}" \
  --set k8s.password="{{ K8S_ADMIN_PWD }}" \
  --set drone.server="{{ DRONE['HOST'] }}" \
  --set awecloud.dex.image.repository={{ REGISTRY_LOCAL }}{{ CLOUD_IMAGES['CLOUD-AWECLOUD-DEX']['NAME'] }} \
  --set awecloud.dex.image.tag={{ CLOUD_IMAGES['CLOUD-AWECLOUD-DEX']['VERSION'] }} \
  --set awecloud.api.image.repository={{ REGISTRY_LOCAL }}{{ CLOUD_IMAGES['CLOUD-AWECLOUD-API']['NAME'] }} \
  --set awecloud.api.image.tag={{ CLOUD_IMAGES['CLOUD-AWECLOUD-API']['VERSION'] }} \
  --set awecloud.deploy.image.repository={{ REGISTRY_LOCAL }}{{ CLOUD_IMAGES['CLOUD-AWECLOUD-DEPLOY']['NAME'] }} \
  --set awecloud.deploy.image.tag={{ CLOUD_IMAGES['CLOUD-AWECLOUD-DEPLOY']['VERSION'] }} \
  --set awecloud.harbor.image.repository={{ REGISTRY_LOCAL }}{{ CLOUD_IMAGES['CLOUD-AWECLOUD-HARBOR']['NAME'] }} \
  --set awecloud.harbor.image.tag={{ CLOUD_IMAGES['CLOUD-AWECLOUD-HARBOR']['VERSION'] }} \
  --set awecloud.kubernetes.image.repository={{ REGISTRY_LOCAL }}{{ CLOUD_IMAGES['CLOUD-AWECLOUD-KUBERNETES']['NAME'] }} \
  --set awecloud.kubernetes.image.tag={{ CLOUD_IMAGES['CLOUD-AWECLOUD-KUBERNETES']['VERSION'] }} \
  --set awecloud.rest.image.repository={{ REGISTRY_LOCAL }}{{ CLOUD_IMAGES['CLOUD-AWECLOUD-REST']['NAME'] }} \
  --set awecloud.rest.image.tag={{ CLOUD_IMAGES['CLOUD-AWECLOUD-REST']['VERSION'] }} \
  --set awecloud.login.image.repository={{ REGISTRY_LOCAL }}{{ CLOUD_IMAGES['CLOUD-AWECLOUD-LOGIN']['NAME'] }} \
  --set awecloud.login.image.tag={{ CLOUD_IMAGES['CLOUD-AWECLOUD-LOGIN']['VERSION'] }} \
  --set awecloud.ui.image.repository={{ REGISTRY_LOCAL }}{{ CLOUD_IMAGES['CLOUD-AWECLOUD-UI']['NAME'] }} \
  --set awecloud.ui.image.tag={{ CLOUD_IMAGES['CLOUD-AWECLOUD-UI']['VERSION'] }} \
  --set awecloud.users.image.repository={{ REGISTRY_LOCAL }}{{ CLOUD_IMAGES['CLOUD-AWECLOUD-USERS']['NAME'] }} \
  --set awecloud.users.image.tag={{ CLOUD_IMAGES['CLOUD-AWECLOUD-USERS']['VERSION'] }}
fi

REGISTRY_LOCAL_IP="${REGISTRY_LOCAL_IP}"
CLOUD_HOST={{ CLOUD['HOST'] }}
if ! (grep -q ${CLOUD_HOST} /etc/hosts) ; then
  echo "${REGISTRY_LOCAL_IP} ${CLOUD_HOST}" >> /etc/hosts;
else
  sed -i "/${CLOUD_HOST}/c\\${REGISTRY_LOCAL_IP} ${CLOUD_HOST}" /etc/hosts
fi