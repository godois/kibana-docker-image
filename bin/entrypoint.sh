#!/bin/bash
set -e

#CLUSTER_NAME=banana-cluster
#NODE_NAME=sage-banana-node1
#IS_MASTER_ELEGIBLE_NODE=yes
#IS_DATA_NODE=yes
#LOCK_MEMORY=true
#NETWORK_HOST=127.0.0.1

sed -i "s/CLUSTER_NAME/$CLUSTER_NAME/
  s/NODE_NAME/$NODE_NAME/
  s/IS_MASTER_ELEGIBLE_NODE/$IS_MASTER_ELEGIBLE_NODE/
  s/IS_DATA_NODE/$IS_DATA_NODE/
  s/LOCK_MEMORY/$LOCK_MEMORY/
  s/NETWORK_HOST/$NETWORK_HOST/
  s/UNICAST_HOSTS/$UNICAST_HOSTS/
  s/DISCOVERY_HOSTS/$DISCOVERY_HOSTS/
  s/MINIMUM_MASTER_NODES/$MINIMUM_MASTER_NODES/" ./config/elasticsearch.yml

#echo -e "Starting Elasticsearch $ELASTICSEARCH_VERSION"
exec /opt/elasticsearch/bin/elasticsearch

#echo -e "Starting Kibana... "
#exec /opt/kibana/bin/kibana

#echo -e "Starting Logstash... "
#exec /opt/logstash/bin/logstash -f /opt/logstash/conf/logstash.conf

#while true
#do
#    echo "Press [CTRL+C] to stop..."
#    sleep 1
#done