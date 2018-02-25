#!/bin/bash

# $1 is the page URL
echo 'Obteniendo el código de la página y guardándolo en un fichero temporal'
TMP_FILE=$( bash ./download_animeflv_page_code.sh $1 )
echo 'Código guardado en '"$TMP_FILE"
echo 'Descargando el fichero de ZippyShare'
plowdown $( bash ./get_zippyurl_from_animeflv_page_code.sh $TMP_FILE )
echo 'Fichero descargado, gracias.'
exit 0
