#!/bin/bash

# === Configuration ===
DEST_DIR="./flag_files"
FLAG="congrats!!"            # 10 characters
FILE_COUNT=10
NOISE_LENGTH=4000           # characters of random noise

# === Setup Directory ===
mkdir -p "$DEST_DIR"
rm -f "$DEST_DIR"/* 2>/dev/null

# === Generate Files with Embedded Fragments ===
for (( i=0; i<FILE_COUNT; i++ )); do
    FILENAME="$DEST_DIR/file_$i.txt"
    CHAR="${FLAG:$i:1}"
    FRAGMENT="FLAG_PART_$((i+1)){$CHAR}"
    
    # Generate random noise
    NOISE=$(tr -dc 'a-zA-Z0-9!@#$%^&*()_+=-' </dev/urandom | head -c "$NOISE_LENGTH")
    
    # Insert flag fragment at random position
    INSERT_POS=$((RANDOM % (NOISE_LENGTH - ${#FRAGMENT})))
    PREFIX="${NOISE:0:$INSERT_POS}"
    SUFFIX="${NOISE:$INSERT_POS}"
    
    # Write to file
    echo "${PREFIX}${FRAGMENT}${SUFFIX}" > "$FILENAME"
done

echo "[✓] Generated $FILE_COUNT files with embedded flag parts in $DEST_DIR"
