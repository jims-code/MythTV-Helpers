#!/bin/sh
#
# On a combined MythTV Frontend/Backend machine often the Frontend starts faster than the Backend.
#
# This script checks if the MythBackend services are running
# and then starts Mythfrontend.
#
# Source: https://github.com/jims-code/MythTV-Helpers
#
# Maybe interesting: https://bugs.launchpad.net/ubuntu/+source/mythtv/+bug/470672

##############################################
# Parameters - please enter your preferences #
##############################################
#
# Choose a file for logging purposes
LOGFILE="/var/log/mythtv/startup_frontend.log"

# Start
LOGENTRY="$(date +"%b %d %T") Mythfrontend.sh:"
echo $LOGENTRY "### mythfrontend.sh: check if mysql, mythbackend and lirc are runnning" | tee -a $LOGFILE
delay=30
#
# wait for MySQL
    while [ ! "$(pidof mysqld)" ] && [ "$delay" -gt "0" ]; do
       let delay--
       sleep 1
       echo "$LOGENTRY No mysqld yet. Delay: $delay" | tee -a $LOGFILE
    done
    if [ "$(pidof mysqld)" ]; then
        echo "$LOGENTRY mysqld started. pid is $(pidof mysqld)" | tee -a $LOGFILE
    fi
#
# wait for Mythbackend
    while [ -z "$(pidof mythbackend)" ] && [ "$delay" -gt "0" ]; do
       let delay--
       sleep 1
       echo "$LOGENTRY No mythbackend yet. Delay: $delay" | tee -a$LOGFILE
    done
    if [ "$(pidof mythbackend)" ]; then
        echo "$LOGENTRY mythbackend started. pid is $(pidof mythbackend)" | tee -a $LOGFILE
    fi
#
# wait for lircd
    while [ ! "$(pidof lircd)" ] && [ "$delay" -gt "0" ]; do
       let delay--
       sleep 1
       echo "$LOGENTRY No lircd yet. Delay: $delay" | tee -a $LOGFILE
    done
    if [ "$(pidof lircd)" ]; then
        echo "$LOGENTRY lircd started. pid is $(pidof lircd)" | tee -a $LOGFILE
    fi
# end checking for services

mythfrontend --service
