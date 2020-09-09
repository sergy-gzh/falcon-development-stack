#!/usr/bin/env bash
set -a
docker-compose  exec -u app magento2_phpfpm /bin/bash
