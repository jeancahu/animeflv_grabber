#!/bin/bash

#LIST=( $( cat index.html | grep 'class..fa-play\"' | grep -v '^<li' | cut --delimiter='"' -f 2 ) ) # Esto crea un ARRAY con la lista de animes de hoy desde el html de la página
LIST=( $( wget -o /dev/null 'www.animeflv.net' -O - | grep 'class..fa-play\"' | grep -v '^<li' | cut --delimiter='"' -f 2 ) ) # Esto crea un ARRAY con la lista de animes de hoy desde el html de la página

#echo ${LIST[1]} # Esto imprime el segundo elemento

#echo ${LIST[*]} # Imprime la lista como un todo

echo -e '\nLista de animes disponibles al día de hoy:\n'
echo ${LIST[*]} | tr ' ' '\n' | cut --delimiter='/' -f 4 | cat -n

echo -ne '\n Desea descargar alguno? (Y/n/#) '
read OPTION

#OPTION=${OPTION:-n}
#echo $OPTION

OPTION=$( echo $OPTION | tr 'A-Z' 'a-z' )

if [ "$OPTION" == 'n' ]
then
    exit 0
else
    if [ "$OPTION" == 'y' ] || [ "$OPTION" == '' ]
    then
	read -p 'Cual? ' NUMBER
    else
	NUMBER=$OPTION
    fi   
fi

#echo $NUMBER

# Comprobar que NUMBER es un número

URL='http://www.animeflv.net'"${LIST[ (( $NUMBER -1 )) ]}" # Esta es la URL del anime deseado

#echo $URL

#Se descarga el anime con:

bash ./download_zippyshare_from_animeflv_page.sh "$URL"

exit 0
