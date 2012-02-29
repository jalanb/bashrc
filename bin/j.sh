#!/bin/bash

python_source=$(python -c "import os; print '%s.py' % os.path.splitext(os.path.realpath(\"$BASH_SOURCE\"))[0]")
if [[ -f $python_source ]]
then

j ()
{
    local datafile=$HOME/.j
	if [[ ${1/--/} == $1 ]]
	then
		python $python_source $*
	else
		cd=$(python $python_source $*)
		if [[ -d $cd ]]
		then
			cd $cd
		fi
	fi
}

fi

j_complete ()
{
	local cmd="${1##*/}"
	local args=${COMP_LINE/$cmd/}
	suggestion=$(python $python_source --complete ${line/$cmd/})
	COMPREPLY=( $(compgen -W "$suggestion" "$cur") )
}
	
# tab completion tested in bash
complete -F j_complete j

# So was the prompt alteration
if [[ ${PROMPT_COMMAND/add/} == $PROMPT_COMMAND ]]
then
	PROMPT_COMMAND='j --add "$(pwd -P)";'"$PROMPT_COMMAND"
fi
