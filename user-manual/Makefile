IMAGENAME ?= k8s-doc
REGISTRY ?= registry-cn.scloud.letv.com/hean
TAG ?= latest
IMAGE = $(REGISTRY)/$(IMAGENAME)
CMDBAPI ?= http://cmdb.scloud.letv.cn/api/k8s.php
CLUSTER ?= dev
APP ?= k8s-doc

all: build push up

build:
	docker build -t $(IMAGE):$(TAG) .

push:
	docker push $(IMAGE):$(TAG)

up:
	sleep 1;echo;curl -s "$(CMDBAPI)?cluster=$(CLUSTER)&app=$(APP)";echo
