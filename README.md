# hello world

本项目用来测试kubesphere的以下功能：
1. Devops项目流水线
2. Devops项目持续部署
3. 应用商店

## Devops项目流水线

流水线运行成功后可以通过 http://192.168.143.151:30862/ 访问

### 准备工作

在devops项目中创建3个凭证
- **github-id:** Github账号的令牌
- **dockerhub-id:** Docker账号的令牌
- **demo-kubeconfig:** 部署项目的集群配置

### main

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

## 持续部署

创建持续部署，清单文件路径填`./devops/`，执行`同步`后即可在指定项目中按yaml配置部署

## 应用商店

### 自制应用

1. 通过`helm create helloworld`命令可以生成helloworld目录及相关文件，修改其配置。
2. 通过`helm package helloworld`打包项目，生成`helloworld-0.1.1.tgz`文件。
3. 在`企业空间 -> 应用管理 -> 应用模板 -> 创建 -> 上传`后，即可进行应用安装或审核。
4. 安装调试完成后，可以在应用模板详情中发起审核。
5. 管理员可在`平台管理 -> 应用商店管理 -> 应用审核`中看到待审核的应用。
6. 审核通过后，用户可在应用模板详情中自行决定是否发布应用到应用商店。
7. 如需更新应用，只需在应用模板详情中上传版本，再重新进去审核即可。

### 应用仓库

可以通过此功能直接使用第三方的应用仓库

1. 在`企业空间 -> 应用管理 -> 应用仓库 -> 添加`成功后，会显示在列表中。
2. 在`企业空间 -> 项目 -> 应用负载 -> 应用 -> 创建 -> 从应用模板`中可以切换到第三方应用仓库。



