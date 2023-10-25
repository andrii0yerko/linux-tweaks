# KDE Slack login workaround

In some versions of KDE you cannot login into a slack using your browser. This happens because of a bug that causes the slack workspace ID to be small case in the command line argument used by slack to login.

This script is aimed to fix that:
1. Launch the script `./capture-slack-login.sh`
2. Login from UI as usual

The script will capture login url and forward it to the slack app, avoiding breaking by kde tools

Refs:
- https://esc.sh/blog/slack-login-issue-kde-plasma/
- https://stackoverflow.com/questions/70867064/signing-into-slack-desktop-not-working-on-4-23-0-64-bit-ubuntu
