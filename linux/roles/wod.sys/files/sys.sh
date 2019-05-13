#!/bin/bash

set -e

function require_ev_all() {
  for rev in $@ ; do
    if [[ -z "${!rev}" ]]; then
      echo ${rev} is not set
      exit 1
    fi
  done
}

require_ev_all REGISTRY_LOCAL_IP

REGISTRY_LOCAL_HOST="${REGISTRY_LOCAL_HOST:-reg.local}"
REGISTRY_LOCAL_IP="${REGISTRY_LOCAL_IP}"
AUTHORIZED_KEYS="${AUTHORIZED_KEYS}"
ENV_OPT="$PATH:/opt/bin"

if ! (grep -q ${REGISTRY_LOCAL_HOST} /etc/hosts) ; then
  echo " " >> /etc/hosts;
  echo "${REGISTRY_LOCAL_IP} ${REGISTRY_LOCAL_HOST}" >> /etc/hosts;
else
  sed -i "/${REGISTRY_LOCAL_HOST}/c\\${REGISTRY_LOCAL_IP} ${REGISTRY_LOCAL_HOST}" /etc/hosts
fi

if ! (grep -q /opt/bin /etc/environment) ; then
  sed -i "/PATH=/c\PATH=${ENV_OPT}" /etc/environment
  source /etc/environment;
fi

if ! [[ -e /usr/bin/mkdir ]]; then
  /bin/mkdir -p /usr/bin
  ln -s /bin/mkdir /usr/bin/mkdir
fi

if ! [[ -e /usr/libexec/kubernetes ]]; then
  /bin/mkdir -p /usr/libexec/kubernetes
fi

if ! [[ -e /root/.ssh/authorized_keys ]]; then
  mkdir -p /root/.ssh/
  touch /root/.ssh/authorized_keys create file
fi

IFS=","
KEYS=(${AUTHORIZED_KEYS})
for key in ${KEYS[@]}; do
  IFS=" "
  keyarr=(${key})
  if ! (grep -q ${keyarr[2]} /root/.ssh/authorized_keys) ; then
    echo " " >> /root/.ssh/authorized_keys;
    echo "${key}" >> /root/.ssh/authorized_keys;
  fi
done

cat > /etc/sysconfig/modules/ipvs.modules <<EOF
#!/bin/bash
/sbin/modprobe -- nf_conntrack_ipv4
ipvs_modules_dir="/usr/lib/modules/\`uname -r\`/kernel/net/netfilter/ipvs"
for i in \`ls \$ipvs_modules_dir | sed  -r 's#(.*).ko.xz#\1#'\`; do
    /sbin/modinfo -F filename \$i  &> /dev/null
    if [ \$? -eq 0 ]; then
        /sbin/modprobe \$i
    fi
done
EOF
chmod 755 /etc/sysconfig/modules/ipvs.modules && bash /etc/sysconfig/modules/ipvs.modules && lsmod | grep -e ip_vs -e nf_conntrack_ipv4 -e br_netfilter

if ! (grep -q 'net.ipv4.ip_forward' /etc/sysctl.conf) ; then
  echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf;
  sysctl -p
fi

if ! (grep -q 'net.bridge.bridge-nf-call-ip6tables' /etc/sysctl.conf) ; then
  echo "net.bridge.bridge-nf-call-ip6tables=1" >> /etc/sysctl.conf;
  sysctl -p
fi

if ! (grep -q 'net.bridge.bridge-nf-call-iptables' /etc/sysctl.conf) ; then
  echo "net.bridge.bridge-nf-call-iptables=1" >> /etc/sysctl.conf;
  sysctl -p
fi

mkdir -p /etc/kubernetes/scripts /etc/kubernetes/manifests /usr/share/ca-certificates