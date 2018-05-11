#!/bin/sh
chown -R nobody.nobody /home/wwwroot/default/
env |grep -v "=$" | sed "s/\(.*\)=\(.*\)/env[\1]='\2'/" >> /etc/php7/php-fpm.d/www.conf
supervisord -n
