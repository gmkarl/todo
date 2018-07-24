#!/bin/bash

# store recorded times teeth brushed in morning
cut -d , -f 1,18 ../routine/2018-routine.csv | grep ....-..-..,1 > bt-routine.csv
# store recorded times teeth brushed in evening
cut -d , -f 1,54 ../routine/2018-routine.csv | grep ....-..-..,1 >> bt-routine.csv

# store recorded times nicotine taken
grep N2 ../meds/2018-meds.csv | tr T , | cut -d , -f 1,4 | grep ....-..-.., > n2-meds.csv

# remove nicotine times from routine times
cut -d , -f 1 n2-meds.csv | while read date
do
  grep -v "$date" bt-routine.csv > bt-routine-2.csv
  mv bt-routine-2.csv bt-routine.csv
done

# create list of toothbrush times
{
  cut -d , -f 1 bt-routine.csv
  cut -d , -f 1 n2-meds.csv
} | sort > bt.csv
rm bt-routine.csv

# make folders for separating data
for ((yr=2018; yr < $(date +%Y); yr ++))
do
	for ((wk=1; wk <=52; wk ++))
	do
		mkdir -p ${yr}-wk$(printf %02d $wk)
	done
done
curwk=$(date +%V)
curwk=${curwk#0}
for ((wk=1; wk < curwk; wk ++))
do
	mkdir -p $(date +%Y)-wk$(printf %02d $wk)
done

# accumulate toothbrushes/wk
cat bt.csv | while read day
do
  wk=$(date -d "$day" +%G-wk%V)
  mkdir -p "$wk"
  if ! [ -e "$wk"/brushes ]
  then
    a=1
  else
    a=$(($(<"$wk"/brushes) + 1))
  fi
  echo $((a)) > "$wk"/brushes
done
rm bt.csv

# accumulate n2/wk
tr , ' ' < n2-meds.csv | while read day n2
do
  wk=$(date -d "$day" +%G-wk%V)
  cn2=$(($(printf %0.2f "$n2" | sed 's/^0//g; s/\.//g')))
  mkdir -p "$wk"
  if ! [ -e "$wk"/n2ct ]
  then
    n2ct=1
    n2accum=$((cn2))
  else
    n2ct=$(($(<"$wk"/n2ct) + 1))
    n2accum=$(($(<"$wk"/n2accum) + cn2))
  fi
  echo $((n2ct)) > "$wk"/n2ct
  echo $((n2accum)) > "$wk"/n2accum
done
rm n2-meds.csv

# consolidate data
echo "Week" '"Recorded Brushes per Week"' '"2mg Nicotine Lozenge % per Brush"' > "Toothbrushing and Nicotine".data
for dir in 20*-*/
do
  label=${dir%/}
  if [ -e "$dir"n2ct ]
  then
    n2ct=$(($(<"$dir"n2ct)))
    n2accum=$(($(<"$dir"n2accum)))
    n2brush=$((n2accum/n2ct))
  else
    n2brush=0
  fi
  if [ -e "$dir"brushes ]
  then
    brushes=$(($(<"$dir"brushes)))
  else
    brushes=0
  fi
  rm -rf "$dir"
  echo "$label" $((brushes)) $((n2brush))
done | tee -a "Toothbrushing and Nicotine".data

cat <<EOF | gnuplot
set terminal 'png' size 1024, 512
set output 'Toothbrushing and Nicotine.png'
set key autotitle columnhead
set xtics rotate
set y2tics
plot 'Toothbrushing and Nicotine.data' using 0:2:xticlabels(1) with lines, \
  '' using 0:3 with lines axes x1y2
EOF
