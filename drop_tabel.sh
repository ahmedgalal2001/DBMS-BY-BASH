#! /bin/bash
clear
if [ $# -eq 1 -a -d "$1.db" ]; then
	read -e -n 10 -p "Enter name table : " name_tb
	pathdata="$1.db/$name_tb"
	pathstr="$1.db/.$name_tb.str"
	if [ -f $pathdata -a -f $pathstr ]; then
		read -e -n 1 -p "Are you sure delete this file  $name_tb Y|y :" cho
		if [ $cho == 'Y' -o $cho == 'y' ]; then
			rm -r -f $pathdata
			rm -r -f $pathstr
			echo ""
			echo "Delete it"
			echo ""
		fi
	else
		echo ""
		echo "WARNING: The table not found "
		echo ""
	fi
fi
read -n 1
