#!/bin/bash

# Error codes definition
E_DND=1 # No directory specify

# Vars definition

if [ $AFLV_GRAB_DIR ]
then
    :
else
    echo 'Error, please execute confif.sh in repository directory.'
    exit $E_DND
fi

case $1 in
    today)
	bash $AFLV_GRAB_DIR/bin/download_from_animeflv_last_anime_list.sh
    ;;
    help)
	echo 'Help'
    ;;
    *)
	echo 'No command recognized, try $ bash ./'"$0"' help'
    ;;
esac

exit 0
