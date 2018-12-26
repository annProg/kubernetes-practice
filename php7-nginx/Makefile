IMAGENAME ?= php7-nginx
REGISTRY ?= registry.cn-beijing.aliyuncs.com/kubebase
TAG ?= latest
IMAGE = $(REGISTRY)/$(IMAGENAME)
exists ?= $(shell docker ps -a |grep $(IMAGENAME) &>/dev/null && echo "yes" || echo "no")
basedir =$(shell pwd)

all: build push

build:
	docker build -t $(IMAGE):$(TAG) .

push:
	docker push $(IMAGE):$(TAG)

run:
ifeq ($(exists), yes)
	docker stop $(IMAGENAME);docker rm $(IMAGENAME)
endif
	docker run --name $(IMAGENAME) --env APP_CONFIG_PATH=/run/config -d -p 8080:80 -v $(basedir)/opt/config.json:/run/config/GBALANCER $(REGISTRY)/$(IMAGENAME):latest
