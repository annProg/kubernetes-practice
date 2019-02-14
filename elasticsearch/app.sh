#!/bin/bash

cat > /etc/elasticsearch/elasticsearch.yml <<EOF
cluster.name: $CLUSTER_NAME
node.name: $MY_POD_NAME
path.data: /var/lib/elasticsearch
path.logs: /var/log/elasticsearch
http.host: $MY_POD_IP
EOF

for item in log lib;do
	[ ! -d /data/$item/elasticsearch ] && sudo mkdir -p /data/$item/elasticsearch
	sudo chown -R elasticsearch:elasticsearch /data/$item/elasticsearch
done

sudo rm -f /etc/sudoers.d/elasticsearch

exec /usr/share/elasticsearch/bin/elasticsearch


