#!/bin/bash

set -e

NGINX_IMAGE_URL="${NGINX_IMAGE_URL:-nginx:1.15.3}"

docker run -d \
  --name k8s-nginx \
  --restart always \
  -v /etc/kubernetes/data/nginx:/etc/nginx \
  -p 6443:6443 \
  $NGINX_IMAGE_URL

docker logs k8s-nginx -f