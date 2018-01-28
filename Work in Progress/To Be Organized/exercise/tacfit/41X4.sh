#!/bin/bash

dir="$1"
. ./functions

notify "One round of warmup" "Do each mobility drill once over 6 minutes."
# playalloncefor "$dir"/00-warmup $((18*60/3))

notify "4/1X4 Workout" "You will perform each exercise for one round 4 minutes in duration, and take 1 minute recovery in between each exercise.  Pace and regress as necessary to perform without stopping."

# $STOPWATCH 20 "Workout starting in 20."

for drill in "$dir"/01-*
do
	notify "$(basename "$(readlink $drill)")"
	playloopbg "$drill"
	playpid=$!
	sleep 1
	$STOPWATCH $((4*60-1)) "Exercise for 4 minutes without pausing & with excellent technique."
	kill $playpid
	$STOPWATCH 60 "Recover for 1 minute: score your repetitions, and record your heart rate, technique, effort, and discomfort."
done

notify "One round of cooldown" "Do each compensation drill once over 6 minutes."
playalloncefor "$dir"/02-cooldown $((18*60/3))

echo '=== DONE ! ==='
echo 'Write your final heart rate'
echo 'Average all your metrics'
