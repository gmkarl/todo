#!/bin/bash

dir="$1"
. ./functions

# Twenty total, 1 minute rounds.  Begin over each new minute.  Perform the circuit of exercises in less than a minute.
# Complete all in time and get one point.  If you don't, then you receive no point.

$PLAYONCE resources/gong1.mp3 &
notify "One round of warmup" "Do each mobility drill once over 6 minutes."
playalloncefor "$dir"/00-warmup $((18*60/3))
$PLAYONCE resource/gong2.mp3 &

playloopbg "$dir"/01-*
playpid=$!

$STOPWATCH 20 "You will perform one circuit of all the repetitions of all the exercises in less than one minute for each point.  Restart from the beginning if you cannot finish in time."

for circuit in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20
do
	$PLAYONCE resources/gong1.mp3 &
	$STOPWATCH 60 "Start at the first exercise and do a complete circuit in less than a minute."
done
kill $playpid
$PLAYONCE resource/gong2.mp3 &

 
# for drill in "$dir"/01-*
# do
# 	notify "$(basename "$(readlink $drill)")"
# 	playloopbg "$drill"
# 	playpid=$!
# 	sleep 1
# 	$STOPWATCH $((4*60-1)) "Exercise for 4 minutes without pausing & with excellent technique."
# 	kill $playpid
# 	$STOPWATCH 60 "Recover for 1 minute: score your repetitions, and record your heart rate, technique, effort, and discomfort."
# done

$STOPWATCH 60 "Write your final heart rate, then your technique, effort, and discomfort."

$PLAYONCE resources/gong1.mp3 &
notify "One round of cooldown" "Do each compensation drill once over 6 minutes."
playalloncefor "$dir"/02-cooldown $((18*60/3))
$PLAYONCE resource/gong2.mp3 &

echo '=== DONE ! ==='
echo 'Write your final heart rate'
echo 'Average all your metrics'

$STOPWATCH 30 "Write your final heart rate, then tally your totals."
