#!/usr/bin/env bash
cd /app

# ~/.env is created by the launch configuration's User Data. It's just a file full of "export SOME_ENV_VAR=value".
source ~/.env
/usr/local/bin/docker-compose --file docker-compose-production.yml up -d > /var/log/docker-compose.log 2> /var/log/docker-compose.log
