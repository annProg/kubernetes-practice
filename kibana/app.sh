#!/bin/bash

cat > /kibana/config/kibana.yml <<EOF
i18n.locale: "zh"
elasticsearch.hosts: ["http://$ELASTICSEARCH_HOST"]
server.host: $MY_POD_IP
EOF

exec /kibana/bin/kibana
