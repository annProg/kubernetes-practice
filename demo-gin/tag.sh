#!/bin/bash

############################
# Usage: 检查镜像tag，防止镜像被覆盖或者代码未提交
# File Name: tag.sh
# Author: annhe  
# Created Time: 2019-04-20 20:31:02
############################

TAG=$1
REVISION=`git rev-parse HEAD`
SHORT_REVISION=`git rev-parse --short HEAD`
TMPFILE="/tmp/k8s_check_tag_$TAG-$REVISION-$RANDOM$RANDOM$RANDOM.txt"

function isclean() {
	isclean=`git status -s |wc -l`
	[ $isclean -gt 0 ] && echo "working directory not clean($isclean). please commit first" && exit 1
}

function ispush() {
	git ls-remote > $TMPFILE
	grep "$REVISION" $TMPFILE &>/dev/null && r=0 || r=1
	[ $r -eq 1 ] && echo "commit not pushed. please run git push first" && exit 1
}

function ismerge() {
	if [ "$TAG"x != "latest"x ];then
		diffstat=`git diff --stat origin/master |wc -l`
		[ $diffstat -gt 0 ] && echo "commit not merged. please merge first" && exit 1
	fi
}

function checkTag() {
	if [ "$TAG"x != "latest"x ];then
		#remotetagrev=`git ls-remote --exit-code --tags origin refs/tags/$TAG^{} |awk '{print $1}'`
		remotetagrev=`grep -E "$TAG\^\{\}" $TMPFILE |awk '{print $1}'`
		tagrev=`git rev-parse $TAG^{}`
		if [ "$tagrev"x != "$REVISION"x ];then
			echo "tag revision($tagrev) not equal to current revision($REVISION). Can not use this tag($TAG)"
			exit 1
		fi

		if [ "$tagrev"x != "$remotetagrev"x ];then
			echo "tag revision($tagrev) not equal to remote tag revision($remotetagrev). Can not use this tag($TAG)"
			exit 1
		fi
	fi
}

[ "$TAG"x == ""x ] && echo "param TAG required!" && exit 1
# 首先判断代码是否提交，然后判断代码是否push
# 指定tag时，要对比本地tag和远程tag是否一致

isclean
ispush
ismerge
checkTag
