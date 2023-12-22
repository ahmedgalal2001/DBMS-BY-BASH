#! /bin/bash
clear
size_chars=10
pathdata="$1/$2"
pathstr="$1/.$2.str"
pathtem="$1/.$2.tem"
if [ $# -eq 2 -a -d $1 -a -f $pathdata -a -f $pathstr ]; then
	colnme=$(cat $pathstr | head -1 | cut -d, -f1)
	num_cols=$(cat $pathstr | tail -1)

	read -e -n $size_chars -p "Enter $colnme : " data
	count=$(cat $pathdata | grep -c "^$data:")
	ln_num=$(cat $pathdata | grep -n "^$data:" | cut -d: -f1)

	if [ $count -eq 1 ]; then
		clear
		echo ""
		for ((i = 2; i <= $num_cols; i++)); do
			primkey=$(cat $pathstr | sed -n "$i p")
			dtyp=$(echo $primkey | cut -d, -f2)
			colnme=$(echo $primkey | cut -d, -f1)

			### the =~ operator is used for regular expression matching within a conditional expression
			read -e -n $size_chars -p "Enter $colnme : " data

			if [ $dtyp == "int" ]; then
				if [[ $data =~ ^[0-9]+$ ]]; then
					### FS Field Separator   OFS Output Field Separator
					### NR is line Number
					awk -v ln_num="$ln_num" -v data="$data" -v i="$i" 'BEGIN{FS=OFS=":"} NR==ln_num {$i=data}1' $pathdata >$pathtem
					mv -f $pathtem $pathdata
				fi
			elif [ $dtyp == "string" ]; then
				### -n checks if the length of the string is non-zero
				### Checks if the string does not consist only of whitespace.
				if [[ -n "$data" ]] && [[ ! "$data" =~ ^[[:space:]]*$ ]]; then
					awk -v ln_num="$ln_num" -v data="$data" -v i="$i" 'BEGIN{FS=OFS=":"} NR==ln_num {$i=data}1' $pathdata >$pathtem
					mv -f $pathtem $pathdata
				fi

			else
				exit
			fi

		done
		echo ""
		echo "Update it"
		echo ""
	else
		echo ""
		echo "WARNING: the primary key not found"
		echo ""
	fi
fi
read -n 1
