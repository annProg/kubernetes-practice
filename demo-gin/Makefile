IMAGENAME ?= $(shell pwd |awk -F'/' '{print $$NF}')
REGISTRY ?= registry-cn.scloud.letv.com/hean
TAG ?= latest
IMAGE = $(REGISTRY)/$(IMAGENAME)
 
# 以下3行用于自动更新dev环境上的部署
CMDBAPI ?= http://cmdb.scloud.letv.cn/api/k8s.php
CLUSTER ?= dev
APP ?= k8s
 
# 判断本地是否允许此容器，用于调试
exists ?= $(shell docker ps -a |grep $(APP) &>/dev/null && echo "yes" || echo "no")
PORT ?= 8080
 
WORKDIR ?= $(shell pwd)
PWD =$(shell pwd)
 
# k8s预定义的APP_CONFIG_PATH环境变量默认值为/run/secret/appconfig
APP_CONFIG_PATH ?= /run/secret/appconfig
 
all: build-docker push up config
 
build:
	cd $(WORKDIR)/src && go install
build-docker:
	docker build -t $(IMAGE):$(TAG) .
 
push:
	docker push $(IMAGE):$(TAG)
 
# 通过定义 // CONFIG-BY-ENV 格式的注释，抓取所有需要用环境变量设置的配置项
config:
	find ./ -name "*.php" |xargs grep "// CONFIG-BY-ENV" |awk -F':' '{print $$3": "}' |tr -d ' ' > config.md
 
# 本地调试
debug: build-docker run
 
# 本地运行容器，需要先判断容器是否存在
run:
	echo $(exists)
ifeq ($(exists), yes)
	docker stop $(APP);docker rm $(APP)
endif
	docker run --name $(APP) -d -p $(PORT):80 --env-file $(PWD)/debug/conf/ENV --env APP_CONFIG_PATH=$(APP_CONFIG_PATH) $(IMAGE):$(TAG)
 
# 上线到dev集群
up:
	sleep 1;echo;curl -s "$(CMDBAPI)?cluster=$(CLUSTER)&app=$(APP)";echo
