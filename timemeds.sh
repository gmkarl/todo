#!/bin/bash

routine="$1"

export TZ=America/New_York
today="$(date +"%F %Z")"
year="${today%%-*}"

csv="${year}-meds.csv"

echo 'Good morning !'

{
	sleep 0.1
	echo "I'll fill in values for your $routine meds!" > /dev/tty
	echo '' > /dev/tty
	cat "$csv" | {
		while read line
		do
			if [ "$line" == "$routine Meds" ]
			then
				break
			fi
		done
		while read line
		do
			if [ "x$line" == "x" ]
			then
				break
			fi
			medid="${line%%,*}"
			line="${line#*, }"
			medname="${line%%,*}"
			line="${line#*, }"
			fulldosage="${line%%,*}"
			dosage="${fulldosage%% *}"
			notes="${line#*, }"
			if [ "$notes" == "$line" ]
			then
				notes=''
				echo "Have $fulldosage of $medname, then hit enter !" > /dev/tty
				read </dev/tty
				echo "$medid" "$dosage"
			else
				echo "Have $fulldosage ($notes) of $medname, then hit enter !" >/dev/tty
				read </dev/tty
				echo "$medid" "$dosage" "$notes"
			fi
			sleep 0.3
		done
	}
} | "$(dirname "$0")/havemed.sh" | grep -v 'ID Dosage'
