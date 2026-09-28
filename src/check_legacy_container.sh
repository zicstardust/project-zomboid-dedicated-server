#!/usr/bin/env bash

LEGACY_CONFIG="false"

mountpoint /cache &> /dev/null && LEGACY_CONFIG="true"

if [ -v BUILD ]; then
    LEGACY_CONFIG="true"
fi


if [ -v DISABLE_CACHE ]; then
    LEGACY_CONFIG="true"
fi



if [ "$LEGACY_CONFIG" == "true" ]; then
    echo "Legacy configuration detected, please use the new configuration method."
    echo "Please refer to the documentation for more information:"
    echo "https://github.com/zicstardust/project-zomboid-dedicated-server#update-from-legacy-container"
    exit 1
else
    exit 0
fi