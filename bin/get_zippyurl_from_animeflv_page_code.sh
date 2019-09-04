#!/bin/bash

# $1 is the file of the html code from animeflv page.

grep -o http://ouo.*zippyshare.*file.html $1 | cut -f 2 --delimiter='=' |
sed 's/%2F/%/g;s/%3A/:/' | tr '%' '/' | cut -f 1 --delimiter=' ' |
tr -d '" ' | uniq

exit 0
