#!/bin/bash

set -e

HTTP_SERVER="${HTTP_SERVER:-https://dl.wodcloud.com/k8s}"
ANSIBLE_LSB_CODENAME="${ANSIBLE_LSB_CODENAME}"
DEB_SERVER="$HTTP_SERVER/ubuntu"
DEB_LIBLTDL7="${DEB_LIBLTDL7:-libltdl7_2.4.6-0.1_amd64.deb}"
DEB_DOCKER="${DEB_DOCKER:-docker-engine_1.13.1-0~ubuntu-xenial_amd64.deb}"
DEB_IPTABLE="${DEB_IPTABLE:-iptables_1.6.0-2ubuntu3_amd64.deb}"

mkdir -p /etc/kubernetes/downloads

if [ "$ANSIBLE_LSB_CODENAME" == "bionic" ]; then
  if ! [ -x "$(command -v docker)" ]; then
    apt install -y docker.io
  fi
  exit 0
fi

if ! [ -x "$(command -v docker)" ]; then
  if ! [[ -e /etc/kubernetes/downloads/$DEB_LIBLTDL7 ]]; then
    curl $DEB_SERVER/$DEB_LIBLTDL7.tgz > /etc/kubernetes/downloads/$DEB_LIBLTDL7.tgz
    cd /etc/kubernetes/downloads && tar -xzf /etc/kubernetes/downloads/$DEB_LIBLTDL7.tgz
    rm -rf /etc/kubernetes/downloads/$DEB_LIBLTDL7.tgz
  fi
  if ! [[ -e /etc/kubernetes/downloads/$DEB_DOCKER ]]; then
    curl $DEB_SERVER/$DEB_DOCKER.tgz > /etc/kubernetes/downloads/$DEB_DOCKER.tgz
    cd /etc/kubernetes/downloads && tar -xzf /etc/kubernetes/downloads/$DEB_DOCKER.tgz
    rm -rf /etc/kubernetes/downloads/$DEB_DOCKER.tgz
  fi
  dpkg -i /etc/kubernetes/downloads/$DEB_LIBLTDL7
  dpkg -i /etc/kubernetes/downloads/$DEB_DOCKER
fi

if ! [ -x "$(command -v iptables)" ]; then
  if ! [[ -e /etc/kubernetes/downloads/$DEB_IPTABLE ]]; then
    curl $DEB_SERVER/$DEB_IPTABLE.tgz > /etc/kubernetes/downloads/$DEB_IPTABLE.tgz
    cd /etc/kubernetes/downloads && tar -xzf /etc/kubernetes/downloads/$DEB_IPTABLE.tgz
    rm -rf /etc/kubernetes/downloads/$DEB_IPTABLE.tgz
  fi
  dpkg -i /etc/kubernetes/downloads/$DEB_IPTABLE
fi