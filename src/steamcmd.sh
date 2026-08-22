#!/usr/bin/env bash

current_dir=$(pwd)

cd /opt/steamcmd

while true; do
    if [ "$(uname -m)" = "aarch64" ]; then
        box86 ./steamcmd.sh "$@"
    else
        ./steamcmd.sh "$@"
    fi
    #echo "Steamcmd return code: $?"
    return_code=$?
    if [ "$return_code" == "0" ]; then
        break
    else
        echo "Steamcmd error ${return_code}, try again"
    fi  
done

cd $current_dir
