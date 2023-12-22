#! /bin/bash

function display_menu() {
	local name_db=$1
	local name_tb=$2

	printf "+------------+------------+------------+\n"
	printf "|  Database  |    Table   |    Owner   |\n"
	printf "+------------+------------+------------+\n"
	printf "| %-10s | %-10s | %-10s |\n" "$name_db" "$name_tb" "$(stat -c "%U" "$name_db"/$name_tb)"
	printf "+------------+------------+------------+\n"

	echo "+-----------------------+"
	echo "|         MENU          |"
	echo "+-----------------------+"
	echo "| 1.Insert Table        |"
	echo "| 2.Select From Table   |"
	echo "| 3.Delete Row          |"
	echo "| 4.Update Table        |"
	echo "| 5.Exit                |"
	echo "+-----------------------+"
}

function choices() {
	tput cnorm
	local cho=$1
	local start=$2
	local name_db=$3
	local name_tb=$4

	case $cho in
	$((start)))
		if [ -f ./insert_table.sh ]; then
			bash ./insert_table.sh $name_db $name_tb
		fi
		;;
	$((start + 1)))
		if [ -f ./select_table.sh ]; then
			bash ./select_table.sh $name_db $name_tb
		fi
		;;
	$((start + 2)))
		if [ -f ./delete_table.sh ]; then
			bash ./delete_table.sh $name_db $name_tb
		fi
		;;
	$((start + 3)))
		if [ -f ./update_table.sh ]; then
			bash ./update_table.sh $name_db $name_tb
		fi
		;;
	$((start + 4)))
		clear
		exit
		;;
	esac
}

function gotoxy() {
	local row=$1
	local col=$2
	tput cup "$row" "$col"
}

function build_arrow() {
	# Hide cursor (stop blinking)
	tput civis
	local alrowdo=$(($1 - 1))
	local alrowup=$(($1 + 1))
	local alcol=$(($2 - 1))
	if [ $alrowdo -ge $min ]; then
		gotoxy $alrowdo $alcol
		echo " "
	fi
	if [ $alrowup -le $max ]; then
		gotoxy $alrowup $alcol
		echo " "
	fi
	gotoxy $row $alcol
	echo "▶"
	gotoxy $1 $2
}

clear
row=8
col=2
max=$((row + 4))
min=$row
if [ $# -eq 1 -a -d "$1.db" ]; then
	read -e -n 10 -p "Enter name table : " name_tb
	if [ -f "$1.db/$name_tb" -a -f "$1.db/.$name_tb.str" ]; then
		name_db="$1.db"
		while true; do
			clear
			display_menu "$name_db" "$name_tb"
			build_arrow "$row" "$col"

			while true; do
				read -n 1 -s cha
				if [ "$cha" == '[' ]; then
					read -n 1 -s cha
					# UP
					if [ "$cha" == 'A' ] && [ "$row" -gt "$min" ]; then
						((row--))
					fi
					# DOWN
					if [ "$cha" == 'B' ] && [ "$row" -lt "$max" ]; then
						((row++))
					fi
					build_arrow "$row" "$col"
				fi
				if [ -z "$cha" ]; then
					choices "$row" "$min" "$name_db" "$name_tb"
					break
				fi
			done
		done
	else
		echo ""
		echo "WARNING: the table not found "
		echo ""
	fi
fi
read -n 1
