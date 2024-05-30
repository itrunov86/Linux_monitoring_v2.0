#!/bin/bash

function check() {
    if [[ $# -ne 6 ]]
    then
        echo "Please Enter 6 arguments"
        exit 1
    fi

    if [[ ! -d "$1" ]]
    then
        echo "No such file or directory: ${1}"
        exit 1
    fi

    if [[ ! $2 =~ ^[0-9]+$ ]]
    then
        echo "The second argument must be a number"
        exit 1
    fi

    if [[ ! $3 =~ ^[a-zA-Z]{1,7}$ ]]
    then
        echo "Third argument: Enter the letters of the English alphabet used in folder names"
        exit 1
    fi

    if [[ ! $4 =~ ^[0-9]+$ ]]
    then
        echo "Fourth argument must be a number"
        exit 1
    fi

    if [[ ! $5 =~ ^[a-zA-Z]{1,7}\.[a-zA-Z]{1,3}$ ]]
    then
        echo "Fifth argument: a list of letters of the English alphabet (no more than 7 characters for a name, no more than 3 characters for an extension)"
        exit 1
    fi

    if ! [[ "$6" =~ ^[1-9][0-9]*kb$ || "$1" == "100kb" ]]; then
        echo "Sixth argument: file size (in kilobytes, but not more than 100)"
        exit 1
    fi

}


