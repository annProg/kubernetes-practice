#!/bin/bash
[ "$BASEPATH"x == ""x ] && BASEPATH="/data"
cat > /etc/elasticsearch/elasticsearch.yml <<EOF
cluster.name: $CLUSTER_NAME
node.name: $MY_POD_NAME
path.data: $BASEPATH/lib/elasticsearch
path.logs: $BASEPATH/log/elasticsearch
http.host: $MY_POD_IP
EOF

for item in log lib;do
	[ ! -d $BASEPATH/$item/elasticsearch ] && sudo mkdir -p $BASEPATH/$item/elasticsearch
	sudo chown -R elasticsearch:elasticsearch $BASEPATH/$item/elasticsearch
done

sudo rm -f /etc/sudoers.d/elasticsearch

exec /usr/share/elasticsearch/bin/elasticsearch


