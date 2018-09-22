#!/bin/bash 

set -e  

REGISTRY_LOCAL="{{ REGISTRY_LOCAL }}"
REGISTRY_STORAGEOS_CHART_REPO="{{ CLOUD_IMAGES['STORAGEOS-CHART']['NAME'] }}"
REGISTRY_STORAGEOS_CHART_VERSION="{{ CLOUD_IMAGES['STORAGEOS-CHART']['VERSION'] }}"

mkdir -p /etc/kubernetes/helm

if ! [[ -e /etc/kubernetes/helm/storageos/Chart.yaml ]]; then
  docker pull $REGISTRY_LOCAL$REGISTRY_STORAGEOS_CHART_REPO:$REGISTRY_STORAGEOS_CHART_VERSION
  docker run -v /etc/kubernetes/helm/storageos:/data/output --rm $REGISTRY_LOCAL$REGISTRY_STORAGEOS_CHART_REPO:$REGISTRY_STORAGEOS_CHART_VERSION
  helm install /etc/kubernetes/helm/storageos --name storageos --namespace storageos \
  --set image.repository={{ REGISTRY_LOCAL }}{{ CLOUD_IMAGES['STORAGEOS-NODE']['NAME'] }} \
  --set image.tag={{ CLOUD_IMAGES['STORAGEOS-NODE']['VERSION'] }} \
  --set initContainer.repository={{ REGISTRY_LOCAL }}{{ CLOUD_IMAGES['STORAGEOS-INIT']['NAME'] }} \
  --set initContainer.tag={{ CLOUD_IMAGES['STORAGEOS-INIT']['VERSION'] }} \
  --set csiDriverRegistrar.repository={{ REGISTRY_LOCAL }}{{ CLOUD_IMAGES['K8SCSI-DRIVER-REGISTRAR']['NAME'] }} \
  --set csiDriverRegistrar.tag={{ CLOUD_IMAGES['K8SCSI-DRIVER-REGISTRAR']['VERSION'] }} \
  --set csiExternalProvisioner.repository={{ REGISTRY_LOCAL }}{{ CLOUD_IMAGES['K8SCSI-CSI-PROVISIONER']['NAME'] }} \
  --set csiExternalProvisioner.tag={{ CLOUD_IMAGES['K8SCSI-CSI-PROVISIONER']['VERSION'] }} \
  --set csiExternalAttacher.repository={{ REGISTRY_LOCAL }}{{ CLOUD_IMAGES['K8SCSI-CSI-ATTACHER']['NAME'] }} \
  --set csiExternalAttacher.tag={{ CLOUD_IMAGES['K8SCSI-CSI-ATTACHER']['VERSION'] }} \
  --set cluster.join={% for host in groups['systech'] %}{{ hostvars[host]['ansible_default_ipv4']['address'] }}{% if loop.last %}{% else %}\,{% endif %}{% endfor %} \
  --set cluster.sharedDir=/var/lib/kubelet/plugins/kubernetes.io~storageos \
  --set storageclass.name=storageos \
  --set csi.enable=true \
  --set api.username=admin \
  --set api.password="{{ STORAGEOS['PASSWORD'] }}" \
  --set ingress.hosts[0].name="{{ STORAGEOS['HOST'] }}"
fi