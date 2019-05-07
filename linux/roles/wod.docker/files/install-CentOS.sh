#!/bin/bash 

set -e  

if ! [ -x "$(command -v docker)" ]; then
  curl -fsSL https://get.docker.com | bash -s docker --mirror Aliyun
  systemctl start docker && systemctl enable docker
fi
