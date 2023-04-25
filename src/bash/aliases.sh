#! /bin/cat -n


# all alan"s aliases
#   as ordered by strcmp()

# One quote might help in reading these files:
#   "If in doubt, call it Fred", Dr. Mike Scott, Dublin City University, late 80s

# This list is quite long enough, we accept no other aliases, except '.'
#   Thanks anyway
#   `whyp.sh` sets `.`

_keep_dot=$(alias . 2>/dev/null | sed -e "s/.*=//" -e "s/'//g")  # parses out any alias of '.'
unalias -a
[[ -n "$_keep_dot" ]] && alias .=$_keep_dot

# The wee x headings are counts
#   all the wee aliases in this wee section have only one character, oui,
#       Awwww.
#   There is an alias for every letter
#       albeit most are unused

# x
# Search for ' [a-z.-]*=' from here

# [0-9]* are in keys/1_0.sh
# a()
# b()
# c()
# alias d=
# e()
# f()
# g()
# h()
# alias i=
# j()
# k()
# l()
# alias m=
# alias n=
# alias o=
# p()
# q()
# Q()
# r= script
# alias s=
# t()
# alias u=
# v()
alias w=whyp
# x()
# y()
# z()

alias X='set -x'
alias Z='set +x'

alias ..='cdup'

alias .c='whyp_source ~/cde.sh'
alias .w="whyp_source $WHYP_SOURCE"

alias p-="echo $OLDPWD"

alias r.="rm -rvf *"

alias z.="zm \*"

alias ...='cdupp'

alias bim=vim
alias cim=vim

alias doc="cde ~/Documents"

alias gti=git

alias jab=j
alias jlf="sst jlfieblu jlf.ie"

alias out="to_release"

alias sle="whyp_source ~/jalanb/local/environ.sh optional"
alias slp="whyp_source ~/jalanb/local/prompt optional"
alias spe="whyp_source ~/jab/environ.d/python.sh"
alias srr="sudo rm -vrf "

alias ....='cduppp'

alias comp="whyp_source ~/jab/environ.d/company.sh"
alias popp=pisd

alias .....='cdupppp'

alias mkenv=mkvirtualenv
alias print=printf
alias whihc=which

alias ......='cduppppp'

alias .......='cdupppppp'
alias quitely=quietly
alias service="sudo /sbin/service "

alias .........='cduppppppp'

alias .........='cdupppppppp'
alias stopwatch="killall -9 watch"

alias .........='cduppppppppp'

alias .........='cdupppppppppp'

alias ............='cduppppppppppp'
alias update_hosts="sudo python ~/jab/src/python/update_hosts.py"

