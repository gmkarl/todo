#!/bin/bash

export TZ=America/New_York
today="$(date +"%F %Z")"
year="${today%%-*}"

csv="${year}-meds.csv"

now()
{
	date +%T
}

if ! grep -q "^$today" "$csv"
then
	echo 'Morning meds ! Yippee !'
	echo 'Fill your fiber/miralax/celexa drink and have a sip, then hit enter.'
	echo 'Type "itsokay" if you missed morning meds today!'

	read morningstart
	if [ "x$morningstart" != "x" ]
	then
		if [ "$morningstart" == "itsokay" ]
		then
			echo 'Sorry you missed morning meds!'
			TODO fill in empty morning meds info
		fi
		echo 'oops!  you typed something weird!'
		exec "$0" "$@"
	fi
	fiberstart=$(now)

	echo 'T
	echo 'Take your multivitamin, then hit enter.'
	echo 'Type "itsokay" to not take your multivitamin.'
	read multiv
fi

