#! /bin/bash
clear
pathdata="$1/$2"
pathstr="$1/.$2.str"
if [ $# -eq 2 -a -d $1 -a -f $pathdata -a -f $pathstr ]; then

        primkey=$(cat $pathstr | head -1)
        colnme=$(echo $primkey | cut -d, -f1)

        read -e -p "Enter $colnme :  " prkey

        ### to count number of rows
        count=$(cat $pathdata | grep -c "^$prkey:")

        if [ $count -eq 1 ]; then

                read -e -n 1 -p "Are you sure delete  $colnme = $prkey Y|y :" cho

                if [ $cho == 'Y' -o $cho == 'y' ]; then
                        sed -i "/^$prkey/d" $pathdata
                        echo ""
                        echo "Delete it "
                        echo ""
                fi
        else
                echo ""
                echo "WARNING: The primary key not found "
                echo ""
        fi
fi
read -n 1
