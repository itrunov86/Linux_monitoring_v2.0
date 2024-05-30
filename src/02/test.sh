#!/bin/bash

get_random_path() {
    local files_array
    mapfile -t files_array < <(ls / | grep -vE 'bin|sbin')

    local random_index=$((RANDOM % ${#files_array[@]}))
    local random_mount_point="${files_array[$random_index]}"

    echo "$random_mount_point"
}

#get_random_path

#while [ -d "${PATH_FOLDERS}/${FOLDER_NAME}" ]; do
				#FOLDER_NAME="$(generate_name "$CHARS_FOLDERS")_${DATE_SUFFIX}"
#done


#while [ -f "${FOLDER_PATH}/${FILE_NAME}.${EXTENSION}" ]; do
				#FILE_NAME="$(generate_name "$NAME")_${DATE_SUFFIX}"
#done

function check_space() {
	local free_space_human
    free_space_human=$(df -h / | awk 'NR==2 {print $4}')
    free_space="${free_space_human//[G]}"
    echo "Free space: $free_space"
    
    if [ $free_space == "1" ]; then
        echo "Less than 1GB of free space available. Exiting."
        exit 1
    fi
}

check_space