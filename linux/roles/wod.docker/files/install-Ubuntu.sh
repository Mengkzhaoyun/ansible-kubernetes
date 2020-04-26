#!/bin/bash

set -e

mkdir -p /etc/kubernetes/downloads

if ! [ -x "$(command -v docker)" ]; then
  apt install docker.io -y
fi