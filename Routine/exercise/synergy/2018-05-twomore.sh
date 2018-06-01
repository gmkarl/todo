#!/bin/bash

. ../tacfit/functions


$STOPWATCH 10 "You will find 3 tight spots in each quadrant of your butt and lower back, and roll your hips to the side to press a lacrosse ball into them for 10 seconds each."

for spot in 1 2 3 4 5 6 7 8 9 10 11 12
do
	$PLAYONCE ../tacfit/resources/gong1.mp3 &
	$STOPWATCH 14 "Press a new tight spot into the lacrosse ball."
done
$PLAYONCE ../tacfit/resources/gong2.mp3 &

$STOPWATCH 10 "You will spend 1 minute stretching each ham string with a lacrosse ball and a 1 minute stretching each thigh muscle with a rolling pin."
$PLAYONCE ../tacfit/resources/gong1.mp3 &
$STOPWATCH 60 "Roll your leg on top of a lacrosse ball."
$PLAYONCE ../tacfit/resources/gong1.mp3 &
$STOPWATCH 60 "Roll your other leg on top of a lacrosse ball."
$PLAYONCE ../tacfit/resources/gong1.mp3 &
$STOPWATCH 60 "Roll out the tight spots in one thigh."
$PLAYONCE ../tacfit/resources/gong1.mp3 &
$STOPWATCH 60 "Roll out the tight spots in the other thigh."
$PLAYONCE ../tacfit/resources/gong1.mp3 &

$STOPWATCH $((60*5)) "Lay on a blanket roll in a snow angel pose to stretch the pecs."
$PLAYONCE ../tacfit/resources/gong2.mp3 &

$STOPWATCH 10 "3 rounds of 30 second exercises coming up."

for rep in 1 2 3
do
	$PLAYONCE ../tacfit/resources/gong1.mp3 &
	$STOPWATCH 35 "Open your legs in a clamshell against the theraband 10 times"
	$PLAYONCE ../tacfit/resources/gong1.mp3 &
	$STOPWATCH 35 "Squueze your glutes in a bridge raised 10 times"
	$PLAYONCE ../tacfit/resources/gong1.mp3 &
	$STOPWATCH 35 "On your back, pull the theraband to the sides 10 times"
	$PLAYONCE ../tacfit/resources/gong1.mp3 &
	$STOPWATCH 35 "Use a belt or rope to stretch one ham string."
	$PLAYONCE ../tacfit/resources/gong1.mp3 &
	$STOPWATCH 35 "Use a belt or rope to stretch the other ham string."
	$PLAYONCE ../tacfit/resources/gong1.mp3 &
	$STOPWATCH 35 "Use the butterfly position to stretch the extreme of your groin."
	$PLAYONCE ../tacfit/resources/gong1.mp3 &
	$STOPWATCH 35 "One one knee, push hips forward and sit up tall"
	$PLAYONCE ../tacfit/resources/gong1.mp3 &
	$STOPWATCH 35 "On the other knee, push hips forward and sit up tall"
done
$PLAYONCE ../tacfit/resources/gong2.mp3 &

