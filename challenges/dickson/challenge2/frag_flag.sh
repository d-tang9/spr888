#!/bin/bash

DEST_DIR="/home/dtang/Desktop/spr888/challenges/dickson/challenge2/files"
TOTAL_FILES=100
FLAG_PARTS=10
FULL_FLAG="congrats!!"
RANDOM_CHARS=4000

mkdir -p "$DEST_DIR"
rm -f "$DEST_DIR"/* 2>/dev/null

# === Generate Random Files ===
used_indices=()
while [ ${#used_indices[@]} -lt $FLAG_PARTS ]; do
    index=$((RANDOM % TOTAL_FILES))
    if [[ ! " ${used_indices[*]} " =~ " $index " ]]; then
        used_indices+=($index)
    fi
done

for (( i=0; i<$TOTAL_FILES; i++ )); do
    FILENAME="$DEST_DIR/file_$i.txt"
    NOISE=$(tr -dc 'a-zA-Z0-9!@#$%^&*()-_=+{}[]:;<>,.?/' </dev/urandom | head -c $RANDOM_CHARS)

    # Check if this file should have a flag part
    if [[ " ${used_indices[*]} " =~ " $i " ]]; then
        part_num=${#used_indices[@]}
        part_index=$(echo ${used_indices[@]} | grep -bo "\b$i\b" | cut -d: -f1)
        CHAR="${FULL_FLAG:$part_index:1}"
        FRAGMENT="FLAG_PART_$((part_index+1)){$CHAR}"

        # Insert flag at a random location
        insert_pos=$((RANDOM % (RANDOM_CHARS - 20)))
        FILE_CONTENT="${NOISE:0:$insert_pos}$FRAGMENT${NOISE:$insert_pos}"
    else
        FILE_CONTENT="$NOISE"
    fi

    echo "$FILE_CONTENT" > "$FILENAME"
done

echo "[✓] Generated $TOTAL_FILES files with $FLAG_PARTS hidden flag parts in $DEST_DIR"
