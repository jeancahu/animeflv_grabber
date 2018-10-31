#!/bin/bash

# $1 is the page URL
echo 'Obteniendo el código de la página y guardándolo en un fichero temporal'
TMP_FILE=$( bash ./download_animeflv_page_code.sh $1 )
echo $TMP_FILE
echo 'Código guardado en '"$TMP_FILE"
echo 'Descargando el fichero de ZippyShare'
URL=$( bash ./get_zippyurl_from_animeflv_page_code.sh $TMP_FILE )
echo $URL
plowdown "$URL"

## HACK
# URL=$( bash -c "
# timeout 140 plowdown $URL &>/dev/stdout |
# grep 'File URL'" |
# grep -o 'http.*' |
# head -n 1
# )
# wget -c $URL

echo 'Fichero descargado, gracias.'
exit 0
