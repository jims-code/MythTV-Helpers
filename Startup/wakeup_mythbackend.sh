#!/bin/sh
#
# This is a scritp for your MythFrontend machine.
# This script shows a picture fullscreen,
# starts your MythBackend Machine and waits until services are provided,
#
# Source: https://github.com/jims-code/MythTV-Helpers
#
# maybe interesting: https://bugs.launchpad.net/ubuntu/+source/mythtv/+bug/470672

##############################################
# Parameters - please enter your preferences #
##############################################
#
# Choose a file for logging purposes
LOGFILE="/var/log/mythtv/startup_frontend.log"
#
# Enter the IPv4 address of your MythBackend Machine that should wake up, e.g. 192.168.0.5
SERVER_IP=
#
# Enter the MAC address of your MythBackend Machine that should wake up, e.g. 00:11:22:33:44:55
SERVER_MAC=
#
# Choose a picture that should be shown while the Frontend waits for the Backend to start up.
# It must be a format that feh can use.
IMAGE="/path/to/your/picture.png"

#
# Function to write logfile
logwrite () {
    echo "["`date '+%Y-%m-%d %H.%M.%S'`"] [start_mythfrontend.sh] $1 returns statuscode: $2" >> $LOGFILE
    if [ $? -ne 0 ]; then 
	echo "ERROR: Cannot write Logfile $LOGFILE!"
	exit 10
    fi
    }

#
# Start
logwrite "### Starting Script ###" 0 

#
# Show picture
/usr/bin/feh -F -x $IMAGE &
logwrite "feh" $?
FEH_PID=`pidof feh`
logwrite "get feh PID ($FEH_PID)" $?

#
# Wakeup and wait for Backend machine
while [ `ping -c 2 $SERVER_IP > /dev/null; echo $?` -ne 0 ]; do
    /usr/bin/wakeonlan $SERVER_MAC
    logwrite "wakeonlan backend" $?
    sleep 1
done
logwrite "Backend network detection" 0

#
# Wait for MythBackend service
while [ `nc -z $SERVER_IP 6544; echo $?` -ne 0 ]; do
    sleep 1
    logwrite "wait for mythbackend service" $?
done
logwrite "mythbackend service detection" 0

kill $FEH_PID
logwrite "kill feh (PID $FEH_PID)" $?
