# Backups

Scripts for periodical backups of a local machine

Backuping home of a current user, excluding common reproducible directories

## Prerequisites
- [Duplicity](https://duplicity.us/) installed

## Usage
1. Create `.env` file with corresponging variables
2. Adjust exclude list in `duplicity-backup.sh` if needed 
3. Run `./duplicity-backup.sh` to create a single backup
4. Run `./setup-cron.sh` to schedule backuping

## Variables description

- `PASSPHRASE` - gpg passphase for encryption and decryption of backup fules
- `DESTINATION` - destination url for duplicity of any supported backend. Refer to [url format](https://duplicity.us/stable/duplicity.1.html#url-format) to setup it properly
- `TELEGRAM_API_TOKEN` - (optional) token of a telegram bot to send notifications
- `TELEGRAM_CHAT_ID` - (optional) id of a telegram chat for notifications


## More info
- [How To Use Duplicity with GPG to Securely Automate Backups on Ubuntu](https://www.digitalocean.com/community/tutorials/how-to-use-duplicity-with-gpg-to-securely-automate-backups-on-ubuntu)
- [duplicity stable version man page](https://duplicity.us/stable/duplicity.1.html#environment-variables)