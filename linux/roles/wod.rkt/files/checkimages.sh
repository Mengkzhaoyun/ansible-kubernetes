#!/bin/bash 

set -e  

HTTP_SERVER="${HTTP_SERVER:-https://dl.wodcloud.com/k8s}"
RKT_DATA_PATH="${RKT_DATA_PATH:-/var/lib/rkt}"
RKT_STAGE1_FLY="stage1-fly-1.30.0-linux-amd64.aci"

mkdir -p ${RKT_DATA_PATH}/stage1-images

if ! [[ -e ${RKT_DATA_PATH}/stage1-images/stage1-fly.aci ]]; then
  curl $HTTP_SERVER/$RKT_STAGE1_FLY.tgz > /etc/kubernetes/downloads/$RKT_STAGE1_FLY.tgz
  cd /etc/kubernetes/downloads && tar -xzf /etc/kubernetes/downloads/$RKT_STAGE1_FLY.tgz
  rm -rf /etc/kubernetes/downloads/$YUM_RKT.tgz
  mv /etc/kubernetes/downloads/${RKT_STAGE1_FLY} ${RKT_DATA_PATH}/stage1-images/stage1-fly.aci
fi