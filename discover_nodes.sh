#! /bin/bash

### Generates a JSON-string for all the hosts in the config file
### that Zabbix acceps for autodiscovery of items
### Used by the discover.nodes userparameter

CONFIGPATH="/etc/meshmap"

# Start the JSON
json_out="{\"data\":["


# Loop through each row in the file
while read host
do
	# Get name and IP for each row
	node_name="$(cut -d':' -f1 <<<$host)"
	node_ip="$(cut -d':' -f2 <<<$host)"

	# Create the JSON for each item
	json_out+="{\"{#NODENAME}\":\"$node_name\",\"{#NODEIP}\":\"$node_ip\"},"

done < $CONFIGPATH/nodelist.conf

# Remove the last ,
json_out=${json_out%?}

# End of JSON
json_out+="]}"

# Print it all out
echo "$json_out"
