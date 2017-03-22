#!/bin/bash

# Requiere que $1 sea la URL de la página de lista de capítulos
# Requiere que $2 sea la dirección del tmp con el code de la página


ANIME_NAME=$( echo $1 | grep -o /\[a-z,A-Z,\-\]*$ | tr '/' '#' | sed s/'#'/''/ )
TMP_FILE=$2
cat $TMP_FILE | grep -o 'href=\"/ver/.\{0,20\}/'"$ANIME_NAME"'.\{0,4\}\" ' | cut --delimiter='"' -f 2 | sort

exit 0
