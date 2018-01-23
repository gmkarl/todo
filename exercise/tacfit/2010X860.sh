#!/bin/bash

dir="$1"
. ./functions

echo '=== 1 round of warmup =='
playall60 "$dir"/00-warmup

echo 'Warmup done, beginning workout in 20'
$STOPWATCH 20

for ex in "$dir"/01-*
do
	echo "=== 8 sets: $(readlink $ex) === "
	playloop "$ex" &
	playpid=$!
	for set in 1 2 3 4 5 6 7 8
	do
		echo "=== SET $set ==="
		echo "Exercise for 20 seconds"
		$STOPWATCH 20
		if (( set != 8 ))
		then
			kill -stop $playpid
			echo "Recover for 10 seconds; write your score"
			$STOPWATCH 10
			kill -cont $playpid
		fi
	done
	kill $playpid

	echo "== RECOVERY =="
	echo "Write down your last score, then your heart rate, then technique, effort, and discomfort"
	$STOPWATCH 60
done


echo '=== 1 round of cooldown ==='
playall60 "$dir"/02-cooldown

echo '=== DONE ! ==='
echo 'Write your final heart rate'
echo 'Sum your lowest set scores'
echo 'Average your other metrics'
