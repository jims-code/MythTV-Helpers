#!/bin/bash
#
# MythTV Shutdown Script
#
# Once a day: MythTV-Database backup and trimming of root file system (fstrim SSD)
#
# Source: https://github.com/jims-code/MythTV-Helpers

##############################################
# Parameters - please enter your preferences #
##############################################
#
# Choose a file for logging purposes
LOGFILE="/var/log/mythtv/shutdown.log"
#
# Choose a file for saving the last shutdown date.
# This will be used to check if a database backup and fstrim command were already executed today.
LASTSHUTDOWNFILE=/var/log/mythtv/lastshutdown.date

#
# Function to write logfile
logwrite () {
	echo "["`date '+%Y-%m-%d %H.%M.%S'`"] [shutdown.sh] $1 returns statuscode: $2" >> $LOGFILE
	if [ $? -ne 0 ]; then 
		echo "ERROR: Cannot write Logfile $LOGFILE!"
		exit 10
	fi
	}

#
# Start
echo "# Check for DB Backup"
if [ `date '+%Y-%m-%d'` = `cat $LASTSHUTDOWNFILE` ];then 
	logwrite "DB Backup was created today! So today no additional Backup will be created." 0
else
	echo "# Create DB Backup"
	sudo /usr/share/mythbuntu-bare/bareclient/mythbackup.py
	logwrite "mythbackup.py (Database-Backup)" $?
	echo "# Starting filesystem trim"
	sudo /sbin/fstrim /
	logwrite "filesystem trim (fstrim /)" $?
fi
echo "# Shutdown system"

#
# Save current date
date '+%Y-%m-%d' > $LASTSHUTDOWNFILE
logwrite "Save current date in $LASTSHUTDOWNFILE" $?

#
# Shutdown System now
mythshutdown --shutdown
