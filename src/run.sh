#!/usr/bin/env bash
set -e
: "${UPDATE_JRE:=false}"
: "${STEAM:=true}"
: "${DISABLE_MOD_DOWNLOADER:=false}"
: "${MAX_RAM:=8g}"
: "${LANGUAGE:=en}"
: "${SERVER_NAME:=server}"
: "${ADMIN_USERNAME:=admin}"

#download server
download_server.sh

#Download Mods
if [[ "$STEAM" =~ ^(0|false|False|n|N)$ ]] && [[ "$DISABLE_MOD_DOWNLOADER" =~ ^(0|false|False|n|N)$ ]]; then
    echo "Downloading mods for non-steam server..."
    mods_downloader.sh
fi


#server run
if [ "$(uname -m)" = "aarch64" ]; then
    start-server-arm64.sh \
        ${LANGUAGE} \
        ${SERVER_NAME} \
        ${ADMIN_USERNAME} \
        ${ADMIN_PASSWORD:-$(head -c 16 /dev/urandom | base64 | tr -dc 'a-zA-Z0-9')}\
        ${STEAM} \
        ${MAX_RAM}
else
    start-server-amd64.sh \
        ${LANGUAGE} \
        ${SERVER_NAME} \
        ${ADMIN_USERNAME} \
        ${ADMIN_PASSWORD:-$(head -c 16 /dev/urandom | base64 | tr -dc 'a-zA-Z0-9')} \
        ${STEAM} \
        ${MAX_RAM}
fi