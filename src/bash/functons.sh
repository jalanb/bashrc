#! /bin/cat

Welcome_to $BASH_SOURCE

# set -e

. ~/jab/bin/first_dir.sh

# Called functons.sh because "functions" is ... something else

# sorted by strcmp of function name, underscores following
# x
# _
# xx
# _x
# xxx
# _xx

# x


,. () {
    cde . "$@"
}

b () {
    if [[ -f ./build.sh ]]; then
        bash ./build.sh
    elif [[ -f Makefile ]]; then
        make
    fi
}

g () {
    $(which grep) --color "$@"
}

t () {
    c "$@"
    tig -- .
}

h () {
    history | tel "$@"
}

x () {
    exit 1
}

y () {
    clear
    mython ~/jab/src/python/y.py "$@"
}

# xx

3d () {
    3l "$@" -d
}

3l () {
    if first_num "$@"; then
        Tree -L $num $args
    else
        Tree -L 2 "$@"
    fi
}

3y () {
    if [[ -f "$1" ]]; then
        dir=$(dirname $1)
        shift
    elif [[ -d "$1" ]]; then
        dir=$1
        shift
    else
        dir=
    fi
    3l -P "*.py" $dir "$@"  --prune | sed -e 's/^│/ /' -e 's/\\s/_/g' -e 's/[│├└]/ /g' -e 's:──:/:'
}

add () {
    echo $($1 + $2)
}

ag () {
    alias | grep "$@"
}

bd () {
    . ~/jab/src/bash/bd.sh -s "$@"
}

dp () {
    (PYTHON_DEBUGGING=-U db "$@")
}

IP () {
    local _break=yes
    if [[ $1 == all ]]; then
        _break=no
    fi
    for number in 10 172 193 192 100
    do
        if python ~/jab/src/python/ifconfig.py $number; then
            if [[ $_break == yes ]]; then
                break
            fi
        fi
    done
}

gf () {
    local __doc__="grep in any file args for other args"
    shift_dir "$@" && shift
    name=$1
    shift
    find $dir -name "$name" -exec grep --colour "$@" -nH {} \;
    local pattern=
    for arg in "$@"; do
        test ! -f "$arg" && pattern="$pattern $arg"
    done
    for arg in "$@"; do
        [[ $(type -t "$arg") == "file" ]] && grep --colour -nH --binary-files=without-match $arg $pattern
    done
}

fa () {
    fv "$@"
}

fc () {
    shift_dir "$@" && shift
    name=$1
    shift
    for path in $(find $dir -name $name -print)
    do
        echo cd $path
        [[ -f "$path" ]] && builtin cd $(dirname $path) || builtin cd $path
    done
}

fd () {
    shift_dir "$@" && shift
    if [[ -n $1 ]]; then
        name=$1
        shift
    fi
    find $dir -type d -name $name "$@"
}

fv () {
    shift_dir "$@" && shift
    if [[ -z "$@" ]]; then
        echo Nothing to find
    else
        files=$(find $(realpath $dir) -name "$@")
        if [[ -z $files ]]; then
            echo "$@" not found
        else
            echo $files | lines_to_spaces | sed -e "s:^\./::"
            vim -p $files
        fi
    fi
}

gg () {
    local readme="show grep results as vim commands"
    sought="$1"
    shift
    grep "$sought" "$@" | sed -e "s/^/vim /" -e "s|:.*| +/\"$sought\"|" | uniq
}

gv () {
    if which gvim >/dev/null 2>&1; then
        date >> ~/log/gvim.log
        echo gvim "$@" >> ~/log/gvim.log
        gvim "$@" 2>> ~/log/gvim.log
    else
        echo gvim not available >&2
        return 1
    fi
}

hd () {
    vim_diff "$1" "$2" "$3" -o
}


_free_line_here () {
    :
}

ky () {
    shift_dir "$@" && shift
    dir=${dir:-~/jab/src/python}
    kd $dir "$@"
    y .
}


ld () {
    lk -1d "$@"
}

lf () {
    locate -f "$@"
}

lj () {
    lk ~/jab "$@"
}

lh () {
    lk -lh  "$@"
}

lk () {
    LS_PROGRAM=$(which ls 2>/dev/null)
    local _gls=$(which gls 2>/dev/null)
    [[ -f $_gls ]] && LS_PROGRAM=$_gls
    export LS_PROGRAM
    local _css=
    $LS_PROGRAM  --help 2>/dev/null | grep -q -- --color && _css=--color
    $LS_PROGRAM  --help 2>/dev/null | grep -q -- --classify && _css="$_css --classify"
    local _header=
    $LS_PROGRAM  --help 2>/dev/null | grep -q -- --group-directories-first && _header=--group-directories-first
    $LS_PROGRAM $_css $_header "$@"
}

lr () {
    lk -lhtr "$@"
}

lt () {
    lk *.test*
}

