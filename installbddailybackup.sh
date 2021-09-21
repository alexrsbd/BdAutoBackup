#!/bin/bash

#Author: Alex Sullivan
#Version: 1.0

#This script is used to create a cron job to back up Black Duck's containerized Postgres instance daily. This only works with Docker
#It will create a bd-backups directory in your home directory to store the dumps. This will be overwritten with each run of the job.
#It grabs and runs the latest version of the "hub_create_data_dump.sh" script from the Black Duck github.
#Paths and cron schedule can be modified via variables instead of modifying the script directly.

#scriptPath sets where bddailybackup.sh will live. This is the script the cron job runs.
#backupDir sets where it saves your Black Duck database
#cronSched sets the frequency that the script will run. By default it will run daily at midnight. You can visit https://crontab.guru/ for more information on scheduling your cron jobs.

scriptPath=$HOME
backupDir=$scriptPath/bd-backups
cronSched='0 0 * * *'

touch $scriptPath/bddailybackup.sh
echo "#!/bin/bash" >> $scriptPath/bddailybackup.sh
echo "mkdir -p $backupDir" >> $scriptPath/bddailybackup.sh
echo "bash <(curl -s -L https://raw.githubusercontent.com/blackducksoftware/hub/master/docker-swarm/bin/hub_create_data_dump.sh) $backupDir" >> $scriptPath/bddailybackup.sh
chmod +x $scriptPath/bddailybackup.sh
(crontab -l 2>/dev/null; echo "$cronSched $scriptPath/bddailybackup.sh") | crontab -