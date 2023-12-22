#! /bin/bash
function display_menu() {
	clear
	local columns=$(tput cols)
	local y=$(((columns - 34) / 2))

	printf "%-${y}s""+--------------------------------+\n"
	printf "%-${y}s|""                                |\n"
	printf "%-${y}s|"" D#####  B#####  M#####  SSSSS  |\n"
	printf "%-${y}s|"" D    ## B     ## M    ## S     |\n"
	printf "%-${y}s|"" D     ##B     ## M     ##SSSSS |\n"
	printf "%-${y}s|"" D    ## B     ## M    ## S     |\n"
	printf "%-${y}s|"" D#####  B#####  M#####  SSSSS  |\n"
	printf "%-${y}s|""                                |\n"
	printf "%-${y}s""+--------------------------------+\n"

	echo "+-----------------------+"
	echo "|         MENU          |"
	echo "+-----------------------+"
	echo "| 1.Creat Database      |"
	echo "| 2.List Databases      |"
	echo "| 3.Connect to Database |"
	echo "| 4.Drop Database       |"
	echo "| 5.Exit                |"
	echo "+-----------------------+"
}

function choices() {
	tput cnorm
	local cho=$1
	local start=$2
	case $cho in
	$((start)))
		if [ -f ./create_database.sh ]; then
			bash ./create_database.sh
		fi
		;;
	$((start + 1)))
		if [ -f ./list_database.sh ]; then
			bash ./list_database.sh
			echo "ddd"
		fi
		;;
	$((start + 2)))
		if [ -f ./connect_database.sh ]; then
			bash ./connect_database.sh
		fi
		;;
	$((start + 3)))
		if [ -f ./drop_database.sh ]; then
			bash ./drop_database.sh
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
row=12
col=2
max=$((row + 4))
min=$row
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
