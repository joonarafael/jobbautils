#!/bin/bash

# Escape markdown special characters
escape_markdown() {
  local input="$1"
  local output="$input"

  local markdown_chars=('_' '*' '[' ']' '(' ')' '~' '`' '>' '#' '+' '-' '=' '|' '{' '}' '.' '!')

  for char in "${markdown_chars[@]}"; do
    output="${output//"$char"/\\$char}"
  done

  echo "$output"
}

send_telegram_message() {
  local chat_id="$1"
  local api_key="$2"
  local message="$3"
  
  local escaped_message=$(escape_markdown "$message")

  local response=$(curl -s -X POST \
    -H "Content-Type: application/json" \
    -d "{\"chat_id\": \"$chat_id\", \"text\": \"$escaped_message\", \"parse_mode\": \"MarkdownV2\"}" \
    "https://api.telegram.org/bot$api_key/sendMessage")

  echo "Telegram API response: $response"
}

send_telegram_message "$1" "$2" "$3"
