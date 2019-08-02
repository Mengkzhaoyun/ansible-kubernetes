#!/bin/bash  
set -e 
 
if [[ -e /etc/kubernetes/ssl/{{ K8S_DOMAIN }}/{{ K8S_DOMAIN }}.key ]]; then
  echo "{{ K8S_DOMAIN }}.key is ready!"
else
  /usr/bin/openssl genrsa -out {{ K8S_DOMAIN }}.key 2048
  echo "{{ K8S_DOMAIN }}.key is ready!"
fi

if [[ -e /etc/kubernetes/ssl/{{ K8S_DOMAIN }}/{{ K8S_DOMAIN }}.crt ]]; then
  echo "{{ K8S_DOMAIN }}.crt is ready!"
else
  /usr/bin/openssl req -new -key {{ K8S_DOMAIN }}.key -out {{ K8S_DOMAIN }}.csr -subj "/CN=admin/C=CN/ST=BeiJing/L=Beijing/O=system:masters/OU=System" -config {{ K8S_DOMAIN }}.cnf
  /usr/bin/openssl x509 -req -in {{ K8S_DOMAIN }}.csr -CA ../ca.crt -CAkey ../ca.key -CAcreateserial -out {{ K8S_DOMAIN }}.crt -days 3650 -extensions v3_req -extfile {{ K8S_DOMAIN }}.cnf
  echo "{{ K8S_DOMAIN }}.crt is ready!"
fi