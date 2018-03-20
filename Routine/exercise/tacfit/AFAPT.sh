#!/bin/bash

dir="$1"
. ./functions

# Perform the given number of reps for each exercise as fast as possible, but no longer than 20 minutes total.  Go as slow as you can continue without taking any pauses, without stopping in between repetitions, and with very good technique.

$PLAYONCE resources/gong1.mp3 &
notify "One round of warmup" "Do each mobility drill once over 6 minutes."
playalloncefor "$dir"/00-warmup $((18*60/3))
$PLAYONCE resource/gong2.mp3 &

$STOPWATCH 20 "You will be exercising for no more than 20 minutes total, attempting to complete all repetitions of all exercises in as a short a time as possible."

for drill in "$dir"/01-*
do
	$PLAYONCE resources/gong1.mp3 &
	notify "$(basename "$(readlink $drill)")"
	playloopbg "$drill"
	playpid=$!
	sleep 1
	$STOPWATCH $((60*5-1)) "Count your reps for 5 minutes without exceeding the target.  Move on when you finish.  Do not stop or compromise on technique."
	$PLAYONCE resources/gong2.mp3 &
	kill $playpid
done

$PLAYONCE resources/gong1.mp3 &
$STOPWATCH 40 "Check the clock, then write your final heart rate, time elapsed, technique, effort, and discomfort."
notify "One round of cooldown" "Do each compensation drill once over 6 minutes."

playalloncefor "$dir"/02-cooldown $((18*60/3))
$PLAYONCE resource/gong2.mp3 &

echo '=== DONE ! ==='
echo 'Write your final heart rate'

$STOPWATCH 30 "Write your final heart rate"
