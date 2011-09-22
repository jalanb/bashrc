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
# Once sourced there is only one useful command:
#
add_to_a_path ()
{
#
# We expect at least two args
# 1: The name of a variable to be set, which  is usually a word like PATH, or PYTHONPATH
#	It should contain a set of paths, like "/bin:/usr/bin:/usr/local/bin"
# 2: A directory to be added to that PATH
#	The directory is added to the front of the path
#
# For example:
# 	$ export PATH=/usr/local/bin
# 	$ add_to_a_path PATH /usr/bin
# 	$ add_to_a_path PATH /bin
# 	$ add_to_a_path PATH /usr/bin
#	$ echo $PATH
#	/usr/bin:/bin:/usr/local/bin
#
# If a third arg is given then it adds debug messages and is included in them
#
# For example:
# 	$ export LIBRARY_PATH=/usr/lib
# 	$ add_to_a_path LIBRARY_PATH /usr/local/lib call_one
#	call_one - $LIBRARY_PATH
#		/usr/local/lib
#		/usr/lib
# 	$ add_to_a_path LIBRARY_PATH /lib call_two
#	call_two - $LIBRARY_PATH
#		/lib
#		/usr/local/lib
#		/usr/lib
# 	$ add_to_a_path LIBRARY_PATH /usr/lib call_three
#	call_three - $LIBRARY_PATH
#		/usr/lib
#		/lib
#		/usr/local/lib
#	$ echo $LIBRARY_PATH
#	/usr/lib:/lib:/usr/local/lib
#
	local path=${1-PATH}
	local new_directory=${2-~/bin}
	local debugging_name=$3
	if [[ -d "$new_directory" ]]
	then
# Older versions of readlink do not support "-f" (canonicalisation of path names)
# So if that doesn't work we'll just use the path as is
		if /usr/bin/readlink -f / > /dev/null 2>&1
		then
# Use canonical path names
			use_readlink=true
			new_directory=$( /usr/bin/readlink -f $new_directory )
		else
			use_readlink=false
		fi
		local new_directories=$new_directory
		local old_directories=${!path}
		OLD_IFS=$IFS
		IFS=:
		for directory in $old_directories
		do
# Ignore directory if it is empty (usually because of "::" anomalies in the PATH)
			if [[ -n $directory ]]
			then
				if $use_readlink
				then directory=$( /usr/bin/readlink -f  $directory )
				fi
# Ignore this directory if it is already in the PATH
				found=false
				for new_directory in $new_directories
				do 
					if [[ $directory == $new_directory ]]
					then found=true; break
					fi
				done
				if ! $found
				then new_directories="${new_directories}:$directory"
				fi
			fi
		done
		IFS=$OLD_IFS
# We need eval to set the PATH
		eval $path=$new_directories
		export $path
		if [[ -n $debugging_name ]]
		then printf "$debugging_name has set \$$path to\n\t${new_directories//:/\n\t}"
		fi
	elif [[ -n $debugging_name ]]
	then echo "$debugging_name -	$new_directory is not a directory "
	fi
}
