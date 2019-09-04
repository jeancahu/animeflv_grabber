#!/bin/bash

URL_BASE='https://my.mail.ru/mail/budyak.rus/video/_myvideo/'
declare SERVER_DIR='e'
declare QUALITY='720p'

# $1 is the file of the html code from animeflv page.
URL=$(
    grep 'server=maru' $1 | grep -o 'budyak\.rus#[^\]*' |
	sed 's/^.*#//'
)

echo "${URL_BASE}${URL}"'.html?time=NaN'

exit 0
