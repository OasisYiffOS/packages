#! /bin/bash

sudo useradd -c "Redis in-memory data structure store" -s /var/lib/redis redis

mkdir -p /var/lib/redis 0700 redis redis
chown redis:redis /var/lib/redis
chmod 0700 /var/lib/redis

mkdir -p /etc/redis
chown root:redis /etc/redis
chmod 0775 /etc/redis

chown root:redis /etc/redis/sentinel.conf
chmod 0664 /etc/redis/sentinel.conf