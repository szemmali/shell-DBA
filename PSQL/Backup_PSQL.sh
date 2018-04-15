#!/bin/bash
##===============================================================================
##		 Project:  Shell-DBA 
##    Repository:  https://github.com/szemmali/shell-DBA)
##	    	Task:  Backup PSQL Data Base
##          FILE:  Backup_PSQL.sh
##  REQUIREMENTS:  Add your SFTP server details: HOST, USER and PASS
##          BUGS:  ---
##         NOTES:  ---
##        AUTHOR:  Eng. Saddam ZEMMALI
##       CREATED:  15.04.2018 17:48:01
##      REVISION:  ---
##       Version:  1.0  ¯\_(ツ)_/¯
##===============================================================================

NOW="$(date +"%B_%Y")"
NOW2="$(date +"%F")"
NOW1="$(date +"%F_%H%M")"
DIR="/home/backup/DB"

echo "╔═══════════════════════════════════════╗"
echo "║     Please add the below details      ║"
echo "╚═══════════════════════════════════════╝"
HOST=
USER=
PASS=

echo "╔═══════════════════════════════════════╗"
echo "║       Backup DB PSQL		          ║"
echo "╚═══════════════════════════════════════╝"
echo "$NOW1 Backup DB postgresql $(date +"%B_%Y")" > $DIR/backup-DB.log
pg_dump -d postgresql  | bzip2 > $DIR/backup_DB_postgresql.$NOW2.psql.bz2


echo "╔═══════════════════════════════════════╗"
echo "║     Check DB PSQL Backup	          ║"
echo "╚═══════════════════════════════════════╝"
#### Check Backup
if [ $? -ne 0 ]
then
       echo "$NOW1 : Backup DB postgresql Reponses NOK" >> $DIR/backup-DB.log
else
       echo "$NOW1 : Backup DB postgresql Reponses OK" >> $DIR/backup-DB.log
fi

echo "╔═══════════════════════════════════════╗"
echo "║    Sending Backup to SFTP Server	  ║"
echo "╚═══════════════════════════════════════╝"

echo "$NOW1 : Starting to send backup..." >> $DIR/backup-DB.log
lftp -u ${USER},${PASS} sftp://${HOST} > $DIR/test_send-DB.log <<EOF
cd   postgresql/DB
put  $DIR/backup_DB_postgresql.$NOW2.psql.bz2
bye
EOF

echo "Send DB  done"  >> $DIR/backup-DB.log
rm $DIR/backup_DB_postgresql.$NOW2.psql.bz2


echo "╔═══════════════════════════════════════╗"
echo "║ Check if exist any error			  ║"
echo "╚═══════════════════════════════════════╝"
err_ftp=`egrep -c '(Could not create file.|Login incorrect.|Not connected.)' $DIR/test_send-DB.log`
if [ $err_ftp -eq 0 ]
then
       echo "$NOW : Send DB  OK" >> $DIR/backup-DB.log
       
else
       echo "$NOW : Send DB  NOK" >> $DIR/backup-DB.log
       cat $DIR/test_send-DB.log >> $DIR/backup.log
fi

echo "╔═══════════════════════════════════════╗"
echo "║  Thanks, Your Backup is Done		  ║"
echo "╚═══════════════════════════════════════╝"