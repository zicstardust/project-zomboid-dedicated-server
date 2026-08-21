#!/usr/bin/env bash

LANGUAGE=$1
SERVER_NAME=$2
ADMIN_USERNAME=$3
ADMIN_PASSWORD=$4
STEAM=$5
MAX_RAM=$6

if [[ "$STEAM" =~ ^(0|false|False|n|N)$ ]]; then
    STEAM="0"
else
    STEAM="1"
fi

INSTDIR="/app"
cd "${INSTDIR}"

export BOX64_LD_LIBRARY_PATH="${INSTDIR}:${INSTDIR}/linux64"
export LD_LIBRARY_PATH="${INSTDIR}/linux64:${INSTDIR}:${LD_LIBRARY_PATH}"

export BOX64_DYNAREC_BIGBLOCK=0
export BOX64_DYNAREC_STRONGMEM=1
export BOX64_DYNAREC_SAFEFLAGS=2
export BOX64_DYNAREC_WAIT=1
export BOX64_DYNAREC_X87=0 

box64 ${INSTDIR}/jre64/bin/java \
    -XX:TieredStopAtLevel=1 \
    -XX:+UseG1GC \
    -XX:CICompilerCount=2 \
    -Xmx${MAX_RAM} \
    -Djava.awt.headless=true \
    -Djava.library.path="${INSTDIR}/linux64/" \
    -Djava.security.egd=file:/dev/urandom \
    \
    -Ddeployment.user.cachedir=/data \
    -Duser.language=${LANGUAGE} \
    -Dzomboid.steam=${STEAM} \
    -Dzomboid.znetlog=1 \
    \
    -classpath "${INSTDIR}/java/.:${INSTDIR}/java/projectzomboid.jar" \
    zombie.network.GameServer "$@"