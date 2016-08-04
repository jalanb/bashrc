#! /bin/cat -n

# all alan"s aliases
#   as ordered by strcmp()

# One quote might help in reading these files:
#   "If in doubt, call it Fred", Dr. Mike Scott, Dublin City University, late 80s

# This list is quite long enough, we accept no other aliases
#   Thanks anyway

_keep_dot=$(alias . | sed -e "s/.*=//" -e "s/'//g")
unalias -a
alias .=$_keep_dot

# The wee x headings are counts
#   all the wee aliases in this wee section have only one character, oui,
#       Awwww.
#   There is an alias for every letter
#       albeit most are unused
# Search for .= from here

# x

# 0= is an alias in ./digits.sh
# a= function
# b= function
# c= function
alias d="d"
alias e="ex --noplugin -u ~/.vim/exrc"
# f= function
# g= function
# h= function
alias i="i"
# j= function
# k= function
# l= function
alias m="m"
alias n="n"
alias o="o"
# p= function
# q= function
# Q= function
# r= script
alias s="s"
# t= function
alias u="u"
# v= function
# w= function
# x= function
# y= function
# z= function

# xx

alias ..='c ..'

alias eg="env | g "

alias kp="rsync -a"

alias p-="echo $OLDPWD"

alias r.="rm -rvf *"

alias sa="source_aliases ~/jab/src/bash/aliases.sh"
alias sb="c ~/jab && source login.sh && -"
alias se="source ~/jab/environ.d/jab.sh"
alias sf="source ~/jab/src/bash/functons.sh"
alias sr="sudo rm -vrf "

alias z.="zm \*"

# xxx

alias ..l='cl ..'
alias ...='c ../..'

alias doc="c ~/Documents"

alias clx="cl; lx "
alias cly="cl; ly "

alias got=git

alias jlf="sst jlfieblu jlf.ie"

alias kpp="kp --progress"


alias out="to_release"

alias sla="source ~/jab/local/aliases.sh"
alias sle="source ~/jab/local/environ.sh"
alias slf="source ~/jab/local/functons.sh"
alias slp="source ~/jab/local/prompt"
alias spe="source ~/jab/environ.d/python.sh"

alias tra="try ~/alans_tests"

# xxxx

alias ....='c ../../..'

alias comp="source ~/jab/environ.d/company.sh"

alias home="cd; cls"

alias tags="p ~/jab/src/python/ptags.py "


# xxxxx

alias .....='c ../../../..'

alias ptags="p ~/jab/src/python/ptags.py "

# xxxxxx

alias ......='c ../../../../..'

# xxxxxxx

alias .......='c ../../../../../..'
alias service="sudo /sbin/service "

# xxxxxxxx

# xxxxxxxx

alias stopwatch="killall -9 watch"

alias update_hosts="sudo python ~/jab/src/python/update_hosts.py"
