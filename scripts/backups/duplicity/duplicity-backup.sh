#!/bin/sh

test -x "$(which duplicity)" || exit 1


DIR="$(dirname "$(readlink -f "$0")")"
. "$DIR"/.env
export PASSPHRASE

$(which duplicity) full \
    --exclude ~/.local \
    --exclude ~/.cache \
    --exclude ~/.pyenv \
    --exclude ~/.npm \
    --exclude ~/snap \
    --exclude ~/go \
    --exclude ~/VirtualBox \
    --exclude ~/Downloads \
    --exclude ~/.gradle \
    --exclude ~/.npm \
    --exclude ~/.minecraft \
    --exclude ~/.wine \
    --exclude ~/.conda \
    --exclude ~/Android \
    --exclude '**/.venv/' \
    --exclude '**/env/' \
    --exclude '**/venv/' \
    --exclude '**/*_tmp' \
    --exclude '**/tmp_*' \
    --exclude '**/tmp' \
    ~ "$DESTINATION"

# notice that PIPESTATUS does not work on zsh
EXIT_STATUS=${PIPESTATUS[0]}

$(which duplicity) remove-all-but-n-full 2 --force "$DESTINATION"

exit $EXIT_STATUS
