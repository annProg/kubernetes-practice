FROM centos:7

RUN yum install -y java-11-openjdk-headless net-tools && rm -fr /var/cache/yum/*
RUN rpm -ivh http://yum.intra.scloud.letv.cn/soft/elasticsearch-6.6.0.rpm

RUN yum install -y sudo && rm -fr /var/cache/yum/* && \
	echo "elasticsearch ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/elasticsearch

USER elasticsearch

COPY app.sh /

CMD ["/bin/bash", "/app.sh"]
