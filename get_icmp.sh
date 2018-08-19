#! /bin/bash

NODEFILEPATH="/usr/share/meshmap"

# Check that the right number of arguments are present
if [ $# -ne 2 ]; then
	echo "ERROR: Usage get_icmp.sh nodename max|min|avg|loss"
	exit 1
fi

# Check if file is present corresponding to the node or throw error
if [ -e $NODEFILEPATH/fping.$1.out ]; then

	# Return an error if the data is too old to not fill the database with stale data
	if [ "$(( $(date +"%s") - $(stat -c "%Y" $NODEFILEPATH/fping.$1.out) ))" -gt "900" ]; then

		echo "ERROR: The cron job for updating ping statistics is not running for more that 15 minutes"
		exit 1
	fi

	# Check what otion was run and get the corresponding data from the file and print it out
	case $2 in
	min)
	        cat $NODEFILEPATH/fping.$1.out | sed -n 's/.*loss[ =]*[0-9]*\/[0-9]*\/\([0-9]*\)%.*max[ =]*\([0-9]*\.[0-9]*\)\/\([0-9]*\.[0-9]*\)\/\([0-9]*\.[0-9]*\)/\2/p'
	        exit 0
	        ;;
	max)
	        cat $NODEFILEPATH/fping.$1.out | sed -n 's/.*loss[ =]*[0-9]*\/[0-9]*\/\([0-9]*\)%.*max[ =]*\([0-9]*\.[0-9]*\)\/\([0-9]*\.[0-9]*\)\/\([0-9]*\.[0-9]*\)/\4/p'
	        exit 0
	        ;;
	avg)
	        cat $NODEFILEPATH/fping.$1.out | sed -n 's/.*loss[ =]*[0-9]*\/[0-9]*\/\([0-9]*\)%.*max[ =]*\([0-9]*\.[0-9]*\)\/\([0-9]*\.[0-9]*\)\/\([0-9]*\.[0-9]*\)/\3/p'
	        exit 0
	        ;;
	loss)
	        cat $NODEFILEPATH/fping.$1.out | sed -n 's/.*loss[ =]*[0-9]*\/[0-9]*\/\([0-9]*\)%.*/\1/p'
	        exit 0
		;;
	*)
		# Exit with an error if some incorrect parameter is specified
	        echo "ERROR: Unknown parameter: $2"
	        echo "Usage get_icmp.sh nodename max|min|avg|loss"
	        exit 1
        	;;
	esac


else
	# If the name of the node is not found, generate an error
	echo "ERROR: Node $1 does not belong to this node or has not reported any data yet"
	exit 1
fi
