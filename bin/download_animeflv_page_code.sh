#!/bin/bash

# WARN: no hacer otros prints adicionales a los del resultato

source ../include/HEAD

# $1 is the page URL

## Modo 1
python3 ../src/$DOWNLOAD_TOOL $1 > "$TMP_DIR/temporal_""$( echo $1 | tr '/' '#' | cut --delimiter='#' -f 5 )"".txt"

## Modo 2
# wget $1 -O "$TMP_DIR/temporal_""$( echo $1 | tr '/' '#' | cut --delimiter='#' -f 5 )"".txt" &>/dev/null

## Modo 3
# curl $1 > "$TMP_DIR/temporal_""$( echo $1 | tr '/' '#' | cut --delimiter='#' -f 5 )"".txt"


echo "$TMP_DIR/temporal_""$( echo $1 | tr '/' '#' | cut --delimiter='#' -f 5 )"".txt"

exit 0
