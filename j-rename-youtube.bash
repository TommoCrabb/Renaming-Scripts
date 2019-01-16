#!/usr/bin/env bash

WRITE=""

function rename_files() {
    for file in * ; do
	i="$file"

	# Major name changes
	#     i=$( echo "$i" | sed -r '
	# s/^Agonywolf Media([|=]{2}.*[|=]{2}Fun With Shorts!)/Josh Way\1/ ;
	# ' )

	# Fix names for full HD Youtube channels.
	i=$( echo "$i" | sed -r '
s/^(Gentle Whispering|Gibi|Melissa Rose|Scottish Murmurs|Sleeping Pearl|Darya Lozhkina|Bright Grey|Jellybean Green|Heather Feather|Christen Noel|Pandora) ASMR([|=]{2})/\1\2/ ;
s/^brightgreyASMR([|=]{2})/Bright Grey\1/ ;
s/^InnocentWhispers ASMR([|=]{2})/Innocent Whispers\1/ ;
s/^Isabel imagination ASMR([|=]{2})/Isabel Imagination\1/ ;
s/^Isabel backstage([|=]{2})/Isabel Backstage\1/ ;
s/^MissChloeASMR([|=]{2})/Miss Chloe\1/ ;
s/^WhisperAudios ASMR([|=]{2})/Whisper Audios\1/ ;
s/^WhispersRed ASMR([|=]{2})/Whispers Red\1/ ;
s/^VisualSounds1 ASMR([|=]{2})/Visual Sounds\1/ ;
s/^ASMRMagic([|=]{2})/ASMR Magic\1/ ;
s/^ASMR KittyKlaw([|=]{2})/KittyKlaw\1/ ;
s/^JellybeanASMR([|=]{2})/Jellybean\1/ ;
s/^ValeriyaASMR([|=]{2})/Valeriya\1/ ;
s/^PeacefulMindASMR([|=]{2})/Peaceful Mind\1/ ;
s/^MissASMR([|=]{2})/Miss ASMR\1/ ;
s/^ANYA WHISPERS . ASMR([|=]{2})/Anya Whispers\1/ ;
s/^LauraLemurex ASMR([|=]{2})/Laura Lemurex\1/ ;
s/^MYSTERY SCIENCE THEATER 3000([|=]{2})/MST3K\1/ ;
s/^Agonywolf Media([|=]{2})/ICWXP\1/ ;
' )

	# Standard-definition spacing. eg: "||720p => || 720p" (for channels listed above only)
	[[ "$file" != "$i" ]] && i=$( echo "$i" | sed -r 's/([|=]{2})([[:digit:]]{3}p-)/\1 \2/' )
	i=$( echo "$i" | sed -r 's/^(Damian Cowell[|=]{2}.*[|=]{2})([[:digit:]]{3}p-)/\1 \2/' )

	# Fix names for 720p (and lower) Youtube channels.
	i=$( echo "$i" | sed -r '
s/^(RedLetterMedia|Previously Recorded)([|=]{2})/RLM\2/ ; 
s/^TeamFourStar([|=]{2})/Team Four Star\1/ ; 
s/^swankivy([|=]{2})/SwankIvy\1/ ;
s/^2000ADonline([|=]{2})/2000AD\1/ ;
s/^ICWXP([|=]{2}.*[|=]{2}) (720p-.*[|=]{2}Fun With Shorts)/Josh Way\1\2/ ;
' )

	# Formatting
	i=$( echo "$i" | sed -r '
s/[- _]+You[tT]ube\.(mp4|webm)$/.\1/ ;
s/[- _]*Yoga With Adriene\.(mp4|webm)$/.\1/ ;
s/([|=]{2})MST3K[-_ ]+/\1/ ;
s/(FULL MOVIE)\)[ -]*( with Annotations)/\1\2)/ ;
s/(AD ABC #[[:digit:]]*)_ /\1: / ;
s/([|=]{2})Previously Recorded - /\1PreRec: / ;
s/([|=]{2})(Half in the Bag|Best of the Worst)_ /\1\2: / ;
s/([|=]{2})DragonBall Z Abridged_ Episode/\1DBZ ABRIDGED: Episode/ ;
s/(([- _])*(#CellGames|TeamFourStar|\(TFS\)))+\.(webm|mp4)/.\4/ ;

# GENERAL
s/==/||/g ;
s/(k-)Vorbis([|=]{2})/\1Vorb\2/ ;
s/-avc1\.[0-9a-f]{6} 128k-mp4a\.40\.2/-H264 128k-AAC/ ;
s/-vp9 160k-opus/-VP9 160k-Opus/ ;
s/\|\|(20[0-9]{2})([0-1][0-9])([0-3][0-9])\|\|/||\1-\2-\3||/ ;
' )

	# Audio Only
	year="$( date +%Y )"
	i=$( echo "$i" | sed -r "
s/^Crooked Russian Cam[|=]{2}(20[[:digit:]]{2}-[[:digit:]]{2}-[[:digit:]]{2})[|=]{2}(.{11})[|=]{2}(128k-AAC)[|=]{2}(.*)\.aac$/Jem Jam||\1||\2||\3 ||\4.aac/ ;
s/[|=]{2}(Jem and the Holograms #[0-9]+)[- _]+(Comic Discussion)[- _]+THE JEM JAM/||\2: \1/ ;
" )

	# Jem Jam||2017-07-09||pQtETFB-yVY||128k-AAC ||Jem and the Holograms #26 - Comic Discussion - THE JEM JAM.aac
	# Jem Jam||2017-05-07||UQpaBF018v8||128k-AAC ||Comic Discussion: Jem and the Holograms #25.aac  

	if [[ "$WRITE" == "yes" ]] ; then
	    [[ "$file" != "$i" ]] && mv -vi "$file" "$i"
	else
	    [[ "$file" != "$i" ]] && echo -e "$file\n$i\n======"
	fi
	
    done
}

rename_files
if [[ "$WRITE" != "yes" ]] ; then
    read -p 'Type "yes" if you want to commit changes to disk (do anything else to exit): ' WRITE
    if [[ "$WRITE" == "yes" ]] ; then
	rename_files
    fi
fi
