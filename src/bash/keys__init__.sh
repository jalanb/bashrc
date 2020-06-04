#! /bin/cat


THIS=$BASH_SOURCE

. ~/jab/local/functons.sh optional

# _
# x

alias 0="home_cde hub"
alias 1="home_cde jab"
alias 2="home_cde bots"
alias 3="echo '#' | pbcopy"
alias 4="home_cde wmp"
alias 5="home_cde tippy"
alias 6="home_cde txt"
alias 7="c ~/hub/zatso"
alias 8="home_range hub"
alias 9="in_home -e tmp"

# _x
# xx

alias 00="0 pysyte"
alias 01="0 cde"
alias 01="0 whyp"
alias 01="0 zatso"
alias 01="0 pym"
alias 01="0 "
alias 01="0 "
alias 01="0 "
alias 01="0 "
alias 01="0 "

# crontab
# python -> src/python
# keys -> bash/keyboard

alias 10="1 bin"
alias 11="1 bash"
alias 12="1 txt"
alias 13="1 local"
alias 14="1 vim"
alias 15="1 python"
alias 16="1 keys"
alias 17="1 etc"
alias 18="1 home"
alias 19="1 crontab"
alias 1v="vim $THIS +1 +/^alias.1[0-9a-z]*="

alias 20="2 bin"
alias 21="2 testing"
alias 22="2 bots/bots"
alias 23="2 testing.master"
alias 24="2 deploys"
alias 25="2 developed"
alias 26="2 tools"
alias 27="2 tools-107"
alias 2v="vim $THIS +1 +/^alias.2[0-9a-z]*= -p ~/keys/2.sh"

alias 31="3 local"
alias 32="3 master"
alias 33="3 eop"
alias 34="3 deploy"
alias 35="3 dupont"
alias 35="3 mrs"
alias 36="3 corteva"
alias 36="3 order"
alias 30="3 eop"
alias 3v="vim $THIS +1 +/^alias.3[0-9a-z]*="

alias 41="4 local"
alias 42="4 master"
alias 43="4 deploy"
alias 44="4 dashboard"
alias 45="4 mrs"
alias 46="4 documents"
alias 47="4 wmp"
alias 48="4 the_dark_side"


alias 54="5 site"
alias 55="vagrant ssh"
alias 56="5 opp_common"
alias 57="5 django_tools"

alias 60="cd ~/txt/.."

alias 77="home_vim tmp"

alias 88="ranger ~/src/git"

alias 99="cde /"
alias 92="cde /etc"
alias 97="cde /usr"
alias 98="cde /usr/local"
alias 99="in_home tmp"

# _x
# _xx
# xxx

alias §00="cd ~/../.."

alias 133="cde ~/hub/pym/pym"
alias 144="cde ~/hub/pysyte/pysyte"
alias 110="2 develop"
alias 111="2 bots"
alias 112="2 testing"
alias 113="2 master"
alias 114="2 deploy"
alias 115="2 mrs"
alias 116=
alias 117="2 tools-107"
alias 118="2 deploys"
alias 119=
alias 1123="2 testing.master"
alias 210="2 develop"
alias 215="2 mrs"
alias 213="2 master"
alias 218="2 deploys"
alias 233="3 master"
alias 235="3 mrs"
alias 233="3 eop"
alias 234="3 deploy"
alias 241="4 dashboard"
alias 243="4 dashboard.master"
alias 244="4 deploy"
alias 249="4 dashboard.local"
alias 254="2 deploys/tippy"
alias 255="ssh_tippy"

alias 333="green_line Hello World"

alias 777="home_vim vim"

alias 2144="214; gfff"
alias 2344="234; gfff"
alias 2444="244; gfff"
alias 2544="254; gfff"
# xxxx

#! /bin/cat


home_echo () {
    local _named=$1; shift
    local _named_too=$1; shift
    local _match_dir=$( (
        cd $_named
        for _arg_path in $_named_too "$@"; do
            if [[ -d $_arg_path ]]; then
                readlink -f $_arg_path
                break
            fi
        done
    ) )
    local _dir=$_named
    [[ -d "$_match_dir" ]] && _dir="$_match_dir"
    [[ -d "$_dir" ]] || return 1
    echo $_dir
}

count_dirs () {
    local _count=0
    (
        cd
        local _arg=
        for _arg in "$@"; do
            [[ $_arg =~ -[ev] ]] && continue
            [[ -d $_arg ]] || continue
            _count=$(( $_count + 1 ))
            cd "$_arg"
        done
        echo $_count
    )
}

