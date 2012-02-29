#!/bin/bash

python_source=$(python -c "import os; print '%s.py' % os.path.splitext(os.path.realpath(\"$BASH_SOURCE\"))[0]")
if [[ -f $python_source ]]
then

j ()
{
	if [[ -z $1 ]]
	then
		python $python_source
	elif [[ ${1/\-/} != $1 ]]
	then
		python $python_source $*
	else
		cd $(python $python_source $*)
	fi
}

fi

j_complete ()
{
	local cmd="${1##*/}"
	local cur="${COMP_WORDS[COMP_CWORD]}"
	local args=${COMP_LINE/$cmd/}
	suggestions=$(python $python_source --complete $args)
	new_word=$(echo $suggestions | sed -es/.*--//)
	suggestions=$(echo $suggestions | sed -es/--.*//)
	COMPREPLY=( $(compgen -W "$suggestions" -- "$new_word") )
}
	
# tab completion tested in bash
complete -F j_complete j

# So was the prompt alteration
if [[ ${PROMPT_COMMAND/add/} == $PROMPT_COMMAND ]]
then
	PROMPT_COMMAND='python $python_source --add "$(pwd -P)";'"$PROMPT_COMMAND"
fi
