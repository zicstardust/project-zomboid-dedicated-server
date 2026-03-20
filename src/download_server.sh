#!/usr/bin/env bash

set -e
: "${BUILD:=stable}"
: "${APP_CACHE:=true}"
: "${DISABLE_CACHE:=false}"


if [ "$BUILD" == "unstable" ]; then
    BUILD="42"
elif [ "$BUILD" == "outdatedunstable" ]; then
    BUILD="42_oldunstable"
elif [ "$BUILD" == "stable" ]; then
    BUILD="41"
fi


if [ "$BUILD" == "42" ]; then
    BRANCHE="unstable"
    APP_CACHE="0"
elif [ "$BUILD" == "42_oldunstable" ]; then
    BRANCHE="outdatedunstable"
    APP_CACHE="0"
elif [ "$BUILD" == "41" ]; then
    BRANCHE="public"
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
    cache.sh backup_app $BUILD $APP_CACHE
fi


configure_server.sh $BUILD
