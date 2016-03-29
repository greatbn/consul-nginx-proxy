#!/bin/bash

sudo su -

echo Update
apt-get update && \
    apt-get install -y curl

echo Install git
apt-get install -y git

echo Fetching consul-nginx-proxy...
git clone https://github.com/greatbn/consul-nginx-proxy.git  /build
cd /build/proxy

echo Installing Docker ...
curl -sSL https://get.docker.io/  | sh

cp /build/proxy/docker /etc/default/docker
service docker restart

echo Installing Docker Compose
curl -L https://github.com/docker/compose/releases/download/1.6.2/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

echo Install nginx-proxy
docker run -d -p 80:80 -e DEFAULT_HOST=sapham.net -e DOCKER_HOST=tcp://10.30.0.10:2376 --name proxy jwilder/nginx-proxy

echo Install consul-server
docker run -d -p 8500:8500 --name consul progrium/consul -server -bootstrap
