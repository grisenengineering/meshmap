#! /bin/bash

### This file runs fping on all the hosts in the nodelist.conf and generates an outputfile
### for each host that the zabbix agent can read asyncronously.
### This script should be run every 5 minutes as a cron-job.

NODEFILEPATH="/usr/share/meshmap"
CONFIGPATH="/etc/meshmap"

# Loop through every node
while read host
do
	# Get the node name
	node_name="$(cut -d':' -f1 <<<$host)"

	# run fping, 50 packages 25 ms apart. Discard the normal data but keep the summary
	# and put it in a textfile with the nodename
	fping -c 50 -p 25 10.50.2.1 1>/dev/null 2> $NODEFILEPATH/fping.$node_name.out

	# short delay between the hosts to not run too many ping-messages at once
	sleep 1

done < $CONFIGPATH/nodelist.conf
