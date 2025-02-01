#!/bin/bash

set -e

ACCESS_TOKEN="${DROPBOX_ACCESS_TOKEN}"
LOCAL_DIRECTORY="./services/backend/logs/"
DROPBOX_FOLDER="/GitHubActionsLogs"

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
