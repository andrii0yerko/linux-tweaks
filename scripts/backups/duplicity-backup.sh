#!/bin/sh

test -x $(which duplicity) || exit 0


CURRENT_DATE=$(date "+%Y%m%d")
TMP_LOGFILE="/tmp/duplicity_output_${CURRENT_DATE}.txt"

DIR="$(dirname "$(readlink -f "$0")")"
source $DIR/.env
export PASSPHRASE

$(which duplicity) full \
    --exclude ~/.local \
    --exclude ~/.cache \
    --exclude ~/snap \
    --exclude ~/go \
    --exclude ~/VirtualBox \
    --exclude ~/Downloads \
    --exclude '**/env' \
    --exclude '**/*_tmp' \
    --exclude '**/tmp_*' \
    --exclude '**/tmp' \
    --dry-run \
    ~ $DESTINATION  | tee $TMP_LOGFILE

EXIT_STATUS=$?

$(which duplicity) remove-all-but-n-full 3 --force $DESTINATION | tee -a $TMP_LOGFILE


if [ -n "$TELEGRAM_API_TOKEN" ] && [ -n "$TELEGRAM_CHAT_ID" ]; then
    if [ $EXIT_STATUS -eq 0 ]; then
        MESSAGE="✅ Duplicity backup succeeded."
    else
        MESSAGE="🔴 Duplicity backup **failed** with exit status $EXIT_STATUS."
    fi
    OUTPUT=$(cat $TMP_LOGFILE)

    TEXT="$MESSAGE"$'\n\n'"$OUTPUT"

    curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_API_TOKEN/sendMessage" \
        -d "chat_id=$TELEGRAM_CHAT_ID" \
        -d "text=$TEXT"

    rm $TMP_LOGFILE
fi
