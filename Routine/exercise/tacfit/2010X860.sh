#!/bin/bash

dir="$1"
. ./functions

$PLAYONCE resources/gong1.mp3 &
notify "One round of warmup" "Do each mobility drill once over 6 minutes."
playalloncefor "$dir"/00-warmup $((18*60/3))
$PLAYONCE resource/gong2.mp3 &

$STOPWATCH 20 'You will be doing 8 sets each of 6 exercises, exercising for 20 seconds and resting for 10'

for ex in "$dir"/01-*
do
	playloopbg "$ex"
	playpid=$!
	for set in 1 2 3 4 5 6 7 8
	do
		$PLAYONCE resources/gong1.mp3 &
		notify "$(basename "$(readlink $ex)") set $set"
		$STOPWATCH 20 "Exercise for 20 seconds."
		$PLAYONCE resources/gong2.mp3 &
		if (( set != 8 ))
		then
			kill -stop $playpid
			$STOPWATCH 10 "Recover for 10 seconds; write your score"
			$PLAYONCE resources/gong1.mp3 &
			kill -cont $playpid
		fi
	done
	kill $playpid

	$STOPWATCH 60 "Write down your last score, then your heart rate, then technique, effort, and discomfort"
done


$PLAYONCE resources/gong1.mp3 &
playalloncefor "$dir"/02-cooldown $((18*60/3))
$PLAYONCE resource/gong2.mp3 &

echo '=== DONE ! ==='
echo 'Write your final heart rate'
$STOPWATCH 30 'Write your final heart rate'
echo 'Sum your lowest set scores'
echo 'Average your other metrics'
