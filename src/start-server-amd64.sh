#!/usr/bin/env bash

LANGUAGE=$1
SERVER_NAME=$2
ADMIN_USERNAME=$3
ADMIN_PASSWORD=$4
STEAM=$5
MAX_RAM=$6


#Set MAX_RAM
sed -i "s/Xmx8g/Xmx${MAX_RAM}/" /app/ProjectZomboid64.json

#Set STEAM
if [[ "$STEAM" =~ ^(0|false|False|n|N)$ ]]; then
    sed -i "s/-Dzomboid.steam=1/-Dzomboid.steam=0/" /app/ProjectZomboid64.json
fi

/app/start-server.sh \
    -Duser.language=${LANGUAGE} \
    -Ddeployment.user.cachedir=/data \
    -- \
    -servername ${SERVER_NAME} \
    -adminusername ${ADMIN_USERNAME} \
    -adminpassword ${ADMIN_PASSWORD}