lx () {
    lk -xhtr "$@"
}

ly () {
    lx *.py
}

ma () {
    local _storage=/tmp/fred.sh;
    if [[ -z "$@" ]]; then
        mython -c "print 'memo -a\"$*\"'" > $_storage;
        bash $_storage;
        cat $_storage;
        rr $_storage;
    fi
}

ml () {
    memo -l 9
}

pg () {
    ps -ef | grep -v grep | grep "$@"
}

pii () {
    local me=$USER
    local here=$(jostname)
    local options=-noconfirm_exit
    local _ipython=${IPYTHON:-ipython}
    if [[ $($_ipython --help | grep no.*confirm) == "--no-confirm-exit" ]]; then
        options=--no-confirm-exit
    fi
    console_title_on "ipython@${here}" && \
        $_ipython $options "$@" && \
        console_title_off "${me}@${here}"
}


pt () {
    ptpython "$@"
}

py () {
    if [[ -z "$@" ]]; then
        mython
    else
        all_args="$*"
        if [[ "$all_args" =~ "--help" || "$all_args" =~ "-h" ]]; then
            mython "$@"
        elif [[ "$all_args" =~ "-U" ]]; then
            mython "$@"
        else
            script=$(mython ~/jab/src/python/scripts.py -m $args 2>/dev/null)
            if [[ $? == 0 ]]; then
                if [[ -z $script ]]; then
                    script=${1/%./.py}
                    shift
                fi
                mython $script $*
            else
                mython "$@"
            fi
        fi
    fi
}

ra () {
    rara cde "$@"
}

raa () {
    rara no ~
}

ru () {
    # do da root root route, do da ru !
    if [[ -z "$@" ]]; then
        SUDO
    else
        sudo "$@"
    fi
}

tm () {
    if [[ -z $1 ]]; then SESSION=$(jostname)
    else
        SESSION=$1
        shift
    fi
    ! tmux attach-session -t $SESSION "$@" && tmux new-session -s $SESSION "$@"
}

tf () {
    [[ $? -eq 0 ]] && echo "true" || echo "false"
}

