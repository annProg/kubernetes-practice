#!/bin/sh
chown -R nobody.nobody /home/wwwroot/default/
supervisord -n
