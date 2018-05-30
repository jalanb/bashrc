#! /bin/cat -n

Welcome_to $BASH_SOURCE

# all alan"s aliases
#   as ordered by strcmp()

# One quote might help in reading these files:
#   "If in doubt, call it Fred", Dr. Mike Scott, Dublin City University, late 80s

# This list is quite long enough, we accept no other aliases
#   Thanks anyway
#
# (Except we will hang on to '.' (which is set by what.sh))

_keep_dot=$(alias . | sed -e "s/.*=//" -e "s/'//g")  # parses out any alias of '.'
unalias -a
[[ -n "$_keep_dot" ]] && alias .=$_keep_dot

# The wee x headings are counts
#   all the wee aliases in this wee section have only one character, oui,
#       Awwww.
#   There is an alias for every letter
#       albeit most are unused
# Search for .= from here

# x

# [0-9]* are in keys/1_0.sh
# a()
# b()
# c()
# d
# e()
# f()
# g()
# h()
# i
# j()
# k()
# l()
# m
# n
# o
# p()
# q()
# Q()
# r= script
# s
# t()
# u
# v()
# w()
# x()
# y()
# z()

# xx

alias ,,='cdp'
alias ..='cdup'

alias eg="env | g "

alias p-="echo $OLDPWD"

alias r.="rm -rvf *"

alias sa="source_aliases ~/jab/src/bash/aliases.sh"
alias sf=". ~/jab/src/bash/functons.sh"
alias sr="sudo rm -vrf "

alias z.="zm \*"

# xxx

alias ..l='cl ..'
alias ...='cdupp'

alias doc="cde ~/Documents"

alias got=git
alias gti=git

alias jlf="sst jlfieblu jlf.ie"


alias out="to_release"

alias sla=". ~/jab/local/aliases.sh optional"
alias sle=". ~/jab/local/environ.sh optional"
alias slf=". ~/jab/local/functons.sh optional"
alias slp=". ~/jab/local/prompt optional"
alias spe=". ~/jab/environ.d/python.sh"

alias tra="try ~/alans_tests"

# xxxx

alias ....='cduppp'

alias comp=". ~/jab/environ.d/company.sh"

alias popp=pisd

alias tags="p ~/jab/src/python/ptags.py "


# xxxxx

alias .....='cdupppp'

alias mkenv=mkvirtualenv

alias print=printf

# xxxxxx

alias ......='cduppppp'

# xxxxxxx

alias .......='cdupppppp'
alias service="sudo /sbin/service "

# xxxxxxxx

# xxxxxxxx

alias stopwatch="killall -9 watch"

alias update_hosts="sudo python ~/jab/src/python/update_hosts.py"

Bye_from $BASH_SOURCE
