############################################################
# Dockerfile to build Elasticsearch 3.4.2 environment
############################################################

# Set the base image to openjdk:8-jre
FROM openjdk:8-jre

# File Author / Maintainer
MAINTAINER Marcio Godoi <souzagodoi@gmail.com>

# Run as a root user
USER root

ENV KIBANA_HOME=/opt/kibana

USER root

# Installing sudo module to support Logstash installation
RUN apt-get update && \
    apt-get -y install sudo vim curl

# Installing Kibana
RUN wget https://artifacts.elastic.co/downloads/kibana/kibana-5.4.1-linux-x86_64.tar.gz -P /tmp/kibana  && \
    tar -xvzf /tmp/kibana/kibana-5.4.1-linux-x86_64.tar.gz -C /tmp/kibana && \
    rm -rf /tmp/kibana/kibana-5.4.1-linux-x86_64.tar.gz && \
    mv /tmp/kibana/kibana-5.4.1-linux-x86_64 $KIBANA_HOME && \
    rm -rf /tmp/kibana

WORKDIR "$KIBANA_HOME"

# Install Kibana monitoring plugins
RUN ./bin/kibana-plugin install x-pack

# Create elasticsearch group and user
RUN groupadd -g 1000 kibana \
  && useradd -d "$KIBANA_HOME" -u 1000 -g 1000 -s /sbin/nologin kibana

ADD bin/entrypoint.sh /opt/kibana/bin/docker-entrypoint.sh

ADD config/kibana.yml /opt/kibana/config/kibana.yml

RUN chmod 755 /opt/kibana/bin/docker-entrypoint.sh

RUN chown -R kibana:kibana /opt/kibana/config/ /opt/kibana/bin/

# Run the container as elasticsearch user
USER kibana

ENTRYPOINT ["/opt/kibana/bin/docker-entrypoint.sh"]