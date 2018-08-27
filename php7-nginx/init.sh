#!/bin/sh

function getEnv() {
	if [ "$1"x == ""x ];then
		echo $2
	else
		echo $1
	fi
}

PHP_FPM_MODE=`getEnv "$PHP_FPM_MODE" "dynamic"`
PHP_FPM_MAX_CHILDREN=`getEnv "$PHP_FPM_MAX_CHILDREN" "100"`
PHP_FPM_START_SERVERS=`getEnv "$PHP_FPM_START_SERVERS" "30"`
PHP_FPM_MIN_SPARE_SERVERS=`getEnv "$PHP_FPM_MIN_SPARE_SERVERS" "10"`
PHP_FPM_MAX_SPARE_SERVERS=`getEnv "$PHP_FPM_MAX_SPARE_SERVERS" "50"`
PHP_FPM_MAX_REQUESTS=`getEnv "$PHP_FPM_MAX_REQUESTS" "500"`

NGINX_WORKER_CONNECTIONS=`getEnv "$NGINX_WORKER_CONNECTIONS" "65535"`
NGINX_WORKER_RLIMIT_NOFILE=`getEnv "$NGINX_WORKER_RLIMIT_NOFILE" "80000"`

PHP_CONF="/etc/php7/php-fpm.d/www.conf"
NGINX_CONF="/etc/nginx/nginx.conf"

sed -i "s/^pm = .*/pm = $PHP_FPM_MODE/g" $PHP_CONF
sed -i "s/^pm.max_children = .*/pm.max_children = $PHP_FPM_MAX_CHILDREN/g" $PHP_CONF
sed -i "s/^pm.start_servers = .*/pm.start_servers = $PHP_FPM_START_SERVERS/g" $PHP_CONF
sed -i "s/^pm.min_spare_servers = /pm.min_spare_servers = $PHP_FPM_MIN_SPARE_SERVERS/g" $PHP_CONF
sed -i "s/^pm.max_spare_servers = /pm.max_spare_servers = $PHP_FPM_MAX_SPARE_SERVERS/g" $PHP_CONF
sed -i "s/^pm.max_requests = /pm.max_requests = $PHP_FPM_MAX_REQUESTS/g" $PHP_CONF

sed -i "s/worker_rlimit_nofile .*/worker_rlimit_nofile $NGINX_WORKER_RLIMIT_NOFILE;/g" $NGINX_CONF
sed -i "s/worker_connections .*/worker_connections $NGINX_WORKER_CONNECTIONS;/g" $NGINX_CONF

chown -R nobody.nobody /home/wwwroot/default/
env |grep -v "=$" | sed "s/\(.*\)=\(.*\)/env[\1]='\2'/" >> /etc/php7/php-fpm.d/www.conf
supervisord -n
