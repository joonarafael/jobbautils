#!/bin/bash

# escape markdown special characters
escape_markdown() {
  echo "$1" | sed -E 's/([_*\[\]()~`>#+\-=|{}.!])/\\\1/g'
}

send_telegram_message() {
  local chat_id=$1
  local api_key=$2
  local message=$3

  local escaped_message=$(escape_markdown "$message")

  curl -X POST \
    -H 'Content-Type: application/json' \
    -d "{\"chat_id\": \"$chat_id\", \"text\": \"$escaped_message\", \"parse_mode\": \"MarkdownV2\"}" \
    "https://api.telegram.org/bot$api_key/sendMessage"
}
