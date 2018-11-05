FROM alpine:3.8

ENV TIMEZONE Asia/Shanghai
ENV TERM linux

RUN	sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories
RUN	apk add --no-cache tzdata && \
	cp /usr/share/zoneinfo/${TIMEZONE} /etc/localtime && \
	echo "${TIMEZONE}" > /etc/timezone


RUN apk add --no-cache wrk apache2-utils iproute2 curl wget nginx

RUN mkdir /run/nginx

ENTRYPOINT ["nginx","-g","daemon off;"]
