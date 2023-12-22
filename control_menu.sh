#!/bin/bash
function gotoxy() {
    local row=$1
    local col=$2
    tput cup "$row" "$col"
}

function build_arrow() {
    # Hide cursor
    tput civis

    local alrowdo=$(($1 - 1))
    local alrowup=$(($1 + 1))
    local alcol=$(($2 - 1))
    local min=$3
    local max=$4

    # Clear space below the arrow if within bounds
    if [ $alrowdo -ge $min ]; then
        gotoxy $alrowdo $alcol
        echo " "
    fi

    # Clear space above the arrow if within bounds
    if [ $alrowup -le $max ]; then
        gotoxy $alrowup $alcol
        echo " "
    fi

    # Draw the arrow
    gotoxy $1 $2
    echo "▶"

    # Show cursor again
    tput cnorm
}

# Example usage
build_arrow "$1" "$2" "$3" "$4"
