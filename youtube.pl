#!/usr/bin/env perl
use strict;
use warnings;

my $n = $ARGV[0] ;

###########################
# FIX OLD NAMING PATTERNS #
###########################

$n =~ s/^
	(?<dd>20\d\d-\d\d-\d\d)[_\ |]+     # Date
	(\d\d-\d\d[_\ |]+)?                # Time (optional)
	(?<ch>.*?\))[_\ |]+                # Channel
	(?<tt>.*)_ [_\ |]*                 # Title
	id=(?<id>[-\w]{11})[_\ |]+         # ID
	\(?(?<fm>\d+p(_\d.+)?)[_)]         # Format
	\.(?<ex>(webm|mp4|mkv|3gp))        # Extention
	$
	/$+{ch}||$+{dd}||$+{id}||$+{fm}||$+{tt}.$+{ex}/xx ;

$n =~ s/^
	(?<ch>.+)==                  # Channel
	(?<dd>20\d\d-\d\d-\d\d)==    # Date
	(?<tt>.+)==                  # Title
	(?<fm>.+)==                  # Format
	(?<id>\w{11})                # ID
	\.(?<ex>(webm|mp4|3gp|mkv))  # Extention
	$
	/$+{ch}||$+{dd}||$+{id}||$+{fm}||$+{tt}.$+{ex}/xx ;

# Audio and video format details
$n =~ s/\|\|(\d+p)_(\d+fps)_(VP9|H264)-(\d+k)bit_/||$1-$2-$3 $4-/ ;

###############################
# FIX CURRENT NAMING PATTERNS #
###############################

# JDownloader
$n =~ s/==/||/g ;
$n =~ s/k-Vorbis\|\|/k-Vorb||/ ;

# Channel/Uploader names
$n =~ s/^([^(]+)\(\1\)\|\|/$1||/ ; # For when channel and uploader names are identical.
$n =~ s/^CardGamesFTW\(LittleKuriboh\)\|\|/Little Kuriboh||/ ;
$n =~ s/^TeamFourStar\|\|/Team Four Star||/ ;

print $n;
