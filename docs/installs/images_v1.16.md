# images

```bash
# pause
docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/pause-amd64:3.1 &&\
docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/pause-amd64:3.1 registry-vpc.cn-qingdao.aliyuncs.com/wod/pause-amd64:3.1 &&\
docker push registry-vpc.cn-qingdao.aliyuncs.com/wod/pause-amd64:3.1

# dashboard
docker pull kubernetesui/dashboard:v2.0.0-rc6 &&\
docker tag kubernetesui/dashboard:v2.0.0-rc6 registry-vpc.cn-qingdao.aliyuncs.com/wod/kubernetesui-dashboard:v2.0.0-rc6 &&\
docker push registry-vpc.cn-qingdao.aliyuncs.com/wod/kubernetesui-dashboard:v2.0.0-rc6

# dashboard-metrics-sidecar
docker pull kubernetesui/metrics-scraper:v1.0.3 &&\
docker tag kubernetesui/metrics-scraper:v1.0.3 registry-vpc.cn-qingdao.aliyuncs.com/wod/kubernetesui-metrics-scraper:v1.0.3 &&\
docker push registry-vpc.cn-qingdao.aliyuncs.com/wod/kubernetesui-metrics-scraper:v1.0.3

# metrics-server
## https://github.com/kubernetes-sigs/metrics-server/releases
docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/metrics-server-amd64:v0.3.6 && \
docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/metrics-server-amd64:v0.3.6 registry-vpc.cn-qingdao.aliyuncs.com/wod/metrics-server-amd64:v0.3.6 && \
docker push registry-vpc.cn-qingdao.aliyuncs.com/wod/metrics-server-amd64:v0.3.6

# nginx
docker pull nginx:1.17.4-alpine && \
docker tag nginx:1.17.4-alpine registry-vpc.cn-qingdao.aliyuncs.com/wod/nginx:1.17.4-alpine && \
docker push registry-vpc.cn-qingdao.aliyuncs.com/wod/nginx:1.17.4-alpine

# coredns
docker pull coredns/coredns:1.6.7 && \
docker tag coredns/coredns:1.6.7 registry-vpc.cn-qingdao.aliyuncs.com/wod/coredns:1.6.7 && \
docker push registry-vpc.cn-qingdao.aliyuncs.com/wod/coredns:1.6.7

# kube-router
docker pull cloudnativelabs/kube-router:v1.0.0-rc1 && \
docker tag cloudnativelabs/kube-router:v1.0.0-rc1 registry-vpc.cn-qingdao.aliyuncs.com/wod/kube-router:v1.0.0-rc1 && \
docker push registry-vpc.cn-qingdao.aliyuncs.com/wod/kube-router:v1.0.0-rc1

# etcd
docker pull quay.io/coreos/etcd:v3.4.4 && \
docker tag quay.io/coreos/etcd:v3.4.4 registry-vpc.cn-qingdao.aliyuncs.com/wod/etcd:v3.4.4 && \
docker push registry-vpc.cn-qingdao.aliyuncs.com/wod/etcd:v3.4.4

# flannel
docker pull quay.io/coreos/flannel:v0.12.0 && \
docker tag quay.io/coreos/flannel:v0.12.0 registry-vpc.cn-qingdao.aliyuncs.com/wod/flannel:v0.12.0 && \
docker push registry-vpc.cn-qingdao.aliyuncs.com/wod/flannel:v0.12.0

# keepalived
docker pull osixia/keepalived:1.4.5 && \
docker tag osixia/keepalived:1.4.5 registry-vpc.cn-qingdao.aliyuncs.com/wod/keepalived:1.4.5 && \
docker push registry-vpc.cn-qingdao.aliyuncs.com/wod/keepalived:1.4.5

# busybox
docker pull busybox:1.31 && \
docker tag busybox:1.31 registry-vpc.cn-qingdao.aliyuncs.com/wod/busybox:1.31 && \
docker push registry-vpc.cn-qingdao.aliyuncs.com/wod/busybox:1.31

# registry
docker pull registry:2.7.1 && \
docker tag registry:2.7.1 registry-vpc.cn-qingdao.aliyuncs.com/wod/registry:2.7.1 && \
docker push registry-vpc.cn-qingdao.aliyuncs.com/wod/registry:2.7.1

# tiller gcr.io/kubernetes-helm/tiller:v2.16.3
docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/tiller:v2.16.3 && \
docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/tiller:v2.16.3 registry-vpc.cn-qingdao.aliyuncs.com/wod/tiller:v2.16.3 && \
docker push registry-vpc.cn-qingdao.aliyuncs.com/wod/tiller:v2.16.3

# traefik
docker pull traefik:v1.7.18-alpine && \
docker tag traefik:v1.7.18-alpine registry-vpc.cn-qingdao.aliyuncs.com/wod/traefik:v1.7.18-alpine && \
docker push registry-vpc.cn-qingdao.aliyuncs.com/wod/traefik:v1.7.18-alpine

# calico-cni
docker pull calico/cni:v3.13.3 && \
docker tag calico/cni:v3.13.3 registry-vpc.cn-qingdao.aliyuncs.com/wod/calico-cni:v3.13.3 && \
docker push registry-vpc.cn-qingdao.aliyuncs.com/wod/calico-cni:v3.13.3

# calico-flexvol
docker pull calico/pod2daemon-flexvol:v3.13.3 && \
docker tag calico/pod2daemon-flexvol:v3.13.3 registry-vpc.cn-qingdao.aliyuncs.com/wod/calico-pod2daemon-flexvol:v3.13.3 && \
docker push registry-vpc.cn-qingdao.aliyuncs.com/wod/calico-pod2daemon-flexvol:v3.13.3

# calico-node
docker pull calico/node:v3.13.3 && \
docker tag calico/node:v3.13.3 registry-vpc.cn-qingdao.aliyuncs.com/wod/calico-node:v3.13.3 && \
docker push registry-vpc.cn-qingdao.aliyuncs.com/wod/calico-node:v3.13.3

# calico-kube-controllers
docker pull calico/kube-controllers:v3.13.3 && \
docker tag calico/kube-controllers:v3.13.3 registry-vpc.cn-qingdao.aliyuncs.com/wod/calico-kube-controllers:v3.13.3 && \
docker push registry-vpc.cn-qingdao.aliyuncs.com/wod/calico-kube-controllers:v3.13.3
```
