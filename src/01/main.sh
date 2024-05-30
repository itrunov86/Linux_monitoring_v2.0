#!/bin/bash

source ./check.sh

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
	local FREE_SPACE=$(df --output=avail / | tail -1)
	local MIN_SPACE=$((1024 * 1024))

	if [[ $FREE_SPACE -lt $MIN_SPACE ]]; then
		echo "Less than 1GB of free space available. Exiting."
		exit 1
	fi
}

function create_folders_and_files() {
	local PATH_FOLDERS="$1"
	local NUM_FOLDERS="$2"
	local CHARS_FOLDERS="$3"
	local NUM_FILES="$4"
	local CHARS_FILES="$5"
	local SIZE_FILE_KB="$6"
	local LOG_FILE="$7"
    local BASENAME=$(basename "$CHARS_FILES")
    local NAME="${BASENAME%.*}"
    local EXTENSION="${BASENAME##*.}"
    local FILE_SIZE_WITHOUT_KB="${SIZE_FILE_KB//[a-zA-Z]/}"
	local DATE_SUFFIX=$(date '+%d%m%y')

	for ((i=0; i<$NUM_FOLDERS; i++)); do
        local FOLDER_NAME="$(generate_name "$CHARS_FOLDERS")_${DATE_SUFFIX}"
		
		while [ -d "${FOLDER_NAME}" ]; do
				FOLDER_NAME="$(generate_name "$CHARS_FOLDERS")_${DATE_SUFFIX}"
		done

        local FOLDER_PATH="${PATH_FOLDERS}/${FOLDER_NAME}"
		mkdir -p "$FOLDER_PATH"

		for ((j=0; j<$NUM_FILES; j++)); do
			check_space

			local FILE_NAME="$(generate_name "$NAME")_${DATE_SUFFIX}"

			while [ -f "${FILE_NAME}" ]; do
				FILE_NAME="$(generate_name "$NAME")_${DATE_SUFFIX}"
			done

			local FILE_PATH="${FOLDER_PATH}/${FILE_NAME}".${EXTENSION}

			fallocate -l "${FILE_SIZE_WITHOUT_KB}K" "$FILE_PATH"
			echo "$(date '+%Y-%m-%d %H:%M:%S') | Created: ${FILE_PATH} | Size: ${FILE_SIZE_WITHOUT_KB}K" >> "$LOG_FILE"
		done		
	done
}


function main() {
	
    check $@

	local PATH_FOLDERS="$1"
	local NUM_FOLDERS="$2"
	local CHARS_FOLDERS="$3"
	local NUM_FILES="$4"
	local CHARS_FILES="$5"
	local SIZE_FILE_KB="$6"
	
	
	local LOG_FILE="${PATH_FOLDERS}/creation_log_$(date '+%d%m%y').txt"
	create_folders_and_files "$PATH_FOLDERS" "$NUM_FOLDERS" "$CHARS_FOLDERS" "$NUM_FILES" "$CHARS_FILES" "$SIZE_FILE_KB" "$LOG_FILE"
}

main $@
