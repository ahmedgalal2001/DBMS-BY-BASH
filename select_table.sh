#! /bin/bash
clear
pathdata="$1/$2"
pathstr="$1/.$2.str"
row=0
if [ $# -eq 2 -a -d $1 -a -f $pathdata -a -f $pathstr ]; then
	primkey=$(cat $pathstr | head -1)
	colnme=$(echo $primkey | cut -d, -f1)
	num_cols=$(cat $pathstr | tail -1)
	PS3="Select Your Choice : "
	select choice in "Select By Primary Key" "Show All Data" "Show Structure Table"; do
		case $REPLY in

		1)
			clear
			read -e -p "Enter $colnme :  " prkey
			count=$(cat $pathdata | grep -c "^$prkey:")
			if [ $count -eq 1 ]; then
				clear

				data=$(cat $pathdata | grep "^$prkey:")
				#header

				for ((i = 1; i <= $num_cols; i++)); do
					echo -n "+------------"
				done
				printf "+\n"
				for ((i = 1; i <= $num_cols; i++)); do
					colnme=$(cat $pathstr | sed -n "$i p" | cut -d, -f1)
					printf "| %-10s " "$colnme"
				done
				printf "|\n"
				for ((i = 1; i <= $num_cols; i++)); do
					echo -n "+------------"
				done
				printf "+\n"
				for ((i = 1; i <= $num_cols; i++)); do
					colnme=$(echo $data | cut -d: -f"$i")
					printf "| %-10s " "$colnme"
				done
				printf "|\n"
				for ((i = 1; i <= $num_cols; i++)); do
					echo -n "+------------"
				done
				printf "+\n"
				printf "%s row in set (0.0 sec)" "1"
				#header
			else
				echo ""
				echo "WARNING: The primary key not found "
				echo ""
			fi
			break
			;;
		2)
			clear
			for ((i = 1; i <= $num_cols; i++)); do
				echo -n "+------------"
			done
			printf "+\n"
			for ((i = 1; i <= $num_cols; i++)); do
				colnme=$(cat $pathstr | sed -n "$i p" | cut -d, -f1)
				printf "| %-10s " "$colnme"
			done
			printf "|\n"
			for ((i = 1; i <= $num_cols; i++)); do
				echo -n "+------------"
			done
			printf "+\n"
			while read -r line; do
				for ((i = 1; i <= $num_cols; i++)); do
					colnme=$(echo $line | cut -d: -f"$i")
					printf "| %-10s " "$colnme"
				done
				((row++))
				printf "|\n"
			done <"$pathdata"

			for ((i = 1; i <= $num_cols; i++)); do
				echo -n "+------------"
			done
			printf "+\n"
			printf "%s rows in set (0.0 sec)" "$row"
			break
			;;
		3)
			clear
			printf "+------------+------------+\n"
			printf "| Table Name |  Datatype  |\n"
			printf "+------------+------------+\n"
			#
			for ((i = 1; i <= $num_cols; i++)); do
				primkey=$(cat $pathstr | sed -n "$i p")
				dtyp=$(echo $primkey | cut -d, -f2)
				colnme=$(echo $primkey | cut -d, -f1)
				printf "| %-10s | %-10s |\n" "$colnme" "$dtyp"
			done
			printf "+------------+------------+\n"
			printf "%s cols in set (0.0 sec)" "$num_cols"
			break
			;;
		esac
	done
fi
read -n 1
