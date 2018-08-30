FROM registry.ispacesys.cn/cig/data:1.0.0
MAINTAINER Shu Cheng <shucheng@spacesystech.com>

ENV HTTP_SERVER=http://k8s.spacecig.com/softs/kubernetes

RUN mkdir -p /data/input \
&& curl $HTTP_SERVER/etcdctl.tgz > /data/input/etcdctl.tgz