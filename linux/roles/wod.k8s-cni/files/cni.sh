#!/bin/bash 

set -e  

HTTP_SERVER="${HTTP_SERVER:-https://dl.wodcloud.com/k8s}"
K8S_CNI_BIN="${K8S_CNI_BIN:-cni-plugins-amd64-v0.7.0}"

cat > /etc/sysconfig/modules/ipvs.modules <<EOF
#!/bin/bash
ipvs_modules="ip_vs ip_vs_lc ip_vs_wlc ip_vs_rr ip_vs_wrr ip_vs_lblc ip_vs_lblcr ip_vs_dh ip_vs_sh ip_vs_fo ip_vs_nq ip_vs_sed ip_vs_ftp nf_conntrack_ipv4"
for kernel_module in \${ipvs_modules}; do
    /sbin/modinfo -F filename \${kernel_module} > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        /sbin/modprobe \${kernel_module}
    fi
done
EOF

chmod 755 /etc/sysconfig/modules/ipvs.modules && bash /etc/sysconfig/modules/ipvs.modules && lsmod | grep ip_vs

mkdir -p /opt/cni/bin

if [[ -e /opt/cni/bin/host-local ]]; then
  echo 'cni bin is already exist!'
else
  curl $HTTP_SERVER/$K8S_CNI_BIN.tgz > /opt/cni/bin/$K8S_CNI_BIN.tgz
  cd /opt/cni/bin && tar -xzf /opt/cni/bin/$K8S_CNI_BIN.tgz
  rm -rf /opt/cni/bin/$K8S_CNI_BIN.tgz
  echo 'cni bin download completed!'
fi