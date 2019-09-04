#!/bin/python3

import cfscrape
import sys

url=''

try:
    url=sys.argv[1]
except:
    quit(1)

scraper = cfscrape.create_scraper()
content = scraper.get(url)
content = str(content.content).replace('\\n','\n')
content = content.replace('\\r', '')

try:
    print(content)
    quit(0)
except:
    quit(2)
