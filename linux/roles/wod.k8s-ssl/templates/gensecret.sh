#!/bin/bash

/usr/bin/kubectl get secret -n kube-system | grep traefik-cert

if [ $? = 0 ];then
  echo "Key is already exist!"
else
  cd /etc/kubernetes/ssl/{{ K8S_DOMAIN }}
  /usr/bin/kubectl create secret generic traefik-cert --from-file={{ K8S_DOMAIN }}.crt --from-file={{ K8S_DOMAIN }}.key --namespace=kube-system
  if [ $? = 0 ];then
    echo "The key has been successfully created!"
  else
    echo "Failed to create key, connect the Administrator!"
  fi
fi
