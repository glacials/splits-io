#!/usr/bin/env bash

cd /app
/usr/local/bin/docker-compose --file docker-compose-production.yml down -d > /var/log/docker-compose.log 2> /var/log/docker-compose.log

# Always succeed; we may be running on a new instance with no containers
exit 0
