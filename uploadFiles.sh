#!/bin/bash

set -e

# sanity checks
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <ACCESS_TOKEN> <LOCAL_DIRECTORY> <DROPBOX_FOLDER>"
    exit 1
fi

ACCESS_TOKEN="$1"
LOCAL_DIRECTORY="$2"
DROPBOX_FOLDER="$3"

if [ ! -d "$LOCAL_DIRECTORY" ]; then
    echo "Error: Directory '$LOCAL_DIRECTORY' not found!"
    exit 1
fi

# upload logic
upload_file() {
    local file_path="$1"
    local dropbox_path="$DROPBOX_FOLDER/${file_path#$LOCAL_DIRECTORY}"
    dropbox_path=$(echo "$dropbox_path" | sed 's/ /%20/g')

    echo "Uploading: $file_path → $dropbox_path"

    curl -X POST https://content.dropboxapi.com/2/files/upload \
        --header "Authorization: Bearer $ACCESS_TOKEN" \
        --header "Dropbox-API-Arg: {\"path\": \"$dropbox_path\", \"mode\": \"overwrite\"}" \
        --header "Content-Type: application/octet-stream" \
        --data-binary @"$file_path"
}

find "$LOCAL_DIRECTORY" -type f | while read -r file; do
    upload_file "$file"
done

echo "All files uploaded successfully."
