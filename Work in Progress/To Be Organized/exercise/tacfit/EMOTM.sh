#!/bin/bash

dir="$1"
. ./functions

# Twenty total, 1 minute rounds.  Begin over each new minute.  Perform the circuit of exercises in less than a minute.
# Complete all in time and get one point.  If you don't, then you receive no point.

notify "One round of warmup" "Do each mobility drill once over 6 minutes."
playalloncefor "$dir"/00-warmup $((18*60/3))

notify "EMOTM Workout" "You will perform one circuit of all the repetitions of all the exercises in less than one minute for each point.  Restart from the beginning if you cannot finish in time."

# $STOPWATCH 20 "Workout starting in 20."
# 
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

notify "One round of cooldown" "Do each compensation drill once over 6 minutes."
playalloncefor "$dir"/02-cooldown $((18*60/3))

echo '=== DONE ! ==='
echo 'Write your final heart rate'
echo 'Average all your metrics'

$STOPWATCH 30 "Write your final heart rate, then tally your totals."