tt () {
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

va () {
    _edit_jab src/bash/aliases.sh
}

ve () {
    _edit_jab environ.d/jab.sh "$@"
}

vf () {
    _edit_jab src/bash/functons.sh "$@"
}

vj () {
    (cd ~/jab;
        v.
        gsi)
}

vy () {
    v $(ls *.py | grep -v '__*.py*')
}

sq () {
    . $GIT_BUCKET/qaz/src/bash/qazrc
}

zm () {
    du -cms "$1" | sort -n | sed -e "s/\t/    /" -e "s/    / Mb /g"
}

# xxx

add () {
    echo $(($1 + $2))
}

ask () {
    local _answer=
    read -e -n1 -p "$1 " _answer
    echo $_answer
}

ddg () {
    firefox "https://next.duckduckgo.com/?q=$*"
}

fgg () {
    fgv *.py "$@"
}

fgp () {
    fgv *.py "$@"
}

fgt () {
    fgv *.test *.tests "$@"
}

ftt () {
    fgv *.test *.tests "$@"
}
ght () {
    gh "$@" | tel
}

ghv () {
    local __doc__="edit stuff from history"
    history | grep -v "\<\(history\|gh\)\>" | sed -e "s/^ *[0-9]\+ *//" -e "s/\([JFMASOND][a-z][a-z].[0-9][0-9] - [0-9:]\+\)\( \+\)/\1=/" | vim - +/"$@"
}

gre () {
    [[ -z $* ]] && echo "gre what?" >&2 || $(which grep) -h --color=never "$@"
}

gv. () {
    PYTHONPATH=$(realpath .) gv .
}

gvd () {
    EDITOR=gvim vd "$@"
}

hd1 () {
    head -n 1 "$@"
}

hed () {
    SCREEN=$(screen_height)
    SCREEN=${LINES:-$(screen_height)}
    HALF_SCREEN=`expr $SCREEN / 2`
    HEADLINES=${HEADLINES:-$HALF_SCREEN}
    head -n ${1:-$HEADLINES} "$@"
}

hub () {
    local _directory=~/hub
    local _remote=
    [[ $( clipout ) =~ http ]] && _remote=$( clipout )
    [[ $1 =~ http ]] && _remote="$1" && shift
    local _destination=
    if [[ -n $1 ]]; then
        _destination=$(kp "$1" "$@")
        shift
        if [[ -d "$_destination" ]]; then
            _directory=$_destination
            cde "$_directory"
            _directory=
        fi
    fi
    [[ $_remote =~ http ]] && _directory=$(clone -n $_remote)
    [[ -d $_directory ]] && cde $_directory
    ranger
}

jjb () {
    kk ~/jab/src/bash "$@"
}

jjy () {
    kk ~/jab/src/python "$@"
}

kpj () {
    rsync -a -e "ssh -i $HOME/.ssh/id_jab" "$@"
}

l1d () {
    ld -1 "$@"
}

lda () {
    ls -1da "$@"
}

lff () {
    ls fred*
}

lka () {
    lk -a "$@"
}

lkk () {
    lk -a "$@"
}

lkl () {
    lkra "$@"
}

lkq () {
    local _sought=$1
    if [[ -f $_sought ]]; then
        lk $_sought
        return 0
    fi
    while [[ -n $_sought ]]; do
        if lk -d $_sought 2>/dev/null; then
            break
        fi
        _sought=$(dirname $_sought)
        if [[ $_sought == / ]]; then
            break
        fi
    done
}

lkr () {
    lk -lhtr "$@"
}

lib () {
    lr ~/.bashrc
}

lla () {
    ll -a "$@"
}

lly () {
    shift_dir "$@" && shift
    reset=$(shopt -p dotglob)
    shopt -s dotglob
    lr "$dir"/*.tests
    echo
    lr "$dir"/*.test
    echo
    lr "$dir"/*.py
    $reset
}

lr2 () {
    lra "$@" | grep --color -- "->"
}

loc () {
    locate "$@"
}

lr1 () {
    shift_dir "$@" && shift
    lk -1tr --color=always "$dir" | tel
}

lra () {
    lr -a "$@"
}

lrd () {
    lr -d "$@"
}

lrt () {
    lk --color=always -lrth "$@" | tel
}

ls1 () {
    l1 "$@" | sort
}

lsh () {
    lk *.sh
}


lyy () {
    reset=$(shopt -p dotglob)
    shopt -s dotglob
    lk -xd $(ls -F |grep \/$)
    echo
    lx *.tests 2>/dev/null
    echo
    lx *.test 2>/dev/null
    echo
    lx *.py 2>/dev/null
    $reset
}

num () {
    vim ~/jab/local/numbers.txt
}

pi2 () {
    IPYTHON="/usr/local/bin/python2 /usr/local/bin/ipython2"; pii "$@"
}
alias pi1=pi2 # I keept typo-ing on that

pi3 () {
    IPYTHON=ipython3; pii "$@"
}

ps3 () {
    if [[ -z "$@" ]]; then
        ps axf | vim - +
    else ps axf | vim - +/"$*"
    fi
}

raj () {
    pushq ~/jab
    range "$@"
    popq
}

rlf () {
    [[ -z $1 ]] && realpath . || realpath "$@"
}

sib () {
    source_path ~/.bashrc
}

sto () {
    firefox "http://stackoverflow.com/search?q=$*"
}

tel () {
    # Using "$*" instead of "$@" deliberately here
    # Side effect: args are now text, not args
    HEADLINES=${HEADLINES:-(( ${LINES:-$(screen_height)} / 2 ))}
    head -n ${1:-$HEADLINES} "$@"
    lines=$(echo "$*" | sed -e "s/ *-n.\([0-9]\+\)/\1/")
    if [[ -n $lines ]]; then
        args=$(echo "$*" | sed -e "s/^\(.*\) *-n.\([0-9]\+\)\(.*\)/\1\3/")
        echo tel $lines $args
        tail -n $lines $args
    else
        tail -n $(( ${LINES:-$(screen_height)} / 2 )) "$@"
    fi
}

tma () {
    tmux new-session -A -s jabtmux
}

tmp () {
    pushq $(mython $KD_DIR/kd.py ~/tmp "$@")
}

unalias try > /dev/null 2>&1
try () {
    TRY=~/jab/src/python/testing/try.py
    [[ -f "./try.py" ]] && TRY=./try.py
    python $TRY "$@"
}

vaf () {
    vim -p ~/jab/src/bash/aliases.sh ~/jab/src/bash/functons.sh
    source_path ~/jab/src/bash/aliases.sh
    source_path ~/jab/src/bash/functons.sh
}

vat () {
    vimcat "$@"
}

vbb () {
    vim -p ~/.bashrc ~/hub/jab/__init__.sh ~/.bash_profile "$@" +/bash
    ls -l ~/.bashrc ~/hub/jab/__init__.sh
}

vbl () {
    vim $(ls -rt1 ~/jab/log/*bashrc*.log | tail -n 1) + +?"^++ "
}

vfg () {
    _sought="$1" && shift
    vf "$@" +/$_sought
}

vfh () {
    vim -p $( $( h1 ) | space_lines ) "$@"
}

vfr () {
    mython ~/jab/src/python/vim_traceback.py "$@"
}

vgf () {
    _edit_jab src/bash/git/functons.sh "$@"
}

vla () {
    _edit_locals aliases.sh
}

vle () {
    _edit_locals environ.sh
}

vlf () {
    _edit_locals functons.sh
}

vlo () {
    v $(locate "$@")
}

vpe () {
    _edit_jab environ.d/python
}

vpr () {
    local _crappy_program_py=$1
    python _crappy_program_py | python ~/jab/src/python/vim_traceback.py
}

vtc () {
    vtr -c
}

vtr () {
    python ~/jab/src/python/tracebacks.py -e "$@"
}

VIM () {
    sudo vim "$@"
}

wtX () {
    . ~/hub/SH.sh
}

wvX () {
    vim -p ~/hub/SH.sh "$@"
}

wta () {
    . ~/hub/ack2vim/ack2vim.sh
}

wva () {
    vim -p ~/hub/ack2vim/ack2vim.sh "$@"
}

wtb () {
    . ~/bash/__init__.sh
}

wvb () {
    vim -p ~/bash "$@"
}

wtd () {
    python3 ~/hub/dotsite/setup.py develop
}

wvd () {
    vim -p ~/hub/dotsite/dotsite/ "$@"
}

wtj () {
    WELCOME_BYE=$1 . ~/jab/__init__.sh
}

wvj () {
    vim -p ~/jab/__init__.sh "$@"
}

wtk () {
    . ~/hub/kd.sh
}

wvk () {
    vim -p ~/hub/kd.sh "$@"
}

wtp () {
    python3 ~/hub/pym/setup.py develop
}

wvp () {
    vim -p ~/hub/pym/pym/edit/ "$@"
}

wvw () {
    vim -p ~/hub/what/what.sh "$@"
}

xib () {
    bash -x ~/.bashrc
}

# xxxx

bool () {
    [[ -z $* || $1 =~ ^0*$ ]] && echo False && return 1
    if what -q "$1"; then
        "$@" 2>/dev/null && echo True && return 0
        echo False; return 1
    fi
    [[ $1 =~ ^0*$ ]] && echo False || echo True
    return 0
}

brew () {
    GIT= /usr/local/bin/brew "$@"
}

bump () {
    local _bump_dir=.
    local _show=
    local _get=
    if [[ $1 == show ]]; then
        _show=1
        shift
    fi
    if [[ $1 == get ]]; then
        _get=1
        shift
    fi
    local _pulled=
    if [[ $1 == pulled ]]; then
        _pulled=1
        shift
    fi
    if [[ -d "$1" ]]; then
        bump_dir="$1"
        shift
    fi
    local _bump_root=$(git_root $_bump_dir)
    local _part=${1:-patch}; shift
    if [[ -z $_show && -z $_get ]]; then
        if [[ -n $_part ]]; then
            [[ $_pulled == 1 ]] || git pull --rebase
            cd "$_bump_root"
            if bumpversion $_part "$@"; then
                git push
                git push origin v$(bump get)
            fi
        fi
    fi
    local _config="$_bump_root/.bumpversion.cfg"
    local _sought=^current_version
    if [[ -n $_show ]]; then
        grep $_sought $_config | grep --colour '\d[0-9a-z.]\+$'
    elif [[ -n $_get ]]; then
        grep $_sought $_config | sed -e 's/.*= //'
    else
        grep $_sought $_config 2>/dev/null
    fi
}

cdra () {
    rara cd "$@"
}

dots () {
    cde ~/hub/dotsite/dotsite
}

down () {
    cde ~/Download* "$@"
    lr -a
}

init () {
    local __doc__="""LOok for __init__.sh here, there, or below and source it if found"""
    local _init=./__init__.sh
    [[ -f $_init ]] || _init=$1
    [[ -f $_init ]] || _init=bash/__init__.sh
    [[ -f $_init ]] || _init=src/bash/__init__.sh
    [[ -f $_init ]] && . $_init
}

lkra () {
    lkr -a "$@"
}

left () {
    local last_command="$1"
    echo $last_command
    local last_command_line="$@"
    echo $last_command_line
}

main () {
    shift_dir "$@" && shift
    [[ -n $* ]] && cp ~/jab/src/python/main.py $1 || cp ~/jab/src/python/main.py $dir
}

mine () {
    sudo chown -R $(id -un):$(id -gn) "$@"
}

mkcd () {
    local __doc__='make a directory and start using it';
    if [[ -d "$@" ]]; then
        echo Directory existed "$@"
    else
        mkdir -p "$@"
    fi
    cd "$@"
}

nose () {
    local _progress=
    nosetests -h 2>&1 | g -q progressive && _progress="--with-progressive"
    local _coverage=
    nosetests -h 2>&1 | g -q coverage && _coverage="--with-coverage --cover-erase --cover-html --cover-html-dir=.coverage --cover-package=."
    if nosetests -h 2>&1 | g -q stopwatch; then
        NOSE_COVER_TESTS= nosetests -A "speed!='slow'" $_coverage $_progress "$@"
    else
        NOSE_COVER_TESTS= nosetests $_coverage $_progress "$@"
    fi
}

SUDO () {
    if [[ -n $1 ]]; then
        user="-u $1"
        you_sir="$1"
    else
        user=
        you_sir=root
    fi
    me=$USER
    here=$(jostname)
    console_title_on "${you_sir}@${here}" && \
        sudo -i $user bash && \
        console_title_off "${me}@${here}"
}

dicp () {
    COMMAND_FOR_SAME_FILES=cp _dixx "$1" "$2"
}

dihh () {
    COMMAND_FOR_SAME_FILES=hd _dixx "$@"
}

divv () {
    COMMAND_FOR_SAME_FILES=vd
    _dixx "$@"
}

popq () {
    popd >/dev/null 2>&1
}

rara () {
    local _cd=$1; shift
    local _path=$(kpp "$@")
    [[ $_cd != "no" ]] && $_cd $_path
    ranger --choosedir=$HOME/.local/ranger.txt
    local _ranged=$( cat $HOME/.local/ranger.txt)
    for word in "$@"; do
        if [[ $word =~ "[-]*cd" ]]; then
            cd $(cat $_ranged)
        fi
    done
}

this () {
    python -c "import this"
}

Tree () {
    tree "$@" | more
}

vibb () {
    vim -p ~/.bashrc ~/jab/login.sh
}

vims () {
    whiches vim
}

vini () {
    vim -p $(find $( rlf ~/jab ) -name __init__.sh | lines_to_spaces)
}

# xxxxx

build () {
    if [[ -f build.sh ]]; then bash build.sh "$@"
    elif [[ -f Makefile ]]; then make "$@"
    fi
}

detab () {
    local _expand=$(which expand)
    what -q gexpand && _expand=$(what -f gexpand)
    if [[ -f "$1" ]]; then
        if grep -Pq "^\s*\t\s*[^ \t]" $1; then
            $_expand -i --tabs=4 $1 > /tmp/txt
            mv /tmp/txt $1
            echo detabbed
        else
            echo no tabs
        fi
    else
        echo not a file $1
    fi
}

fewer () {
    if [[ -n "$@" && -f "$1" ]]; then
        local _lines=$(wc -l "$1" | cut -d' ' -f1)
        if [[ $_lines -lt ${LINES:-$(screen_height)} ]]; then
            cat -n "$1"
        else
            lesen "$1"
        fi
    else
        cat -n
    fi
}

freds () {
    mython ~/jab/src/python/freds.py "$@"
}

LetGo () {
    echo 'Digger, Thumber, Tarzan, Climber'
}

paste () {
    if [[ -z "$*" ]]; then
        echo "$ $(pbpaste)"
        $(pbpaste)
    else
        echo "# $(pbpaste)"
    fi
}

clip_in () {
    pbcopy
    echo "# $(clipout)"
}

clipout () {
    echo "$(pbpaste)"
}

ptags () {
    local _source="$1"
    [[ -n $_source ]] || _source="."
    python ~/jab/src/python/ptags.py $_source
}

pushq () {
    pushd "$@"  > /dev/null 2>&1
}

quack () {
    local _result=1
    for $item in "$@"; do
        if _like_duck $item; then
            python  $1
            _result=0
        fi
    done
    return $_result
}

range () {
    local destination=.
    if [[ -n "$*" ]]; then
        local kd_script=$KD_DIR/kd.py
        if ! destination=$(PYTHONPATH=$python_directory mython $kd_script "$@" 2>&1); then
            echo "$destination"
            return 1
        fi
    fi
    local real_destination=$(PYTHONPATH=$python_directory python -c "import os; print os.path.realpath('$destination')")
    if [[ $destination != $real_destination ]]; then
        echo "ranger ($destination ->) $real_destination"
        destination=$real_destination
    elif [[ $destination != $1 && $1 != "-" ]]; then
        echo "ranger $destination"
    fi
    pushq "$destination"
    source $(which ranger) $(which ranger)
    console_whoami
    return 0
}

taocl () {
    curl -s https://raw.githubusercontent.com/jlevy/the-art-of-command-line/master/README.md |
    pandoc -f markdown -t html |
    xmlstarlet fo --html --dropdtd |
    xmlstarlet sel -t -v "(html/body/ul/li[count(p)>0])[$RANDOM mod last()+1]" |
    xmlstarlet unesc | fmt -80
}

tools () {
    (cd ~/wwts/tools/bin
    PATH=~/wwts/tools/bin:$PATH
    [[ -f ~/.virtualenvs/tools/bin/activate ]] && . ~/.virtualenvs/tools/bin/activate
    "$@"
    )
}

ylint () {
    mython /home/alanb/.jab/src/python/site/ylint.py "$@"
}

# xxxxxx

bumper () {
    if [[ -z $1 ]]; then
        echo Please specify branch to bump >&2
        return 1
    fi
    local _bump_branch=$1; shift
    local _current_branch=$(git rev-parse --abbrev-ref HEAD)
    if [[ $_current_branch != $_bump_branch ]]; then
        if git co $_bump_branch; then
            return
        fi
    fi
    git pull --rebase
    bump pulled "$@"
    git push
}

cd_one () {
    clear
    shift_dir "$@" && shift
    cde $dir
}

has_py () {
    has_ext py "$@"
}

_lesser () {
    less -R "$@"
}

lesen () {
    less -NR "$@"
}

mkenv2 () {
    _mkenv python2
}

mkenv3 () {
    _mkenv python3
}

_mkenv () {
    local _python=$1; shift
    local _pager=vin
    local _file=/tmp/mager
    mkvirtualenv -v -r pai/requirements.txt -p $_python --clear --always-copy --download "$@" 2>&1 > $_file
    [[ $(wc -l $_file) < 39 ]] && _pager="kat -n"
    $_pager $_file
    rr $_file
}

online () {
    local _dest="$1"; shift
    [[ -z $_dest ]] && _dest=www.google.com
    if quick_ping $_dest "$@" >/dev/null 2>&1; then
        echo $_dest online
        return 0
    else
        echo $_dest offline
        return 1
    fi
}

please () {
    local last=$(history -p !-1)
    echo "sudo $last"
    sudo $last
}

mython () {
    PATH=$HOME/bin:/usr/local/bin:/usr/bin python2.7 "$@"
}

qwerty  () {
    echo '` 1 2 3 4 5 6 7 8 9 0 - = '
    echo 'q w e r t y u i o p [ ]'
    echo 'a s d f g h j k l ;' "'" '#'
    echo '\ z x c v b n m , . /'
}

run_as () {
    username=$1
    shift
    if [[ -n "$1" ]]; then
        sudo -u $username "$@"
    else
        SUDO $username
    fi
}

# xxxxxxx

has_ext () {
    [[ -n $(ls ${2:-.}/*.$1 2>/dev/null | grep -v -e fred -e log  | hd1) ]]
}

pylinum () {
    local string=$(pylint --help-msg $1 | hd1 | cut -d\: -f2 | cut -d\  -f1 | sed -e "s/^/# pylint: disable=/")
    [[ $string != "# pylint: disable=No" ]] && echo $string
}

relpath () {
    python ~/jab/src/python/relpath.py "$@"
}

whiches () {
    local _which=$(which $1)
    local _located=
    for _located in $(locate -f $1); do
        echo
        if $_located --version >/dev/null 2>&1; then
            $_located --version | grep --color ' [0,7,8]\.[0-9]'
            ll $_located | grep --color $_which || ll $_located
        fi
    done
}

umports () {
    for file in "$@"; do
        reorder-python-imports "$file"
        python ~/jab/bin/imports -ume "$file"
    done
}

# xxxxxxxx

jostname () {
    echo ${HOSTNAME:-$(hostname -s)}
}

maketest () {
    local path="$1"
    if [[ ! -f "$path" ]]; then
        echo $path is not a file >&2
        return 1
    fi
    local filename=$(basename $path)
    local stem=${filename%.*}
    local classname=$(mython -c "print 'Test%s' % '$stem'.title()")
    local methodname="test_$stem"
    local test_file=$(mython -c "import os; print os.path.join(os.path.dirname(os.path.abspath('$path')), 'test', 'test_%s' % os.path.basename('$path'))")
    if [[ -f "$test_file" ]]; then
        echo $test_file is already a file >&2
        return 1
    fi
    local test_dir=$(dirname $test_file)
    [[ -d "$test_dir" ]] || mkdir -p "$test_dir"
    sed -e s/TestClass/$classname/ -e s/test_case/$methodname/ ~/jab/src/python/test_.py > $test_file
}

sudo_ssh () {
    local _host=$1; shift
    ssh -t -q $_host "sudo ""$@"
}

thirteen () {
    cd_one
    3d "$@"
}

todo_edit () {
    local todo_txt="~/jab/todo.txt"
    local git_options="--git-dir=~/jab/.git --work-tree=~/jab"
    if [[ -f todo.txt ]]; then
        todo_txt=todo.txt
        git_options=
    elif [[ -f TODO.md ]]; then
        todo_txt=TODO.md
        git_options=
    fi
    v $todo_txt
    if git status -s ~/jab/todo.txt 2>&1 | grep -q "M.*$(basename ~/jab/todo.txt)"; then
        git add ~/jab/todo.txt
        git commit -m'more or less stuff to be done' ~/jab/todo.txt
    elif svn stat "~/jab/todo.txt" 2>&1 | grep -q "M .* ~/jab/todo.txt"; then
        svn ci -m'more or less stuff to be done' "~/jab/todo.txt"
    fi
}

todo_show () {
    local todo_txt="~/jab/todo.txt"
    if [[ -f todo.txt ]]; then todo_txt=todo.txt
    elif [[ -f TODO.md ]]; then todo_txt=TODO.md
    fi
    python ~/jab/src/python/todo.py $todo_txt
}

# xxxxxxxxx

viewstyle () {
    git status --porcelain "$1" | grep -q .  || return 1
    git dv "$1"
    git add "$1"
    git commit
}

autostyle () {
    reorder-python-imports "$1"
    viewstyle "$1"
    autoflake -i --remove-all-unused-imports "$1"
    viewstyle "$1"
    ~/jab/bin/imports --tmp --unused "$1";
    viewstyle "$1"
    autopep8 -a -a -a -i "$1"
    viewstyle "$1"
    vim "$1"; git add "$1"; git commit
}

# xxxxxxxxxx
_like_duck () {
    has_py "$*"
}

continuing () {
    local _answer=$(ask "Continue ?")
    [[ $_answer =~ [yY] ]]
}

jab_scripts () {
    mython ~/jab/src/python/scripts.py "$@"
}

quick_ping () {
    if ping -c 1 -w 1 -W 1 "$@" 2>&1 | grep -q -e illegal -e invalid; then
        # looks like OS X
        ping -c 1 -t 1 -W 1 "$@"
    else
        # make sure we return correctly
        ping -c 1 -w 1 -W 1 "$@"
    fi
}

thirty_two () {
    3l "$@"
    2
}

# _______________

_diff_two_files () {
    ! diff -q $1 $2 >/dev/null 2>&1
}

_any_diff () {
    _diff_two_files $1 $2 && return 0
    [[ -z $3 ]] && return 1
    _diff_two_files $1 $3 && return 0
    _diff_two_files $2 $3 && return 0
    return 1
}

vim_diff () {
    first_file="$1"
    shift
    second_file="$1"
    shift
    third_file=
    editor_command="vim -d "
    for arg in "$@"
    do
        [[ $arg =~ ^-.* ]] && editor_command="$editor_command $arg" && continue
        [[ -z $third_file ]] && third_file=$arg
    done
    if ! _any_diff "$first_file" "$second_file" "$third_file"; then
        echo same
        return 0
    fi
    if [[ -n $third_file ]]; then
        $editor_command "$first_file" "$second_file" "$third_file"
    else $editor_command "$first_file" "$second_file"
    fi
}

# xxxxxxxxxx

# xxxxxxxxxxx

lines_to_spaces () {
    tr '\n' ' '
}

# xxxxxxxxxxxx

blank_script () {
    [[ -f "$1" ]] && return
    echo "#! /bin/bash" > $1
    echo "" >> $1
}

# xxxxxxxxxxxxx

console_hello () {
    local me=$USER
    local here=$(jostname)
    export PYTHON=${PYTHON:-mython}
    console_title_on "mython@${here}" && \
        $PYTHON "$@" && \
        console_title_off "${me}@${here}"
}

one_two_three () {
    clear
    cd_one "$@"
    todo_show
    if first_num "$@"; then
        3d $num --noreport $args
    else
        3d 1 --noreport "$@"
    fi
    lk $(ls1 -p | g -v "\(pyc\|/\)$")
}

insert_commas () {
    # From http://shallowsky.com/blog/linux/cmdline/sed-improve-comma-insertion.html
    sed ':a;s/\b\([0-9]\+\)\([0-9]\{3\}\)\b/\1,\2/;ta'
}

sudo_default () {
    sudo_ssh default "$@"
}

three_two_one () {
    clear
    3d 2 "$@"
    todo_show
    cd_one "$@"
}

# xxxxxxxxxxxxxx

console_whoami () {
    console_title_on $USER@$(jostname)...$(basename "$PWD")
}

source_aliases () {
    local __doc__='source files which have aliases and remember the filenames'
    ALIASES="$ALIASES:$1"
    source $1
}

# xxxxxxxxxxxxxxx

# xxxxxxxxxxxxxxxx

console_title_on () {
    if [[ -n $TERM_PROGRAM && $TERM_PROGRAM == "iTerm.app" ]]; then
        echo -e "\033]0;$1\007" # http://stackoverflow.com/a/6887306/500942
    elif env | grep -iq konsole 2>/dev/null; then
        #dcop $KONSOLE_DCOP_SESSION renameSession $1
        echo -e "\033]0;$1\007" # http://stackoverflow.com/a/21380108/500942
    elif env | grep -iq gnome.terminal; then
        echo -e "\033]0;$1\007" # http://askubuntu.com/a/22417/130752
    elif [[ -n $TERM ]]; then
        if [[ $TERM == "linux" ]]; then
            echo -e "]1;$1"
        elif [[ $TERM =~ xterm ]]; then
            echo -ne "\033]0;$1\007" # http://askubuntu.com/a/22417/130752
        fi
    else
        echo "Title: $1"
    fi
}

show_functons_in ()
{
    for f in $(grep "^[a-z][a-z_]\+ .. .$" $1  | sed -e "s: .. .$::"); do
        what -v $f
    done | fewer
}

# xxxxxxxxxxxxxxxxx

console_title_off () {
    if [[ -n $TERM_PROGRAM && $TERM_PROGRAM == "iTerm.app" ]]; then
        echo -e "]0;$1"
    elif env | grep -iq konsole 2>/dev/null; then
        dcop $KONSOLE_DCOP_SESSION renameSession $1
    elif env | grep -iq gnome.terminal; then
        echo -e "\033]0;$1\007" # http://askubuntu.com/a/22417/130752
    elif [[ -n $TERM ]]; then
        if [[ $TERM == "linux" ]]; then
            echo -e "]1;$1"
        elif [[ $TERM =~ xterm ]]; then
            echo -e "\033]0;$1\007" # http://askubuntu.com/a/22417/130752
        fi
    else
        echo "Title: $1"
    fi
}

# _xxxxxxxxxxxxxxxxxxx

_publish_Localhost () {
    /bin/bash ~/jab/bin/publish_host.sh $HOME/public_html/index.html
}

# functions starting with an underscore are intended for use within this file only

_dixx () {
    local _source_dir="$1"
    local _destination_dir="$2"
    local number_in_both=$(_divv_get_difference "$1" "$2" | grep Files | wc -l)
    if [[ $number_in_both -gt 0 ]]; then
        echo
        echo "# Files 1 and 2 differ"
        _divv_get_difference "$1" "$2" | grep Files | sed -e 's/Files /'$COMMAND_FOR_SAME_FILES' "/' -e 's/ and /" "/' -e 's/ differ/"/'
    fi
    local number_in_source=$(_divv_get_difference "$1" "$2" | grep "Only in $_source_dir" | wc -l)
    if [[ $number_in_source -gt 0 ]]; then
        echo
        echo "Only in $_source_dir"
        _divv_get_difference "$1" "$2" | grep "Only in $_source_dir" | sed -e "s/Only in/vim /" -e "s|: |/|"
    fi
    local number_in_destination=$(_divv_get_difference "$1" "$2" | grep "Only in $_destination_dir" | wc -l)
    if [[ $number_in_destination -gt 0 ]]; then
        echo
        echo "Only in $_destination_dir"
        _divv_get_difference "$1" "$2" | grep "Only in $_destination_dir" | sed -e "s/Only in/vim /" -e "s|: |/|"
    fi
}

_edit_source () {
    local filepath=$1
    shift
    blank_script $filepath
    filedir=$(dirname $filepath)
    if [[ $filedir == "." ]]; then
        v $filepath
    else
        pushq $filedir
        v $filepath
        popq
    fi
    if echo $filepath | grep -q alias; then
        source_aliases $filepath
    else
        source_path $filepath "$@"
    fi
}

_edit_jab () {
    [[ -d "~/jab" ]] || mkdir -p ~/jab
    local filepath=~/jab/$1
    shift
    _edit_source $filepath "$@"
}

_edit_locals () {
    local local_dir=~/jab/local
    [[ -d "$local_dir" ]] || mkdir -p $local_dir
    _edit_source $local_dir/$1
}

_divv_get_difference () {
    local _source_dir="$1"
    local _destination_dir="$2"
    local _source_gitignore=
    [[ -f "$_source_dir/.gitignore" ]] && _source_gitignore="--exclude-from=$_source_dir/.gitignore"
    local destination_gitignore=
    [[ -f "$_destination_dir/.gitignore" ]] && destination_gitignore="--exclude-from=$_destination_dir/.gitignore"
    diff -q -r \
        --exclude=.svn \
        --exclude=.git \
        --exclude=.DS_Store \
        --exclude="*.fail" \
        --exclude="*.py[co]" \
        --exclude=tags \
        --exclude=".*sw[po]" \
        --exclude=tmp \
        --exclude="*~" \
        --exclude="*.beam" \
        --exclude="*.a" \
        --exclude="*.o" \
        --exclude=.gitignore \
        $_source_gitignore \
        $destination_gitignore \
    "$_source_dir" "$_destination_dir" 2>/dev/null
}

unremembered () {
    shift
    blank_script $filepath
    filedir=$(dirname $filepath)
    if [[ $filedir == "." ]]; then
        v $filepath
    else
        pushq $filedir
        v $filepath
        popq
    fi
    if echo $filepath | grep -q alias; then
        source_aliases $filepath
    else
        source_path $filepath "$@"
    fi
}

copy_from_wwts_server () {
    local _server_name=$1
    local _source="$2"
    local _source_dir=$(dirname "$_source")
    local _here_root=~/wwts/$_server_name
    [[ -d $_here_root ]] || mkdir -p $_here_root
    local _here_path=$_here_root/"$_source_dir"
    [[ -d "$_here_path" ]] || mkdir -p "$_here_path"
    rsync -av $_server_name:"$_source" "$_here_path"
}

Bye_from $BASH_SOURCE
