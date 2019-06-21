FROM alpine:3.8

ENV TIMEZONE Asia/Shanghai

RUN	sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories

RUN	apk add --no-cache tzdata && \
	cp /usr/share/zoneinfo/${TIMEZONE} /etc/localtime && \
	echo "${TIMEZONE}" > /etc/timezone

RUN apk add --no-cache dumb-init ca-certificates

COPY init.sh /

RUN chmod +x /init.sh
ENTRYPOINT ["/usr/bin/dumb-init", "-v", "--"] 
CMD ["/init.sh"]
