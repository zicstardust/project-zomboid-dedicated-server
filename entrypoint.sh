#!/usr/bin/env bash

set -e

: "${PUID:=1000}"
: "${PGID:=1000}"

if [ "$(id -g pzserver)" != "${PGID}" ]; then
    groupmod -o -g "${PGID}" pzserver
fi


if [ "$(id -u pzserver)" != "${PUID}" ]; then
    usermod -o -u "${PUID}" pzserver
fi

mkdir -p /data /cache

chown -R pzserver:pzserver /app /data /home/pzserver /opt/steamcmd /cache

exec gosu pzserver "$@"
