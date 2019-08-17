# debug
```powershell
## aliyun
# docker remove 
docker rm ansible -f

# docker run
docker run `
--name ansible `
-h ansible `
-v $PWD/linux/aliyun.ini:/etc/ansible/hosts `
-v $PWD/linux/group_vars/aliyun.yml:/etc/ansible/linux/group_vars/aliyun.yml `
-d registry.cn-qingdao.aliyuncs.com/wod-cloud/ansible-kubernetes

docker run `
--name ansible `
-h ansible `
-v $PWD/:/etc/ansible `
-d registry.cn-qingdao.aliyuncs.com/wod-cloud/ansible-kubernetes

# docker exec
docker exec -it ansible bash
```

windows 10

```powershell
docker run `
--name ansible `
-h ansible `
-v $PWD/:/etc/ansible `
-d registry.cn-qingdao.aliyuncs.com/wod/ansible:2.7.10
```
