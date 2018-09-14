# images

```powershell
# hyperkube
docker pull gcr.io/google-containers/hyperkube:v1.11.2 ;`
docker tag gcr.io/google-containers/hyperkube:v1.11.2 registry.cn-qingdao.aliyuncs.com/wod/hyperkube:v1.11.2 ;`
docker push registry.cn-qingdao.aliyuncs.com/wod/hyperkube:v1.11.2 

# kube-apiserver
docker pull gcr.io/google-containers/kube-apiserver:v1.11.2 ;`
docker tag gcr.io/google-containers/kube-apiserver:v1.11.2 registry.cn-qingdao.aliyuncs.com/wod/kube-apiserver:v1.11.2 ;`
docker push registry.cn-qingdao.aliyuncs.com/wod/kube-apiserver:v1.11.2

# kube-controller-manager
docker pull gcr.io/google-containers/kube-controller-manager:v1.11.2 ;`
docker tag gcr.io/google-containers/kube-controller-manager:v1.11.2 registry.cn-qingdao.aliyuncs.com/wod/kube-controller-manager:v1.11.2 ;`
docker push registry.cn-qingdao.aliyuncs.com/wod/kube-controller-manager:v1.11.2

# kube-scheduler
docker pull gcr.io/google-containers/kube-scheduler:v1.11.2 ;`
docker tag gcr.io/google-containers/kube-scheduler:v1.11.2 registry.cn-qingdao.aliyuncs.com/wod/kube-scheduler:v1.11.2 ;`
docker push registry.cn-qingdao.aliyuncs.com/wod/kube-scheduler:v1.11.2

# kube-proxy
docker pull gcr.io/google-containers/kube-proxy:v1.11.2 ;`
docker tag gcr.io/google-containers/kube-proxy:v1.11.2 registry.cn-qingdao.aliyuncs.com/wod/kube-proxy:v1.11.2 ;`
docker push registry.cn-qingdao.aliyuncs.com/wod/kube-proxy:v1.11.2
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
```