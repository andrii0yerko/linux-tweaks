#!/bin/sh

DIR="$( dirname "$0" )"
FILE="$( readlink -f "$DIR"/settings.json )"

ln -sf $FILE ~/.config/Code/User/settings.json
