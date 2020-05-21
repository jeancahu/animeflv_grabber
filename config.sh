#!/bin/bash

if [ -f include/HEAD ]
then
    :
else
    if [-d include ]
    then
	:
    else
	mkdir include
    fi
    touch include/HEAD
    echo '### GLOBAL CONFIG FILE

AFLV_GRAB_DIR='"$PWD"'
TMP_DIR=$AFLV_GRAB_DIR/tmp
DOWNLOAD_TOOL=cloudflare_ninja.py
fi

exit 0
