IMAGENAME ?= php7-nginx
REGISTRY ?= registry-cn.scloud.letv.com/hean
TAG ?= latest
IMAGE = $(REGISTRY)/$(IMAGENAME)

all: build push

build:
	docker build -t $(IMAGE):$(TAG) .

push:
	docker push $(IMAGE):$(TAG)
