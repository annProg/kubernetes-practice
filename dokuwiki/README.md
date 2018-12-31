# Dokuwiki docker image
部署到kubernetes集群

## 配置
- 环境变量名称为配置文件名称(不带php后缀)，脚本将复制文件到conf目录
- 举例来说，设置环境变量local, 则cp $APP_CONFIG_PATH/local /home/wwwroot/default/conf/local.php

```
WIKIROOT=/home/wwwroot/default

for item in `ls $APP_CONFIG_PATH`; do 
	cp $APP_CONFIG_PATH/$item $WIKIROOT/conf/${item}".php"
done
```

## 管理员密码
通过`tools/smd5.php`设置

```
# php smd5.php mypasswd
$1$R8JFGQ1J$WEbAwCMI2RLKjkGQRgEWG.
```
