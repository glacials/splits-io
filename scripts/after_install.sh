#!/usr/bin/env bash

cd /app
docker load < dist.tar
rm dist.tar
