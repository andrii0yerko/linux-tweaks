#!/bin/bash

DIR="$(dirname "$(readlink -f "$0")")"

(crontab -l ; echo "0 0 * * 1 $DIR/backup.sh") | crontab -
