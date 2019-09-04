#!/bin/bash

# $1 is the page URL
echo 'Obteniendo el código de la página y guardándolo en un fichero temporal'
declare -xr TMP_FILE=$( bash ./download_animeflv_page_code.sh $1 )
echo $TMP_FILE
echo 'Código guardado en '"$TMP_FILE"
echo 'Descargando el fichero de ZippyShare'

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

function download_cap ()
{
    S_TOOL=$1
    S_SERV=$2
    S_SCRI=$3
    [ -e "${ANIME_ID}_${EPISODE_NUM}.mp4" ] && return 0
    URL=$( bash ./${S_SCRI} $TMP_FILE )
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

declare -rx ANIME_ID="$( grep 'var' $TMP_FILE | sed 's/^[\t ]*//;s/var *//' | tr -d ' ;' | grep 'anime_id' | sed 's/.*=//' | grep -o '[0-9]*' )"
declare -rx EPISODE_ID="$( grep 'var' $TMP_FILE | sed 's/^[\t ]*//;s/var *//' | tr -d ' ;' | grep 'episode_id' | sed 's/.*=//' | grep -o '[0-9]*' )"
declare -rx EPISODE_NUM="$( grep 'var' $TMP_FILE | sed 's/^[\t ]*//;s/var *//' | tr -d ' ;' | grep 'episode_num' | sed 's/.*=//' | grep -o '[0-9]*' )"

echo ''
for SCRIPT in get_*url_*.sh
do
echo "URL: $( bash $SCRIPT $TMP_FILE)"
done
echo "ANIME_ID: $ANIME_ID
EPISODE_ID: $EPISODE_ID
EPISODE_NUM: $EPISODE_NUM
"

# # Download
# Download by Mega
download_cap 'megadl' 'Mega' 'get_megaurl_from_animeflv_page_code.sh'

# Download by RapidVideo
download_cap 'wget' 'RapidVideo' 'get_rapidvideourl_from_animeflv_page_code.sh'

# Download by ZippyShare
download_cap 'plowdown' 'ZippyShare' 'get_zippyurl_from_animeflv_page_code.sh'

# Download by Maru
download_cap 'youtube-dl' 'Maru' 'get_maruvideourl_from_animeflv_page_code.sh'

# Download error
[ -e "${ANIME_ID}_${EPISODE_NUM}.mp4" ] && exit 1

echo 'Fichero descargado, gracias.'
exit 0
