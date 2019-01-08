#!/bin/bash 

set -e  

HTTP_SERVER="${HTTP_SERVER:-https://dl.wodcloud.com/k8s}"
YUM_SERVER="$HTTP_SERVER/centos"

mkdir -p /etc/kubernetes/downloads

if ! [ -x "$(command -v docker)" ]; then
  curl -fsSL https://get.docker.com | bash -s docker --mirror Aliyun
fi
