#!/usr/bin/env bash

set -e
: "${BUILD:=stable}"
: "${DISABLE_CACHE:=false}"

mountpoint /cache &> /dev/null || DISABLE_CACHE="true"


if [ "$BUILD" == "outdatedunstable" ]; then
    BRANCHE="outdatedunstable"
elif [ "$BUILD" == "42.19" ]; then
    BRANCHE="42.19"
elif [ "$BUILD" == "stable" ] || [ "$BUILD" == "42" ]; then
    BRANCHE="public"
elif [ "$BUILD" == "41" ]; then
    BRANCHE="legacy41"
else
    echo "BUILD ${BUILD} not supported"
    exit 1
fi

echo "Downloading server BUILD ${BUILD}..."

if [[ "$DISABLE_CACHE" =~ ^(0|false|False|n|N)$ ]]; then
    cache.sh restore_steamcmd
    cache.sh restore_app $BUILD
fi

steamcmd.sh +force_install_dir /app +login anonymous +app_update 380870 validate -beta "${BRANCHE}" +quit

if [[ "$DISABLE_CACHE" =~ ^(0|false|False|n|N)$ ]]; then
    cache.sh backup_steamcmd
    cache.sh backup_app $BUILD
fi


configure_server.sh $BUILD
