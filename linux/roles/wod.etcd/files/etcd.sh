#!/bin/bash 
# Wrapper for launching etcd via rkt.
#
# Make sure to set ETCD_IMAGE_TAG to an image tag published here:
# https://quay.io/repository/coreos/etcd?tab=tags Alternatively,
# override ETCD_IMAGE to a custom image.

set -e 

function require_ev_all() {
	for rev in $@ ; do
		if [[ -z "${!rev}" ]]; then
			echo ${rev} is not set
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

require_ev_one ETCD_IMAGE ETCD_IMAGE_TAG
require_ev_all ETCD_USER ETCD_DATA_DIR

ETCD_IMAGE_URL="${ETCD_IMAGE_URL:-quay.io/coreos/etcd}"
ETCD_IMAGE="${ETCD_IMAGE:-${ETCD_IMAGE_URL}:${ETCD_IMAGE_TAG}}"

if [[ "${ETCD_IMAGE%%/*}" == "quay.io" ]]; then
	RKT_RUN_ARGS="${RKT_RUN_ARGS} --trust-keys-from-https"
fi

if [[ ! -e "${ETCD_DATA_DIR}" ]]; then
	mkdir --parents "${ETCD_DATA_DIR}"
	chown "${ETCD_USER}" "${ETCD_DATA_DIR}"
fi

# Do not pass ETCD_DATA_DIR through to the container. The default path,
# /var/lib/etcd is always used inside the container.
etcd_data_dir="${ETCD_DATA_DIR}"
ETCD_DATA_DIR="/var/lib/etcd"

ETCD_SSL_DIR="${ETCD_SSL_DIR:-/etc/ssl/certs}"

SYSTEMD_SYSTEM_DIR_SRC="${SYSTEMD_SYSTEM_DIR_SRC:-/run/systemd/system}"
if [[ -d "${SYSTEMD_SYSTEM_DIR_SRC}" ]]; then
	RKT_RUN_ARGS="${RKT_RUN_ARGS} \
		--mount volume=coreos-systemd-dir,target=/run/systemd/system \
		--volume coreos-systemd-dir,kind=host,source=${SYSTEMD_SYSTEM_DIR_SRC},readOnly=true \
	"
fi

if [[ -S "${NOTIFY_SOCKET}" ]]; then
	RKT_RUN_ARGS="${RKT_RUN_ARGS} \
		--mount volume=coreos-notify,target=/run/systemd/notify \
		--volume coreos-notify,kind=host,source=${NOTIFY_SOCKET} \
		--set-env=NOTIFY_SOCKET=/run/systemd/notify \
	"
fi

RKT="${RKT:-/usr/bin/rkt}"
RKT_STAGE1_ARG="${RKT_STAGE1_ARG:---stage1-from-dir=stage1-fly.aci}"
set -x
exec ${RKT} ${RKT_GLOBAL_ARGS} \
	run ${RKT_RUN_ARGS} \
	--volume data-dir,kind=host,source="${etcd_data_dir}",readOnly=false \
	--volume coreos-etc-ssl-certs,kind=host,source="${ETCD_SSL_DIR}",readOnly=true \
	--volume coreos-usr-share-certs,kind=host,source=/usr/share/ca-certificates,readOnly=true \
	--volume coreos-etc-hosts,kind=host,source=/etc/hosts,readOnly=true \
	--volume coreos-etc-resolv,kind=host,source=/etc/resolv.conf,readOnly=true \
	--mount volume=data-dir,target=/var/lib/etcd \
	--mount volume=coreos-etc-ssl-certs,target=/etc/ssl/certs \
	--mount volume=coreos-usr-share-certs,target=/usr/share/ca-certificates \
	--mount volume=coreos-etc-hosts,target=/etc/hosts  \
	--mount volume=coreos-etc-resolv,target=/etc/resolv.conf  \
	--inherit-env \
	${RKT_STAGE1_ARG} \
	${ETCD_IMAGE} \
		${ETCD_IMAGE_ARGS} \
		--user=$(id -u "${ETCD_USER}") \
		-- "$@"