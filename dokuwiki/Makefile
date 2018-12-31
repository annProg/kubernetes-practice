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
	docker run --name $(APP) -d --env APP_CONFIG_PATH=$(APP_CONFIG_PATH) -v $(PWD)/debug:$(APP_CONFIG_PATH) -p 8080:80 $(IMAGE):latest

up:
	sleep 1;echo;curl -s "$(CMDBAPI)?cluster=$(CLUSTER)&app=$(APP)";echo
