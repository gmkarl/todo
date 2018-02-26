#!/bin/bash
if [ "$2" != "" ]
then
	msg="$(echo "$2" | sed 's/\&/\&amp;/g')"
else
	msg="$1 seconds"
fi
date1=`date +%s`
while true
do 
	echo $((100 * ($(date +%s) - $date1) / $1))
	echo -ne "$(date -u --date @$((`date +%s` - date1)) +%H:%M:%S) $msg\r" 1>&2
	#sleep 0.1
done |
zenity --progress --auto-close --no-cancel --pulsate --text="$msg" 2>/dev/null #&
#sleep "$@"
#kill $!
echo "DONE! $@" 1>&2
