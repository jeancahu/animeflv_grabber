#!/bin/bash

# $1 is the file of the html code from animeflv page.

grep -o 'http://ouo.*mega[^"]*' $1 | cut -f 2 --delimiter='=' |
sed 's/%2F/\//g;s/%3A/:/;s/%23/\#/g;s/%21/\!/g;s/ class//;s/"//g' | uniq

exit 0
