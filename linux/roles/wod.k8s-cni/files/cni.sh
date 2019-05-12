#!/bin/bash 

set -e  

HTTP_SERVER="${HTTP_SERVER:-https://dl.wodcloud.com/k8s}"
K8S_CNI_BIN="${K8S_CNI_BIN:-cni-plugins-amd64-v0.7.5}"

if [[ -e /etc/sysconfig/modules/ipvs.modules ]]; then
  echo 'ipvs.modules is already exist!'
else
  cat > /etc/sysconfig/modules/ipvs.modules <<EOF
#!/bin/bash
modprobe -- ip_vs
modprobe -- ip_vs_rr
modprobe -- ip_vs_wrr
modprobe -- ip_vs_sh
modprobe -- nf_conntrack_ipv4
EOF
  chmod 755 /etc/sysconfig/modules/ipvs.modules && bash /etc/sysconfig/modules/ipvs.modules && lsmod | grep -e ip_vs -e nf_conntrack_ipv4
  echo 'ipvs.modules config completed!'
fi

mkdir -p /opt/cni/bin

if [[ -e /opt/cni/bin/host-local ]]; then
  echo 'cni bin is already exist!'
else
  curl $HTTP_SERVER/$K8S_CNI_BIN.tgz > /opt/cni/bin/$K8S_CNI_BIN.tgz
  cd /opt/cni/bin && tar -xzf /opt/cni/bin/$K8S_CNI_BIN.tgz
  rm -rf /opt/cni/bin/$K8S_CNI_BIN.tgz
  echo 'cni bin download completed!'
fi