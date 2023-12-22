#! /bin/bash
clear
size_chars=10
pathdata="$1/$2"
pathstr="$1/.$2.str"
if [ $# -eq 2 -a -d $1 -a -f $pathdata -a -f $pathstr ]; then
	### this path for creating file structure
	f="0"
	num_cols=$(cat $pathstr | tail -1)
	aldata=""
	for ((i = 1; i <= $num_cols; i++)); do
		clear
		primkey=$(cat $pathstr | sed -n "$i p")
		dtyp=$(echo $primkey | cut -d, -f2)
		colnme=$(echo $primkey | cut -d, -f1)

		### the =~ operator is used for regular expression matching within a conditional expression
		read -e -n $size_chars -p "Enter $colnme : " data
		count=$(cat $pathdata | grep -c "^$data:")
		if [ $i -eq 1 -a $count -eq 1 ]; then
			echo ""
			echo "WARNING: the primary key found"
			echo ""
			break
		fi

		if [[ $dtyp == "int" && $data =~ ^[0-9]+$ ]]; then
			aldata="$aldata$data:"
			f="1"
		### -n checks if the length of the string is non-zero
		elif [[ $dtyp == "string" && -n $data ]]; then
			aldata="$aldata$data:"
			f="1"
		else
			exit
		fi

	done

	if [ $f == "1" ]; then
		echo $aldata >>$pathdata
		echo ""
		echo "Add it"
	fi
fi
read -n 1
