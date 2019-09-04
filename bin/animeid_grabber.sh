#!/bin/bash

# Show anime servers URL from a $1 URL animeid chapter page
# Give URLs over a second layer of server.

# Variables
declare -xi COUNTER=0
declare -xa LAST_ANIME_LIST
declare -xi ANIME_NUM

# Functions

function get_urls_from_animeid_chapter_page ()
{
    URL=$1
    # URL='https://www.animeid.tv/v/goblin-slayer-7'

    curl $URL 2>/dev/null |
	tee >( grep 'yourupload' ) >( grep 'rapidvideo' ) &>/dev/null |
	sed 's/.*src=//
s/\\u0022//g
s/\\\//\//g
s/\\u0026/\&/g
s/.*\/\{2\}/https:\/\//' |
	cut -f 1 --delimiter=' '
}

function get_animeid_chapter_list ()
{
    URL='https://www.animeid.tv/'
    curl $URL 2>/dev/null | grep 'href' |
	grep '/v/' | tr -d ' \t' | cut -f 2 --delimiter='"' |
	sort | uniq
}

function download_from_last_anime_list ()
{
    URL='https://www.animeid.tv'
    LAST_ANIME_LIST=(
	$( get_animeid_chapter_list )
    )

    for ANIME in ${LAST_ANIME_LIST[@]}
    do
	printf "${COUNTER}\t${ANIME}\n"
	let COUNTER++
    done | sed 's/-/ /g;s/\/v\// \* /'

    read -p 'Cúal animé desea descargar? [#] ' ANIME_NUM
    echo ${URL}${LAST_ANIME_LIST[$ANIME_NUM]}

    # Download with rapidvideo
    get_urls_from_animeid_chapter_page ${URL}${LAST_ANIME_LIST[$ANIME_NUM]} |
	grep 'rapidvideo' | head -n 1 |
	curl "$( tee )" 2>/dev/null | grep -o 'https[^"]*\.mp4' |
	head -n 1 | wget -O "${LAST_ANIME_LIST[$ANIME_NUM]:3}.mp4" "$( tee )"
}

# Main
if [ $1 ] # There is a URL chapter page
then
    get_urls_from_animeid_chapter_page "$1"
else # There is not a URL
    download_from_last_anime_list
fi

exit 0
