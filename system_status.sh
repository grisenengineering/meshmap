#! /bin/bash

### Checks the status for the system and returns a simple 0 or a 1
### Returns a 1 only if all the output files has updated the last 15 minutes.
### (cron job failed 3 times in a row)

NODEFILEPATH="/usr/share/meshmap"
CONFIGPATH="/etc/meshmap"

# Loop through all files in the nodelist and check that the file is newer than 15 minutes. 

while read host
do
	# Get the node name from each row
	node_name="$(cut -d':' -f1 <<<$host)"

	# Check that the file for the node exists
	if [ -e $NODEFILEPATH/fping.$node_name.out ]; then
		# Check file age for the file corresponding to the node	
			if [ "$(( $(date +"%s") - $(stat -c "%Y" $NODEFILEPATH/fping.$node_name.out) ))" -gt "900" ]; then
			# Return 0 as status
			echo "0"
			exit 1
		fi
	else
		# File did not exist, return 0 as status
		echo "0"
		exit 1
	fi

done < $CONFIGPATH/nodelist.conf

# Return 1 as status
echo 1

