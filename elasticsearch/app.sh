#!/bin/bash
[ "$BASEPATH"x == ""x ] && BASEPATH="/data"
cat > /etc/elasticsearch/elasticsearch.yml <<EOF
cluster.name: $CLUSTER_NAME
node.name: $MY_POD_NAME
path.data: $BASEPATH/lib/elasticsearch
path.logs: $BASEPATH/log/elasticsearch
http.host: $MY_POD_IP
EOF

[ "$ES_HEAP_SIZE"x == ""x ] && ES_HEAP_SIZE="1g"
sudo sed -i -r "s/^-Xm(s|x).*$/-Xm\1$ES_HEAP_SIZE/g" /etc/elasticsearch/jvm.options

for item in log lib;do
	[ ! -d $BASEPATH/$item/elasticsearch ] && sudo mkdir -p $BASEPATH/$item/elasticsearch
	sudo chown -R elasticsearch:elasticsearch $BASEPATH/$item/elasticsearch
done

sudo rm -f /etc/sudoers.d/elasticsearch

exec /usr/share/elasticsearch/bin/elasticsearch


