# 说明

记录v1.16升级至v1.17的注意事项

## hyperkube镜像

hyperkube镜像的启动命令发生了改变。kubelet的启动目录变更

- 原值：'/kubelet'
- 变更：'/usr/local/bin/kubelet'

启动参数变更，大部分启动参数归入--config进行管理，详见链接[kubelet-config-file](https://v1-17.docs.kubernetes.io/zh/docs/tasks/administer-cluster/kubelet-config-file/)

取消了一个feature gate 参数 PersistentLocalVolumes

取消了kubelet运行在rkt里面的限制

## kube-apiserver

feature gates发生改变，MountContainers=true已过期，删掉

## kube-controller-manager

feature gates发生改变，MountContainers=true已过期，删掉
