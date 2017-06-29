############################################################
# Dockerfile to build Elasticsearch 3.4.2 environment
############################################################

# Set the base image to openjdk:8-jre
FROM openjdk:8-jre

# File Author / Maintainer
MAINTAINER Marcio Godoi <souzagodoi@gmail.com>

# Run as a root user
USER root

ENV ELASTICSEARCH_VERSION 5.4.1
ENV ELASTICSEARCH_DEB_VERSION 5.4.1
ENV ELASTICSEARCH_HOME=/opt/elasticsearch
ENV KIBANA_HOME=/opt/kibana
ENV LOGSTASH_HOME=/opt/logstash

USER root

# Installing sudo module to support Logstash installation
RUN apt-get update && \
    apt-get -y install sudo vim curl

# Installing Elasticsearch
RUN wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-5.4.1.tar.gz -P /tmp/elasticsearch && \
  tar -xvzf /tmp/elasticsearch/elasticsearch-5.4.1.tar.gz -C /tmp/elasticsearch && \
  rm -rf /tmp/elasticsearch/elasticsearch-5.4.1.tar.gz && \
  mv /tmp/elasticsearch/elasticsearch-5.4.1 $ELASTICSEARCH_HOME && \
  rm -rf /tmp/elasticsearch

RUN wget https://github.com/lmenezes/cerebro/releases/download/v0.6.5/cerebro-0.6.5.tgz -P /tmp/cerebro && \
  tar -xvzf /tmp/cerebro/cerebro-0.6.5.tgz -C /tmp/cerebro && \
  rm -rf /tmp/cerebro/cerebro-0.6.5.tgz && \
  mv /tmp/cerebro/cerebro-0.6.5 /opt/cerebro && \
  rm -rf /tmp/cerebro

# Installing Kibana
#RUN wget https://artifacts.elastic.co/downloads/kibana/kibana-5.4.1-linux-x86_64.tar.gz -P /tmp/kibana  && \
#    tar -xvzf /tmp/kibana/kibana-5.4.1-linux-x86_64.tar.gz -C /tmp/kibana && \
#    rm -rf /tmp/kibana/kibana-5.4.1-linux-x86_64.tar.gz && \
#    mv /tmp/kibana/kibana-5.4.1-linux-x86_64 $KIBANA_HOME && \
#    rm -rf /tmp/kibana

# Installing Logstash
#RUN wget https://artifacts.elastic.co/downloads/logstash/logstash-5.4.1.tar.gz -P /tmp/logstash  && \
#    tar -xvzf /tmp/logstash/logstash-5.4.1.tar.gz -C /tmp/logstash && \
#    rm -rf /tmp/logstash/logstash-5.4.1.tar.gz && \
#    mv /tmp/logstash/logstash-5.4.1 $LOGSTASH_HOME && \
#    rm -rf /tmp/logstash

WORKDIR "$ELASTICSEARCH_HOME"

# Install Elasticsearch monitoring plugins
RUN ./bin/elasticsearch-plugin install x-pack

#WORKDIR "$KIBANA_HOME"

# Install Elasticsearch monitoring plugins
#RUN ./bin/kibana-plugin install x-pack

WORKDIR "$LOGSTASH_HOME"

# Install Elasticsearch monitoring plugins
#RUN ./bin/logstash-plugin install x-pack

# Creates directory used to store the data files
RUN mkdir -p /var/data/elasticsearch

# Creates directory used to store the log files
RUN mkdir -p /var/log/elasticsearch

#RUN mkdir -p /opt/logstash/logs /opt/logstash/data

# Create elasticsearch group and user
RUN groupadd -g 1000 elasticsearch \
  && useradd -d "$ELASTICSEARCH_HOME" -u 1000 -g 1000 -s /sbin/nologin elasticsearch

ADD bin/entrypoint.sh /opt/elasticsearch/bin/docker-entrypoint.sh

ADD config/elasticsearch.yml /opt/elasticsearch/config/elasticsearch.yml

#ADD config/kibana.yml /opt/kibana/config/kibana.yml

#ADD config/logstash.yml /opt/logstash/config/logstash.yml

#ADD config/logstash.conf /opt/logstash/config/logstash.conf

RUN chmod 755 /opt/elasticsearch/bin/docker-entrypoint.sh

#RUN chown -R elasticsearch:elasticsearch /opt/elasticsearch/config/ /opt/kibana/config/ /opt/logstash/config/ /opt/logstash/logs/ /opt/logstash/data/ /var/data/elasticsearch /var/log/elasticsearch

RUN chown -R elasticsearch:elasticsearch /opt/elasticsearch/config/ /var/data/elasticsearch /var/log/elasticsearch /opt/cerebro/

# Run the container as elasticsearch user
USER elasticsearch

WORKDIR "$ELASTICSEARCH_HOME"

ENTRYPOINT ["/opt/elasticsearch/bin/docker-entrypoint.sh"]

# Exposes http ports
EXPOSE 9200 9300
