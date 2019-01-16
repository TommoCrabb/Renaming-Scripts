#!/usr/bin/env perl
use strict;
use warnings;

my $n = $ARGV[0] ;
# my ($sn, $dd, $st, $en, $et, $id) = ("","","","","","") ; # This doesn't work. Causes errors

# Basic episode and title re-arrangements.
$n =~ s/^
    (?<st>[^|]+)					# Series title ${1}
    \|\|
    (?<en>\d+)					# Episode number ${2}
    \|\|
    (?<dd>20\d\d\d\d\d\d)				# Date ${3}
    \|\|
    (Series\ (?<sn>\d+)\ Ep\ \2)?\ *(?<et>[^|]+)?		# Series title ${5} & Episode title ${6}
    \|\|
	((?<vr>\d)                                  # Veritcal Resolution (not in older names)
	\|\|)?
    (?<id>\w{7}0*\2S00)             			# Internal ID ${7}
    \ *\.mkv                                    # File extension (mkv)
    $
    /$+{st}||$+{dd}||s$+{sn}||e$+{en}||$+{vr}p||$+{id}||$+{et}.mkv/xx ;

$n =~ s/ \|\| s       \|\| /||/x ; # Remove empty season
$n =~ s/ \|\| s(\d)   \|\| /||s0${1}||/x ; # Pad season
$n =~ s/ \|\| e(\d)   \|\| /||e0${1}||/x ; # Pad episode
$n =~ s/ \|\| e(\d\d) \|\| /||e0${1}||/x ; # Pad episode again

# Basic 1-off re-arrangements.
$n =~ s/ \|\|NA\|\| (20\d{6}) \|\|NA\|\| (\w{10}S00)\ *.mkv /||${1}||${2}||.mkv/xx ;

# General Fixes
$n =~ s/ &\#039;           /\x27/xg ; # Fix apostrophes
$n =~ s/ \|\| (\w{10}S00) \|\|  /||576p||${1}||/x ; # Add resolution
$n =~ s/ \|\| (20\d\d)(\d\d)(\d\d) \|\|  /||${1}-${2}-${3}||/x ; # Add hyphens to dates

print $n ;
