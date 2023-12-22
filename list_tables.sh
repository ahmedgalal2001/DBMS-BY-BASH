#! /bin/bash
clear
if [ $# -eq 1 -a -d "$1.db" ]; then
	row=0
	path=$(ls "$1.db")
	printf "+-------------+\n"
	printf "|    Tables   |\n"
	printf "+-------------+\n"
	for file in $path; do
		let "row = row + 1"
		data=$(echo "$file" | cut -d"/" -f2)
		printf "| %-11s |\n" "$row.$data"
		printf "| %-11s |\n" ""
	done
	if [ ! $row -eq 0 ]; then
		printf "+-------------+\n"
	fi
	printf "%s rows in set (0.0 sec)" "$row"
fi
read -n 1
