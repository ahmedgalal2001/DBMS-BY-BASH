#! /bin/bash
clear
read -e -n 12 -p "Enter the database name : " name_db
if [ -d "$name_db.db" ]; then
	read -e -n 1 -p "Are you sure delete this database $name_db.db Y|y : " cho
	if [ $cho == 'Y' -o $cho == 'y' ]; then
		rm -r -f $name_db.db
		echo ""
		echo "Delete it"
		echo ""
	else
		exit
	fi
else
	echo ""
	echo "WARNING: Not found it "
	echo ""
fi
read -n 1
