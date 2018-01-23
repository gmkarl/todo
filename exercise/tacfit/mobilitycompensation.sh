#!/bin/bash

dir="$1"
. ./functions

for round in 1 2 3
do
	echo "== 6 minutes of drills, round $round / 3 =="
	playalloncefor "$dir" $((18*60/3))
done
echo "== done =="
