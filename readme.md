# QuickStart Kubernetes Cluster

## 调试命令

```powershell
docker run `
--rm `
-h ansible `
-v $PWD/:/etc/ansible `
-w /etc/ansible/linux `
--entrypoint=bash `
-it registry.cn-qingdao.aliyuncs.com/wod/ansible:2.7.10
```

## 项目目标

- 快速搭建一个Kubernetes集群

### 限制条件

- Linux Kernel >= 5.3 , 推荐 Ubuntu 20.04

### 核心组件

- 容器引擎: docker-ce 19.08
- 数据库:   etcd v3.4
- 容器平台: kubernetes v1.16.x
- 网络组件: flannel v0.12.0 , calico v3.13 , kube-router v1.0.0 , cilium v1.7.2
- 扩展组件: coredns 1.5.2 , dashboard v2.0.0

## 开始

### 1.准备主机

确保ansible能通过密钥来登录服务器，修改以下文件 <br>
/root/.ssh/authorized_keys

```bash
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAAAgQDCJNFRbNc0SsHa/+mWB71z7SLPH9rQpwEqGbRo7q466a97h3bejNav9wc9AKmepHPfRw7DJfSmWO3lGBya0QkXMYXVvtfcWPvZZDlar5JK/ZsC8HGOpwVLdd1uUfyPu2qM0sjRNA/Ty8PDMkS5dSyZAJNlxUAILRpepkYoT8jhrw== ansible@docker
```

检查每台主机上的时间<br>
时间差距在30s以内，或者装个NTP来同步时间<br>
apt install ntp -y && ntpdate -u time.windows.com<br>

[./hosts](./hosts)

```ini
[systech]
ubuntu-1 ansible_ssh_host=192.168.1.200 ansible_ssh_port=22 ansible_ssh_user=root ansible_python_interpreter=/opt/bin/python
ubuntu-2 ansible_ssh_host=192.168.1.201 ansible_ssh_port=22 ansible_ssh_user=root ansible_python_interpreter=/opt/bin/python
```

### 2.修改配置文件

修改配置文件中的参数<br>
ubuntu-1是Master<br>
[./linux/group_vars/systech.yml](./linux/group_vars/systech.yml)

```yml
# docker
DOCKER_DATA_PATH: /data/docker

# etcd options
ETCD_CLUSTER_ROLE:
  ubuntu-1: etcd

# k8s option
# K8S_ADMIN_TOKEN , 管理员访问Token ， 请设置为随机值
# K8S_NETWORK_PLUGIN , 网络插件 ， flannel , kube-router , cilium , calico
K8S_ADMIN_TOKEN: "pleasechangeit"
K8S_NETWORK_PLUGIN: cilium
K8S_SERVICE_PORT_RANGE: 1-65535
K8S_CLUSTER_ROLE:
  ubuntu-1: master

# registry options
REGISTRY_LOCAL_HOSTNAME: ubuntu-1
REGISTRY_LOCAL_IP: "{{ hostvars['ubuntu-1']['ansible_default_ipv4']['address'] }}"  
REGISTRY_LOCAL: "registry.cn-qingdao.aliyuncs.com/wod/"
REGISTRY_DATA_PATH: /data/kubernetes/registry
RKT_DATA_PATH: /data/kubernetes/rkt

# single master
K8S_MASTER_IP: "{{ hostvars['ubuntu-1']['ansible_default_ipv4']['address'] }}"  
K8S_MASTER_PORT: "6443"

K8S_DOMAIN: "home.wodcloud.local"

```

### 3.开始安装集群

Windows/Linux用户不需要安装ansible，在Docker中运行命令即可 <br>

```powershell
# docker run
docker run `
--rm `
-h ansible `
-v $PWD/:/etc/ansible `
-w /etc/ansible/linux `
--entrypoint=bash `
-it registry.cn-qingdao.aliyuncs.com/wod/ansible:2.7.10

# install kubernetes cluster
ap 4.install-online.yml

# uninstall kubernetes cluster
ap 9.uninstall.yml

```

### 4.检查成果

https://k8s.home.wodcloud.local<br>

使用上面设置的Token来登录服务