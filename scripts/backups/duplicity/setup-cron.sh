#!/bin/bash

DIR="$(dirname "$(readlink -f "$0")")"

(crontab -l ; echo "0 0 * * 6 $DIR/duplicity-backup-standalone.sh") | crontab -
