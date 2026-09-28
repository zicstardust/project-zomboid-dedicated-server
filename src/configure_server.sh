#!/usr/bin/env bash

STEAM_BRANCHE=$(cat /home/pzserver/branch.txt)


echo $STEAM_BRANCHE
sleep 5

set -e
: "${UPDATE_JRE:=false}"
: "${STEAM:=true}"
: "${DISABLE_MOD_DOWNLOADER:=false}"

#Check update
echo "Checking for updates..."
steamcmd.sh +force_install_dir /app +login anonymous +app_update 380870 validate -beta "${STEAM_BRANCHE}" +quit

#Set MAX_RAM
echo "Setting max RAM to ${MAX_RAM:-8g}..."
sed -i "s/Xmx8g/Xmx${MAX_RAM:-8g}/" /app/ProjectZomboid64.json

#Set STEAM
echo "Setting Steam to ${STEAM}..."
if [[ "$STEAM" =~ ^(0|false|False|n|N)$ ]]; then
    sed -i "s/-Dzomboid.steam=1/-Dzomboid.steam=0/" /app/ProjectZomboid64.json
fi

#Update JRE
if [[ "$UPDATE_JRE" =~ ^(1|true|True|y|Y)$ ]]; then
     if [ "$STEAM_BRANCHE" == "legacy41" ]; then
        JRE_MAJOR_VERSION="17"
    else
        JRE_MAJOR_VERSION="25"
    fi

    JRE_URL=$(curl -s "https://api.azul.com/metadata/v1/zulu/packages/?java_version=${JRE_MAJOR_VERSION}&os=linux&arch=x64&archive_type=tar.gz&java_package_type=jre&availability_types=ca&crac_supported=false&javafx_bundled=false&latest=true" | jq -r '.[0].download_url')
    JRE_VERSION=$(echo "$JRE_URL" | sed -n 's/.*zulu\([0-9.]*-ca-jre[0-9.]*\).*/\1/p')

    echo "Update default Java Runtime ${JRE_MAJOR_VERSION}..."
    rm -Rf /app/jre64
    wget -q ${JRE_URL}
    tar -xf zulu${JRE_VERSION}-linux_x64.tar.gz
    rm -f zulu${JRE_VERSION}-linux_x64.tar.gz
    mv zulu${JRE_VERSION}-linux_x64 jre64
fi

#Download Mods
if [[ "$STEAM" =~ ^(0|false|False|n|N)$ ]] && [[ "$DISABLE_MOD_DOWNLOADER" =~ ^(0|false|False|n|N)$ ]]; then
    echo "Downloading mods for non-steam server..."
    mods_downloader.sh
fi
