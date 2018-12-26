FROM alpine:3.8

ENV TIMEZONE Asia/Shanghai

RUN mkdir -p /home/wwwroot/default && \
	mkdir -p /run/nginx && \
	mkdir /home/nobody && chown -R nobody.nobody /home/nobody && \
	sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories && \
	sed -ri 's#^(nobody:.*)?:/:(.*)#\1:/home/nobody:\2#g' /etc/passwd

RUN	apk add --no-cache tzdata && \
	cp /usr/share/zoneinfo/${TIMEZONE} /etc/localtime && \
	echo "${TIMEZONE}" > /etc/timezone
RUN	apk add --no-cache dumb-init nginx php7 php7-fpm php7-common php7-gd \
	php7-json php7-curl php7-mbstring php7-iconv php7-opcache \
	php7-mysqli php7-mysqlnd php7-pdo_mysql && \
	sed -i -e "s/;daemonize\s*=\s*yes/daemonize = no/g" /etc/php7/php-fpm.conf && \
	sed -i "s|;date.timezone =.*|date.timezone = ${TIMEZONE}|" /etc/php7/php.ini

COPY conf/default.conf /etc/nginx/conf.d/
COPY conf/nginx.conf /etc/nginx/
COPY opt/gbalancer /usr/bin/

# php7 extensions
RUN	apk add --no-cache php7-bcmath php7-ctype php7-xmlreader php7-xmlwriter php7-session php7-sockets php7-gettext php7-ldap
RUN apk add --no-cache php7-mongodb

RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log
RUN ln -sf /dev/stderr /var/log/php7/error.log

COPY opt/daemonize /usr/bin
COPY init.sh /
RUN chmod +x /init.sh
ENTRYPOINT ["/usr/bin/dumb-init", "-v", "--rewrite", "15:3"]
CMD ["/init.sh"]
