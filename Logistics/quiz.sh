#!/bin/bash

file="00-Organizer.txt"
needed=7
pat='^I*[0-9]\.* '
tmp=$(mktemp)
echo 0  > "$tmp"
echo 0 >> "$tmp"
while (( $(<"$tmp") < "$needed" ))
do
	grep "$pat"  "$file" | sort -R | head -n 1 |
	{
		read prefix descr
		echo "$file '$prefix': what's the rest?"
		read rest < /dev/tty
		read correct total < "$tmp"
		total=$((total + 1))
		if [ "$rest" = "$descr" ]
		then
			echo "Exactly!  Well done!"
			correct=$((correct + 1))
		else
			echo "Not quite right ... it was:"
			echo "$descr"
			echo "enter to continue"
			read < /dev/tty
			clear
		fi
		echo "$correct" > "$tmp"
		echo "$total" > "$tmp"
	}
done
read correct total < "$tmp"
echo "$(( correct * 100 / total))% !"
rm "$tmp"
