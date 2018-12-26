# php7-nginx镜像
通过环境变量注入自定义配置
## 自定义PHP配置

```
PHP_FPM_MODE=`getEnv "$PHP_FPM_MODE" "dynamic"`
PHP_FPM_MAX_CHILDREN=`getEnv "$PHP_FPM_MAX_CHILDREN" "100"`
PHP_FPM_START_SERVERS=`getEnv "$PHP_FPM_START_SERVERS" "30"`
PHP_FPM_MIN_SPARE_SERVERS=`getEnv "$PHP_FPM_MIN_SPARE_SERVERS" "10"`
PHP_FPM_MAX_SPARE_SERVERS=`getEnv "$PHP_FPM_MAX_SPARE_SERVERS" "50"`
PHP_FPM_MAX_REQUESTS=`getEnv "$PHP_FPM_MAX_REQUESTS" "100000"`
```

## 自定义Nginx配置
```
NGINX_WORKER_CONNECTIONS=`getEnv "$NGINX_WORKER_CONNECTIONS" "65535"`
NGINX_WORKER_RLIMIT_NOFILE=`getEnv "$NGINX_WORKER_RLIMIT_NOFILE" "80000"`
```

## gbalancer配置
为了获得正确的进程树，使用`daemonize`命令启动gbalancer，`daemonize`在alpine中需要编译安装,代码地址 https://github.com/bmc/daemonize

必须在配置项中提供GBALANCER参数，内容为gbalancer配置文件
```
GBALANCER: |
 {xxx
 xxx
 xxx
 }
```

## 自定义启动脚本
在`/app.sh`中提供自定义内容

