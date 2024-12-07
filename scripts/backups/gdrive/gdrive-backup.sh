#!/bin/bash
# usage ./gdrive-backup.sh [output_dir]

test -x "$(which rclone)" || exit 1

rclone sync -v drive:/ "$1"
