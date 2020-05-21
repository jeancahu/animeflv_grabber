#!/bin/bash

## Depends
# python3
# python3-cfscrape
#

## Anime list

function cloudflare_ninja_anime_list ()
{
    URL='https://www.animeflv.net'
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
" ) | grep 'class..fa-play\"' | grep -v '^<li' |
    cut --delimiter='"' -f 2
}

# lista de animes de hoy desde el html de la página
LIST=( $( cloudflare_ninja_anime_list ) )

if [ "$LIST" ]
then :
else
    echo "No list" &>/dev/stderr
    exit 1
fi


## Functions

function rename_cap ()
{
    ORG_NAME=$1
    NEW_NAME=$2
    # Rename a cap with cap number if that exists
    CAP_TMP_NAME="$( find ./ -name ${ORG_NAME}'*' | head -n 1 )"

    if [ $CAP_TMP_NAME ]
    then
	echo "Cap actual name: $CAP_TMP_NAME"
	echo "Cap new name: $NEW_NAME"
	mv $CAP_TMP_NAME $NEW_NAME
	return 0
    else
	return 1
    fi
}

function get_megaurl_from_animeflv_page_code ()
{
    # $1 is the file of the html code from animeflv page.
    {
	# grep -o 'http://ouo.*mega[^"]*' $1 | cut -f 2 --delimiter='='
	cat $1 | tr -d '\\' | grep -o 'https[^"]*mega[^"]*'
    } | sed 's/%2F/\//g;s/%3A/:/;s/%23/\#/g;s/%21/\!/g;s/ class//;s/"//g' |
	grep -v 'embed' |
	sort | uniq | head -n 1
}

function get_zippyurl_from_animeflv_page_code ()
{
    # $1 is the file of the html code from animeflv page.
    grep -o http://ouo.*zippyshare.*file.html $1 | cut -f 2 --delimiter='=' |
	sed 's/%2F/%/g;s/%3A/:/' | tr '%' '/' | cut -f 1 --delimiter=' ' |
	tr -d '" ' | uniq
}

function get_rapidvideourl_from_animeflv_page_code ()
{
    declare SERVER_DIR='e'
    declare QUALITY='720p'

    # $1 is the file of the html code from animeflv page.
    URL=$(
	grep '^ *video\[.\]' $1 | sed 's/.*src=//' |
	    grep 'rv\&value' | sed 's/^.*rv\&value=//;s/\".*$//' |
	    head -n 1 |
	    echo "https://www.rapidvideo.com/$SERVER_DIR/$( tee )"'&q='"$QUALITY"
       )

    # Actually we don't need the original URL
    # echo $URL

    curl "$URL" 2>/dev/null | grep -o 'https[^"]*\.mp4' | tail -n 1
}

function get_maruvideourl_from_animeflv_page_code ()
{
    URL_BASE='https://my.mail.ru/mail/budyak.rus/video/_myvideo/'
    declare SERVER_DIR='e'
    declare QUALITY='720p'

    # $1 is the file of the html code from animeflv page.
    URL=$(
	grep 'server=maru' $1 | grep -o 'budyak\.rus#[^\]*' |
	    sed 's/^.*#//'
       )

    echo "${URL_BASE}${URL}"'.html?time=NaN'
}

function download_cap ()
{
    S_TOOL=$1
    S_SERV=$2
    S_SCRI=$3
    [ -e "${ANIME_ID}_${EPISODE_NUM}.mp4" ] && return 0
    URL=$( ${S_SCRI} $TMP_FILE )
    echo 'Descargar por '"${S_SERV}"
    [ "$URL" ] && case "${S_TOOL}" in
	wget)
	    wget -O "${ANIME_ID}_${EPISODE_NUM}.mp4" "$URL"
	    ;;
	*)
	    ${S_TOOL} "$URL"
    esac
    case "${S_SERV}" in
	Mega|Maru)
	    sleep 0.1 ; rename_cap "${ANIME_ID}_${EPISODE_NUM}" "${ANIME_ID}_${EPISODE_NUM}.mp4"
	    ;;
	*)
	    :
	    ;;
    esac
    return 0
}

function download_animeflv_page_code ()
{
    source ../include/HEAD

    # $1 is the page URL

    ## Mode 1
    python3 ../src/$DOWNLOAD_TOOL $1 > "$TMP_DIR/temporal_""$( echo $1 | tr '/' '#' | cut --delimiter='#' -f 5 )"".txt"

    ## Mode 2
    # wget $1 -O "$TMP_DIR/temporal_""$( echo $1 | tr '/' '#' | cut --delimiter='#' -f 5 )"".txt" &>/dev/null

    ## Mode 3
    # curl $1 > "$TMP_DIR/temporal_""$( echo $1 | tr '/' '#' | cut --delimiter='#' -f 5 )"".txt"

    ## Return result
    echo "$TMP_DIR/temporal_""$( echo $1 | tr '/' '#' | cut --delimiter='#' -f 5 )"".txt"
}

function download_video_from_animeflv_page ()
{
    # $1 is the page URL
    echo 'Obteniendo el código de la página y guardándolo en un fichero temporal'
    declare -xr TMP_FILE=$( download_animeflv_page_code $1 )
    echo $TMP_FILE
    echo 'Código guardado en '"$TMP_FILE"
    echo 'Descargando el fichero de ZippyShare'

    declare -rx ANIME_ID="$( grep 'var' $TMP_FILE | sed 's/^[\t ]*//;s/var *//' | tr -d ' ;' | grep 'anime_id' | sed 's/.*=//' | grep -o '[0-9]*' )"
    declare -rx EPISODE_ID="$( grep 'var' $TMP_FILE | sed 's/^[\t ]*//;s/var *//' | tr -d ' ;' | grep 'episode_id' | sed 's/.*=//' | grep -o '[0-9]*' )"
    declare -rx EPISODE_NUM="$( grep 'var' $TMP_FILE | sed 's/^[\t ]*//;s/var *//' | tr -d ' ;' | grep 'episode_num' | sed 's/.*=//' | grep -o '[0-9]*' )"

    echo "
ANIME_ID: $ANIME_ID
EPISODE_ID: $EPISODE_ID
EPISODE_NUM: $EPISODE_NUM
"

    # # Download
    # Download by Mega
    download_cap 'megadl' 'Mega' 'get_megaurl_from_animeflv_page_code'

    # Download by RapidVideo
    download_cap 'wget' 'RapidVideo' 'get_rapidvideourl_from_animeflv_page_code'

    # Download by ZippyShare
    download_cap 'plowdown' 'ZippyShare' 'get_zippyurl_from_animeflv_page_code'

    # Download by Maru
    download_cap 'youtube-dl' 'Maru' 'get_maruvideourl_from_animeflv_page_code'

    # Download error
    [ -e "${ANIME_ID}_${EPISODE_NUM}.mp4" ] && exit 1

    echo 'Fichero descargado, gracias.'
    
}

declare -a NUMERALS=( {0..9} {a..z} )
declare -i COUNTER=0

echo -e '\nLista de animes disponibles al día de hoy:\n'

for LINE in $( echo ${LIST[*]} | tr ' ' '\n' | cut --delimiter='/' -f 3 )
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

echo "Anime URL is: $URL"

# Download Anime using the next function
download_video_from_animeflv_page "$URL"

exit 0
