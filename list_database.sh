#! /bin/bash
clear
printf "+-------------+\n"
printf "|  Databases  |\n"
printf "+-------------+\n"
if [ $USER == "root" ]; then
	dbs="./*"
else
	dbs=$(find ./* -type d -perm -g+rs -o -user $USER 2>/dev/null)
fi
row=0
for db in $dbs; do
	if [ -d $db ]; then
		let "row = row + 1"
		printf "| %-10s  |\n" "$db"
		printf "| %-10s  |\n" ""
	fi
done
printf "+-------------+\n"
printf "%s rows in set (0.0 sec)" "$row"
read -n 1
