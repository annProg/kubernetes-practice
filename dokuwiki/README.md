# Dokuwiki docker image
支持部署到kubernetes集群

## 插件

```
plot
catlist
csv
dw2pdf
imgpaste
mathjax
move
todo
epub
wrap
bookcreator
gitbacked
tag
```

## 模板

```
bootstrap3
```

## 配置
- 环境变量名称为配置文件名称(不带php后缀)，脚本将复制文件到conf目录
- 举例来说，设置环境变量local, 则cp $APP_CONFIG_PATH/local /home/wwwroot/default/conf/local.php
- 为了和普通环境变量区分，普通环境变量请使用大写

```
WIKIROOT=/home/wwwroot/default

for item in `ls $APP_CONFIG_PATH`; do 
	echo $item | grep -E '[A-Z]' && continue          # 跳过普通环境变量
	cp $APP_CONFIG_PATH/$item $WIKIROOT/conf/${item}".php"
done
```

### 存储
挂载volume到/home/wwwroot/default/data目录

### git存储
如果没有挂载持久化的存储，推荐使用git存储，需要配置一下环境变量

```
GITREPO
ID_RSA
ID_RSA_PUB
```
如果git使用https方式，则可以不配置ID_RSA和ID_RSA_PUB

## 管理员密码
通过`tools/smd5.php`设置

```
# php smd5.php mypasswd
$1$R8JFGQ1J$WEbAwCMI2RLKjkGQRgEWG.
```

## 基础镜像支持的环境变量
### 自定义PHP配置

```
PHP_FPM_MODE=`getEnv "$PHP_FPM_MODE" "dynamic"`
PHP_FPM_MAX_CHILDREN=`getEnv "$PHP_FPM_MAX_CHILDREN" "100"`
PHP_FPM_START_SERVERS=`getEnv "$PHP_FPM_START_SERVERS" "30"`
PHP_FPM_MIN_SPARE_SERVERS=`getEnv "$PHP_FPM_MIN_SPARE_SERVERS" "10"`
PHP_FPM_MAX_SPARE_SERVERS=`getEnv "$PHP_FPM_MAX_SPARE_SERVERS" "50"`
PHP_FPM_MAX_REQUESTS=`getEnv "$PHP_FPM_MAX_REQUESTS" "100000"`
```

### 自定义Nginx配置
```
NGINX_WORKER_CONNECTIONS=`getEnv "$NGINX_WORKER_CONNECTIONS" "65535"`
NGINX_WORKER_RLIMIT_NOFILE=`getEnv "$NGINX_WORKER_RLIMIT_NOFILE" "80000"`
NGINX_WORKER_PROCESSES=`getEnv "$NGINX_WORKER_PROCESSES" "auto"`
```

