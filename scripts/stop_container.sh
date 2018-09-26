#!/usr/bin/env bash
cd /app
/usr/local/bin/docker-compose --file docker-compose-production.yml down -d > /var/log/docker-compose.log 2> /var/log/docker-compose.log
