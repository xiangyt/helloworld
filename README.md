# hello world

本项目用来测试kubesphere的Devops项目流水线功能

流水线运行成功后可以通过 http://192.168.143.151:30862/ 访问

## main

go代码是一个监听8080端口的web服务，访问0.0.0.0:8080可以看到`hello world`文本
```go
package main

import (
	"net/http"

	"github.com/gin-gonic/gin"
)

func main() {
	r := gin.Default()
	r.GET("/", func(c *gin.Context) {
		c.String(http.StatusOK, "hello world")
	})
	r.Run() // listen and serve on 0.0.0.0:8080 (for windows "localhost:8080")
}
```

## 准备工作

在devops项目中创建3个凭证
- **github-id:** Github账号的令牌
- **dockerhub-id:** Docker账号的令牌
- **demo-kubeconfig:** 部署项目的集群配置

### Jenkinsfile

```text
environment{
    // 保存Github令牌的变量名
    GITHUB_CREDENTIAL_ID='github-id'
    // 保存Docker令牌的变量名
    DOCKER_CREDENTIAL_ID='dockerhub-id'
    // 保存集群配置的变量名
    KUBECONFIG_CREDENTIAL_ID='demo-kubeconfig'
    // 镜像仓库，默认为docker.io
    REGISTRY = 'docker.io'
    // Docker用户名
    DOCKERHUB_NAMESPACE = 'xiangyt'
    // Docker用户名
    GITHUB_ACCOUNT = 'xiangyt'
    // 应用名称
    APP_NAME='helloworld'
}
```

#### build & push

使用docker编译项目并推送到dockerhub

#### deploy app

根据`KUBECONFIG_CREDENTIAL_ID`和`./manifest/deploy.yaml`部署项目

### Dockerfile逻辑

使用golang:1.19.6-alpine3.17镜像编译项目，将二进制拷贝到最终镜像中

### deploy.yaml

包含一个deployment和service

deploy是go代码制作的镜像，监听8080端口

svc是NodePort类型，将30862端口映射到pod的8080