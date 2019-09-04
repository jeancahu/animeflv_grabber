#!/bin/bash

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

exit 0
