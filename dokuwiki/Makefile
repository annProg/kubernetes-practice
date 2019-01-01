IMAGENAME ?= dokuwiki
REGISTRY ?= registry.cn-beijing.aliyuncs.com/kubebase
TAG ?= latest
IMAGE = $(REGISTRY)/$(IMAGENAME)
CMDBAPI ?= http://cmdb.cn/api/k8s.php
CLUSTER ?= dev
APP ?= opwiki
# 判断本地是否允许此容器，用于调试
exists ?= $(shell docker ps -a |grep $(APP) &>/dev/null && echo "yes" || echo "no")

PWD =$(shell pwd)

# k8s预定义的APP_CONFIG_PATH环境变量默认值为/run/secret/appconfig
APP_CONFIG_PATH ?= /run/secret/appconfig

GITREPO ?=
ID_RSA ?= 
ID_RSA_PUB ?=

all: build push up

build:
	docker build -t $(IMAGE):$(TAG) .

push:
	docker push $(IMAGE):$(TAG)
# 本地调试
debug: build run

# 本地运行容器，需要先判断容器是否存在
run:
ifeq ($(exists), yes)
	docker stop $(APP);docker rm $(APP)
endif
	docker run --name $(APP) -d --env-file $(PWD)/debug/conf/ENV --env GITREPO=$(GITREPO) -v $(ID_RSA):$(APP_CONFIG_PATH)/ID_RSA -v $(ID_RSA_PUB):$(APP_CONFIG_PATH)/ID_RSA_PUB --env APP_CONFIG_PATH=$(APP_CONFIG_PATH) -v $(PWD)/debug/conf:$(APP_CONFIG_PATH) -v $(PWD)/debug/data:/home/wwwroot/default/data -p 8080:80 $(IMAGE):$(TAG)

up:
	sleep 1;echo;curl -s "$(CMDBAPI)?cluster=$(CLUSTER)&app=$(APP)";echo
