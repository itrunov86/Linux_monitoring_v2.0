#!/bin/bash

start_time=$(date '+%d-%m-%Y %H:%M:%S')
start_seconds=$(date +%s)
LOG_FILE="${PWD}/creation_log_$(date '+%d%m%y').txt"

get_random_path() {
    local files_array
    mapfile -t files_array < <(ls / | grep -vE 'bin|sbin')

    local random_index=$((RANDOM % ${#files_array[@]}))
    local random_mount_point="${files_array[$random_index]}"

    echo "$random_mount_point"
}

function generate_name() {
	local CHARS="$1"
	local LEN=7
	local NAME="$1"

	for ((i = 0; i<$LEN; i++)); do
		NAME="${NAME}${CHARS:$((RANDOM % ${#CHARS})):1}"
	done

	echo "${NAME}"
}

function check_space() {
	local free_space_human
    free_space_human=$(df -h / | awk 'NR==2 {print $4}')
    free_space="${free_space_human//[G]}"
    #echo "Free space: $free_space"
    
    if [ $free_space == "1" ]; then
        echo "Less than 1GB of free space available. Exiting."
        exit 1
    fi
}

function create_folders_and_files() {
	
	local NUM_FOLDERS="$((RANDOM % 10 + 1))"
	local CHARS_FOLDERS="$1"

	local CHARS_FILES="$2"
	local SIZE_FILE_MB="$3"
    local BASENAME=$(basename "$CHARS_FILES")
    local NAME="${BASENAME%.*}"
    local EXTENSION="${BASENAME##*.}"
    local FILE_SIZE_WITHOUT_MB="${SIZE_FILE_MB//[a-zA-Z]/}"

	local DATE_SUFFIX=$(date '+%d%m%y')

	#local LOG_FILE="$4"


	for ((i=0; i<$NUM_FOLDERS; i++)); do
        local PATH_FOLDERS="$(get_random_path)"
        local FOLDER_NAME="$(generate_name "$CHARS_FOLDERS")_${DATE_SUFFIX}"
		
        local FOLDER_PATH="${PATH_FOLDERS}/${FOLDER_NAME}"
		mkdir -p "$FOLDER_PATH"

        local NUM_FILES="$((RANDOM % 10 + 1))"

		for ((j=0; j<$NUM_FILES; j++)); do

			check_space

			local FILE_NAME="$(generate_name "$NAME")_${DATE_SUFFIX}"

			local FILE_PATH="${FOLDER_PATH}/${FILE_NAME}".${EXTENSION}

			fallocate -l "${FILE_SIZE_WITHOUT_MB}K" "$FILE_PATH"
			echo "$(date '+%d-%m-%Y %H:%M:%S') | Created: ${FILE_PATH} | Size: ${FILE_SIZE_WITHOUT_MB}K" >> "$LOG_FILE"
		done		
	done
}


function main() {

	local CHARS_FOLDERS="$1"
	local CHARS_FILES="$2"
	local SIZE_FILE_MB="$3"
	
	
	
	create_folders_and_files "$CHARS_FOLDERS" "$CHARS_FILES" "$SIZE_FILE_MB" #"$LOG_FILE"
}

main $@

end_time=$(date '+%d-%m-%Y %H:%M:%S')
end_seconds=$(date +%s)
execution_time=$((end_seconds - start_seconds))

echo "Start time: $start_time" >> "$LOG_FILE"
echo "End time: $end_time" >> "$LOG_FILE"
echo "Total running time: ${execution_time} seconds" >> "$LOG_FILE"

echo "Start time: $start_time"
echo "End time: $end_time"
echo "Total running time: ${execution_time} seconds"