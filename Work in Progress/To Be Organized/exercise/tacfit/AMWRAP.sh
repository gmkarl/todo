#!/bin/bash

dir="$1"
. ./functions

# Complete the circuit as many times as possible in 20 minutes.

$PLAYONCE resources/gong1.mp3 &
notify "One round of warmup" "Do each mobility drill once over 6 minutes."
playalloncefor "$dir"/00-warmup $((18*60/3))
$PLAYONCE resource/gong2.mp3 &

playloopbg "$dir"/01-*
playpid=$!

$STOPWATCH 20 "Workout will be 20 minutes with no pauses."

$PLAYONCE resources/gong1.mp3 &
$STOPWATCH $((60*20)) "Perform as many rounds as possible in twenty minutes.  Go as slow as you can continue without taking any pauses, without stopping in between repetitions, and with very good technique."

kill $playpid
$PLAYONCE resource/gong2.mp3 &

$STOPWATCH 60 "Write your final heart rate, then your technique, effort, and discomfort."

$PLAYONCE resources/gong1.mp3 &
notify "One round of cooldown" "Do each compensation drill once over 6 minutes."
playalloncefor "$dir"/02-cooldown $((18*60/3))
$PLAYONCE resource/gong2.mp3 &

echo '=== DONE ! ==='
echo 'Write your final heart rate and your total number of rounds'

$STOPWATCH 30 "Write your final heart rate, then tally your totals."
