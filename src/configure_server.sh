#!/usr/bin/env bash


BUILD=$1

#Update JRE
#if [[ "$UPDATE_JRE" =~ ^(1|true|True|y|Y)$ ]] || [ "$(uname -m)" = "aarch64" ]; then
if [[ "$UPDATE_JRE" =~ ^(1|true|True|y|Y)$ ]]; then
     if [ "$BUILD" == "41" ]; then
        JRE_MAJOR_VERSION="17"
    else
        JRE_MAJOR_VERSION="25"
    fi

    JRE_URL=$(curl -s "https://api.azul.com/metadata/v1/zulu/packages/?java_version=${JRE_MAJOR_VERSION}&os=linux&arch=x64&archive_type=tar.gz&java_package_type=jre&availability_types=ca&crac_supported=false&javafx_bundled=false&latest=true" | jq -r '.[0].download_url')
    JRE_VERSION=$(echo "$JRE_URL" | sed -n 's/.*zulu\([0-9.]*-ca-jre[0-9.]*\).*/\1/p')

    echo "Update default Java Runtime ${JRE_MAJOR_VERSION} to version ${JRE_VERSION}..."
    rm -Rf /app/jre64
    wget -q ${JRE_URL}
    tar -xf zulu${JRE_VERSION}-linux_${JAVA_ARCH}.tar.gz
    rm -f zulu${JRE_VERSION}-linux_${JAVA_ARCH}.tar.gz
    mv zulu${JRE_VERSION}-linux_${JAVA_ARCH} jre64
fi


#if [ "$(uname -m)" = "aarch64" ]; then
#    sed -i "s|jre64/lib/amd64|jre64/lib|" /app/start-server.sh
#    sed -i "s|./ProjectZomboid64|box64 ./ProjectZomboid64|" /app/start-server.sh
#    sed -i '\|$PATH"|a \        export BOX64_LD_LIBRARY_PATH="${INSTDIR}:${INSTDIR}/linux64"' /app/start-server.sh
#fi



