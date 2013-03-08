#! /bin/bash
#
# Based on a file found at https://github.com/jalanb/jab.sh/blob/master/add_to_a_path.sh
# See also ./add_to_path.py and ./add_to_path.test
#

if [[ $0 == $BASH_SOURCE ]]
then
	echo "This file should be run as"
	echo "	source $0"
	echo "and should not be run as"
	echo "	sh $0"
fi
#
# Gonna need python
#
find_python ()
{
	[[ -n $PYTHON ]] && return
	PYTHON=$(which python 2>/dev/null)
	[[ -n $PYTHON ]] && return
	if [[ -f /usr/local/bin/python ]]
	then PYTHON=/usr/local/bin/python
	elif [[ -f /usr/bin/python ]]
	then PYTHON=/usr/bin/python
	fi
}

#
# Once sourced there is one major command:
#
add_to_a_path ()
{
	find_python
	eval $1=$( $PYTHON << EOP
import os
import sys

def add_path_to_paths(paths,path):
	result = []
	for p in paths + [ path ]:
		if p and p not in result:
			result.append(p)
	return result

def add_path_to_path_string(path_string, path, separator=":"):
	if not os.path.isdir(path):
		return path_string
	paths = []
	for p in path_string.split(separator):
		paths = add_path_to_paths(paths,p)
	if path:
		real_path = os.path.realpath(path)
		if os.path.isdir(real_path):
			paths = add_path_to_paths(paths,real_path)
	return separator.join(paths)

def main(name_of_paths,new_path):
	path_string = os.environ.get(name_of_paths,"")
	print add_path_to_path_string(path_string,new_path)

main("$1","$2")
EOP
)
	export $1
}

show_value ()
{
	local name=${1-SHELL}
	local value=${!name}
	if [[ -z "$value" ]]
	then echo \$$name is not set
	else
		local where=${2-bash}
		printf "$where has set \$$name to\n\t$value\n"
	fi
}

show_a_path ()
{
	local name=${1-PATH}
	local value=${!name}
	local where=${2-bash}
	printf "$where has set \$$name to\n\t${value//:/\n\t}\n"
}

show_path ()
{
	show_a_path PATH $*
}

show_ppath ()
{
	show_a_path PYTHONPATH $*
}

debug_show_a_path ()
{
	if [[ $DEBUG_PATHS == "yes" ]]
	then
		show_a_path $*
	fi
}
debug_show_path ()
{
	debug_show_a_path PATH $*
}
debug_show_ppath ()
{
	debug_show_a_path PYTHONPATH $*
}
