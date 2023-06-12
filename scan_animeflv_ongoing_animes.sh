#!/bin/bash

## Depends
# python3
# python3-cfscrape
#

## Anime list

TMP_DIR=/tmp/anime_grabber
test -d $TMP_DIR || mkdir $TMP_DIR

function cloudflare_ninja ()
{
    URL=$1
    echo -ne $( python3 -c "
import cfscrape

url='$URL'

scraper = cfscrape.create_scraper()
content = scraper.get(url)
content = str(content.content)

try:
    print(content)
except:
    quit(1)
" )
}

# lista de animes de hoy desde el html de la página
LIST=( $( cloudflare_ninja 'https://www.animeflv.net' | grep 'class..fa-play\"' 2>/dev/null| grep -v '^<li' | cut --delimiter='"' -f 2 ) )

if [ "$LIST" ]
then :
else
    echo "No list" &>/dev/stderr
    exit 1
fi


## Functions
function print_green () {
    printf "\033[92m$*\033[0m"
}

function print_yellow(){
    printf "\033[93m$*\033[0m"
}

function print_red(){
    printf "\033[91m$*\033[0m"
}

function get_megaurl_from_animeflv_page_code ()
{
    # $1 is the file of the html code from animeflv page.
    {
  # grep -o 'http://ouo.*mega[^"]*' $1 | cut -f 2 --delimiter='='
   tr -d '\\' </dev/stdin | grep -o 'https[^"]*mega\.[^"]*'
    } | sed 's/%2F/\//g;s/%3A/:/;s/%23/\#/g;s/%21/\!/g;s/ class//;s/"//g' |
  grep -v 'embed' |
  sort | uniq | head -n 1
}


function download_animeflv_page_code ()
{
    # $1 is the page URL

    ## Mode 1
    cloudflare_ninja $1

    ## Mode 2
    # curl $1 > "$TMP_DIR/temporal_""$( echo $1 | tr '/' '#' | cut --delimiter='#' -f 5 )"".txt"

    ## Return result
    echo "$TMP_DIR/temporal_""$( echo $1 | tr '/' '#' | cut --delimiter='#' -f 5 )"".txt"
}

function scan_video_urls_from_animeflv_page ()
{
    # $1 is the page URL
    echo 'Obteniendo el código de la página'
    declare -xr TMP_FILE="$( download_animeflv_page_code $1 )"

    declare -rx ANIME_ID="$(
    echo "$TMP_FILE" | grep 'var' | sed 's/^[\t ]*//;s/var *//' | tr -d ' ;' | grep 'anime_id' | sed 's/.*=//' | grep -o '[0-9]*' )"

    declare -rx EPISODE_ID="$(
    echo "$TMP_FILE" | grep 'var' | sed 's/^[\t ]*//;s/var *//' | tr -d ' ;' | grep 'episode_id' | sed 's/.*=//' | grep -o '[0-9]*' )"

    declare -rx EPISODE_NUM="$(
    echo "$TMP_FILE" | grep 'var' | sed 's/^[\t ]*//;s/var *//' | tr -d ' ;' | grep 'episode_num' | sed 's/.*=//' | grep -o '[0-9]*' )"

    echo "
    -> ANIME_ID: $ANIME_ID
    -> EPISODE_ID: $EPISODE_ID
    -> EPISODE_NUM: $EPISODE_NUM
"
    # Print URLs
    #print_red 'Mega URL -> '
    #echo $TMP_FILE | get_megaurl_from_animeflv_page_code
    #echo ''

    print_red "Scraped URLs:"
    echo ''
    echo $TMP_FILE | grep -o 'var *videos.*mega[^;]*' | grep '\([^,]*title[^,]*\|\|[^"]*http[^"]*\)' -o |
        tr -d '\\' | sed 's/http/\thttp/;s/"//g;s/title:/ -> /'
}

declare -a NUMERALS=( {0..9} {a..z} )
declare -i COUNTER=0

print_yellow 'Lista de animes disponibles al día de hoy:

'

for LINE in $( echo ${LIST[*]} | tr ' ' '\n' | cut --delimiter='/' -f 3 )
do
    print_green "\t${NUMERALS[$COUNTER]}"
    print_green "\t$LINE\n"
    let COUNTER++
done | tr '-' ' '

print_yellow '
Desea escanear alguno? (Y/n/#)
'

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

print_red "
-- >> Anime URL: $URL << --

"

# Scan Anime video urls using the next function
scan_video_urls_from_animeflv_page "$URL"

exit 0
