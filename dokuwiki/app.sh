#!/bin/sh
set -x

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

# 设置SSH KEY
SSHDIR=/home/nobody/.ssh/
echo "SSHDIR: $SSHDIR"
[ ! -d $SSHDIR ] && mkdir -p $SSHDIR
[ -f "$APP_CONFIG_PATH/ID_RSA" ] && cp $APP_CONFIG_PATH/ID_RSA $SSHDIR/id_rsa
[ -f "$APP_CONFIG_PATH/ID_RSA_PUB" ] && cp $APP_CONFIG_PATH/ID_RSA_PUB $SSHDIR/id_rsa.pub
echo "I am `whoami`"
echo "StrictHostKeyChecking no" >> $SSHDIR/config
chown -R nobody.nobody /home/nobody

# gitbacked设置，忽略cache tmp目录
# 将git作为默认存储，容器更新后拉取远程仓库
# 为了提高git pull速度，需要有持久化存储。如果用hostPath，需要固定机器
MAINCONF="$WIKIROOT/conf/local.php"
grep "ignorePaths" $MAINCONF || echo "\$conf['plugin']['gitbacked']['ignorePaths'] = 'cache,tmp';" >> $MAINCONF
grep "periodicPull" $MAINCONF || echo "\$conf['plugin']['gitbacked']['periodicPull'] = 1;" >> $MAINCONF
grep "pushAfterCommit" $MAINCONF || echo "\$conf['plugin']['gitbacked']['pushAfterCommit'] = 1;" >> $MAINCONF

# data目录
DATADIR="$WIKIROOT/data"
# 需要设置权限
chown -R nobody.nobody $DATADIR
cd $DATADIR

function gitCmd() {
	su - nobody -s /bin/sh -c "cd $DATADIR;git $1"
}

isEmpty=`ls $DATADIR |wc -l`
[ $isEmpty -eq 0 ] && gitCmd "clone $GITREPO $DATADIR"
if [ ! -d $DATADIR/.git ];then
   	gitCmd init
	gitCmd "remote add origin $GITREPO"
fi
gitCmd "pull origin master"

for item in attic cache index locks media media_attic media_meta meta pages tmp; do
	[ ! -d $DATADIR/$item ] && mkdir $DATADIR/$item
done

for item in cache tmp index locks;do
	grep "$item/" .gitignore|| echo "$item/" >> .gitignore
done

chown -R nobody.nobody $DATADIR

changes=`git status --short |wc -l`
if [ $changes -gt 0 ];then
	git config --get user.email || git config user.email "dokuwiki@k8s.cluster"
	git config --get user.name || git config user.name "nobody"
	git add -A
	git commit -m "commit"
	gitCmd "push -u origin master"
fi

