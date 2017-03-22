#!/bin/bash

import cfscrape
import sys

url=''

try:
    url=sys.argv[1]
except:
    quit(1)

scraper = cfscrape.create_scraper()

try:
    print (scraper.get(url).content)
    quit(0)
except:
    quit(2)
