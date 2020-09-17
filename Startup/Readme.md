# MythTV-Helpers

## Startup Scripts for MythTV
SOmetimes the startup procedure is not working as good as expected. In this case these scripts 
might provide ideas to create improvements.
These scripts are provided as-is. **USE THESE SCRIPTS AT YOUR OWN RISK!**

**PLEASE ENSURE THAT YOU EDITED THE SCRIPTS BEFORE YOU RUN THEM**: Minimum is to provide 
Parameter values, e.g. logfile names, IP addresses AND to check if all used programs are installed,
e.g. wakeonlan.

### start_mythfrontend.sh
On a combined MythTV Frontend/Backend machine often the Frontend starts faster than the Backend. 
This script checks if the MythBackend services are running and then starts Mythfrontend. 
It might only be used on a combined Fronted/Backend machine.

### wakeup_mythbackend.sh
If you are running MythWelcome on your MythBackend machine then it won't be online 
all th time. And if you are running an additional Frontend-only machine it's annoying 
to go to the MythBackend computer, turn it on, go to the Frontend machine, turn it on too 
and hope that meanwhile all MythBackend services were started.
In this situation wakeup_mythbacken.sh may provide help. Just turn on the Forntend machine, 
then a "welcome screen" is shown (you may use any picture that feh may interprete), the Backend machine will be started by 
wakeonlan, the script will check for mythbackend service (Port 6544 on MythBackend machine) and finally 
remove the "welcome screen".
