#! /bin/cat


# Based on an answer in StackOverflow:
#   http://apple.stackexchange.com/a/168168/4180

_completable_hosts () {
    (
        cat ~/.ssh/known_hosts | cut -f1 -d' ' | sed -e s/,.*//g | grep -v -e ^# -e "\["; \
        cat ~/.ssh/config | grep ^Host | cut -d ' ' -f2
    ) | sort | uniq
}

_complete_ssh_hosts () {
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    comp_ssh_hosts=$(_completable_hosts)
    COMPREPLY=( $(compgen -W "${comp_ssh_hosts}" -- $cur) )
    return 0
}

complete -F _complete_ssh_hosts ssh

Bye_from $BASH_SOURCE
