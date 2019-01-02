# images

```powershell
# hyperkube
docker pull gcr.io/google_containers/hyperkube:v1.11.5 ;`
docker tag gcr.io/google_containers/hyperkube:v1.11.5 registry.cn-qingdao.aliyuncs.com/wod/hyperkube:v1.11.5 ;`
docker push registry.cn-qingdao.aliyuncs.com/wod/hyperkube:v1.11.5

# kube-apiserver
docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/kube-apiserver:v1.11.5 &&\
docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/kube-apiserver:v1.11.5 registry-vpc.cn-qingdao.aliyuncs.com/wod/kube-apiserver:v1.11.5 &&\
docker push registry-vpc.cn-qingdao.aliyuncs.com/wod/kube-apiserver:v1.11.5

# kube-controller-manager
docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/kube-controller-manager:v1.11.5 &&\
docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/kube-controller-manager:v1.11.5 registry-vpc.cn-qingdao.aliyuncs.com/wod/kube-controller-manager:v1.11.5 &&\
docker push registry-vpc.cn-qingdao.aliyuncs.com/wod/kube-controller-manager:v1.11.5

# kube-scheduler
docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/kube-scheduler:v1.11.5 &&\
docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/kube-scheduler:v1.11.5 registry-vpc.cn-qingdao.aliyuncs.com/wod/kube-scheduler:v1.11.5 &&\
docker push registry-vpc.cn-qingdao.aliyuncs.com/wod/kube-scheduler:v1.11.5

# kube-proxy
docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/kube-proxy:v1.11.5 &&\
docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/kube-proxy:v1.11.5 registry-vpc.cn-qingdao.aliyuncs.com/wod/kube-proxy:v1.11.5 &&\
docker push registry-vpc.cn-qingdao.aliyuncs.com/wod/kube-proxy:v1.11.5

# pause
docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/pause-amd64:3.1 &&\
docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/pause-amd64:3.1 registry-vpc.cn-qingdao.aliyuncs.com/wod/pause-amd64:3.1 &&\
docker push registry-vpc.cn-qingdao.aliyuncs.com/wod/pause-amd64:3.1

# heapster
docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/heapster-amd64:v1.5.4 &&\
docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/heapster-amd64:v1.5.4 registry-vpc.cn-qingdao.aliyuncs.com/wod/heapster-amd64:v1.5.4 &&\
docker push registry-vpc.cn-qingdao.aliyuncs.com/wod/heapster-amd64:v1.5.4

# addon-resizer
docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/addon-resizer:1.8.3 &&\
docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/addon-resizer:1.8.3 registry-vpc.cn-qingdao.aliyuncs.com/wod/addon-resizer:1.8.3 &&\
docker push registry-vpc.cn-qingdao.aliyuncs.com/wod/addon-resizer:1.8.3
```

```bash
# nginx
docker pull nginx:1.15.3-alpine && \
docker tag nginx:1.15.3-alpine registry-vpc.cn-qingdao.aliyuncs.com/wod/nginx:1.15.3-alpine && \
docker push registry-vpc.cn-qingdao.aliyuncs.com/wod/nginx:1.15.3-alpine

# coredns
docker pull coredns/coredns:1.2.2 && \
docker tag coredns/coredns:1.2.2 registry-vpc.cn-qingdao.aliyuncs.com/wod/coredns:1.2.2 && \
docker push registry-vpc.cn-qingdao.aliyuncs.com/wod/coredns:1.2.2

# kube-router
docker pull cloudnativelabs/kube-router:v0.2.0 && \
docker tag cloudnativelabs/kube-router:v0.2.0 registry-vpc.cn-qingdao.aliyuncs.com/wod/kube-router:v0.2.0 && \
docker push registry-vpc.cn-qingdao.aliyuncs.com/wod/kube-router:v0.2.0

# etcd
docker pull quay.io/coreos/etcd:v3.3.9 && \
docker tag quay.io/coreos/etcd:v3.3.9 registry-vpc.cn-qingdao.aliyuncs.com/wod/etcd:v3.3.9 && \
docker push registry-vpc.cn-qingdao.aliyuncs.com/wod/etcd:v3.3.9

# flannel
docker pull quay.io/coreos/flannel:v0.10.0 && \
docker tag quay.io/coreos/flannel:v0.10.0 registry-vpc.cn-qingdao.aliyuncs.com/wod/flannel:v0.10.0 && \
docker push registry-vpc.cn-qingdao.aliyuncs.com/wod/flannel:v0.10.0

# keepalived
docker pull osixia/keepalived:1.4.5 && \
docker tag osixia/keepalived:1.4.5 registry-vpc.cn-qingdao.aliyuncs.com/wod/keepalived:1.4.5 && \
docker push registry-vpc.cn-qingdao.aliyuncs.com/wod/keepalived:1.4.5
```