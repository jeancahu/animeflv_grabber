#!/bin/bash

# $1 is the file of the html code from animeflv page.

grep -o 'http://ouo.*openload[^"]*' $1 | cut -f 2 --delimiter='=' |
sed 's/%2F/%/g;s/%3A/:/' | tr '%' '/' | uniq

exit 0
