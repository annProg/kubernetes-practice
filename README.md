# kubernetes-practice

## kubernetes工作流
使用iTop作为用户前端，开发人员提供镜像地址，iTop负责像kube-apiserver提交变更。iTop提供给用户3中类型的表单：Deployment，Ingress，Secret，具体策略如下：
1. 新增Deployment后，创建与app同名的Deployment，Service，并创建域名为 appname.xxx.xxx 的默认Ingress
2. 新增Ingress后，读取Deployment的Ingress列表，更新名为appname的Ingress
3. 新增Secret后，创建Secret。Deployment中可以引用Secret（以挂载文件方式）


### 代码规范
1. 代码仓库中不应包含数据库密码等敏感信息，应使用Secret存储配置信息
2. Secret统一挂载至`/run/secrets/appconfig`目录，需要修改代码从此目录读取配置
