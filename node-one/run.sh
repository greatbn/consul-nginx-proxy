#!/bin/bash

sudo su -

echo Update
apt-get update && \
    apt-get install -y curl

echo Fetching consul-nginx-proxy ...
git clone https://github.com/greatbn/consul-nginx-proxy.git  /build
cd /build/node-one

echo Installing Docker ...
curl -sSL https://get.docker.io/  | sh

cp /build/node-two/docker /etc/default/docker
service docker restart

echo Installing Docker Compose
curl -L https://github.com/docker/compose/releases/download/1.6.2/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

echo Install consul-server
docker run -d -p 8500:8500 --name consul progrium/consul -server -bootstrap

echo Install swarm
docker run -d swarm join --addr=10.30.0.10:2375 consul://10.30.0.10:8500/swarm

echo Install swarm-manager
docker run -d -p 2376:2375 swarm manage consul://10.30.0.10:8500/swarm
