#!/bin/bash  
set -e 

cd /etc/kubernetes/ssl    
 
if [[ -e /etc/kubernetes/ssl/kube-proxy.key ]]; then
  echo 'kube-proxy.key is ready!'
else
  openssl genrsa -out kube-proxy.key 2048
  echo 'kube-proxy.key is ready!'
fi

if [[ -e /etc/kubernetes/ssl/kube-proxy.pem ]]; then
  echo 'kube-proxy.pem is ready!'
else
  openssl req -new -key kube-proxy.key -out kube-proxy.csr -subj "/CN=kube-proxy/C=CN/ST=BeiJing/L=Beijing/O=system:masters/OU=System" -config worker-kube-proxy.cnf
  openssl x509 -req -in kube-proxy.csr -CA ca.pem -CAkey ca.key -CAcreateserial -out kube-proxy.pem -days 36500 -extensions v3_req -extfile worker-kube-proxy.cnf
  echo 'kube-proxy.pem is ready!'
fi

if [[ -e /etc/kubernetes/ssl/kubelet.key ]]; then
  echo 'kubelet.key is ready!'
else
  openssl genrsa -out kubelet.key 2048
  echo 'kubelet.key is ready!'
fi

if [[ -e /etc/kubernetes/ssl/kubelet.pem ]]; then
  echo 'kubelet.pem is ready!'
else
  openssl req -new -key kubelet.key -out kubelet.csr -subj "/CN=kubelet/C=CN/ST=BeiJing/L=Beijing/O=system:masters/OU=System" -config worker-kubelet.cnf 
  openssl x509 -req -in kubelet.csr -CA ca.pem -CAkey ca.key -CAcreateserial -out kubelet.pem -days 36500 -extensions v3_req -extfile worker-kubelet.cnf  
  echo 'kubelet.pem is ready!'
fi