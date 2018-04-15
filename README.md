# shell-DBA
## Backup and Restore Data Base


:+1: [For Backup All MySQL Data Base click here](https://github.com/szemmali/shell-DBA/blob/master/MySQL/Backup-All-MySQL.sh) :shipit:
```
Task:  			Backup MySQL Data Base
FILE:  			Backup_All_MySQL.sh
Description:  	This script will create a backup of each table in every database  (one file per table), 
                compress it and upload it to a remote ftp
Requirement:  	Create a new user only for backups, with following privileges: 
                SHOW DATABASES, SELECT, LOCK TABLES and RELOAD
Note:  			    Create daily cronjobs in /etc/crontab to backup runs daily 
```

:+1: [For Backup PSQL Data Base click here](https://github.com/szemmali/shell-DBA/blob/master/PSQL/Backup_PSQL.sh) :shipit:
```
Task:  			Backup PSQL Data Base
FILE:  			Backup_PSQLL.sh
Description:  	This script will create a backup of database, 
                compress it and upload it to a remote ftp
Requirement:  	Create a new user only for backups, with following privileges: 
                SHOW DATABASES, SELECT, LOCK TABLES and RELOAD
Note:  			    Create daily cronjobs in /etc/crontab to backup runs daily 
```
