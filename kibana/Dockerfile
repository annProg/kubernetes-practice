FROM alpine:edge as builder
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories
RUN apk add --no-cache wget 
WORKDIR root
RUN wget http://yum.intra.scloud.letv.cn/soft/kibana-6.6.0-linux-x86_64.tar.gz
RUN tar zxvf kibana-6.6.0-linux-x86_64.tar.gz
RUN apk add --no-cache git python2
RUN git clone https://github.com/anbai-inc/Kibana_Hanization
RUN cd Kibana_Hanization && python main.py /root/kibana-6.6.0-linux-x86_64/


FROM centos:7
RUN mkdir /kibana
RUN yum install -y net-tools && rm -fr /var/cache/yum/*
COPY --from=builder /root/kibana-6.6.0-linux-x86_64/ /kibana/

COPY app.sh /

CMD ["/bin/bash", "/app.sh"]
