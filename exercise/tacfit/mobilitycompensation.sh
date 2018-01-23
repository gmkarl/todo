#!/bin/bash

dir="$1"
. ./functions

numdrills=$(ls "$dir" | wc -l)

for round in 1 2 3
do
	echo "== 6 minutes of drills, round $round / 3 =="
	if (( numdrills == 6 ))
	then
		playall60 "$dir"
	else
		playallN "$dir" $((18*60/3/numdrills))
	fi
done
echo "== done =="
