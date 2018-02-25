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
#DOWNLOAD_TOOL=wget_download.sh' > include/HEAD
fi

#if [ -z $( grep AFLV_GRAB_DIR ~/.bashrc ) ] ; then
#    echo 'export AFLV_GRAB_DIR='"$PWD" >> ~/.bashrc
#fi

exit 0
