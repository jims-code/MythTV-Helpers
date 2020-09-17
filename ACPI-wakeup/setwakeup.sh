#!/bin/sh
#
# $1 is the first argument for the script. It is the time in seconds since 1970.
# This is defined in mythtv-setup with the time_t argument.
#
# This scripts sets the wakeup time in the BIOS.
#
# Source: https://github.com/jims-code/MythTV-Helpers


##############################################
# Parameters - please enter your preferences #
##############################################
#
# Choose a file for logging purposes
LOGFILE="/var/log/mythtv/shutdown.log"

#
# Function to write Logfile
logwrite () {
	echo "["`date '+%Y-%m-%d %H.%M.%S'`"] [setwakeup.sh] $1 returns statuscode: $2" >> $LOGFILE
	if [ $? -ne 0 ]; then 
		echo "ERROR: Cannot write Logfile $LOGFILE!"
		exit 10
	fi
	}

# Save current date/time to HardwareClock
# UTC is used (HWCLOCK is UTC, localtime is +1 (Winter) +2 (Summer)
# 
hwclock --rtc=/dev/rtc0 --systohc --utc --noadjfile
logwrite "Save time in HardwareClock" $?

# set wakeuptime to BIOS
echo 0 > /sys/class/rtc/rtc0/wakealarm      #this clears your alarm.
echo $1 > /sys/class/rtc/rtc0/wakealarm     #this writes your alarm
logwrite "Save wakeup time $1 in BIOS" $?

echo $1 > /home/system/startup-time.txt
