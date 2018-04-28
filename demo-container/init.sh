#!/bin/sh
chown -R nobody.nobody /home/wwwroot/default/
env | sed "s/\(.*\)=\(.*\)/env[\1]='\2'/" > /etc/php7/php-fpm.d/env.conf
supervisord -n
