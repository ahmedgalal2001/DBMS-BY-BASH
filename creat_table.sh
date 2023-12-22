#! /bin/bash
clear
size_chars=10
if [ $# -eq 1 -a -d "$1.db" ]; then
	read -e -n $size_chars -p "Enter name of table : " name_tb
	### this path for creating file structure
	pathdata="$1.db/$name_tb"
	pathstr="$1.db/.$name_tb.str"
	if [ ! -f $pathdata -a ! -f $pathstr ]; then

		read -e -n $size_chars -p "Enter number of columns :  " num_cols
		clear
		if [ $num_cols -le 5 ]; then
			for ((i = 1; i <= $num_cols; i++)); do
				if [ $i -eq 1 ]; then
					echo -n "Enter name of primary key : "
				else
					echo -n "Enter name of column $i : "
				fi

				read -e -n $size_chars name_col

				PS3="Choice datatype : "
				select dty in "Int" "String"; do
					case $REPLY in
					1)
						echo "$name_col,int" >>$pathstr
						break
						;;
					2)
						echo "$name_col,string" >>$pathstr
						break
						;;
					esac
				done
			done
			touch $pathdata
			if [ -f $pathdata -a -f $pathstr ]; then
				echo $num_cols >>$pathstr
				echo ""
				echo "Table is created"
				echo ""
			fi
		else
			echo ""
			echo "WARNING: Can't create table "
			echo ""
		fi
	else
		echo ""
		echo "WARNING: table found it "
		echo ""
	fi

fi
read -n 1
