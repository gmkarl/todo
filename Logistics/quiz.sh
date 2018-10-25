#!/bin/bash

file="Current_Concerns.txt"
needed=2
pat='^[0-9]\.'
tmp=$(mktemp)
echo 0  > "$tmp"
while (( $(<"$tmp") < "$needed" ))
do
	grep "$pat"  "$file" | sort -R | head -n 1 |
	{
		read prefix descr
		echo "$file '$prefix': what's the rest?"
		read rest < /dev/tty
		if [ "$rest" = "$descr" ]
		then
			echo "Exactly!  Well done!"
			correct=$(( $(<"$tmp") + 1))
			echo "$correct" > "$tmp"
		else
			echo "Not quite right ... it was:"
			echo "$descr"
			echo "enter to continue"
			read < /dev/tty
			clear
		fi
	}
done
rm "$tmp"
