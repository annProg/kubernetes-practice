FROM alpine:3.8 as builder
RUN	sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories
RUN apk add --no-cache wget unzip
WORKDIR /wiki
RUN wget https://github.com/splitbrain/dokuwiki/archive/release_stable_2018-04-22a.tar.gz -O stable.tar.gz
RUN tar zxvf stable.tar.gz
RUN rm -f dokuwiki-release_stable_2018-04-22a/install.php

FROM registry.cn-beijing.aliyuncs.com/kubebase/php7-nginx:1.2
COPY --from=builder /wiki/dokuwiki-release_stable_2018-04-22a/ /home/wwwroot/default/
COPY conf/default.conf /etc/nginx/conf.d/default.conf
COPY app.sh /app.sh

