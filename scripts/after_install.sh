#!/usr/bin/env bash

cd /app
export REPOSITORY_URI="767531804574.dkr.ecr.us-east-1.amazonaws.com/splitsio-prod-builder"
$(aws ecr get-login --no-include-email --region us-east-1)
docker pull $REPOSITORY_URI:latest
source ~/.env
/usr/local/bin/docker-compose -f docker-compose-production.yml build web
