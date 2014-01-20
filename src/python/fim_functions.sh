# This file should be sourced by fim.sh, which will provide the $VIM value
recover ()
{
	local swap_file="$2"
	local text_file="$1"
	read -p "Recover $args ? " reply
	if [[ -z $reply || $reply == "y" || $reply == "Y" ]]
	then
		echo "Recovering $swap_file"
		recovered_file="${text_file}.recovered"
		#
		# I use the "g:recovering" variable within vim to
		# 	prevent opening of extra tabs, YMMV
		#
		$VIM -r "$text_file" --cmd ":let g:recovering=1" -c"|:wq! ${recovered_file}" >/dev/null 2>&1
		/bin/rm -f "$swap_file"
		if [[ -f "$recovered_file" ]]
		then
			if ! diff -q "$text_file" "$recovered_file"
			then
				$VIM -d "$text_file" "$recovered_file"
			fi
			/bin/rm -f "$recovered_file"
		fi
		return 0
	else
		return 1
	fi
}

post_vimming ()
{
#
# This function is called after editting, arguments are same as vim got
#
	local arg
	for arg in "$@"
	do
		[[ -e $arg ]] && ls -l $arg
	done
}

