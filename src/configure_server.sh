#!/usr/bin/env bash

set -e
: "${UPDATE_JRE:=false}"
: "${STEAM:=true}"
: "${DISABLE_MOD_DOWNLOADER:=false}"

BUILD=$1
JRE17_VERSION="17.64.17-ca-jre17.0.18"
JRE25_VERSION="25.32.21-ca-jre25.0.2"


#Set MAX_RAM
sed -i "s/Xmx8g/Xmx${MAX_RAM:-4g}/" /app/ProjectZomboid64.json


#Set server language
sed -i '/"-Dzomboid.steam=1",/ a\
		"-Duser.language=TEMP",\' /app/ProjectZomboid64.json
sed -i "s/-Duser.language=TEMP/-Duser.language=${LANGUAGE:-en}/" /app/ProjectZomboid64.json


#Set gamedata to /data
sed -i '/"-Dzomboid.steam=1",/ a\
		"-Ddeployment.user.cachedir=/data",\' /app/ProjectZomboid64.json


#Set STEAM
if [[ "$STEAM" =~ ^(0|false|False|n|N)$ ]]; then
    sed -i "s/-Dzomboid.steam=1/-Dzomboid.steam=0/" /app/ProjectZomboid64.json
fi

#Update JRE
if [[ "$UPDATE_JRE" =~ ^(1|true|True|y|Y)$ ]]; then
    if [ "$BUILD" == "41" ]; then
        JRE_VERSION=$JRE17_VERSION
    else
        JRE_VERSION=$JRE25_VERSION
    fi

    echo "Updating JRE to ${JRE_VERSION}..."
    rm -Rf /app/jre64
    wget -q https://cdn.azul.com/zulu/bin/zulu${JRE_VERSION}-linux_x64.tar.gz
    tar -xf zulu${JRE_VERSION}-linux_x64.tar.gz
    rm -f zulu${JRE_VERSION}-linux_x64.tar.gz
    mv zulu${JRE_VERSION}-linux_x64 jre64
fi

#Download Mods
if [[ "$STEAM" =~ ^(0|false|False|n|N)$ ]] && [[ "$DISABLE_MOD_DOWNLOADER" =~ ^(0|false|False|n|N)$ ]]; then
    echo "Downloading mods for non-steam server..."
    mods_downloader.sh
fi
