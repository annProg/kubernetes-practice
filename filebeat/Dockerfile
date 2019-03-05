FROM alpine:edge as builder
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories
RUN apk add --no-cache wget 
WORKDIR root
RUN wget https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-6.6.0-linux-x86_64.tar.gz
RUN tar zxvf filebeat-6.6.0-linux-x86_64.tar.gz


FROM centos:7
RUN mkdir /filebeat
RUN yum install -y net-tools && rm -fr /var/cache/yum/*
COPY --from=builder /root/filebeat-6.6.0-linux-x86_64/ /filebeat

COPY app.sh /

CMD ["/bin/bash", "/app.sh"]
