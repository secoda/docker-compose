#!/bin/bash

SCRIPT_DIRECTORY="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";
PARENT_DIRECTORY="${SCRIPT_DIRECTORY%/*}"
source $PARENT_DIRECTORY/.env

NOW=$(date +"%m-%d-%Y")

# Get directory that matches this pattern: /var/lib/docker/volumes/*postgres_data
POSTGRES_DIRECTORY=$(sudo find /var/lib/docker/volumes/ -maxdepth 1 -type d -name "*postgres_data")
BACKUP_FILE=$PARENT_DIRECTORY/postgres_$NOW.tar.gz
sudo tar -zcvf $BACKUP_FILE $POSTGRES_DIRECTORY

AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY aws s3 cp --acl private $BACKUP_FILE s3://$PRIVATE_BUCKET/

# Confirm last command was successful:
if [ $? -ne 0 ]; then
  echo "Backup failed. Keeping backup."
  exit 1
fi

rm -rf $BACKUP_FILE