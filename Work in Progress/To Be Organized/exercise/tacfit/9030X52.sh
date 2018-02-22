#!/bin/bash

dir="$1"
. ./functions

# 5 exercises: perform each for 90 seconds followed by 30 seconds recoery.  Then do them all a second time.

$PLAYONCE resources/gong1.mp3 &
notify "One round of warmup" "Do each mobility drill once over 6 minutes."
playalloncefor "$dir"/00-warmup $((18*60/3))
$PLAYONCE resource/gong2.mp3 &

$STOPWATCH 20 "You will perform 90 seconds of each of five exercises twice, and only take your lowest score for each pair."

for drill in "$dir"/01-*
do
	$PLAYONCE resources/gong1.mp3 &
	notify "$(basename "$(readlink $drill)")"
	playloopbg "$drill"
	playpid=$!
	sleep 1
	$STOPWATCH 89 "Count your reps for 90 seconds."
	$PLAYONCE resources/gong2.mp3 &
	kill $playpid
	$STOPWATCH 30 "Recover for 30 seconds: score your repetitions and heart rate, then technique, effort, and discomfort."
done
# after the final cool-down, totals are tallied: 5 lowest reps taken, and all other items averaged among all 10

$PLAYONCE resources/gong1.mp3 &
notify "One round of cooldown" "Do each compensation drill once over 6 minutes."
playalloncefor "$dir"/02-cooldown $((18*60/3))
$PLAYONCE resource/gong2.mp3 &

echo '=== DONE ! ==='
echo 'Write your final heart rate, take your lowest 5 reps, and average everything else'

$STOPWATCH 30 "Write your final heart rate, take your lowest 5 reps, and average everything else."
