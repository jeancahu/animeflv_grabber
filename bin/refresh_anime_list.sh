#!/bin/bash

echo '<!DOCTYPE html>
<html>
<head>
<title>Anime</title>
</head>
<body>

<h1>Anime List</h1>

'

for FILE in *.mp4 */*.mp4
do
	#FILE="$( basename $FILE )"
	echo "<a href=./$FILE>$FILE</a><br/>"
done

echo '
</body>
</html>'
