FROM alpine:edge as builder
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories
RUN apk add --no-cache wget 
WORKDIR root
RUN wget http://yum.intra.scloud.letv.cn/soft/kibana-6.6.0-linux-x86_64.tar.gz
RUN tar zxvf kibana-6.6.0-linux-x86_64.tar.gz


FROM centos:7
RUN mkdir /kibana
RUN yum install -y net-tools && rm -fr /var/cache/yum/*
COPY --from=builder /root/kibana-6.6.0-linux-x86_64/ /kibana/

COPY app.sh /

CMD ["/bin/bash", "/app.sh"]
