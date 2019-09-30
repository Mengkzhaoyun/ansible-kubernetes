# images

```bash
# pause
docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/pause-amd64:3.1 &&\
docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/pause-amd64:3.1 registry-vpc.cn-qingdao.aliyuncs.com/wod/pause-amd64:3.1 &&\
docker push registry-vpc.cn-qingdao.aliyuncs.com/wod/pause-amd64:3.1

# metrics-scraper
docker pull kubernetesui/metrics-scraper:v1.0.1 &&\
docker tag kubernetesui/metrics-scraper:v1.0.1 registry-vpc.cn-qingdao.aliyuncs.com/wod/metrics-scraper:v1.0.1 &&\
docker push registry-vpc.cn-qingdao.aliyuncs.com/wod/metrics-scraper:v1.0.1

# nginx
docker pull nginx:1.17.4-alpine && \
docker tag nginx:1.17.4-alpine registry-vpc.cn-qingdao.aliyuncs.com/wod/nginx:1.17.4-alpine && \
docker push registry-vpc.cn-qingdao.aliyuncs.com/wod/nginx:1.17.4-alpine

# coredns
docker pull coredns/coredns:1.6.4 && \
docker tag coredns/coredns:1.6.4 registry-vpc.cn-qingdao.aliyuncs.com/wod/coredns:1.6.4 && \
docker push registry-vpc.cn-qingdao.aliyuncs.com/wod/coredns:1.6.4

# kube-router
docker pull cloudnativelabs/kube-router:v0.3.2 && \
docker tag cloudnativelabs/kube-router:v0.3.2 registry-vpc.cn-qingdao.aliyuncs.com/wod/kube-router:v0.3.2 && \
docker push registry-vpc.cn-qingdao.aliyuncs.com/wod/kube-router:v0.3.2

# etcd
docker pull quay.io/coreos/etcd:v3.4.1 && \
docker tag quay.io/coreos/etcd:v3.4.1 registry-vpc.cn-qingdao.aliyuncs.com/wod/etcd:v3.4.1 && \
docker push registry-vpc.cn-qingdao.aliyuncs.com/wod/etcd:v3.4.1

# flannel
docker pull quay.io/coreos/flannel:v0.11.0 && \
docker tag quay.io/coreos/flannel:v0.11.0 registry-vpc.cn-qingdao.aliyuncs.com/wod/flannel:v0.11.0 && \
docker push registry-vpc.cn-qingdao.aliyuncs.com/wod/flannel:v0.11.0

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

# tiller gcr.io/kubernetes-helm/tiller:v2.14.3
docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/tiller:v2.14.3 && \
docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/tiller:v2.14.3 registry-vpc.cn-qingdao.aliyuncs.com/wod/tiller:v2.14.3 && \
docker push registry-vpc.cn-qingdao.aliyuncs.com/wod/tiller:v2.14.3

# traefik
docker pull traefik:v1.7.18-alpine && \
docker tag traefik:v1.7.18-alpine registry-vpc.cn-qingdao.aliyuncs.com/wod/traefik:v1.7.18-alpine && \
docker push registry-vpc.cn-qingdao.aliyuncs.com/wod/traefik:v1.7.18-alpine
```
