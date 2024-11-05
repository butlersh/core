#!/usr/bin/env bash

# E.g: Environment variables
# BACKUP_NAME=laravel
# LARAVEL_DIR=/home/forge/laravel.confetticode.com
# BACKUPS_DIR=/home/forge/backups
# MYSQL_USERNAME=forge
# MYSQL_PASSWORD=njx4TpmtC3Jztl1j
# MYSQL_DATABASE=laravel

# E.g: Command
# BACKUP_NAME=laravel BACKUPS_DIR=/home/forge/backups LARAVEL_DIR=/home/forge/laravel.confetticode.com MYSQL_USERNAME=forge MYSQL_PASSWORD=njx4TpmtC3Jztl1j MYSQL_DATABASE=laravel /home/forge/backup.sh

SUFFIX=$(date '+%Y-%m-%d-%H%M%S')

echo
echo 'Create the temporary backup directory'
echo

rm -rf "$BACKUPS_DIR/$BACKUP_NAME-$SUFFIX"

mkdir "$BACKUPS_DIR/$BACKUP_NAME-$SUFFIX"

cd "$BACKUPS_DIR/$BACKUP_NAME-$SUFFIX"

echo
echo 'Dump the MySQL database'
echo

mysqldump --no-tablespaces -u$MYSQL_USERNAME -p$MYSQL_PASSWORD $MYSQL_DATABASE > database.sql

echo
echo 'Copy storage files'
echo

mkdir -p "$BACKUPS_DIR/$BACKUP_NAME-$SUFFIX/storage/app/"

cp -a "$LARAVEL_DIR/storage/app/public/" "$BACKUPS_DIR/$BACKUP_NAME-$SUFFIX/storage/app/"

echo
echo 'Zip the backup directory'
echo

zip -r "$BACKUPS_DIR/$BACKUP_NAME-$SUFFIX.zip" "$BACKUPS_DIR/$BACKUP_NAME-$SUFFIX"

echo
echo 'Delete the temporary backup directory'
echo

rm -rf "$BACKUPS_DIR/$BACKUP_NAME-$SUFFIX"

echo
echo "Finished: $BACKUPS_DIR/$BACKUP_NAME-$SUFFIX.zip"
echo
