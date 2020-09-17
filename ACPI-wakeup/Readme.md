# MythTV-Helpers

## Scripts for improving wakeup and shutdown for use on a MythBackend machine
These scripts maybe used when a MythBackend machine should not run 24/7.
In this case MythWelcome allows to start the machine before a recording
should be started and shuts down the machine when it's idle.

Currently I use these scripts on Ubuntu 16.04/MythTV 0.29.
**THESE SCRIPTS ARE PROVIDED AS-IS. USE THEM AT YOUR OWN RISK!!**

**PLEASE ENSURE THAT YOU EDITED THE SCRIPTS BEFORE YOU RUN THEM**: Minimum is to provide 
Parameter values, e.g. logfile names, IP addresses AND to check if all used programs are installed,
e.g. wakeonlan.
 
### pre-shutdown-check.sh
Shutdown your MythBackend when it's idle? Especially your "when it's idle" 
condition may contain more aspects than the built-in command "mythshutdown -c" checks.
--> then have a look at **pre-shutdown-check.sh**

### setwakeup.sh
This script sets the wakeup time in the BIOS. Input time format is time_t .

### shutdown.sh
This script creates a database backup once a day. It calls 
/usr/share/mythbuntu-bare/bareclient/mythbackup.py . So you must ensure 
that mythbackup.py exists. 
Then it runs "fstrim /" once a day. **THIS COMMAND SHOULD ONLY BE RUN ON SSD's!**
SSD's require that fstrim is run "sometimes". Maybe that this feature is provided
by modern Linux distributions out of the box, so that there is no need to run fstrim 
by a script anymore. 
And finally the script calls mythshutdown to shutdown the machine.
