#! /bin/bash
function display_menu() {
	local name_db=$1

	printf "+------------+------------+\n"
	printf "|  Database  |    Owner   |\n"
	printf "+------------+------------+\n"
	printf "| %-10s | %-10s |\n" "$name_db" "$(stat -c "%U" "$name_db.db")"
	printf "+------------+------------+\n"

	echo "+-----------------------+"
	echo "|         MENU          |"
	echo "+-----------------------+"
	echo "| 1.Create Table        |"
	echo "| 2.List Tables         |"
	echo "| 3.Drop Table          |"
	echo "| 4.Operation On Table  |"
	echo "| 5.Exit                |"
	echo "+-----------------------+"
}

function choices() {
	tput cnorm
	local cho=$1
	local start=$2
	local name_db=$3
	case $cho in
	$((start)))
		if [ -f ./creat_table.sh ]; then
			bash ./creat_table.sh $name_db
		fi
		;;
	$((start + 1)))
		if [ -f ./list_tables.sh ]; then
			bash ./list_tables.sh $name_db
		fi
		;;
	$((start + 2)))
		if [ -f ./drop_tabel.sh ]; then
			bash ./drop_tabel.sh $name_db
		fi
		;;
	$((start + 3)))
		if [ -f ./operat_table.sh ]; then
			bash ./operat_table.sh $name_db
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
read -e -n 10 -p "Enter name of database : " name_db
if [ -d "$name_db.db" ]; then
	prem=$(stat -c "%a" "$name_db.db")
	owner=$(stat -c "%U" "$name_db.db")
	if [ $prem == "2700" -a $owner != "$USER" -a "$USER" != "root" ]; then
		echo ""
		echo "WARNING: Can't connect this database because it is private"
		echo ""
	else
		while true; do
			clear
			display_menu "$name_db"
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
					choices "$row" "$min" "$name_db"
					break
				fi
			done
		done
	fi
else
	echo ""
	echo "WARNING: Database not found"
	echo ""
fi
read -n 1
