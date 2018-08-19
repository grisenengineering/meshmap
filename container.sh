#! /bin/bash

# Set the hostname in the zabbix agent configuration file
sed -i "s/{HOSTNAME}/$HOSTNAME/g" /etc/zabbix/zabbix_agentd.conf

# Start the zabbix agent
zabbix_agentd

# Start crond
crond

# Delay to make sure everything is started
sleep 5

# Run scripts an initial time
/usr/sbin/meshmap/test_icmp.sh


# Run an infinite loop to prevent container from exiting
while true
do
	sleep 5
done
