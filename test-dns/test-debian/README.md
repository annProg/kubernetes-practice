# dumb-init镜像
通过环境变量注入自定义配置
## 自定义启动脚本
在`/app.sh`中提供自定义内容，请使用 exec 替换shell进程，否则程序可能无法正常接收dumb-init发送的信号
```
exec /mybinname -c $APP_CONFIG_PATH/CONFIG
```
