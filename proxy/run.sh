#!/bin/bash

sudo su -

echo Install git
apt-get install -y git

echo Fetching microservices-swarm-consul ...
git clone https://github.com/greatbn/consul-nginx-proxy.git  /build
cd /build/node-one

echo Installing Docker ...
apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
echo "deb https://apt.dockerproject.org/repo ubuntu-trusty main" \
    > /etc/apt/sources.list.d/docker.list

apt-get update && \
    apt-get install -y linux-image-extra-$(uname -r)

apt-get update && \
    apt-get install -y docker-engine

cp /build/agent-one/docker /etc/default/docker
service docker restart

echo Installing Docker Compose
curl -L https://github.com/docker/compose/releases/download/1.6.2/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

echo Install nginx-proxy
docker run -d -p 80:80 -e DEFAULT_HOST=sapham.net -e DOCKER_HOST=tcp://10.30.0.10:2376 --name proxy jwilder/nginx-proxy

echo Install consul-server
docker run -d -p 8500:8500 --name consul progrium/consul -server -bootstrap
