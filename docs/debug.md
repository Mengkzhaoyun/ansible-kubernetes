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
-d hub.c.163.com/mengkzhaoyun/cloud/ansible-kubernetes

# docker exec
docker exec -it ansible bash
```

windows 10

```powershell
docker run `
--name ansible `
-h ansible `
-v C:/Go/src/gitlab.wodcloud.com/kubernetes/ansible/:/etc/ansible `
-d hub.c.163.com/mengkzhaoyun/public:ansible-2.3.0-centos7 /bin/sh -c "while true; do echo hello world; sleep 1; done"
```