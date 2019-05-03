#!/bin/bash
# Wrapper for launching kubelet via rkt-fly.
#
# Make sure to set KUBELET_IMAGE_TAG to an image tag published here:
# https://quay.io/repository/coreos/hyperkube?tab=tags Alternatively,
# override KUBELET_IMAGE to a custom image.

set -e

function require_ev_all() {
    for rev in $@ ; do
        if [[ -z "${!rev}" ]]; then
            echo "${rev}" is not set
            exit 1
        fi
    done
}

function require_ev_one() {
    for rev in $@ ; do
        if [[ ! -z "${!rev}" ]]; then
            return
        fi
    done
    echo One of $@ must be set
    exit 1
}

if [[ -n "${KUBELET_VERSION}" ]]; then
    echo KUBELET_VERSION environment variable is deprecated, please use KUBELET_IMAGE_TAG instead
fi

if [[ -n "${KUBELET_ACI}" ]]; then
    echo KUBELET_ACI environment variable is deprecated, please use the KUBELET_IMAGE_URL instead
fi

if [[ -n "${RKT_OPTS}" ]]; then
    echo RKT_OPTS environment variable is deprecated, please use the RKT_RUN_ARGS instead
fi

KUBELET_IMAGE_TAG="${KUBELET_IMAGE_TAG:-${KUBELET_VERSION}}"

require_ev_one KUBELET_IMAGE KUBELET_IMAGE_TAG

KUBELET_IMAGE_URL="${KUBELET_IMAGE_URL:-${KUBELET_ACI:-quay.io/coreos/hyperkube}}"
KUBELET_IMAGE="${KUBELET_IMAGE:-${KUBELET_IMAGE_URL}:${KUBELET_IMAGE_TAG}}"

RKT_RUN_ARGS="${RKT_RUN_ARGS} ${RKT_OPTS}"

if [[ "${KUBELET_IMAGE%%/*}" == "quay.io" ]]; then
    RKT_RUN_ARGS="${RKT_RUN_ARGS} --trust-keys-from-https"
fi

/usr/bin/mkdir --parents /etc/kubernetes
/usr/bin/mkdir --parents /var/lib/docker
/usr/bin/mkdir --parents /var/lib/kubelet
/usr/bin/mkdir --parents /run/kubelet

RKT="${RKT:-/usr/bin/rkt}"
RKT_STAGE1_ARG="${RKT_STAGE1_ARG:---stage1-from-dir=stage1-fly.aci}"
KUBELET_IMAGE_ARGS=${KUBELET_IMAGE_ARGS:---exec=/kubelet}
set -x
exec ${RKT} ${RKT_GLOBAL_ARGS} \
run ${RKT_RUN_ARGS} \
--volume coreos-etc-kubernetes,kind=host,source=/etc/kubernetes,readOnly=false \
--volume coreos-etc-ssl-certs,kind=host,source=/etc/ssl/certs,readOnly=true \
--volume coreos-usr-share-certs,kind=host,source=/usr/share/ca-certificates,readOnly=true \
--volume coreos-var-lib-docker,kind=host,source=/var/lib/docker,readOnly=false \
--volume coreos-var-lib-kubelet,kind=host,source=/var/lib/kubelet,readOnly=false,recursive=true \
--volume coreos-var-log,kind=host,source=/var/log,readOnly=false \
--volume coreos-os-release,kind=host,source=/etc/os-release,readOnly=true \
--volume coreos-run,kind=host,source=/run,readOnly=false \
--volume coreos-bin,kind=host,source=/bin,readOnly=true \
--volume coreos-sbin,kind=host,source=/sbin,readOnly=true \
--volume coreos-usr-bin,kind=host,source=/usr/bin,readOnly=true \
--volume coreos-usr-sbin,kind=host,source=/usr/sbin,readOnly=true \
--volume coreos-lib-modules,kind=host,source=/lib/modules,readOnly=true \
--volume coreos-etc-cni-net,kind=host,source=/etc/cni/net.d,readOnly=true \
--volume coreos-var-lib-cni,kind=host,source=/var/lib/cni,readOnly=false \
--volume coreos-etc-localtime,kind=host,source=/etc/localtime,readOnly=true \
--volume coreos-kubelet-plugins-volume,kind=host,source=/usr/libexec/kubernetes,readOnly=false \
--mount volume=coreos-etc-kubernetes,target=/etc/kubernetes \
--mount volume=coreos-etc-ssl-certs,target=/etc/ssl/certs \
--mount volume=coreos-usr-share-certs,target=/usr/share/ca-certificates \
--mount volume=coreos-var-lib-docker,target=/var/lib/docker \
--mount volume=coreos-var-lib-kubelet,target=/var/lib/kubelet \
--mount volume=coreos-var-log,target=/var/log \
--mount volume=coreos-os-release,target=/etc/os-release \
--mount volume=coreos-run,target=/run \
--mount volume=coreos-bin,target=/bin \
--mount volume=coreos-sbin,target=/sbin \
--mount volume=coreos-usr-bin,target=/usr/bin \
--mount volume=coreos-usr-sbin,target=/usr/sbin \
--mount volume=coreos-lib-modules,target=/lib/modules \
--mount volume=coreos-etc-cni-net,target=/etc/cni/net.d \
--mount volume=coreos-var-lib-cni,target=/var/lib/cni \
--mount volume=coreos-etc-localtime,target=/etc/localtime \
--mount volume=coreos-kubelet-plugins-volume,target=/usr/libexec/kubernetes \
--hosts-entry host \
${RKT_STAGE1_ARG} \
${KUBELET_IMAGE} \
${KUBELET_IMAGE_ARGS} \
-- "$@"