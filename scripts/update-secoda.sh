#!/bin/bash

command_present() {
  type "$1" >/dev/null 2>&1
}

cd "${0%/*}"
source ../.env
docker login -u secodaonpremise --password $DOCKER_TOKEN

docker-compose stop frontend api
docker rm $(docker ps -aq)
docker-compose pull

docker-compose up -d
docker image prune -a -f
