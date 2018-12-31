#!/bin/sh

############################
# Usage:
# File Name: app.sh
# Author: annhe  
# Mail: i@annhe.net
# Created Time: 2018-12-31 16:51:25
############################

# wiki配置方式
# 环境变量名称为配置文件名称(不带php后缀)，脚本将复制文件到conf目录
# 举例来说，设置环境变量local, 则cp $APP_CONFIG_PATH/local /home/wwwroot/default/conf/local.php

WIKIROOT=/home/wwwroot/default

for item in `ls $APP_CONFIG_PATH`; do 
	cp $APP_CONFIG_PATH/$item $WIKIROOT/conf/${item}".php"
done

