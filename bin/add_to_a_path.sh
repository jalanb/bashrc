# ! /bin/bash
#
# Copyright Alan Brogan, 2011
#
# See LICENSE file for your rights
# 
# I like this script because it uses bash variables well
#	In particular it allows changing of a variable whose name is in another variable
# I learned how from http://wiki.bash-hackers.org/
#	Please email any other suggestions to jab.sh@al-got-rhythm.net
#
if [[ $0 == $BASH_SOURCE ]]
then
	echo "This file should be run as"
	echo "	source $0"
	echo "and should not be run as"
	echo "	sh $0"
fi
#
# Once sourced there is one major command:
#
add_to_a_path ()
{
eval $1=$(/usr/bin/python << EOP
import os
import sys

def add_path_to_paths(paths,path):
	result = []
	for p in paths + [ path ]:
		if p and p not in result:
			result.append(p)
	return result

def add_path_to_path_string(path_string, path, separator=':'):
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
	path_string = os.environ.get(name_of_paths,'')
	print add_path_to_path_string(path_string,new_path)

main("$1","$2")
EOP)
}

show_a_path ()
{
	printf "$1 has set \$$2 to\n\t${3//:/\n\t}"
	echo
	echo
}

alias show_path="show_a_path bash PATH $PATH"
alias show_ppath="show_a_path bash PYTHONPATH $PYTHONPATH"

