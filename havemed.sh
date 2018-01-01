#!/bin/bash

export TZ=America/New_York
today="$(date +"%F %Z")"
year="${today%%-*}"

csv="${year}-meds.csv"

echo ''
grep ^.., "$csv"
echo ''
echo 'Yay!  Meds time!'
echo ''
echo 'Enter meds in the form "ID Dosage".  Hit enter when you take it!'
med='go'
while true
do
	echo ''
	read med dosage notes
	time="$(date -Is)"
	if [ "x$med" == "x" ]; then break; fi
	line="$(grep ^"$med", "$csv")"
	if [ "x$line" == "x" ]
	then
		echo "That med doesn't exist!  You should add it, or fix the ID and re-enter it!"
		continue
	fi
	line="${line#*, }"
	medname="${line%,*}"
	line="${line#*, }"
	stddose="${line% *}"
	medunit="${line#* }"
	if [ "x$dosage" == "x" ]
	then
		dosage="$stddose"
	fi
	if [ "x$notes" != "x" ]; then
		notes="\"$notes\""
		echo "I'll note this with your med! $notes"
	fi
	echo "$time,$med,$dosage,$notes" >> "$csv"
	git add "$csv"
	git commit -m "meds $med $dosage"
	echo "You took $dosage $medunit of $medname at $time !  Yippee!"
done
echo ''
echo "You rock at meds!  Uploading ..."
echo ''
git push

