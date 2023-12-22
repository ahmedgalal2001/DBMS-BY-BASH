#! /bin/bash
### How to handle backspace while reading
### i have problem with read in linux when I backspace
### -e to enable bash's own line editor
clear
read -e -p 'Enter name Of database : ' name_db
if [ -d "$name_db.db" ]; then
	echo ""
	echo "WARNING: Database is existed"
	echo ""
else

	PS3="Choice Privacy : "
	select dty in "Private" "Public"; do
		case $REPLY in
		1)
			mkdir "$name_db.db"
			if [ -d "$name_db.db" ]; then
				chmod go-rwx "$name_db.db"
				echo "Database is created"
			fi
			break
			;;
		2)
			mkdir "$name_db.db"
			if [ -d "$name_db.db" ]; then
				chmod go-w "$name_db.db"
				echo "Database is created"
			fi
			break
			;;
		esac
	done
fi
read -n 1
