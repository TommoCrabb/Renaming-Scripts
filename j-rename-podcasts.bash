#!/usr/bin/env bash

pubDate='20[[:digit:]]{2}-[[:digit:]]{2}-[[:digit:]]{2}'

for file in * ; do
	[[ -f "$file" ]] || continue
	i="$file"

	i=$( echo "$i" | sed -r " 
	s/^Security Now \(MP3\)\|\|(${pubDate})\|\|SN ([[:digit:]]+): (.*)$/Security Now||0\2||\1||#||\3/ ;
	s/^Late Night Linux \(MP3\)\|\|(${pubDate})\|\|Late Night Linux . Episode ([[:digit:]]+)/Late Night Linux||0\2||\1||#||/ ;
	s/^The 2000 AD Thrill-Cast\|\|(${pubDate})\|\|(.*)/2000AD ThrillCast||\1||#||\2/ ;
	s/^My Dad Wrote A Porno\|\|(${pubDate})\|\|Footnotes: (.*)/My Dad Wrote A Porno||\1||FOOTNOTES||#||\2/ ;
	s/^My Dad Wrote A Porno\|\|(${pubDate})\|\|S([[:digit:]]+)E([[:digit:]]+)[-\' ]*(.*)[\']*/My Dad Wrote A Porno||\1||S0\2||E0\3||#||\4/ ;
	s/\|\|E0(.)\|\|/||E00\1||/ ;
	s/^No Agenda\|\|(20[[:digit:]]{2}-[[:digit:]]{2}-[[:digit:]]{2})\|\|([[:digit:]]+): +\"(.*)\"/No Agenda||0\2||\1||#||\3/ ;
	s/^The Sporting Probe[^|]*\|\|(20[0-9]{2}-[0-9]{2}-[0-9]{2})\|\|The Sporting Probe[:. 0-9]+(.*)\.mp3.*/Roy \& HG||\1||#||The Sporting Probe!!||\2.mp3/ ;
s/^The Jem Jam[|=]{2}(20[[:digit:]]{2}-[[:digit:]]{2}-[[:digit:]]{2})[|=]{2}(.*)\.mp3$/Jem Jam||\1||||\2.mp3/ ;
s/^(House to Astonish)[|=]{2}(20[0-9]{2}-[0-9]{2}-[0-9]{2})[|=]{2}House to Astonish[- _]+(Episode[- _]+)?([0-9]+)[- _]+(.*mp3)?.*$/\1||\2||\4||#||\5/ ;
s/^Geek News Radio[|=]{2}(20[0-9]{2}-[0-9]{2}-[0-9]{2})[|=]{2}GNR ([[:digit:]]+)[- _–]+(.*\.mp3)$/Geek News Radio||0\2||\1||#||\3/ ;
s/^systemau[|=]{2}(20[0-9]{2}-[0-9]{2}-[0-9]{2})[|=]{2}Episode[- _]+([-.0-9]+)\.mp3$/System AU||\1||0\2-0||#||.mp3/ ;
	" )

	if [[ "$file" != "$i" ]] ; then
		if [[ "$1" == "mv" ]] ; then
			mv -vn "$file" "$i"
		else
			echo -e "$file\n$i\n=========="
		fi
	fi
done
echo "Pass 'mv' as the first argument to actually rename files."
