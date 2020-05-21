#!/bin/bash

# Requiere que $1 sea la dirección del tmp con el code de la página
declare TMP_FILE=$1
declare CAP_PAGE='/ver/CODE/ANIME-'
declare -i COUNTER=1

if [ -f $TMP_FILE ]
then
    CAP_PAGE=${CAP_PAGE/ANIME/$( grep anime_info $TMP_FILE | cut -f3 --delimiter=',' | tr -d '"\r];' )}
    grep episodes $TMP_FILE | sed 's/\],\[/\n/g;s/.*\[\[//;s/\]\].*//' |
	sort | cut -f 2 --delimiter=',' |
	while read CODE
	do
	    echo "${CAP_PAGE/CODE/$CODE}$COUNTER"
	    let COUNTER++
	done
else
	exit 1
fi

exit 0
