FROM alpine:3.10

ENV TIMEZONE Asia/Shanghai

RUN	sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories

RUN	apk add --no-cache tzdata && \
	cp /usr/share/zoneinfo/${TIMEZONE} /etc/localtime && \
	echo "${TIMEZONE}" > /etc/timezone

RUN apk add --no-cache dumb-init ca-certificates

RUN apk add --no-cache nginx tcpdump iproute2 bind-tools curl
RUN mkdir /run/nginx && chown -R nginx.nginx /run/nginx
COPY conf/default.conf /etc/nginx/conf.d
RUN mkdir -p /home/wwwroot/default

COPY init.sh /
COPY test.sh /
RUN chmod +x /test.sh

RUN chmod +x /init.sh
ENTRYPOINT ["/usr/bin/dumb-init", "-v", "--"] 
CMD ["/init.sh"]
