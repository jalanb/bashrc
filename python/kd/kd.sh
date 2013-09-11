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
	local python_directory=$(dirname $BASH_SOURCE)
	local python_script=$python_directory/kd.py
	if ! destination=$(PYTHONPATH=$python_directory python $python_script $* 2>&1)
	then
		echo "$destination"
	else
		real_destination=$(PYTHONPATH=$python_directory python -c "import os; print os.path.realpath('$destination')")
		if [[ $destination != $real_destination ]]
		then
			echo "cd ($destination ->) $real_destination"
			destination=$real_destination
		elif [[ $destination != $1 && $1 != "-" ]]
		then
			echo "cd $destination"
		fi
		cd "$destination"
	fi
	unset destination
}

kg ()
{
	local python_directory=$(dirname $BASH_SOURCE)
	local python_script=$python_directory/kd.py
	PYTHONPATH=$python_directory python $python_script -U $*
}