cd_home_dirs () {
    local _count=0
    local _cd=
    local _echo=
    local _arg=
    cd
    while [[ $# > 0 ]]
    do
        _arg="$1"
        [[ "$_arg" ]] || break 
        if [[ "$_arg" =~ -[ve] ]]; then
            [[ $_arg == -v ]] && _echo=1
            [[ $_arg == -e ]] && _cd=cde
            shift
            continue
        fi
        [[ -d "$_arg" ]] || continue
        _count=$(( $_count + 1 ))
        cd "$_arg"
        [[ $_echo ]] && pwd
        shift
    done
    [[ $_echo ]] && pwd
    return $_count
}

home_ls () {
    local _doc="""Try $1, and $1/$2 as a directory under $HOME"""
    local $_dir=$(cd_home_dirs "$@" && pwd)
    CDE_header=$( ls -1 -d $ $_dir * 2>/dev/null )
    # set +x
}

home_cd () {
    local _return=$(count_dirs "$@")
    cd_home_dirs "$@"
    [[ $? > 0 ]]
}

home_cde () {
    home_cd -e "$@"
}

home_range () {
    cd_home_dirs "$@"
    ranger
}

home_echo () {
    (
        home_cd -v "$@"
    )
}

in_home () {
    local _shifts=$(count_dirs "$@")
    (
        home_cd "$@"
        shift $?
        "$@"
    )
    return $_shifts
}

home_fd () {
    (
        home_cd "$@"
        shift $?
        fd "$@"
    )
}

home_vim () {
    vim -p $(home_fd "$@")    
}

#! /bin/cat


THIS=$BASH_SOURCE

. ~/jab/local/functons.sh optional

# _
# x

alias 0="home_cde hub"
alias 1="home_cde jab"
alias 2="home_cde bots"
alias 3="echo '#' | pbcopy"
alias 4="home_cde wmp"
alias 5="home_cde tippy"
alias 6="home_cde txt"
alias 7="c ~/hub/zatso"
alias 8="home_range hub"
alias 9="in_home -e tmp"

# _x
# xx

alias 00="0 pysyte"
alias 01="0 cde"
alias 01="0 whyp"
alias 01="0 zatso"
alias 01="0 pym"
alias 01="0 "
alias 01="0 "
alias 01="0 "
alias 01="0 "
alias 01="0 "

# crontab
# python -> src/python
# keys -> bash/keyboard

alias 10="1 bin"
alias 11="1 bash"
alias 12="1 txt"
alias 13="1 local"
alias 14="1 vim"
alias 15="1 python"
alias 16="1 keys"
alias 17="1 etc"
alias 18="1 home"
alias 19="1 crontab"
alias 1v="vim $THIS +1 +/^alias.1[0-9a-z]*="

alias 20="2 bin"
alias 21="2 testing"
alias 22="2 bots/bots"
alias 23="2 testing.master"
alias 24="2 deploys"
alias 25="2 developed"
alias 26="2 tools"
alias 27="2 tools-107"
alias 2v="vim $THIS +1 +/^alias.2[0-9a-z]*= -p ~/keys/2.sh"

alias 31="3 local"
alias 32="3 master"
alias 33="3 eop"
alias 34="3 deploy"
alias 35="3 dupont"
alias 35="3 mrs"
alias 36="3 corteva"
alias 36="3 order"
alias 30="3 eop"
alias 3v="vim $THIS +1 +/^alias.3[0-9a-z]*="

alias 41="4 local"
alias 42="4 master"
alias 43="4 deploy"
alias 44="4 dashboard"
alias 45="4 mrs"
alias 46="4 documents"
alias 47="4 wmp"
alias 48="4 the_dark_side"


alias 54="5 site"
alias 55="vagrant ssh"
alias 56="5 opp_common"
alias 57="5 django_tools"

alias 60="cd ~/txt/.."

alias 77="home_vim tmp"

alias 88="ranger ~/src/git"

alias 99="cde /"
alias 92="cde /etc"
alias 97="cde /usr"
alias 98="cde /usr/local"
alias 99="in_home tmp"

# _x
# _xx
# xxx

alias §00="cd ~/../.."

alias 133="cde ~/hub/pym/pym"
alias 144="cde ~/hub/pysyte/pysyte"
alias 110="2 develop"
alias 111="2 bots"
alias 112="2 testing"
alias 113="2 master"
alias 114="2 deploy"
alias 115="2 mrs"
alias 116=
alias 117="2 tools-107"
alias 118="2 deploys"
alias 119=
alias 1123="2 testing.master"
alias 210="2 develop"
alias 215="2 mrs"
alias 213="2 master"
alias 218="2 deploys"
alias 233="3 master"
alias 235="3 mrs"
alias 233="3 eop"
alias 234="3 deploy"
alias 241="4 dashboard"
alias 243="4 dashboard.master"
alias 244="4 deploy"
alias 249="4 dashboard.local"
alias 254="2 deploys/tippy"
alias 255="ssh_tippy"

alias 333="green_line Hello World"

alias 777="home_vim vim"

alias 2144="214; gfff"
alias 2344="234; gfff"
alias 2444="244; gfff"
alias 2544="254; gfff"
# xxxx

#! /bin/cat


home_echo () {
    local _named=$1; shift
    local _named_too=$1; shift
    local _match_dir=$( (
        cd $_named
        for _arg_path in $_named_too "$@"; do
            if [[ -d $_arg_path ]]; then
                readlink -f $_arg_path
                break
            fi
        done
    ) )
    local _dir=$_named
    [[ -d "$_match_dir" ]] && _dir="$_match_dir"
    [[ -d "$_dir" ]] || return 1
    echo $_dir
}

count_dirs () {
    local _count=0
    (
        cd
        local _arg=
        for _arg in "$@"; do
            [[ $_arg =~ -[ev] ]] && continue
            [[ -d $_arg ]] || continue
            _count=$(( $_count + 1 ))
            cd "$_arg"
        done
        echo $_count
    )
}

cd_home_dirs () {
    local _count=0
    local _cd=
    local _echo=
    local _arg=
    cd
    while [[ $# > 0 ]]
    do
        _arg="$1"
        [[ "$_arg" ]] || break 
        if [[ "$_arg" =~ -[ve] ]]; then
            [[ $_arg == -v ]] && _echo=1
            [[ $_arg == -e ]] && _cd=cde
            shift
            continue
        fi
        [[ -d "$_arg" ]] || continue
        _count=$(( $_count + 1 ))
        cd "$_arg"
        [[ $_echo ]] && pwd
        shift
    done
    [[ $_echo ]] && pwd
    return $_count
}

home_ls () {
    local _doc="""Try $1, and $1/$2 as a directory under $HOME"""
    local $_dir=$(cd_home_dirs "$@" && pwd)
    CDE_header=$( ls -1 -d $ $_dir * 2>/dev/null )
    # set +x
}

home_cd () {
    local _return=$(count_dirs "$@")
    cd_home_dirs "$@"
    [[ $? > 0 ]]
}

home_cde () {
    home_cd -e "$@"
}

home_range () {
    cd_home_dirs "$@"
    ranger
}

home_echo () {
    (
        home_cd -v "$@"
    )
}

in_home () {
    local _shifts=$(count_dirs "$@")
    (
        home_cd "$@"
        shift $?
        "$@"
    )
    return $_shifts
}

home_fd () {
    (
        home_cd "$@"
        shift $?
        fd "$@"
    )
}

home_vim () {
    vim -p $(home_fd "$@")    
}

#! /bin/cat


# _
# x
# _x
# xx


. ~/hub/ackvim/ackvim.sh

# a is defined in ackvim.sh

# _x
# xx

# aa is in ackvim.sh

# _xx

_av () {
    (cd $1; vack "$@")
}

# xxx

# aaa also ackvim.sh

avb () {
    __doc__="vack all args in ~/jab/src/bash";
    _av ~/jab/src/bash "$@"
}

avg () {
    __doc__="vack all args in ~/src/git";
    _av ~/src/git "$@"
}

avh () {
    __doc__="vack all args in ~/hub";
    _av ~/hub "$@"
}

avj () {
    __doc__="vack all args in ~/jab";
    _av ~/jab "$@"
}

avp () {
    __doc__="vack all args in ~/jab/src/python";
    _av ~/jab/src/python "$@"
}

avs () {
    __doc__="vack all args in ~/src";
    _av ~/src "$@"
}

avu () {
    __doc__="vack all args in ~";
    _av ~ "$@"
}

avv () {
    __doc__="vack all args in ~/jab/vim";
    _av ~/jab/vim "$@"
}


#! /bin/cat


# _
# x
# _x
# xx

alias b=echo
alias bt="set -eu; source ~/bash/bashtrace.sh"

#! /bin/cat



# x

c () {
    cde "$@"
}

# _
# xx

cb () {
    cde ~/bots/bots/bots
}

if [[ ! $ALIAS_CC ]]; then
    unalias cc 2>/dev/null

cc () {
    c $CDE.sh
}
fi

cg () {
    local _where=.
    [[ "$*" ]] && _where="$@"
    c $(git -C "$_where" rev-parse --show-toplevel)
}

ch () {
    cde ~/hub/
}

cj () {
    cde ~/jab/
}

cl () {
    clear
    l "$@"
}

cr () {
    clear
}

# cp is hashed (/usr/local/gnu/cp)

cw () {
    cde $WHYP.sh
}

cv () {
    cde $1; v $(basename_ $1)
}

cy () {
    cde ~/hub/pysyte
}

# _x
# xxx
# _xx

can () {
    cat -n "$@"
}

ib () { cn ~/.bashrc
}

cjy () {
    cd ~/jab/src/python "$@"
}

clf () {
    cat ~/jab/local/functons.sh
}

cla () {
    clear
    la "$@"
}

clo () {
    clear
    lo "$@"
}

cloa () {
    clear
    loa "$@"
}

cloo () {
    cde $(locate "$@")
}

# xxxx
calf () {
    cat ~/jab/local/functons.sh
}

# _xxx
# xxxxx

clean () {
    rf -q "$@"
}

# _xxxx
# xxxxxx
# _xxxxx

#! /bin/cat


# _
# x
# _x
# xx

alias d=echo

ddf () {
    local __doc__="""where the arg came from"""
    ( shopt -s extdebug; declare -F "$1" )
}

#! /bin/cat


# _
# x
# _x
# xx

#
# These e*() functions show result of last command
#      $ ls /bin && et || ef
# Especially used in CLI to show conditions
#      $ [[ -d /bin ]] && et || ef
# "&& et || ef" was abbreviated to etf
#      $ [[ -d /bin ]]; etf 
# Can also be used as command
#      $ etf test -d /bin 
# 
ef () {
    [[ $? == 0 ]] && return $? || eff $?
    local __doc__="""fail fast, or show angrier faces"""
}

et () {
    [[ $? == 0 ]] && ett $? || return $?
    local __doc__="""show a happy face :-) Or let the other ones out"""
}

quietly unalias eg
eg () {
    env | g "$@"
}

# xxx

eff () {
    local __doc__="""Errors from a failed command"""
    local _status=$1
    echo "False $_status $(face $_status)" >&2
    false
}

eft () {
    local __doc__="""Errors from a command, or the one before"""
    ( [[ $@ ]] && "$@" )
    etf
}

etf () {
    wtf $?
    local __doc__="""Errors from a status"""
}

ett () {
    local __doc__="""Errors from a successful command"""
    local _status=$1
    echo "True $_status $(face $_status)" >&1
    true
}

wtf () {
    local _status=$?
    local __doc__="""Errors from a status"""
    [[ $1 ]] && _status=$1 && shift
    local _name=True
    local _streams=
    [[ $1 =~ -[qQ] ]] || _streams='>&1'
    [[ $_status == 0 ]] ||_name=False
    [[ $_name == True ]] || _streams="$_streams >&2"
    [[ $1 =~ -[Q] ]] && _streams=
    _message="$_name $_status $(face $_status)" 
    echo $_message $_streams
    [[ $_name == False ]] && return $_status
    true
}

# _xx
# xxx

err () {
    "$@" >/dev/null 2>&1
    er
}

# xxxxx

face () {
    local _faces=(😎 👿  👎  💀  👻  💩  🤨   😐  😑  😥  😮  😫  😲  ☹️  😤  😢  😭  😦  😧  😨  😩  🤯   😬  😰  😱  🥵   🥶   😳  🤢  🤮)
    echo ${_faces[$1]}
}
#! /bin/cat

# . ~/jab/src/bash/f.sh


# x

f () {
    local _dir=.
    [[ -d "$1" ]] && _dir="$1" && shift
    local _type=f
    [[ $1 =~ ^[dDfF]$ ]] && _type="$1" && shift
    _type="-type $_type"
    local _name='*'
    [[ -n $1 ]] && _name="$1" && shift
    _name="-name $_name"
    find $_dir $_type $_name "$@"
}

# _
# xx

ff () {
    local _dir=.
    [[ -d "$1" ]] && _dir="$1" && shift
    find $_dir -type f -name "$@"
}

fl () {
    freds | tr ' ' '\n'
}

fn () {
    f -name "$@"
}

# _x
# xxx

fdd () {
    $(freds --debug "$@")
}

fee () {
    $(freds --edit "$@")
}

fff () {
    freds | tr ' ' '\n'
}

fll () {
    $(freds --list)
}

frr () {
    $(freds --remove "$@")
}

fpp () {
    $(freds --python "$@")
}

fss () {
    $(freds --shell "$@")
}

vfd () {
    vim -p $(fd "$@")
}

vff () {
    $(freds --edit "$@")
}

# _xx
# xxxx

bash_null () {
    echo ~/bash/null 
}

fynd () {
    local _options=
    [[ $# == 1 ]] && _options=". -name"
    sudo find $_options "$@"
}

fynd.old () {
    if [[ "$@" =~ -name ]]; then
        echo "Do not use '-name'" >&2
        return 1
        shift
    fi
    dir=
    local _argc=${#*}
    if [[ $_argc > 1 ]]; then
        shift_dir "$@" && shift
    elif [[ -z $dir ]]; then
        dir=$(realpath $(pwd))
    fi
    local _debug=$dir
    local _arg=$1; shift
    local _type=
    if [[ $_arg == "-type" ]]; then
        local _type_type=$1; shift
        _type="-type $_type_type"
        _arg=$1; shift
    fi
    local old_ifs=$IFS
    IFS=";"
        for FOUND in $(find $(realpath "$dir") -name "$_arg" -print "$@" 2>/dev/null | tr '\n' ';')
    do
        relpath -s $FOUND
    done
    IFS=$old_ifs
}
# _xxx
# xxxxx

ffind () {
    local __doc__="ff $dir $filename # finds files with that name in that dir"
    shift_dir "$@" && shift
    filename=$1; shift
    find $dir -type f -name $filename "$@"
}
# _xxxx
# xxxxxx
# _xxxxx
#! /bin/cat


# _
# x
# _x
# xx

g () {
    $(which egrep) --color "$@"
}


#! /usr/bin/env kat -n

. ~/bash/history.sh
. ~/bash/keyboard/v.sh


# _
# x

h () {
    local __doc__="tail history for half a screen"
    local _options=$(( $LINES / 2 ))
    history_tail "$@" $_options
}

# _x
# xx

alias HG=$(which hg 2>/dev/null) # With apologies, but don't really use it

h1 () {
    history_tail 2 | head -n 1
}

hd () {
    vim_diff -o "$@"
}

alias hg=history_grep
alias hh=history_head

hl () {
    h "$@" | less
}

alias ht=history_tail
alias hv=history_vim

# xxx

hgt () {
    local __doc__="grep and tail history"
    hg "$@" | tail
}

hgv () 
{ 
    local __doc__="edit history";
    local _vim_suffix=+
    if [[ -n $* ]]; then
        _vim_suffix=+/"$@";
        [[ "$@" =~ ^+ ]] && _vim_suffix="$@";
    fi
    h "$@" > ~/tmp/history.tmp
    vim ~/tmp/history.tmp $_vim_suffix;
    rr ~/tmp/history.tmp
}


# history_xxxx+

history_parse () {
    HISTTIMEFORMAT= history "$@" | sed -e "s/^ *[0-9]*  //"  | grep -v -e "^\<\(history\(_[a-z-]*\)*\|[Hh][Gghnt]\|h [0-9][0-9]*$\)\> "
}

history_view () {
    local __doc__="view history"
    local _viewer=
    whyp_executable "$1" && _viewer="$1"
    [[ $_viewer ]] && shift || _viewer=tail
    local _options="-n $(( $LINES - 7 ))"
    [[ $1 == -n ]] && shift
    if [[ $1 =~ ^[0-9] ]]; then
        _options="-n $1"
        shift
    fi
    history_parse "$@" | $_viewer $_options
}

history_head () {
    history_view head "$@"
}

history_grep () {
    local __doc__="grep in history"
    [[ $1 =~ (-h|--help) ]] && ww hg && return 0
    local _back=
    [[ $1 =~ -B[0-9] ]] && _back=$1 && shift
    local _sought="$@"
    history_parse | sed -es':^ *::' -e 's: *$::' | grep --color $_back "${_sought/ /.}"
}

history_tail () {
    history_view tail "$@"
}

history_vim () {
    local __doc__="edit history"
    history_parse "$@" > ~/tmp/history.tmp
    local _vim_suffix=+
    if [[ -n $* ]]; then
        _vim_suffix=+/"$@"
        [[ "$@" =~ ^+ ]] && _vim_suffix="$@"
    fi
    vim ~/tmp/history.tmp $_vim_suffix
}

#! /usr/bin/env kat -n

. ~/bash/history.sh


# _
# x

I () {
    printf "%s" "$*"
}

#! /bin/cat

. ~/bash/jabnet.sh
. ~/keys/k.sh

# x

j () {
    cde ~/jab
    clear
    lo
}

# xx

jj () {
    cde_activate_venv ~/jab/.venv
}

jjj () {
    . ~/jab/__init__.sh
}

# xxx

#! /bin/cat

# x

k () {
    local _dir="$1"; shift
    [[ -z "$_dir" ]] && _dir=.
    [[ -d "$_dir" ]] || return 1
    cd $_dir; 
    "$@"
}

# xx

kk () {
    clear
    k "$@" && ranger
}

kl () {
    kk "$@"
    l
}

kv () {
    (k $1 || return 1
    shift
    vim -p "$@" && gsi)
    return 0
}

# xxx

kkk () {
    :  # Name reserved
}


#! /bin/cat

# x

l () {
    show_run_command $(_ls_command) "$@"
}

# xx

l0 () {
    ll -htrLo "$@"
}

la () {
    l -a "$@"
}

lg () {
    l -g "$@"
}

lh () {
    l -lh  "$@"
}

ll () {
    local _long_option=-l
    local _dir_option=
    if [[ -d "$1" ]]; then
        _dir_option=-d
        [[ "$1" =~ /$ ]] && _dir_option=-a
        [[ "$1" =~ ^[.]*$ ]] && _dir_option=-a
    fi
    l $_long_option $_dir_option "$@"
}

lo () {
    l -C "$@"
}

lr () {
    l -tr "$@"
}

lt () {
    l -t "$@"
}

lx () {
    l -xtr "$@"
}

ly () {
    local _dir=.
    [[ -d "$1" ]] && _dir="$1" 
    l ${_dir}/*.py
}

# xxx

lao () {
    l -1 -a "$@"
}

lal () {
    l -a -l "$@"
}

llg () {
    local _grep=$1; shift
    if [[ -n "$@" ]]; then
        if [[ -d "$1" ]]; then
            local _dir="$1"
            shift
            ll "$_dir/" "$@"
        else
            ll "$@" 
        fi
    else
        ll ./
    fi | g $_grep
}

lll () {
    ll -tr "$@"
}

llr () {
    lr -l "$@"
}

ltr () {
    lt -r "$@"
}

loa () {
    lo -a
}

# xxxx

llll () {
    lll -a "$@"
}

lotr () {
    lo -tr "$@"
}

# _xxxxxxxxx

_ls_option () {
    $(_ls_program)  --help 2>/dev/null | grep -q -- $1
}

# _xxxxxxxxxx

_ls_command () {
    # echo "$(_ls_program)"      "$(_ls_options)"
      echo "  $LS_PROGRAM "      "  $LS_OPTIONS "
    # echo "  $LS_PROGRAM " "$@" "  $LS_OPTIONS "
}

_ls_program () {
    local __doc__="""Use ls by default, or gls if available (e.g. macOS)"""
    if [[ -z $LS_PROGRAM ]]; then
        LS_PROGRAM=$(which ls 2>/dev/null)
        local _gls=$(which gls 2>/dev/null)
        [[ -x "$_gls" ]] && LS_PROGRAM="$_gls"
    fi
    echo $LS_PROGRAM
}

_ls_options () {
    local __doc__="""Use available options"""
    if [[ -z $LS_OPTIONS ]]; then
        LS_OPTIONS="-h -1"
        if _ls_option --color; then
            LS_OPTIONS="$LS_OPTIONS --color"
            _ls_option --group-directories-first && LS_OPTIONS="$LS_OPTIONS --group-directories-first"
            _ls_option --classify && LS_OPTIONS="$LS_OPTIONS --classify"
        else
            # BSD / macOS has older names for --color and --classify
            _ls_option -G && LS_OPTIONS="$LS_OPTIONS -G"
            _ls_option -F && LS_OPTIONS="$LS_OPTIONS -F"
        fi
    fi
    echo $LS_OPTIONS
}

export LS_PROGRAM=$(LS_PROGRAM= _ls_program)
export LS_OPTIONS=$(LS_OPTIONS= _ls_options)
#! /bin/cat


# _
# x
alias m=echo

# x_
# xx
# xxx

std () {
    local std_="$1"
    shift
    "$@"  > $std_.out 2> $std_.err
}

mvm () {
    std "$HOME/logs/mvim" /Applications/MacVim.app/Contents/bin/mvim --remote-tab "$@"
}

mvv () {
    local vimrc_=="~/.vimrc ~/.vim/mvimrc ~/keys/v.sh" types_==~/hub/pysyte/types/ sources_="$types_/sources.py $types_/test/sources.test"
    local log_="$HOME/logs/mvv" args_= 
    [[ "$@" ]] || args_="$vimrc_ $sources_"
    mvm "$@" $args_
}

#! /bin/cat


# _
# x
# _x
# xx

alias n=echo

#! /bin/cat


# _
# x
# _x
# xx

alias o=echo

#! /bin/cat

# _x
# _xx
# _xxx
# _xxxx
# _xxxxx
# _xxxxxx

. ~/bash/python.sh

# x

p () {
    py "$@"
}

# xx

pd () {
    python -m doctest -o REPORT_ONLY_FIRST_FAILURE -o FAIL_FAST "$@"
}

# xxx

ppp () {
    pyth pai "$@"
}

# xxxx

pypu () {
    pyth pudb "$@"
}
#! /bin/cat


# x
# _
# x
# _x

,. () {
    [[ -f .cd ]] && . .cd
}

,, () {
    cde . "$@"
}

,c () {
    . $CDE.sh
}

,w () {
    . $WHYP.sh
}

#! /bin/cat

. ~/jab/src/bash/queue.sh

# quit may be defined in queue.sh
# x
# _

q () {
    quit
}

alias Q="exit 0"

# xx
# _x
# _xx
# xxx
#! cat

# x

r () {
    [[ -z "$@" ]] && ra . || rm -vrf "$@"
}


# xx

ri () {
    local _argc=${#*}
    if [[ $_argc == 1 ]]; then
        [[ -d "$1" ]] && chewed_rri "$1"
    else
        rri "$@"
    fi
}

_chewed="I been chewed out before"

chew () {
    echo "Landa: You'll be shot for this"
    echo "Aldo: Nah, I don't think so, more like chewed out. $_chewed"
}

chewed_rri () {
    [[ -d "$2" || -d "$1" ]] && (
        chew
    )
    rri "$@"
}


scalp_hermann () {
    (
    echo "Landa: Are you mad? What have you done? I made a deal with your general for that man's life!"
    echo ""
    echo "Aldo: Yeah, they made that deal, but they don't give a fuck about him. They need you"
    ) 
}

rr () {
    local _interactive= _path= _options=
    if [[ "$1" == '-i' ]]; then
        _interactive=1
        shift
    fi
    if [[ "$1" =~ ^/[^/]*$|^[./]*$|^$HOME[/]*$ ]]; then
        echo "Will not remove $1" >&2
        return 1
    fi
    local _real_home=$(realpath $HOME)
    if [[ $(realpath "$@") == "$_real_home" ]]; then
        scalp_hermann 
        return 1
    fi
    for p in "$@"; do
        if [[ "$p" == "/" ]];  then
            echo $_chewed
            return
        fi
        if [[ -e "$p" ]]; then
            _paths="${_paths}${_sep}${p}"
            _path=$(realpath "$p")
            [[ -e "$_path" ]] || continue
            if [[ "$_path" == "$_real_home" ]]; then
                scalp_hermann
            fi
            [[ -d "$_path" ]] && _options='-r'
            if [[ -n $_interactive ]]; then
                chewed_rri $_options "$_path"
            else
                rm -f $_options "$p"
            fi
        fi
    done
}

# xxx

rri () {
    read -n1 -p "rm $@ [Y]" reply
    [[ $reply =~ [qQ] ]] && return 1
    [[ $reply =~ (^$|[yY]) ]] || return 0
    local _result=1
    local _opts='-f'
    for path in "$@"; do
        [[ -e "$path" ]] || continue
        _result=0
        _opts='-f'
        [[ -d "$path" ]] && _opts='-rf'
        rm $_opts "$path"
    done
    return $_result
}

rrr () {
    # Scalp Hans too
    sudo rm -rf "$@" 2> /tmp/std/err
}
#! /bin/cat


source ~/hub/whyp/whyp.sh

# _
# x
s () {
    local __doc__="""s is for sourcing"""
    . "$@"
}

# _x
# xx
sa () {
    s $(aliases)
}

sb () {
    s ~/bash/__init__.sh
}

sf () {
    s $(functons)
}

# _xx
# xxx

ses () {
    local _old="$1"; shift
    local _new="$1"; shift
    echo "$@" | sed -e "s,$_old,$_new,"
}

sla () {
    s $(aliases -l)
}

sgf () {
    s $(functons -g)
}

slf () {
    s $(functons -l)
}

swf () {
    s $(functons -w)
}

#! /bin/cat

# x

t () {
    c "$@"
    tig -- .
}

# xx

tt () {
    try .
}

tx () {
    if echo $1 | grep -q "gz$"; then
        contents=tz
        extract=xz
    else
        contents=t
        extract=x
    fi
    tar ${extract}f $1
    cd $(tar ${contents}f $1 | hd1)
    ra
}

#! /bin/cat


# _
# x
# _x
# xx

alias u=echo

#! /bin/cat

type mvv >/dev/null 2>&1 || . ~/keys/m.sh

# x

v  () {
    mvv "$@"
#   vim -p "$@"
}

alias V=VIM

v. () {
    v .
}

# va

vb () {
    v "$@"
}

vc () {
    local _dot_cd
    [[ -f .cd ]] && _dot_cd=.cd
    v $CDE.sh ~/hub/cde/cde/ ~/keys/c.sh $_dot_cd
}

vd () {
    vim_diff -O "$@"
}

# ve
# vf
# vg
# vh
# vi


vj () {
    (cd ~/jab; mvv ~/jab; gsi)
}

# vk
# vl
# vm
# vn

vo () {
    local _command=$(history -p !-1)
    v $($_command 2>/dev/null)
}

# vp

vq () {
    v "$@"
}

vr () {
    local _command=$(history -p !-1)
    v $($_command >/dev/null)
}

# vs

vt () {
    python ~/jab/src/python/vim_traceback.py "$@"
}

vu () {
    __doc__="Edit vim files in ~/jab. Add home vim files if different"
    local _vimrc="~/jab/vim/vimrc"; diff -q ~/.vimrc $_vimrc || _vimrc="~/.vimrc $_vimrc"
    local _vim="~/jab/vim/vimrc"; diff -qr ~/.vim $_vim >/dev/null || _vim="~/.vim $_vim"
    v $_vimrc $_vim
}

vv () {
    vim -p "$@"
}

vw () {
    v $WHYP.sh "$@"
}

# vx

vy () {
    v $(ls *.py | grep -v '__*.py*')
}

# vz
# xxx

# vaf

vat () {
    vimcat "$@"
}

vd1 () {
    vd ~/one "$@"
}

vdd () {
    local _vim_mark=_vim_
    local _vim_files=$(find . -type f -name "*$_vim_mark")
    for _vim_file in $_vim_files; do
        _vim_rlf=$(readlink -f $_vim_file)
        _vim_dir=$(dirname_ $_vim_rlf)

        _vim_name=$(basename_ $_vim_rlf)
        _vim_stem="${_vim_name/$_vim_mark/}"
        _vim_back="${_vim_stem}$_vim_mark"
        # echo "file: $_vim_file"
        # echo "readlink: $_vim_rlf"
        # echo "name: $_vim_name"
        # echo "stem: $_vim_stem"
        # echo "back: $_vim_back"
        # echo "dir: $_vim_dir"

        [[ -d "$_vim_dir" ]] || echo "not -d $_vim_dir"
        [[ -d "$_vim_dir" ]] || continue

        (
        # echo "cd $_vim_dir"
            cd $_vim_dir
            if [[ -f "$_vim_stem" ]]; then
                ls -l "$_vim_stem"
                if [[ -f "$_vim_back" ]]; then
                    ls -l "$_vim_back"
                    vd $_vim_back $_vim_stem
                    rri $_vim_back
                # else
                    # echo "not -f $_vim_back"
                fi
            # else
                # echo "not -f $_vim_stem"
            fi
        )
        echo
    done
}

vdf () {
    [[ -f ~/tmp/fred.vim ]] && vd ~/tmp/fred.vim "$1"
}

ved () {
    # https://www.reddit.com/r/vim/comments/53mhut/using_vim_like_awk/d7ude9m
    vim - -u NONE -es '+1' "+$*" '+%print' '+:qa!' | tail -n +2
}

vfd () {
    v $(fd "$@")
}

vin () {
    vim -c "setlocal buftype=nofile bufhidden=hide noswapfile" -
}

vlo () {
    v_safely $(locate "$@")
}

vtc () {
    vtr -c
}

vtr () {
    python ~/jab/src/python/tracebacks.py -e "$@"
}

vtt () {
    local _crappy_program_py=$1
    python _crappy_program_py | python ~/jab/src/python/vim_traceback.py
}

vvb () {
    vvf sh.vim
}

vvf () {
    vvv ftplugin/$1
}

vvg () { gv ~/jab/vim/gvimrc
}

vvp () {
    vvf python
}

vvy () {
    vvf python/jab.vim
}


vvu () {
    __doc__="Edit ~/jab/vim files and ~/vim files if different"
    local _vimrc="$HOME/jab/vim/vimrc"; diff -q $HOME/.vimrc $_vimrc || _vimrc="$HOME/.vimrc $_vimrc"
    local _vim="$HOME/jab/vim"; diff -qr $HOME/.vim $_vim >/dev/null || _vim="$HOME/.vim $_vim"
    vvv $_vimrc $_vim "$@"
}

vvv () {
    v ~/.vimrc ~/.vim "$@"
}

VIM () {
    sudo vim -p "$@"
}

# xxxx

hd12 () {
    hd ~/one ~/two
}

vd12 () {
    vd ~/one ~/two
}

vd13 () {
    vd ~/one ~/three
}

vd23 () {
    vd ~/two ~/three
}

vims () {
    whiches vim
}

vini () {
    v $(find $( rlf ~/jab ) -name __init__.sh | lines_to_spaces)
}

vvpj () {
    vvf python/jab.vim
}

vvvv () {
    (cd ~/jab/vim "$@" ; gsi)
}

# xxxxx

vimpy () {
    if [[ -z $* ]]; then
        vim_none
        return 0
    fi
    local _script=$(python ~/jab/src/python/vim.py "$@")
    status=$?
    if [[ $status == 0 && -f "$_script" ]]; then
        bash $_script
        return $?
    fi
    [[ $status == 0 ]] || echo Python error: $status
    if [[ -f $_script ]]; then
        echo "Script produced, you could run it with"
        echo "    bash $_script"
        echo "or debug the problem with"
        echo "    pudb ~/jab/src/python/vim.py" "$@"
    else
        echo "No script produced please try"
        echo "    pudb ~/jab/src/python/vim.py" "$@"
    fi
    return 1
}

vd123 () {
    vd ~/one ~/two ~/three
}

# xxxxxx
# xxxxxxx
# xxxxxxxx

vim_diff () {
    local one_ ="$1" two_="$2" three_= edit_opts= opt_=
    shift 2
    (
        EDITOR="vim -d "
        for opt_ in "$@"
        do
            [[ $opt_ =~ ^-.* ]] && edit_opts="$edit_opts $opt_" && continue
            [[ ! $three_ ]] && [[ -e "$opt" ]] && three_=$opt_
        done
        if ! _any_diff "$one_ " "$two_" "$three_"; then
            echo same
            return 0
        fi
        $EDITOR "$one_ " "$two_" "$three_"
    )
}

v_safely () {
    local __doc__="""Use a safe vim function"""
    vv "$@"
}


vvvvv () {
    [[ $1 ]] && vim_none || vim_some "$@"
}

vim_none () {
    (echo "" > ~/tmp/fred
    $EDITOR ~/tmp/fred)
}

vim_some () {
    script=$(python ~/jab/src/python/vim.py "$@")
    status=$?
    if [[ $status == 0 ]]; then
        if [[ -n $script ]]; then
            if [[ -f "$script" ]]; then
                bash $script
                #rr $script
            else
                echo $script is not a file >&2
            fi
        else
            python ~/jab/src/python/vim.py -U "$@"
        fi
    else
        echo Python error: $status
        if [[ -n $script ]]; then
            echo Script produced you could run it with
            echo "  bash $script"
            echo or debug the problem with
            echo "  pudb ~/jab/src/python/vim.py" "$@"
        else
            echo No script produced please try
            echo pudb ~/jab/src/python/vim.py "$@"
        fi
    fi
}
#! /bin/cat


# # x
# 
# w () {
#     what_w "$@"
# }
# 
# # xx
# 
# ww () {
#     what_ww "$@"
# }
# 
# # xxx
# 
# www () {
#     what_www "$@"
# }
# 
# # xxxx
# # xxxxx
# # xxxxxx
# 
# what_ww () {
# . ~/hub/whyp/whyp.sh
#     local __doc__='whyp(all arguments (whether they like it or not))'
#     PASS=0
#     FAIL=1
#     [[ -z "$@" ]] && return $FAIL
#     [[ $1 == -q ]] && return whyp "$@"
#     if [[ $(type -t $1) == "file" ]]; then
#         what_file $1
#         return $PASS
#     fi
#     whype -v "$@" && return $PASS
#     echo $1 not found
#     what_ww ${1:0:${#1}-1} && return $PASS
#     return $FAIL
# }
# 
# # xxxxxxx
# 
# what_w () {
# . ~/hub/whyp/whyp.sh
#     local __doc__='Show whether the first argument is a text file, alias or function'
#     if is_existing_alias $1; then
#         alias $1
#     elif is_existing_function $1; then
#         _parse_function $1
#         echo vim $path_to_file +$line_number "+/\"^$1 \""
#     elif which $1 >/dev/null 2>&1; then
#         real_file=$(realpath $(which $1))
#         if [[ $real_file != $1 ]]; then
#             echo "$1 -> $real_file"
#         fi
#         ls -l $(realpath $(which $1))
#     else type $1
#     fi
# }
# 
# # xxxxxxxx
# 
# what_www () {
#     . ~/hub/whyp/whyp.sh
#     (DEBUGGING=www;
#     local _command=$1; shift
#     ww $_command;
#     w $_command;
#     if is_existing_function $_command; then
#         (set -x; $_command "$@")
#     elif is_existing_alias $_command; then
#         (set -x; $_command "$@")
#     elif file $_command  | grep -q -e script -e text; then
#         what_wwm $_command "$@"
#     else
#         echo 0
#     fi)
# }

#! /bin/cat


# _
# x
# _x
# xx

x () {
    exit 1
}


#! /bin/cat


# _
# x
# _x
# xx

alias y=echo

#! /bin/cat



# x
# _
# xx

zm () {
    du -cms "$1" | sort -n | sed -e "s/\t/    /" -e "s/    / Mb /g"
}

zz () {
    du -sh "$*"
}

# _x
# _xx
# xxx

# . ~/jab/src/bash/zoo.sh

zzz () {
    df -h
}

#! /bin/cat


# _
# x
# _x
# xx


. ~/hub/ackvim/ackvim.sh

# a is defined in ackvim.sh

# _x
# xx

# aa is in ackvim.sh

# _xx

_av () {
    (cd $1; vack "$@")
}

# xxx

# aaa also ackvim.sh

avb () {
    __doc__="vack all args in ~/jab/src/bash";
    _av ~/jab/src/bash "$@"
}

avg () {
    __doc__="vack all args in ~/src/git";
    _av ~/src/git "$@"
}

avh () {
    __doc__="vack all args in ~/hub";
    _av ~/hub "$@"
}

avj () {
    __doc__="vack all args in ~/jab";
    _av ~/jab "$@"
}

avp () {
    __doc__="vack all args in ~/jab/src/python";
    _av ~/jab/src/python "$@"
}

avs () {
    __doc__="vack all args in ~/src";
    _av ~/src "$@"
}

avu () {
    __doc__="vack all args in ~";
    _av ~ "$@"
}

avv () {
    __doc__="vack all args in ~/jab/vim";
    _av ~/jab/vim "$@"
}


#! /bin/cat


# _
# x
# _x
# xx

alias b=echo
alias bt="set -eu; source ~/bash/bashtrace.sh"

#! /bin/cat



# x

c () {
    cde "$@"
}

# _
# xx

cb () {
    cde ~/bots/bots/bots
}

if [[ ! $ALIAS_CC ]]; then
    unalias cc 2>/dev/null

cc () {
    c $CDE.sh
}
fi

cg () {
    local _where=.
    [[ "$*" ]] && _where="$@"
    c $(git -C "$_where" rev-parse --show-toplevel)
}

ch () {
    cde ~/hub/
}

cj () {
    cde ~/jab/
}

cl () {
    clear
    l "$@"
}

cr () {
    clear
}

# cp is hashed (/usr/local/gnu/cp)

cw () {
    cde $WHYP.sh
}

cv () {
    cde $1; v $(basename_ $1)
}

cy () {
    cde ~/hub/pysyte
}

# _x
# xxx
# _xx

can () {
    cat -n "$@"
}

ib () { cn ~/.bashrc
}

cjy () {
    cd ~/jab/src/python "$@"
}

clf () {
    cat ~/jab/local/functons.sh
}

cla () {
    clear
    la "$@"
}

clo () {
    clear
    lo "$@"
}

cloa () {
    clear
    loa "$@"
}

cloo () {
    cde $(locate "$@")
}

# xxxx
calf () {
    cat ~/jab/local/functons.sh
}

# _xxx
# xxxxx

clean () {
    rf -q "$@"
}

# _xxxx
# xxxxxx
# _xxxxx

#! /bin/cat


# _
# x
# _x
# xx

alias d=echo

ddf () {
    local __doc__="""where the arg came from"""
    ( shopt -s extdebug; declare -F "$1" )
}

#! /bin/cat


# _
# x
# _x
# xx

#
# These e*() functions show result of last command
#      $ ls /bin && et || ef
# Especially used in CLI to show conditions
#      $ [[ -d /bin ]] && et || ef
# "&& et || ef" was abbreviated to etf
#      $ [[ -d /bin ]]; etf 
# Can also be used as command
#      $ etf test -d /bin 
# 
ef () {
    [[ $? == 0 ]] && return $? || eff $?
    local __doc__="""fail fast, or show angrier faces"""
}

et () {
    [[ $? == 0 ]] && ett $? || return $?
    local __doc__="""show a happy face :-) Or let the other ones out"""
}

quietly unalias eg
eg () {
    env | g "$@"
}

# xxx

eff () {
    local __doc__="""Errors from a failed command"""
    local _status=$1
    echo "False $_status $(face $_status)" >&2
    false
}

eft () {
    local __doc__="""Errors from a command, or the one before"""
    ( [[ $@ ]] && "$@" )
    etf
}

etf () {
    wtf $?
    local __doc__="""Errors from a status"""
}

ett () {
    local __doc__="""Errors from a successful command"""
    local _status=$1
    echo "True $_status $(face $_status)" >&1
    true
}

wtf () {
    local _status=$?
    local __doc__="""Errors from a status"""
    [[ $1 ]] && _status=$1 && shift
    local _name=True
    local _streams=
    [[ $1 =~ -[qQ] ]] || _streams='>&1'
    [[ $_status == 0 ]] ||_name=False
    [[ $_name == True ]] || _streams="$_streams >&2"
    [[ $1 =~ -[Q] ]] && _streams=
    _message="$_name $_status $(face $_status)" 
    echo $_message $_streams
    [[ $_name == False ]] && return $_status
    true
}

# _xx
# xxx

err () {
    "$@" >/dev/null 2>&1
    er
}

# xxxxx

face () {
    local _faces=(😎 👿  👎  💀  👻  💩  🤨   😐  😑  😥  😮  😫  😲  ☹️  😤  😢  😭  😦  😧  😨  😩  🤯   😬  😰  😱  🥵   🥶   😳  🤢  🤮)
    echo ${_faces[$1]}
}
#! /bin/cat

# . ~/jab/src/bash/f.sh


# x

f () {
    local _dir=.
    [[ -d "$1" ]] && _dir="$1" && shift
    local _type=f
    [[ $1 =~ ^[dDfF]$ ]] && _type="$1" && shift
    _type="-type $_type"
    local _name='*'
    [[ -n $1 ]] && _name="$1" && shift
    _name="-name $_name"
    find $_dir $_type $_name "$@"
}

# _
# xx

ff () {
    local _dir=.
    [[ -d "$1" ]] && _dir="$1" && shift
    find $_dir -type f -name "$@"
}

fl () {
    freds | tr ' ' '\n'
}

fn () {
    f -name "$@"
}

# _x
# xxx

fdd () {
    $(freds --debug "$@")
}

fee () {
    $(freds --edit "$@")
}

fff () {
    freds | tr ' ' '\n'
}

fll () {
    $(freds --list)
}

frr () {
    $(freds --remove "$@")
}

fpp () {
    $(freds --python "$@")
}

fss () {
    $(freds --shell "$@")
}

vfd () {
    vim -p $(fd "$@")
}

vff () {
    $(freds --edit "$@")
}

# _xx
# xxxx

bash_null () {
    echo ~/bash/null 
}

fynd () {
    local _options=
    [[ $# == 1 ]] && _options=". -name"
    sudo find $_options "$@"
}

fynd.old () {
    if [[ "$@" =~ -name ]]; then
        echo "Do not use '-name'" >&2
        return 1
        shift
    fi
    dir=
    local _argc=${#*}
    if [[ $_argc > 1 ]]; then
        shift_dir "$@" && shift
    elif [[ -z $dir ]]; then
        dir=$(realpath $(pwd))
    fi
    local _debug=$dir
    local _arg=$1; shift
    local _type=
    if [[ $_arg == "-type" ]]; then
        local _type_type=$1; shift
        _type="-type $_type_type"
        _arg=$1; shift
    fi
    local old_ifs=$IFS
    IFS=";"
        for FOUND in $(find $(realpath "$dir") -name "$_arg" -print "$@" 2>/dev/null | tr '\n' ';')
    do
        relpath -s $FOUND
    done
    IFS=$old_ifs
}
# _xxx
# xxxxx

ffind () {
    local __doc__="ff $dir $filename # finds files with that name in that dir"
    shift_dir "$@" && shift
    filename=$1; shift
    find $dir -type f -name $filename "$@"
}
# _xxxx
# xxxxxx
# _xxxxx
#! /bin/cat


# _
# x
# _x
# xx

g () {
    $(which egrep) --color "$@"
}


#! /usr/bin/env kat -n

. ~/bash/history.sh
. ~/bash/keyboard/v.sh


# _
# x

h () {
    local __doc__="tail history for half a screen"
    local _options=$(( $LINES / 2 ))
    history_tail "$@" $_options
}

# _x
# xx

alias HG=$(which hg 2>/dev/null) # With apologies, but don't really use it

h1 () {
    history_tail 2 | head -n 1
}

hd () {
    vim_diff -o "$@"
}

alias hg=history_grep
alias hh=history_head

hl () {
    h "$@" | less
}

alias ht=history_tail
alias hv=history_vim

# xxx

hgt () {
    local __doc__="grep and tail history"
    hg "$@" | tail
}

hgv () 
{ 
    local __doc__="edit history";
    local _vim_suffix=+
    if [[ -n $* ]]; then
        _vim_suffix=+/"$@";
        [[ "$@" =~ ^+ ]] && _vim_suffix="$@";
    fi
    h "$@" > ~/tmp/history.tmp
    vim ~/tmp/history.tmp $_vim_suffix;
    rr ~/tmp/history.tmp
}


# history_xxxx+

history_parse () {
    HISTTIMEFORMAT= history "$@" | sed -e "s/^ *[0-9]*  //"  | grep -v -e "^\<\(history\(_[a-z-]*\)*\|[Hh][Gghnt]\|h [0-9][0-9]*$\)\> "
}

history_view () {
    local __doc__="view history"
    local _viewer=
    whyp_executable "$1" && _viewer="$1"
    [[ $_viewer ]] && shift || _viewer=tail
    local _options="-n $(( $LINES - 7 ))"
    [[ $1 == -n ]] && shift
    if [[ $1 =~ ^[0-9] ]]; then
        _options="-n $1"
        shift
    fi
    history_parse "$@" | $_viewer $_options
}

history_head () {
    history_view head "$@"
}

history_grep () {
    local __doc__="grep in history"
    [[ $1 =~ (-h|--help) ]] && ww hg && return 0
    local _back=
    [[ $1 =~ -B[0-9] ]] && _back=$1 && shift
    local _sought="$@"
    history_parse | sed -es':^ *::' -e 's: *$::' | grep --color $_back "${_sought/ /.}"
}

history_tail () {
    history_view tail "$@"
}

history_vim () {
    local __doc__="edit history"
    history_parse "$@" > ~/tmp/history.tmp
    local _vim_suffix=+
    if [[ -n $* ]]; then
        _vim_suffix=+/"$@"
        [[ "$@" =~ ^+ ]] && _vim_suffix="$@"
    fi
    vim ~/tmp/history.tmp $_vim_suffix
}

#! /usr/bin/env kat -n

. ~/bash/history.sh


# _
# x

I () {
    printf "%s" "$*"
}

#! /bin/cat

. ~/bash/jabnet.sh
. ~/keys/k.sh

# x

j () {
    cde ~/jab
    clear
    lo
}

# xx

jj () {
    cde_activate_venv ~/jab/.venv
}

jjj () {
    . ~/jab/__init__.sh
}

# xxx

#! /bin/cat

# x

k () {
    local _dir="$1"; shift
    [[ -z "$_dir" ]] && _dir=.
    [[ -d "$_dir" ]] || return 1
    cd $_dir; 
    "$@"
}

# xx

kk () {
    clear
    k "$@" && ranger
}

kl () {
    kk "$@"
    l
}

kv () {
    (k $1 || return 1
    shift
    vim -p "$@" && gsi)
    return 0
}

# xxx

kkk () {
    :  # Name reserved
}


#! /bin/cat

# x

l () {
    show_run_command $(_ls_command) "$@"
}

# xx

l0 () {
    ll -htrLo "$@"
}

la () {
    l -a "$@"
}

lg () {
    l -g "$@"
}

lh () {
    l -lh  "$@"
}

ll () {
    local _long_option=-l
    local _dir_option=
    if [[ -d "$1" ]]; then
        _dir_option=-d
        [[ "$1" =~ /$ ]] && _dir_option=-a
        [[ "$1" =~ ^[.]*$ ]] && _dir_option=-a
    fi
    l $_long_option $_dir_option "$@"
}

lo () {
    l -C "$@"
}

lr () {
    l -tr "$@"
}

lt () {
    l -t "$@"
}

lx () {
    l -xtr "$@"
}

ly () {
    local _dir=.
    [[ -d "$1" ]] && _dir="$1" 
    l ${_dir}/*.py
}

# xxx

lao () {
    l -1 -a "$@"
}

lal () {
    l -a -l "$@"
}

llg () {
    local _grep=$1; shift
    if [[ -n "$@" ]]; then
        if [[ -d "$1" ]]; then
            local _dir="$1"
            shift
            ll "$_dir/" "$@"
        else
            ll "$@" 
        fi
    else
        ll ./
    fi | g $_grep
}

lll () {
    ll -tr "$@"
}

llr () {
    lr -l "$@"
}

ltr () {
    lt -r "$@"
}

loa () {
    lo -a
}

# xxxx

llll () {
    lll -a "$@"
}

lotr () {
    lo -tr "$@"
}

# _xxxxxxxxx

_ls_option () {
    $(_ls_program)  --help 2>/dev/null | grep -q -- $1
}

# _xxxxxxxxxx

_ls_command () {
    # echo "$(_ls_program)"      "$(_ls_options)"
      echo "  $LS_PROGRAM "      "  $LS_OPTIONS "
    # echo "  $LS_PROGRAM " "$@" "  $LS_OPTIONS "
}

_ls_program () {
    local __doc__="""Use ls by default, or gls if available (e.g. macOS)"""
    if [[ -z $LS_PROGRAM ]]; then
        LS_PROGRAM=$(which ls 2>/dev/null)
        local _gls=$(which gls 2>/dev/null)
        [[ -x "$_gls" ]] && LS_PROGRAM="$_gls"
    fi
    echo $LS_PROGRAM
}

_ls_options () {
    local __doc__="""Use available options"""
    if [[ -z $LS_OPTIONS ]]; then
        LS_OPTIONS="-h -1"
        if _ls_option --color; then
            LS_OPTIONS="$LS_OPTIONS --color"
            _ls_option --group-directories-first && LS_OPTIONS="$LS_OPTIONS --group-directories-first"
            _ls_option --classify && LS_OPTIONS="$LS_OPTIONS --classify"
        else
            # BSD / macOS has older names for --color and --classify
            _ls_option -G && LS_OPTIONS="$LS_OPTIONS -G"
            _ls_option -F && LS_OPTIONS="$LS_OPTIONS -F"
        fi
    fi
    echo $LS_OPTIONS
}

export LS_PROGRAM=$(LS_PROGRAM= _ls_program)
export LS_OPTIONS=$(LS_OPTIONS= _ls_options)
#! /bin/cat


# _
# x
alias m=echo

# x_
# xx
# xxx

std () {
    local std_="$1"
    shift
    "$@"  > $std_.out 2> $std_.err
}

mvm () {
    std "$HOME/logs/mvim" /Applications/MacVim.app/Contents/bin/mvim --remote-tab "$@"
}

mvv () {
    local vimrc_=="~/.vimrc ~/.vim/mvimrc ~/keys/v.sh" types_==~/hub/pysyte/types/ sources_="$types_/sources.py $types_/test/sources.test"
    local log_="$HOME/logs/mvv" args_= 
    [[ "$@" ]] || args_="$vimrc_ $sources_"
    mvm "$@" $args_
}

#! /bin/cat


# _
# x
# _x
# xx

alias n=echo

#! /bin/cat


# _
# x
# _x
# xx

alias o=echo

#! /bin/cat

# _x
# _xx
# _xxx
# _xxxx
# _xxxxx
# _xxxxxx

. ~/bash/python.sh

# x

p () {
    py "$@"
}

# xx

pd () {
    python -m doctest -o REPORT_ONLY_FIRST_FAILURE -o FAIL_FAST "$@"
}

# xxx

ppp () {
    pyth pai "$@"
}

# xxxx

pypu () {
    pyth pudb "$@"
}
#! /bin/cat


# x
# _
# x
# _x

,. () {
    [[ -f .cd ]] && . .cd
}

,, () {
    cde . "$@"
}

,c () {
    . $CDE.sh
}

,w () {
    . $WHYP.sh
}

#! /bin/cat

. ~/jab/src/bash/queue.sh

# quit may be defined in queue.sh
# x
# _

q () {
    quit
}

alias Q="exit 0"

# xx
# _x
# _xx
# xxx
#! cat

# x

r () {
    [[ -z "$@" ]] && ra . || rm -vrf "$@"
}


# xx

ri () {
    local _argc=${#*}
    if [[ $_argc == 1 ]]; then
        [[ -d "$1" ]] && chewed_rri "$1"
    else
        rri "$@"
    fi
}

_chewed="I been chewed out before"

chew () {
    echo "Landa: You'll be shot for this"
    echo "Aldo: Nah, I don't think so, more like chewed out. $_chewed"
}

chewed_rri () {
    [[ -d "$2" || -d "$1" ]] && (
        chew
    )
    rri "$@"
}


scalp_hermann () {
    (
    echo "Landa: Are you mad? What have you done? I made a deal with your general for that man's life!"
    echo ""
    echo "Aldo: Yeah, they made that deal, but they don't give a fuck about him. They need you"
    ) 
}

rr () {
    local _interactive= _path= _options=
    if [[ "$1" == '-i' ]]; then
        _interactive=1
        shift
    fi
    if [[ "$1" =~ ^/[^/]*$|^[./]*$|^$HOME[/]*$ ]]; then
        echo "Will not remove $1" >&2
        return 1
    fi
    local _real_home=$(realpath $HOME)
    if [[ $(realpath "$@") == "$_real_home" ]]; then
        scalp_hermann 
        return 1
    fi
    for p in "$@"; do
        if [[ "$p" == "/" ]];  then
            echo $_chewed
            return
        fi
        if [[ -e "$p" ]]; then
            _paths="${_paths}${_sep}${p}"
            _path=$(realpath "$p")
            [[ -e "$_path" ]] || continue
            if [[ "$_path" == "$_real_home" ]]; then
                scalp_hermann
            fi
            [[ -d "$_path" ]] && _options='-r'
            if [[ -n $_interactive ]]; then
                chewed_rri $_options "$_path"
            else
                rm -f $_options "$p"
            fi
        fi
    done
}

# xxx

rri () {
    read -n1 -p "rm $@ [Y]" reply
    [[ $reply =~ [qQ] ]] && return 1
    [[ $reply =~ (^$|[yY]) ]] || return 0
    local _result=1
    local _opts='-f'
    for path in "$@"; do
        [[ -e "$path" ]] || continue
        _result=0
        _opts='-f'
        [[ -d "$path" ]] && _opts='-rf'
        rm $_opts "$path"
    done
    return $_result
}

rrr () {
    # Scalp Hans too
    sudo rm -rf "$@" 2> /tmp/std/err
}
#! /bin/cat


source ~/hub/whyp/whyp.sh

# _
# x
s () {
    local __doc__="""s is for sourcing"""
    . "$@"
}

# _x
# xx
sa () {
    s $(aliases)
}

sb () {
    s ~/bash/__init__.sh
}

sf () {
    s $(functons)
}

# _xx
# xxx

ses () {
    local _old="$1"; shift
    local _new="$1"; shift
    echo "$@" | sed -e "s,$_old,$_new,"
}

sla () {
    s $(aliases -l)
}

sgf () {
    s $(functons -g)
}

slf () {
    s $(functons -l)
}

swf () {
    s $(functons -w)
}

#! /bin/cat

# x

t () {
    c "$@"
    tig -- .
}

# xx

tt () {
    try .
}

tx () {
    if echo $1 | grep -q "gz$"; then
        contents=tz
        extract=xz
    else
        contents=t
        extract=x
    fi
    tar ${extract}f $1
    cd $(tar ${contents}f $1 | hd1)
    ra
}

#! /bin/cat


# _
# x
# _x
# xx

alias u=echo

#! /bin/cat

type mvv >/dev/null 2>&1 || . ~/keys/m.sh

# x

v  () {
    mvv "$@"
#   vim -p "$@"
}

alias V=VIM

v. () {
    v .
}

# va

vb () {
    v "$@"
}

vc () {
    local _dot_cd
    [[ -f .cd ]] && _dot_cd=.cd
    v $CDE.sh ~/hub/cde/cde/ ~/keys/c.sh $_dot_cd
}

vd () {
    vim_diff -O "$@"
}

# ve
# vf
# vg
# vh
# vi


vj () {
    (cd ~/jab; mvv ~/jab; gsi)
}

# vk
# vl
# vm
# vn

vo () {
    local _command=$(history -p !-1)
    v $($_command 2>/dev/null)
}

# vp

vq () {
    v "$@"
}

vr () {
    local _command=$(history -p !-1)
    v $($_command >/dev/null)
}

# vs

vt () {
    python ~/jab/src/python/vim_traceback.py "$@"
}

vu () {
    __doc__="Edit vim files in ~/jab. Add home vim files if different"
    local _vimrc="~/jab/vim/vimrc"; diff -q ~/.vimrc $_vimrc || _vimrc="~/.vimrc $_vimrc"
    local _vim="~/jab/vim/vimrc"; diff -qr ~/.vim $_vim >/dev/null || _vim="~/.vim $_vim"
    v $_vimrc $_vim
}

vv () {
    vim -p "$@"
}

vw () {
    v $WHYP.sh "$@"
}

# vx

vy () {
    v $(ls *.py | grep -v '__*.py*')
}

# vz
# xxx

# vaf

vat () {
    vimcat "$@"
}

vd1 () {
    vd ~/one "$@"
}

vdd () {
    local _vim_mark=_vim_
    local _vim_files=$(find . -type f -name "*$_vim_mark")
    for _vim_file in $_vim_files; do
        _vim_rlf=$(readlink -f $_vim_file)
        _vim_dir=$(dirname_ $_vim_rlf)

        _vim_name=$(basename_ $_vim_rlf)
        _vim_stem="${_vim_name/$_vim_mark/}"
        _vim_back="${_vim_stem}$_vim_mark"
        # echo "file: $_vim_file"
        # echo "readlink: $_vim_rlf"
        # echo "name: $_vim_name"
        # echo "stem: $_vim_stem"
        # echo "back: $_vim_back"
        # echo "dir: $_vim_dir"

        [[ -d "$_vim_dir" ]] || echo "not -d $_vim_dir"
        [[ -d "$_vim_dir" ]] || continue

        (
        # echo "cd $_vim_dir"
            cd $_vim_dir
            if [[ -f "$_vim_stem" ]]; then
                ls -l "$_vim_stem"
                if [[ -f "$_vim_back" ]]; then
                    ls -l "$_vim_back"
                    vd $_vim_back $_vim_stem
                    rri $_vim_back
                # else
                    # echo "not -f $_vim_back"
                fi
            # else
                # echo "not -f $_vim_stem"
            fi
        )
        echo
    done
}

vdf () {
    [[ -f ~/tmp/fred.vim ]] && vd ~/tmp/fred.vim "$1"
}

ved () {
    # https://www.reddit.com/r/vim/comments/53mhut/using_vim_like_awk/d7ude9m
    vim - -u NONE -es '+1' "+$*" '+%print' '+:qa!' | tail -n +2
}

vfd () {
    v $(fd "$@")
}

vin () {
    vim -c "setlocal buftype=nofile bufhidden=hide noswapfile" -
}

vlo () {
    v_safely $(locate "$@")
}

vtc () {
    vtr -c
}

vtr () {
    python ~/jab/src/python/tracebacks.py -e "$@"
}

vtt () {
    local _crappy_program_py=$1
    python _crappy_program_py | python ~/jab/src/python/vim_traceback.py
}

vvb () {
    vvf sh.vim
}

vvf () {
    vvv ftplugin/$1
}

vvg () { gv ~/jab/vim/gvimrc
}

vvp () {
    vvf python
}

vvy () {
    vvf python/jab.vim
}


vvu () {
    __doc__="Edit ~/jab/vim files and ~/vim files if different"
    local _vimrc="$HOME/jab/vim/vimrc"; diff -q $HOME/.vimrc $_vimrc || _vimrc="$HOME/.vimrc $_vimrc"
    local _vim="$HOME/jab/vim"; diff -qr $HOME/.vim $_vim >/dev/null || _vim="$HOME/.vim $_vim"
    vvv $_vimrc $_vim "$@"
}

vvv () {
    v ~/.vimrc ~/.vim "$@"
}

VIM () {
    sudo vim -p "$@"
}

# xxxx

hd12 () {
    hd ~/one ~/two
}

vd12 () {
    vd ~/one ~/two
}

vd13 () {
    vd ~/one ~/three
}

vd23 () {
    vd ~/two ~/three
}

vims () {
    whiches vim
}

vini () {
    v $(find $( rlf ~/jab ) -name __init__.sh | lines_to_spaces)
}

vvpj () {
    vvf python/jab.vim
}

vvvv () {
    (cd ~/jab/vim "$@" ; gsi)
}

# xxxxx

vimpy () {
    if [[ -z $* ]]; then
        vim_none
        return 0
    fi
    local _script=$(python ~/jab/src/python/vim.py "$@")
    status=$?
    if [[ $status == 0 && -f "$_script" ]]; then
        bash $_script
        return $?
    fi
    [[ $status == 0 ]] || echo Python error: $status
    if [[ -f $_script ]]; then
        echo "Script produced, you could run it with"
        echo "    bash $_script"
        echo "or debug the problem with"
        echo "    pudb ~/jab/src/python/vim.py" "$@"
    else
        echo "No script produced please try"
        echo "    pudb ~/jab/src/python/vim.py" "$@"
    fi
    return 1
}

vd123 () {
    vd ~/one ~/two ~/three
}

# xxxxxx
# xxxxxxx
# xxxxxxxx

vim_diff () {
    local one_ ="$1" two_="$2" three_= edit_opts= opt_=
    shift 2
    (
        EDITOR="vim -d "
        for opt_ in "$@"
        do
            [[ $opt_ =~ ^-.* ]] && edit_opts="$edit_opts $opt_" && continue
            [[ ! $three_ ]] && [[ -e "$opt" ]] && three_=$opt_
        done
        if ! _any_diff "$one_ " "$two_" "$three_"; then
            echo same
            return 0
        fi
        $EDITOR "$one_ " "$two_" "$three_"
    )
}

v_safely () {
    local __doc__="""Use a safe vim function"""
    vv "$@"
}


vvvvv () {
    [[ $1 ]] && vim_none || vim_some "$@"
}

vim_none () {
    (echo "" > ~/tmp/fred
    $EDITOR ~/tmp/fred)
}

vim_some () {
    script=$(python ~/jab/src/python/vim.py "$@")
    status=$?
    if [[ $status == 0 ]]; then
        if [[ -n $script ]]; then
            if [[ -f "$script" ]]; then
                bash $script
                #rr $script
            else
                echo $script is not a file >&2
            fi
        else
            python ~/jab/src/python/vim.py -U "$@"
        fi
    else
        echo Python error: $status
        if [[ -n $script ]]; then
            echo Script produced you could run it with
            echo "  bash $script"
            echo or debug the problem with
            echo "  pudb ~/jab/src/python/vim.py" "$@"
        else
            echo No script produced please try
            echo pudb ~/jab/src/python/vim.py "$@"
        fi
    fi
}
#! /bin/cat


# # x
# 
# w () {
#     what_w "$@"
# }
# 
# # xx
# 
# ww () {
#     what_ww "$@"
# }
# 
# # xxx
# 
# www () {
#     what_www "$@"
# }
# 
# # xxxx
# # xxxxx
# # xxxxxx
# 
# what_ww () {
# . ~/hub/whyp/whyp.sh
#     local __doc__='whyp(all arguments (whether they like it or not))'
#     PASS=0
#     FAIL=1
#     [[ -z "$@" ]] && return $FAIL
#     [[ $1 == -q ]] && return whyp "$@"
#     if [[ $(type -t $1) == "file" ]]; then
#         what_file $1
#         return $PASS
#     fi
#     whype -v "$@" && return $PASS
#     echo $1 not found
#     what_ww ${1:0:${#1}-1} && return $PASS
#     return $FAIL
# }
# 
# # xxxxxxx
# 
# what_w () {
# . ~/hub/whyp/whyp.sh
#     local __doc__='Show whether the first argument is a text file, alias or function'
#     if is_existing_alias $1; then
#         alias $1
#     elif is_existing_function $1; then
#         _parse_function $1
#         echo vim $path_to_file +$line_number "+/\"^$1 \""
#     elif which $1 >/dev/null 2>&1; then
#         real_file=$(realpath $(which $1))
#         if [[ $real_file != $1 ]]; then
#             echo "$1 -> $real_file"
#         fi
#         ls -l $(realpath $(which $1))
#     else type $1
#     fi
# }
# 
# # xxxxxxxx
# 
# what_www () {
#     . ~/hub/whyp/whyp.sh
#     (DEBUGGING=www;
#     local _command=$1; shift
#     ww $_command;
#     w $_command;
#     if is_existing_function $_command; then
#         (set -x; $_command "$@")
#     elif is_existing_alias $_command; then
#         (set -x; $_command "$@")
#     elif file $_command  | grep -q -e script -e text; then
#         what_wwm $_command "$@"
#     else
#         echo 0
#     fi)
# }

#! /bin/cat


# _
# x
# _x
# xx

x () {
    exit 1
}


#! /bin/cat


# _
# x
# _x
# xx

alias y=echo

#! /bin/cat



# x
# _
# xx

zm () {
    du -cms "$1" | sort -n | sed -e "s/\t/    /" -e "s/    / Mb /g"
}

zz () {
    du -sh "$*"
}

# _x
# _xx
# xxx

# . ~/jab/src/bash/zoo.sh

zzz () {
    df -h
}

