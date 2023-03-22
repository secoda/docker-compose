#!/bin/bash
source ../.env
now=$(date +"%m-%d-%Y")
sudo tar -zcvf "postgres_${now}".tar.gz /var/lib/docker/volumes/*postgres_data
aws s3 cp "postgres_${now}".tar.gz "$S3_BUCKET"
rm -rf "postgres_${now}.tar.gz"