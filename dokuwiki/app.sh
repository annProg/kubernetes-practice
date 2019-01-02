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
[ "$DEBUG"x == "yes"x ] && set -x

WIKIROOT=/home/wwwroot/default
MAINCONF="$WIKIROOT/conf/local.php"
DATADIR="$WIKIROOT/data"

[ ! -d $DATADIR ] && echo "Must mount volume to $DATADIR!" && exit 1

function setConf() {
	# $1 type eg. plugin or tpl
	# $2 plugin or tpl name
	# $3 config item
	# $4 config value
	grep "\['$1'\]\['$2'\]\['$3'\]" $MAINCONF &>/dev/null|| echo "\$conf['$1']['$2']['$3'] = '$4';" >> $MAINCONF
}

# app.sh是以root用户运行的，php程序以nobody用户运行，因此git相关命令也应用nobody运行，否则会有权限问题
# 需要设置HOME 参见 https://stackoverflow.com/a/27151021 解决  unable to access '/root/.config/git/attributes' 报错
function gitCmd() {
	su - nobody -s /bin/sh -c "HOME=/home/nobody;cd $DATADIR;git $1"
}

function stepPreConf() {
	for item in `ls $APP_CONFIG_PATH`; do 
		echo $item | grep -E '[A-Z]' && continue          # 跳过普通环境变量
		cp $APP_CONFIG_PATH/$item $WIKIROOT/conf/${item}".php"
		chown nobody.nobody $WIKIROOT/conf/${item}".php"   # 允许通过配置工具修改配置，但是重部之后会失效
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

	# default template
	echo "\$conf['template'] = 'bootstrap3';" >> $MAINCONF
}

# 设置SSH KEY
function sshKey() {
	SSHDIR=/home/nobody/.ssh/
	echo "SSHDIR: $SSHDIR"
	[ ! -d $SSHDIR ] && mkdir -p $SSHDIR
	[ -f "$APP_CONFIG_PATH/ID_RSA" ] && cp $APP_CONFIG_PATH/ID_RSA $SSHDIR/id_rsa
	[ -f "$APP_CONFIG_PATH/ID_RSA_PUB" ] && cp $APP_CONFIG_PATH/ID_RSA_PUB $SSHDIR/id_rsa.pub
	echo "I am `whoami`"
	echo "StrictHostKeyChecking no" >> $SSHDIR/config
	chown -R nobody.nobody /home/nobody
}

# gitbacked设置，忽略cache tmp目录
# 将git作为默认存储，容器更新后拉取远程仓库
# 为了提高git pull速度，需要有持久化存储。如果用hostPath，需要固定机器
function stepPluginGitbacked() {
	sshKey
	# 设置默认值
	setConf plugin gitbacked ignorePaths "cache,tmp,index,locks"
	setConf plugin gitbacked periodicPull "1"
	setConf plugin gitbacked pushAfterCommit "1"

	# 需要设置HOME 参见 https://stackoverflow.com/a/27151021 解决  unable to access '/root/.config/git/attributes' 报错
	export HOME=/home/nobody

	# 需要设置权限
	chown -R nobody.nobody $DATADIR
	cd $DATADIR

	isEmpty=`ls $DATADIR |wc -l`
	[ $isEmpty -eq 0 ] && gitCmd "clone $GITREPO $DATADIR"
	if [ ! -d $DATADIR/.git ];then
		gitCmd init
		gitCmd "remote add origin $GITREPO"
	fi

	# 设置
	gitCmd 'config user.name "nobody"'
	gitCmd 'config user.email "dokuwiki@k8s.cluster"'

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
		gitCmd "add -A"
		gitCmd 'commit -m "commit"'
		gitCmd "push -u origin master"
	fi
}

function stepPluginSyntaxhighlightjs() {
	setConf plugin syntaxhighlightjs selectClass "pre.code"
}

function stepTplBootstrap3() {
	setConf tpl bootstrap3 showThemeSwitcher "1"
	setConf tpl bootstrap3 showPageIcons "1"
	setConf tpl bootstrap3 showPurgePageCache "logged"
	setConf tpl bootstrap3 pageIcons "feed,send-mail,permalink,print,help"
}

# 执行以step开头的函数
stepPreConf
stepPluginGitbacked
stepPluginSyntaxhighlightjs
stepTplBootstrap3
