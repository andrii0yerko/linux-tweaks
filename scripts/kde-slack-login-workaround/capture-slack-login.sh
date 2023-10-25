#!/bin/sh

while true; do
    ps aux | grep '[s]lack' | grep 'magic-login' | awk '{print $13}' | while read -r slack_command; do
        echo "Slack command: $slack_command"
        slack -s "$slack_command"
    done
    sleep .2
done
