#!/bin/bash
##==================================================================================
##		 Project:  Shell-DBA 
##        AUTHOR:  Eng. Saddam ZEMMALI
##       CREATED:  15.04.2018 18:10:01
##      REVISION:  ---
##       Version:  1.0  ¯\_(ツ)_/¯
##    Repository:  https://github.com/szemmali/shell-DBA)
##	    	Task:  Backup MySQL Data Base
##          FILE:  Backup_All_MySQL.sh
##   Description:  This script will create a backup of each table in every database 
##				  (one file per table), compress it and upload it to a remote ftp
##   Requirement:  Create a new user only for backups, with following privileges:
##				   SHOW DATABASES, SELECT, LOCK TABLES and RELOAD
##			Note:  Create daily cronjobs in /etc/crontab to backup runs daily 
##          BUGS:  ---
##==================================================================================

NOW=$(date +"%d%H")

echo "╔═══════════════════════════════════════╗"
echo "║     Please add the below details      ║"
echo "╚═══════════════════════════════════════╝"

echo "System Setup"
BACKUP=YOUR_LOCAL_BACKUP_DIR

echo "The MySQL Setup"
MUSER="MYSQL_USER"
MPASS="MYSQL_USER_PASSWORD"
MHOST="localhost"

echo "The FTP server Setup "
FTPD="YOUR_FTP_BACKUP_DIR"
FTPU="YOUR_FTP_USER"
FTPP="YOUR_FTP_USER_PASSWORD"
FTPS="YOUR_FTP_SERVER_ADDRESS"


echo "The Binaries"
TAR="$(which tar)"
GZIP="$(which gzip)"
FTP="$(which ftp)"
MYSQL="$(which mysql)"
MYSQLDUMP="$(which mysqldump)"


echo "╔═══════════════════════════════════════╗"
echo "║     Start Backup Process		      ║"
echo "╚═══════════════════════════════════════╝"

echo "Create hourly directory"
mkdir $BACKUP/$NOW

echo "Get all databases name "
DBS="$($MYSQL -u $MUSER -h $MHOST -p$MPASS -Bse 'show databases')"
for db in $DBS
do

echo "Create directory for each databases, backup tables in individual files"
  mkdir $BACKUP/$NOW/$db

  for i in `echo "show tables" | $MYSQL -u $MUSER -h $MHOST -p$MPASS $db|grep -v Tables_in_`;
  do
    FILE=$BACKUP/$NOW/$db/$i.sql.gz
    echo $i; $MYSQLDUMP --add-drop-table --allow-keywords -q -c -u $MUSER -h $MHOST -p$MPASS $db $i | $GZIP -9 > $FILE
  done
done


echo "╔═══════════════════════════════════════════════════════╗"
echo "║  Compress all tables in one nice file to upload	      ║"
echo "╚═══════════════════════════════════════════════════════╝"
ARCHIVE=$BACKUP/$NOW.tar.gz
ARCHIVED=$BACKUP/$NOW
$TAR -cvf $ARCHIVE $ARCHIVED

echo "╔═══════════════════════════════════════╗"
echo "║    Send Backup Using FTP		      ║"
echo "╚═══════════════════════════════════════╝"
cd $BACKUP
DUMPFILE=$NOW.tar.gz
$FTP -n $FTPS <<END_SCRIPT
quote USER $FTPU
quote PASS $FTPP
cd $FTPD
mput $DUMPFILE
quit
END_SCRIPT


echo "╔═══════════════════════════════════════════════════════╗"
echo "║  		Delete the backup dir and keep archive 		  ║"
echo "╚═══════════════════════════════════════════════════════╝"
rm -rf $ARCHIVED


echo "╔═══════════════════════════════════════╗"
echo "║  Thanks, Your Backup is Done		  ║"
echo "╚═══════════════════════════════════════╝"