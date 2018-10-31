#!/bin/bash

# $1 es el URL de la página de la lísta de capítulos

echo 'Generando el fichero temporal con el code de la página lista'
TMP_FILE=$( bash ./download_animeflv_page_code.sh $1 )
echo 'Obteniendo la lista de capítulos del code HTML'
LIST=$( bash ./get_animeflv_cap_list_from_tmpfile.sh $TMP_FILE )
echo ${LIST[@]}
echo 'Iniciando descarga de vídeos'
# Se descarga cada uno de los capítulos disponibles:
for PAGE in $LIST
do
        echo "Descargando de: https://www.animeflv.net""$PAGE"
	bash ./download_zippyshare_from_animeflv_page.sh "https://www.animeflv.net""$PAGE"	
done
echo 'Descargas finalizadas'

exit 0
