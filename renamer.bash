#!/usr/bin/env bash

function print_help
# Prints help and exits.
{
	cat << EOF
BASIC DESCRIPTION
This script takes a number of filenames as arguments, and tries to "fix" them, according to predefined rule-sets.
Without any command options, the old names and the new "fixed" names are simply printed to stdout.
See below for options that actually write changes to the hard drive.

RULE SETS
Each rule set is basically a perl script stored in the same directory as the main script. Each filename argument is
handed to the perl script, which runs it through a series of "s/input/outpout/" type substitutions, before handing
back a result. Which perl script is used depends on the alias that was called in the inital invocation. For example, 
if "0-rename-youtube" was called, the perl script used will be "youtube.pl".

USAGE
Test run   | 0-renamer filename1 filename2 ...
Real thing | 0-renamer [ -l | -m ] filename1 filename2 ...
Print Help | 0-renamer -h

NOTE: Options MUST preceed filenames. "0-renamer filename -l" WILL NOT WORK!

OPTIONS
-l (LINK) Creates a link to a file in $new_name_dir and moves original to $old_name_dir
-m (MOVE) Renames files in place. Mistakes can't be undone!
-v (VERB) Also print filenames which were not "fixed"   
-h (HELP) Prints this help text and exits.
EOF

	exit
}

function warn
# Takes one argument ($1) and prints it to both a log file and to stdout as coloured text
{
	echo -e "\033[0;35m${1}\033[0m"
	echo "${1}" >> "${log_file}"
}

### SETUP

# Variables

readonly timestamp=$( date '+%F-%H%M%S' )
readonly log_file="0-renamer_warnings_${timestamp}"
readonly local_file=$( readlink -e "${0}" )
readonly local_dir=$( dirname "${local_file}" )
readonly cmd=$( basename "${0}" )
readonly new_name_dir="0-new-names"
readonly old_name_dir="0-old-names"
readonly hr="\033[0;34m====================\033[0m"
mode="test"

# Determine which Perl script to use

cmd_rgx='^0-rename-(.+)$'
if [[ "${cmd}" =~ ${cmd_rgx} ]] ; then
	script_file="${local_dir}/${BASH_REMATCH[1]}.pl"
else
	warn "ERROR: Pattern mismatch for cmd_rgx (${0}). Exiting"
	exit
fi

# Make sure Perl script exists and is executable

if ! [[ -x "${script_file}" ]] ; then
	warn "ERROR: ${script_file} does not exist or is not executable. Exiting."
	exit
fi

### OPTIONS

while getopts "hmlv" option ; do
	case "${option}" in
		h)
			print_help
			;;
		v)
			verb=1
			;;
		m)
			mode="move"
			;;
		l)
			mode="link"
			# Check if working directories already exist. Create them if they don't. Exit on failure.
			if ! [[ -d "${new_name_dir}" ]] ; then
				mkdir "${new_name_dir}" || { warn "ERROR: could not mkdir ${new_name_dir}. Exiting" ; exit ; }
			fi
			if ! [[ -d "${old_name_dir}" ]] ; then
				mkdir "${old_name_dir}" || { warn "ERROR: could not mkdir ${old_name_dir}. Exiting" ; exit ; }
			fi
			;;
		*)
			warn "Unsopported option. Use -h for help. Exiting."
			exit
			;;
	esac
done
shift $(( ${OPTIND} -1 ))

# If no arguments given, print a warning and exit
[[ -z "${1}" ]] && { warn "No arguments supplied. Use -h for help. Exiting." ; exit ; }

### MAIN LOOP

for input in "${@}" ; do

	# Get $output from Perl script 
	output=$( "${script_file}" "${input}" )

	# If $input and $output match, print or do nothing, depending on value of $verb
	# Either way, skip the rest of the loop.
	if [[ "${input}" == "${output}" ]] ; then
		if [[ "${verb}" == 1 ]] ; then
			echo -e "${hr}"
			warn "NO CHANGE IN FILENAME: ${input}"
		fi
		continue
	fi

	# Insert horizontal rule
	echo -e "${hr}"

	# Take appropriate action depending on value of $mode
	case "${mode}" in
		"link")
			ln -v "${input}" "${new_name_dir}/${output}" &&	mv -vn "${input}" "${old_name_dir}/" || warn "ERROR with ${input}"
			;;
		"move")
			mv -vn "${input}" "${output}" || warn "ERROR with ${input}"
			;;
		"test")
			echo -e " ${input} \n ${output}"
			;;
		*)
			warn "ERROR: var 'mode' = ${mode}. Exiting."
			exit
			;;
	esac
done

# Insert final horizontal rule
echo -e "${hr}"

