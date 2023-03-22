#!/bin/bash

command_present() {
  type "$1" >/dev/null 2>&1
}

SCRIPT_DIRECTORY="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";
PARENT_DIRECTORY="${SCRIPT_DIRECTORY%/*}"
source $PARENT_DIRECTORY/.env

cd $PARENT_DIRECTORY

docker login -u secodaonpremise --password $DOCKER_TOKEN

docker-compose stop frontend api
docker rm $(docker ps -aq)
docker-compose pull

echo "Please wait... This may take a few minutes."
docker-compose up -d
docker image prune -a -f
