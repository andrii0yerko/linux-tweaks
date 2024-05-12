#!/bin/sh

# Function to send logs via Telegram API
send_logs_via_telegram() {
    COMMAND=$1
    EXIT_STATUS=$2
    TMP_LOGFILE=$3

    if [ $EXIT_STATUS -eq 0 ]; then
        MESSAGE="✅ <code>$COMMAND</code> backup succeeded."
    else
        MESSAGE="🔴 <code>$COMMAND</code> backup <b>failed</b> with exit status <b>$EXIT_STATUS</b>."
    fi

    OUTPUT=$(cat "$TMP_LOGFILE")

    TEXT="$MESSAGE"'%0A%0A'"$OUTPUT"

    curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_API_TOKEN/sendMessage" \
        -d "chat_id=$TELEGRAM_CHAT_ID" \
        -d "text=$TEXT" \
        -d "parse_mode=HTML"
}

# Function to execute command with logging
run_with_logging() {
    COMMAND=("$@")
    TMP_LOGFILE=$(mktemp)

    ${COMMAND[@]} > "$TMP_LOGFILE" 2>&1
    EXIT_STATUS=${PIPESTATUS[0]}
    send_logs_via_telegram ${COMMAND[0]} $EXIT_STATUS "$TMP_LOGFILE"

    rm "$TMP_LOGFILE"
}


DIR="$(dirname "$(readlink -f "$0")")"
. "$DIR"/.env


# run_with_logging echo "abc"
# run_with_logging touch /root
run_with_logging "$DIR"/notion/notion-backup.sh ~/data/notion
run_with_logging "$DIR"/duplicity/duplicity-backup.sh
