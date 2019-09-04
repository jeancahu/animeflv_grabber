#!/bin/bash

# lista de animes de hoy desde el html de la página
#LIST=( $( wget -o /dev/null 'https://www.animeflv.net' -O - | grep 'class..fa-play\"' | grep -v '^<li' | cut --delimiter='"' -f 2 ) ) # Esto crea un ARRAY con la
LIST=( $( python3 ../src/cloudflare_ninja.py 'https://www.animeflv.net' | grep 'class..fa-play\"' | grep -v '^<li' | cut --delimiter='"' -f 2 ) ) # Esto crea un ARRAY con la

declare -a NUMERALS=( {0..9} {a..z} )
declare -i COUNTER=0

echo -e '\nLista de animes disponibles al día de hoy:\n'

echo ${LIST[*]} | tr ' ' '\n' | cut --delimiter='/' -f 4 |
    while read LINE
    do
	printf "\t${NUMERALS[$COUNTER]}\t$LINE\n"
	let COUNTER++
    done | tr '-' ' '

echo -ne '\n Desea descargar alguno? (Y/n/#) '

OPTION=''
while [[ $OPTION != [0-9a-zYN] ]]
do
    read -n 1 OPTION
done

printf '\n'

if [ "${OPTION,}" == 'n' ]
then
    exit 0
else
    if [ "${OPTION,}" == 'y' ] || [ "${OPTION}" == '' ]
    then
	read -p 'Cual? ' NUMBER
    else
	NUMBER=$OPTION
    fi
fi

if [[ $NUMBER == [a-z] ]]
then
    NUMBER=$( bash -c '
    declare -i COUNTER=0
    for NUM in {a..'"$NUMBER"'}
    do
	let COUNTER++
    done
    echo $(( COUNTER + 9 ))' )
else
    :
fi

# Comprobar que NUMBER es un número

URL='https://www.animeflv.net'"${LIST[$NUMBER]}" # Esta es la URL del anime deseado

echo "El URL del anime es: $URL"

# Se descarga el anime con:

bash ./download_video_from_animeflv_page.sh "$URL"

## Post script:

bash ./refresh_anime_list.sh > ./list.html

exit 0
