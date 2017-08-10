#!/usr/bin/env bash

cd /app

# ~/.env is created by the launch configuration's User Data. It's just a file full of "export SOME_ENV_VAR=value".
source ~/.env
rm ~/.env

# envsubst will replace all $ENV_VARS_LIKE_THIS in Dockerfile with their actual values.
cat Dockerfile-production | envsubst > Dockerfile-production.tmp
mv -f Dockerfile-production.tmp Dockerfile-production

/usr/local/bin/docker-compose --file docker-compose-production.yml up -d > /var/log/docker-compose.log 2> /var/log/docker-compose.log
