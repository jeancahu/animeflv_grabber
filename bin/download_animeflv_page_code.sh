#!/bin/bash

source ../include/HEAD

# $1 is the page URL

python3 ../src/$DOWNLOAD_TOOL $1 > "$TMP_DIR/temporal_""$( echo $1 | tr '/' '#' | cut --delimiter='#' -f 5 )"".txt"

echo "$TMP_DIR/temporal_""$( echo $1 | tr '/' '#' | cut --delimiter='#' -f 5 )"".txt"

exit 0
