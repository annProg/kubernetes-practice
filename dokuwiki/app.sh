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
# 为了和普通环境变量区分，普通环境变量请使用大写

WIKIROOT=/home/wwwroot/default

for item in `ls $APP_CONFIG_PATH`; do 
	echo $item | grep -E '[A-Z]' && continue          # 跳过普通环境变量
	cp $APP_CONFIG_PATH/$item $WIKIROOT/conf/${item}".php"
done

# default acl and account
AUTH="$WIKIROOT/conf/users.auth.php"
ACL="$WIKIROOT/conf/acl.auth.php"
if [ ! -f $AUTH ]; then
	echo 'admin:$1$lgH1ByTw$3agbZNBd7/JrVrUflGVNp/:annProg:admin@admin.com:admin,user' > $AUTH
fi

if [ ! -f $ACL ]; then
	echo -e "* @ALL 1\n* @user 8" > $ACL
fi

# data目录
DATADIR="$WIKIROOT/data"

for item in attic cache index locks media media_attic media_meta meta pages tmp; do
	[ ! -d $DATADIR/$item ] && mkdir $DATADIR/$item
done
# 需要设置权限
chown -R nobody.nobody $DATADIR
