#! /bin/bash

# all alan"s aliases
#   as ordered by strcmp()

# One quote might help in reading these files:
#   "If in doubt, call it Fred", Dr. Mike Scott, Dublin City University, late 80s

# This list is quite long enough, we accept no other aliases
#   Thanks anyway
unalias -a

# The wee x headings are counts
#   all the wee aliases in this wee section have only one character, oui,
#       Awwww.
#   There is an alias for every letter
#       albeit most are unused

# x

alias -- -="cd -"
alias 1=cd_one
alias 2=todo_show
alias 3=3l
alias 4=todo_edit
# a is a function
alias b="b"
# c is a function
alias d="d"
alias e="ex --noplugin -u ~/.vim/exrc"
# f is a function
# g is a function
# h is a function
alias i="i"
alias j="j"
alias k="k"
alias l="$LS_PROGRAM "
alias m="m"
alias n="n"
alias o="o"
# p is a function
# q is a function
alias Q="exit 0"
alias r="rm -vrf"
alias s="s"
alias t="t"
alias u="u"
# v is a function
# w is a function
# x is a function
# y is a function
alias z="du -sh"

# xx

alias 13="thirteen"
alias 32="thirty_two "

alias ..='c ..'

alias eg="env | g "

alias kp="rsync -a"

alias ls="$LS_PROGRAM $LS_COLOUR_OPTION $LS_DIRS_OPTION"

alias p-="echo $OLDPWD"
alias pt="p $JAB/src/python/vim_traceback.py"

alias r.="rm -rvf *"

alias sa="source_aliases $JAB/aliases.sh"
alias sb="c $JAB && source login.sh && -"
alias se="source $JAB/environ.sh"
alias sf="source $JAB/functons.sh"
alias sp="source $JAB/prompt.sh"
alias sr="sudo rm -vrf "

alias yy="y $PYTHON_HOME"

alias z.="zm \*"

# xxx

alias 123="one_two_three"
alias 321="three_two_one"

alias ..l='cl ..'
alias ...='c ../..'

alias doc="c ~/Documents"

alias clx="cl; lx "
alias cly="cl; ly "

alias got=git

alias jlf="sst jlfieblu jlf.ie"

alias kpp="kp --progress"

alias lda="ls -1da"
alias lff="ls fred*"
alias lll="ll -a"
alias lra="lr -a"
alias lrd="lr -d"
alias lsh="ls *.sh"

alias out="to_release"

alias sla="source $JAB/local/aliases.sh"
alias sle="source $JAB/local/environ.sh"
alias slf="source $JAB/local/functons.sh"
alias slp="source $JAB/local/prompt"
alias spe="source $JAB/environ.d/python.sh"

alias tra="try ~/alans_tests"

# xxxx

alias ....='c ../../..'

alias comp="source $JAB/environ.d/company.sh"

alias home="cd; cls"

alias tags="p $JAB/src/python/ptags.py "


# xxxxx

alias .....='c ../../../..'

alias ptags="p $JAB/src/python/ptags.py "

# xxxxxx

alias ......='c ../../../../..'



# xxxxxxx

alias .......='c ../../../../../..'
alias service="sudo /sbin/service "

# xxxxxxxx

# xxxxxxxx

alias stopwatch="killall -9 watch"

alias update_hosts="sudo python $JAB/src/python/update_hosts.py"
