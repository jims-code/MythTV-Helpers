# MythTV-Helpers
## Scripts and more for running MythTV

Currently I use these scripts on Ubuntu 16.04/MythTV 0.29.
**THESE SCRIPTS ARE PROVIDED AS-IS. USE THEM AT YOUR OWN RISK!!**

**PLEASE ENSURE THAT YOU EDITED THE SCRIPTS BEFORE YOU RUN THEM**: Minimum is to provide 
Parameter values, e.g. logfile names, IP addresses AND to check if all used programs are installed,
e.g. wakeonlan.

**MAKE SHURE THAT THE LOGFILES SPECIFIED IN THE SCRIPTS EXIST AND THAT THE USER mythtv IS ALLOWED TO WRITE INTO THE FILES**

## Known Issues
In the script parameters logfiles are spcified. I like to use the path /var/log/mythtv/ for storing these files. 
Every time I update my system (Ubuntu) the file permissions are set back to default. Thia is annoying because the user 
mythtv needs permissions to write into these logfiles. So every time I have to change the permissions again.
