#!/usr/bin/env bash

cd /app
source ~/.env
/usr/local/bin/docker-compose --file docker-compose-production.yml up -d > /var/log/docker-compose.log 2> /var/log/docker-compose.log
