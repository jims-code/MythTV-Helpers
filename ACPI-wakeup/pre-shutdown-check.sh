#!/bin/bash
#
# Pre shutdown check command should return one of the following values
# 0 : Allows the backend to reboot
# 1 : Machine is busy. Try shutdown later again.
#
# Checks are made for
#   - MythTV (mythshutdown)
#   - Running firefox or kodi (ps)
#   - UPNP/DLNA playback (netstat)
#   - NFS share connection (netstat)
#   - SMB share connection (smbstatus)
#   - Running MythTV Client machine (IP address)
#
# Source: https://github.com/jims-code/MythTV-Helpers

##############################################
# Parameters - please enter your preferences #
##############################################
#
# Choose a file for logging purposes
LOGFILE="/var/log/mythtv/shutdown.log"
#
# Enter the IPv4 address of your MythFrontend machine that should be checked, e.g. 192.168.0.6
CLIENT_IP=
#
# Enter the name of your Samba share on the MythBackend machine that should be checked for active connections
SMB_SHARE="media"

#
# Function to write logfile
logwrite () {
	echo "["`date '+%Y-%m-%d %H.%M.%S'`"] [pre-shutdown-check.sh] $1 returns statuscode: $2" >> $LOGFILE
	if [ $? -ne 0 ]; then 
		echo "ERROR: Cannot write Logfile $LOGFILE!"
		exit 10
	fi
	# Stop Script if the MythTV machine is not idle
	if [ $2 -ne 0 ]; then
		exit 1
	fi
	}

# Check for MythTV Actions
# this is usually called by the backend as the 'Pre-Shutdown Check command'.
# will return 1 if shutdown is locked, mythcommflag is running, mythtranscode
# is running, mythfilldatabase is running or we are in or about to start a
# daily wakeup/shutdown period.
/usr/bin/mythshutdown --check -q
RETURN_STATUS=$?
logwrite "Mythshutdown" "$RETURN_STATUS"
	# /usr/bin/mythshutdown --status
	#         0 - Idle
	#         1 - Transcoding
	#         2 - Commercial Flagging
	#         4 - Grabbing EPG data
	#         8 - Recording - only valid if flag is 1
	#        16 - Locked
	#        32 - Jobs running or pending
	#        48 - Possibly 16 + 32
	#        64 - In a daily wakeup/shutdown period
	#       128 - Less than 15 minutes to next wakeup period
	#       255 - Setup is running

# Check for running Firefox
RETURN_STATUS=`/bin/ps -ef | grep firefox | grep -v grep | grep -c firefox`
logwrite "Firefox is running" "$RETURN_STATUS"

# Check for running Chrome
# /opt/google/chrome/chrome
RETURN_STATUS=`/bin/ps -ef | grep chrome | grep -v grep | grep -c chrome`
logwrite "Chrome is running" "$RETURN_STATUS"

# Check for running Kodi
RETURN_STATUS=`/bin/ps -ef | grep kodi | grep -v grep | grep -c kodi`
logwrite "Kodi ist running" "$RETURN_STATUS"

# Check for running UPNP/DLNA playback
RETURN_STATUS=`/bin/netstat -tun | grep :6544 | grep -c -i established`
logwrite "UPNP/DLNA-Server (reported via netstat)" "$RETURN_STATUS"

# Check for NFS share connection
RETURN_STATUS=`/bin/netstat | grep -c nfs`
logwrite "NFS (reported via netstat)" "$RETURN_STATUS"

# Check for SMB share connection
RETURN_STATUS=`sudo /usr/bin/smbstatus | grep -c $SMB_SHARE`
logwrite "Samba-Share media" "$RETURN_STATUS"

# Check for MythTV Client (mythfrontend and other programs)
if [ `ping -c 1 192.168.1.122 > /dev/null; echo $?` = 0 ]; then 
    RETURN_STATUS=1
    else
    RETURN_STATUS=0
fi
logwrite "MythTV client" $RETURN_STATUS
