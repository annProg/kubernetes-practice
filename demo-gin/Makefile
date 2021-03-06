IMAGENAME ?= $(shell pwd |awk -F'/' '{print $$NF}')
REGISTRY ?= registry.cn-beijing.aliyuncs.com/kubebase
IMAGE = $(REGISTRY)/$(IMAGENAME)

TAG ?= latest
REVISION = $(shell git rev-parse --short HEAD)
REALTAG = $(TAG)-$(REVISION)

# 以下3行用于自动更新dev环境上的部署
CMDBAPI ?= http://cmdb.com.cn/api/k8s.php
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
	docker build -t $(IMAGE):$(REALTAG) .
 
push:
	./tag.sh $(TAG)
	docker tag $(IMAGE):$(REALTAG) $(IMAGE):latest
	docker push $(IMAGE):$(REALTAG)
	docker push $(IMAGE):latest
 
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
	docker run --name $(APP) -d -p $(PORT):80 --env-file $(PWD)/debug/conf/ENV --env APP_CONFIG_PATH=$(APP_CONFIG_PATH) $(IMAGE):$(REALTAG)
 
# 上线到dev集群
up:
	sleep 1;echo;curl -s "$(CMDBAPI)?cluster=$(CLUSTER)&app=$(APP)";echo
