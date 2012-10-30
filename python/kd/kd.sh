#! /bin/bash

# This script is intended to be sourced, not run
if [[ $0 == $BASH_SOURCE ]]
then
    echo "This file should be run as"
    echo "  source $0"
    echo "and should not be run as"
    echo "  sh $0"
fi

kd ()
{ 
	local python_script=$(dirname $BASH_SOURCE)/kd.py
	local destination=$(python $python_script $* 2>&1)
	local first_word=$(echo "$destination" | head -n 1 | cut -d\   -f1)
	if [[ "$first_word" == "Error" ]]
	then
		echo $destination
	else
		if [[ $destination != $1 && $1 != "-" ]]
		then
			echo "cd $destination"
		fi
		cd "$destination"
	fi
}

