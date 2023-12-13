#! /usr/bin/env head -n 3

# This script is intended to be sourced, not run


# set -e
. ~/bash/types.sh

typed green || . ~/bash/crayons.sh
typed pong || . ~/bash/pong.sh
typed pii || . ~/bash/python.sh

# Called functons.sh because "functions" is ... something else

# sorted by strcmp of function name, punctuation before letters

# x


,. () {
    [[ -f .cd ]] && . .cd
}

,, () {
    cde . "$@"
}

# xx

arg_dirs () {
    local dir_=. arg_= path_= result_=1
    for arg_ in "$@"; do
        [[ -e "$arg_" ]] || continue
        path_=$( readlink -f "$arg_")
        [[ -d "$path_" ]] && dir_="$path_"
        [[ -f "$path_" ]] && dir_=$(dirname "$path_")
        [[ -d "$dir_" ]] && result_=0
        [[ -d "$dir_" ]] && echo $dir_
    done
    return $result_
}

arg_dir () {
    [[ -e "$1" ]] || return 1
    local path_=$( readlink -f "$1") dir_=
    [[ -d "$path_" ]] && echo "$path_" || dirname "$path_"
    return 0
}


free_line_here () {
    :
}


# xxx

# xxxx

back () {
    tput rmcup
}

bins () {
    local name_="$1"; shift
    [[ -z $name_ ]] && return 1
    while [[ -n $name_ ]]; do
        for root in $HOME /bin /usr; do
            find $root -wholename "bin/*$name_*" -print 2>/dev/null
        done | grep -e $name_ | sort | uniq | grep $name_ 2>/dev/null
        name_="$1"; shift
    done
}

bash4 () {
    /usr/local/bin/bash4 "$@"
}

bool () {
    [[ -z $* || $1 =~ ^0*$ ]] && echo False && return 1
    if whyp -q "$1"; then
        if [[ $1 == "[[" ]]; then
            eval "$@"
            local result_=$?
            [[ $result_ == 0 ]] && echo True || echo False
            return $result_
        else
            "$@" 2> ~/fd2 && echo True && return 0
        fi
        echo False; return 1
    fi
    [[ $1 =~ ^0*$ ]] && echo False || echo True
    return 0
}

brew () {
    brew_=/usr/local/bin/brew
    [[ -f /opt/homebrew/bin/brew ]] && brew_=/opt/homebrew/bin/brew
    GIT= $brew_ "$@"
}

bump () {
    local show_=
    local get_=
    if [[ $1 == show ]]; then
        show_=1
        shift
    fi
    if [[ $1 == get ]]; then
        get_=1
        shift
    fi
    local pulled_=
    if [[ $1 == pulled ]]; then
        pulled_=1
        shift
    fi
    if [[ -d "$1" ]]; then
        bumpdir_="$1"
        shift
    fi
    local name_=$(basename_ $1)
    local config_=
    [[ $name = ".bumpversion.cfg" ]] && config_="$1"
    [[ -n $config_ ]] && shift
    local bump_root_=$(git_root -q .)
    local part_=${1:-patch}; shift
    if [[ -z $show_ && -z $get_ ]]; then
        if [[ -n $part_ ]]; then
            [[ $pulled_ == 1 ]] || git pull --rebase
            cd "$bump_root_"
            local options_=
            [[ -n $config ]] && options_="--config-file $name_"
            if bumpversion $options_ $part_ "$@"; then
                git push
                git push origin v$(bump get)
            fi
        fi
    fi
    [[ -z $config ]] && config_="$bump_root_/.bumpversion.cfg"
    [[ -f $config_ ]] || return 2
    local sought_=^current_version
    if [[ -n $show_ ]]; then
        grep $sought_ $config_ | grep --colour '\d[0-9a-z.]\+$'
    elif [[ -n $get_ ]]; then
        grep $sought_ $config_ | sed -e 's/.*= //'
    else
        bumpversion "$@"
    fi
}


down () {
    cde ~/Downloads "$@"
    l -tr . | tail
}

envv () {
    env | grep VIRTUAL_ENV= | grep '=.*'
}

hhhh () {
    echo '#' | clip_in
}

lkra () {
    lkr -a "$@"
}

left () {
    local lastcommand_="$1"
    echo $last_command
    local lastcommand_line_="$@"
    echo $last_command_line
}

main () {
    shift_dir "$@" && shift
    [[ -n $* ]] && cp ~/jab/src/python/main.py $1 || cp ~/jab/src/python/main.py $dir
}

mann () {
    man -P /usr/local/gnu/cat $1 | col -b
}

mine () {
    sudo chown -R $(id -un):$(id -gn) "$@"
}

mkcd () {
    local __doc__='make a directory and start using it';
    show_command mkdir -p "$1"
    mkdir -p "$1"
    [[ -d "$1" ]] || return 1
    show_command cd "$1"
    cd "$1"
}

mkpy () {
    mkd "$1"
    touch "$1"/__init__.py
}

mkv3 () {
    mkvirtualenv -v --clear --system-site-packages --relocatable --python=$(which python3) $1
    virtualenv --python=$(which python3) /Users/jab/.virtualenvs/$1
}

SUDO () {
    if [[ -n $1 ]]; then
        user="-u $1"
        yousir_="$1"
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

dic () {
    dixx_ cp "$1" "$2"
}

dih () {
    dixx_ hd "$@"
}

dii () {
    dixx_ icdiff "$@"
}

div () {
    dixx_ vd "$@"
}

over () {
    tput smcup
}

popq () {
    popd >/dev/null 2>&1
}

pythis () {
    python -c "import this"
}

this () {
    if [[ "$@" =~ -q ]]; then
        pythis
    else
        pythis | head -n1 | green
        echo
        pythis | tail -n+2 | lgreen
    fi
}

Tree () {
    tree "$@" | less -R
}

vims () {
    whiches vim
}

vini () {
    vim -p $(find $( rlf ~/jab ) -name __init__.sh | lines_to_spaces)
}

# xxxxx

build () {
    if [[ -x bin/make ]]; then
        [[ -f bin/made ]] || bin/make "$@"
        if [[ -x bin/deploy ]]; then
            [[ -e bin/deployed ]] || bin/deploy "$0"
            [[ -e bin/deployed ]] && return 0
        fi
    elif [[ -f build.sh ]]; then bash build.sh "$@"
    elif [[ -f Makefile ]]; then make "$@"
    fi
}

detab () {
    local expand_=$(which expand)
    whype -q gexpand && expand_=$(whyp -f gexpand)
    if [[ -f "$1" ]]; then
        if grep -Pq "^\s*\t\s*[^ \t]" $1; then
            $expand_ -i --tabs=4 $1 > /tmp/txt
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
        local lines_=$(wc -l "$1" | cut -d' ' -f1)
        if [[ $lines_ -lt ${LINES:-$(screen_height)} ]]; then
            cat -n "$1"
        else
            lesen "$1"
        fi
    else
        cat -n
    fi
}

hello () {
    /usr/bin/say -v Moira \
        Hello, my name is Moira. \
        I am an Irish-English voice. \

}

jalanb () {
    local root_=~/src/git/jalanb
    for repo in $(readlink -f $root_/*); do
        [[ -d $repo ]] || continue
        git_dirty $repo || continue
        echo
        show_command $repo
        git -C $repo branch
        git -C $repo lg -n 3
        git -C $repo status | grep 'Your branch'
        git -C $repo status -s
    done
}

ncduhd () {
    sudo ncdu -x /Volumes/Macintosh\ HD/
}

ncduru () {
    sudo ncdu -x /
}

paste () {
    if [[ -z "$*" ]]; then
        echo "$ $(pbpaste)"
        $(pbpaste)
    else
        echo "# $(pbpaste)"
    fi
}

blacken () {
    black -l 79 "$@"
}

clipvim () {
    bash -x ~/jab/bin/tmp_fred.sh
}

clip_in () {
    pbcopy
    [[ "$@" =~ -q ]] || (echo "$(clipout)" | sed -e "s:^:# :")
}

clipout () {
    echo "$(pbpaste)"
}

given () {
    cat /Users/jab/jab/txt/given.jira.txt | pbcopy
    echo "copied"
    cp /Users/jab/jab/txt/given.jira.txt ~/tmp/given.txt
    vim ~/tmp/given.txt
    cat ~/tmp/given.txt | pbcopy
}

ptags () {
    local source_="$1"
    [[ -n $source ]] || source_="."
    python ~/jab/src/python/ptags.py $source_
}

pushq () {
    pushd "$@"  >/dev/null 2>&1
}

quack () {
    local result_=1
    for $item in "$@"; do
        if like_duck $item; then
            python  $1
            result_=0
        fi
    done
    return $result_
}


range () {
    local __doc__="""range(""$@"")"""
    local dir_=.
    if [[ -n "$*" ]]; then
#       local cde_script_=~/hub/cde/cd.py
        local cde_script_=~/cde/cde/__main__.py
        if ! dir_=$(PYTHONPATH=$python_directory python $cde_script_ "$@" 2>&1); then
            echo "$dir_"
            return 1
        fi
    fi
    local rlf_=$(readlink -f "$dir_")
    if [[ $dir_ != $rlf_ ]]; then
        dir_=$rlf_
        echo "ranger ($dir_ ->) $rlf_"
    elif [[ $dir_ != $1 && $1 != "-" ]]; then
        echo "ranger $dir_"
    fi
    pushq "$dir_"
    source $(which ranger) $(which ranger)
    echo; green_line $PWD; echo; l
    return 0
}

taocl () {
    curl -s https://raw.githubusercontent.com/jlevy/the-art-of-command-line/master/README.md |
    pandoc -f markdown -t html |
    xmlstarlet fo --html --dropdtd |
    xmlstarlet sel -t -v "(html/body/ul/li[count(p)>0])[$RANDOM mod last()+1]" |
    xmlstarlet unesc | fmt -80
}

ylint () {
    python $HOME/jab/src/python/ylint.py "$@"
}

# xxxxxx


bumper () {
    if [[ -z $1 ]]; then
        echo Please specify branch to bump >&2
        return 1
    fi
    local bump_branch_=$1; shift
    local current_branch_=$(git rev-parse --abbrev-ref HEAD)
    if [[ $current_branch_ != $bump_branch_ ]]; then
        if git co $bump_branch_; then
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

header () {
    head -n 1 "$@"
}

howdoi () {
    /usr/local/bin/howdoi -c -a "$@"
}

lesser () {
    less -R "$@"
}

lese () {
    less -SR "$@"
}

lesen () {
    less -SNR "$@"
}

mkvenv () {
    local dir_=. venv_dir_=
    if [[ -d "$1" ]]; then
        dir_="$1"
        shift
    fi
    venvdir__="$dir_/.venv"
    deactivate
    rm -rf $venv_dir_
    python3 -m venv "$venv_dir_"
    . "$venv_dir_/bin/activate"
    piup
}

show_line () {
    local prefix_=$1; shift
    local server_= suffix_=
    [[ $1 ]] && server_=$1
    [[ $2 ]] && suffix_=", $2"
    echo "$prefix_ ${server_}$suffix_"
}

pysyon () {
    local python_path_=/users/jab/pysyte
    [[ $PYTHONPATH ]] && pythonpath__="$python_path_:$PYTHONPATH"
    PYTHONPATH="$python_path_" python "$@"
}

please () {
    local command_=$(history -p !-1)
    [[ "$@" ]] && command_="$@"
    show_run_command sudo $command_
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

tailer () {
    tail -n 1 "$@"
}

# xxxxxxx

aliases () {
    local sub_dir_="src/bash"
    [[ $1 == -l ]] && sub_dir_="local"
    [[ $1 == -w ]] && sub_dir_="work"
    echo "$HOME/jab/${sub_dir_}/aliases.sh"
}

brewup () {
    local update_=
    if [[ $@ ]]; then
        update_=1
    else
        brew upgrade "$@" > ~/tmp/brew.upgrade.out 2>  ~/tmp/brew.upgrade 
        grep "You have [0-9]+ outdated formulae" ~/tmp/brew.upgrade.out && update_=1
        grep "[0-9]+ outdated cask installed" ~/tmp/brew.upgrade.out && update_=1
    fi
    if [[ $update_ ]]; then
        brew update
    fi
    [[ $* ]] || return 0
    brew upgrade "$@"
}

clearly () {
    clear
    l
}

doctest () {
    local __doc__="""doctest args"""
    local pythonpath_=$(readlink -f .)
    [[ $PYTHONPATH ]] && pythonpath_="$PYTHONPATH:$pythonpath_"
    local target_="$@"
    [[ $target_ ]] || target_=.
    (PYTHONPATH="$pythonpath_" python -m doctest -o REPORT_ONLY_FIRST_FAILURE -o FAIL_FAST "$target_")
}

has_ext () {
    [[ -n $(ls ${2:-.}/*.$1 2>/dev/null | grep -v -e fred -e log  | head -n 1) ]]
}

cde_bash () {
    show_command "$@"
    local cde_="$CDE_DIR" cde_out_="$cde_/std.out" cde_err_=$cde_/std.err
    local result_=0
    "$@" > $cde_out 2> $cde_err && result_=$?
    show_pass $(cat $cde_out)
    show_fail $(cat $cde_err)
    return $result_
}

headline () {
    [[ $1 ]] && head -n 1 "$1" || cat | head -n 1
}

tailline () {
    [[ $1 ]] && tail -n 1 "$1" || cat | tail -n 1
}

is_a_dir () {
    [[ -d "$1" ]] || echo "\"$1\" is not a directory" >&2
    [[ -d "$1" ]]
}

playbook () {
    ANSIBLE_STDOUT_CALLBACK=debug ansible-playbook "$@"
}

relpath () {
    python ~/jab/src/python/relpath.py "$@"
}

whiches () {
    local which_=$(which $1)
    local located_=
    for located_ in $(locate -f $1); do
        echo
        if $located_ --version >/dev/null 2>&1; then
            $located_ --version | grep --color ' [0,7,8]\.[0-9]'
            ll $located_ | grep --color $which_ || ll $located_
        fi
    done
}

umports () {
    local old_venv_=$VIRTUAL_ENV
    local pysyte_=$HOME/jalanb/pysyse/__main__
    QUIETLY deactivate
    source $pysyte_/.venv/bin/activate
    for file in "$@"; do
        reorder-python-imports "$file"
        python -m pysyte.imports -ume "$file"
    done
    QUIETLY deactivate
    [[ $old_venv_ ]] || return 0
    source $old_venv_/bin/activate
}

# xxxxxxxx

doctests () {
    .venv/bin/pytest --doctest-modules --doctest-glob=*.test --doctest-glob=*.tests --doctest-glob=*.md
}

functons () {
    local sub_dir_="src/bash"
    [[ $1 == -g ]] && sub_dir_="$sub_dir_/git"
    [[ $1 == -l ]] && sub_dir_="local"
    [[ $1 == -w ]] && sub_dir_="work"
    echo "$HOME/jab/${sub_dir_}/functons.sh"
}

jostname () {
    local short_name_=$(hostname -s)
    local caps_name_=${HOSTNAME:-hostless}
    echo ${short_name_:-$caps_name_}
}

maketest () {
    local path_="$1"
    if [[ ! -f "$path" ]]; then
        echo $path is not a file >&2
        return 1
    fi
    local filename_=$(basename_ $path)
    local stem_=${filename%.*}
    local classname_=$(python -c "print 'Test%s' % '$stem'.title()")
    local methodname_="test_$stem"
    local test_file_=$(python -c "import os; print os.path.join(os.path.dirname(os.path.abspath('$path')), 'test', 'test_%s' % os.path.basename('$path'))")
    if [[ -f "$test_file" ]]; then
        echo $test_file is already a file >&2
        return 1
    fi
    local test_dir_=$(files_dirs $test_file)
    [[ -d "$test_dir" ]] || mkdir -p "$test_dir"
    sed -e s/TestClass/$classname/ -e s/test_case/$methodname/ ~/jab/src/python/test_.py > $test_file
}

pong_work () {
    pong -t3 $1.$(work $1)
}

ssh_tippy () {
    at_home tippy
    vagrant status 2>&1 | grep -q -e 'poweroff' -e 'Run .vagrant up' && vagrant up
    vagrant ssh
}

sudo_ssh () {
    local host_=$1; shift
    ssh -t -q $host_ "sudo ""$@"
}

thirteen () {
    cd_one
    3d "$@"
}


todo_edit () {
    local todotxt_="~/jab/todo.txt"
    local gitoptions_="--git-dir=~/jab/.git --work-tree=~/jab"
    if [[ -f todo.txt ]]; then
        todo_txt=todo.txt
        git_options=
    elif [[ -f TODO.md ]]; then
        todo_txt=TODO.md
        git_options=
    fi
    v $todo_txt
    if git status -s ~/jab/todo.txt 2>&1 | grep -q "M.*$(basename_ ~/jab/todo.txt)"; then
        git add ~/jab/todo.txt
        git commit -m'more or less stuff to be done' ~/jab/todo.txt
    elif svn stat "~/jab/todo.txt" 2>&1 | grep -q "M .* ~/jab/todo.txt"; then
        svn ci -m'more or less stuff to be done' "~/jab/todo.txt"
    fi
}

files_dirs () {
    local __doc__="""echo all args' directories"""
    local result_=1
    for arg_ in "$@"; do
        [[ -e "$arg_" ]] || continue
        dirname "$arg_"
        result_=0
    done
    return $result_
}

dirnames () {
    local __doc__="""echo all directories in args"""
    local result_=1
    for arg_ in "$@"; do
        [[ -e "$arg_" ]] || continue
        [[ -d "$arg_" ]] && echo "$arg_" || dirname "$arg_"
        result_=0
    done
    return $result_
}

quietless () {
    "$@" 2> /dev/null
}

twkgit00 () {
    is_a_file .git/config || return 1
    sed -i -e s/$(work twkgit30)/$(work git)/ .git/config
    sed -i -e s/$(work twkgit20)/$(work bots)/ .git/config
    sed -i -e s/$(work twkgit31)/$(work bots)/ .git/config
    sed -i -e 's!https://$(work git)!https://$(work git)!' .git/config
    sed -i -e 's!http://$(work bots)!https://$(work bots)!' .git/config
}

twkgit30 () {
    is_a_file .git/config || return 1
    local twkgit30_=$(work twkgit30)
    sed -i -e s/$(work git)/${twkgit30_}/ .git/config
    sed -i -e s/$(work twkgit20)/${twkgit30_}/ .git/config
    sed -i -e s/$(work tools)/${twkgit30_}/ .git/config
    sed -i -e s/$(work tooltest)/${twkgit30_}/ .git/config
    sed -i -e 's,http://${twkgit30_},https://${twkgit30_},' .git/config
}

unittest () {
    local __doc__="""unittest args"""
    local pythonpath_=$(readlink -f .)
    local option_=--failfast
    if [[ $1 =~ [-][vf] ]]; then
        option_=
        shift
    fi
    [[ $PYTHONPATH ]] && pythonpath_="$PYTHONPATH:$pythonpath_"
    local target_="$@"
    [[ $target_ ]] || target_=.
    (PYTHONPATH="$pythonpath_" python -m unittest $option_ "$target_")
}

# xxxxxxxxx

basename () {
    local result_=1
    for arg_ in "$@"; do
        [[ -e "$arg_" ]] || continue
        basename "$arg_"
        result_=0
    done
    return $result_
}

first_num () {
    num=$(python ~/jab/src/python/first_num.py "$@")
    args=$(python ~/jab/src/python/first_num.py --Invert "$@")
    [[ -n $num ]]
}

is_a_file () {
    [[ -f "$1" ]] || echo "\"$1\" is not a file" >&2
    [[ -f "$1" ]]
}

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
like_duck () {
    has_py "$*"
}

al_email () {
    echo "$@@al-got-rhythm.net"
}


continuing () {
    local answer_=$(ask "Continue ?")
    [[ $answer_ =~ [yY] ]]
}

jab_hub () {
    local dir_=
    local dirs_=
    [[ $1 == -d ]] && dirs_=1
    [[ $1 == -D ]] && dirs_=2
    (
        cd ~/hub;
        local result_=$(
        grep slack -H */.travis.yml | \
            sed -e "s/:.*//" -e "s:..travis.yml::" | \
            grep -v -e old -e master -e suds | \
            sort | uniq
        )
        [[ $dirs_ == 1 ]] && for dir_ in $result_; do short_dir $dir_; done
        [[ $dirs_ == 2 ]] && for dir_ in $result_; do rlf $dir_; done
        [[ $dirs_ ]] || echo $result_ | spaces_to_lines
    )
}

jab_scripts () {
    python ~/jab/src/python/scripts.py "$@"
}

make_it_so () {
    please "$@"
}

thirty_two () {
    3l "$@"
    2
}

diff_two_files () {
    ! diff -q $1 $2 >/dev/null 2>&1
}

any_diff () {
    diff_two_files_ $1 $2 && return 0
    [[ -z $3 ]] && return 1
    diff_two_files_ $1 $3 && return 0
    diff_two_files_ $2 $3 && return 0
    return 1
}

# xxxxxxxxxx

# xxxxxxxxxxx

spaces_to_lines () {
    tr ' ' '\n'
}
lines_to_spaces () {
    tr '\n' ' '
}

# xxxxxxxxxxxx

blank_script () {
    [[ -f "$1" ]] && return
    echo "#! /bin/bash" > $1
    echo "" >> $1
}

project_root () {
    git_root -q "$@" 2>/dev/null && return 0
    local arg_= file_= path_=
    for arg_ in "$@"; do
        for path_ in $(~/jab/bin/parents $arg_); do
            for file_ in .bumpversion.cfg .gitignore .travis.tml setup.py requirements.txt README.rst readme.md LICENSE tox.ini; do
                if [[ -f $path_/$file_ ]]; then
                    echo $path_
                    return 1
                fi
            done
        done
    done
    return 1
}

# xxxxxxxxxxxxx

disable_spctl () {
    sudo spctl --master-disable
}

show_functions () {
    local __doc__="""You're mad!!"""
    echo all functions? here ye go
    declare -f | grep "^[^ ]* ()"
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
    l $(ls1 -p | grep -v "\(pyc\|/\)$")
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
    console_title_on $USER@$(jostname)...$(basename_ "$PWD")
}

source_aliases () {
    local __doc__='source files which have aliases and remember the filenames'
    ALIASES="$ALIASES:$1"
    source $1
}

# xxxxxxxxxxxxxxx

brew_install_all () {
    for brew_ in "$@";
    do
        GIT= brew install $brew_ 3>&1 1>&2 2>&3 | grep -v -e "already installed" -e re[-]*install
    done
}

# xxxxxxxxxxxxxxxx

console_title_on () {
    if [[ -n $TERM_PROGRAM && $TERM_PROGRAM == "iTerm.app" ]]; then
        echo -e "\033]0;$1\007" # http://stackoverflow.com/a/6887306/500942
    elif env | grep -iq konsole 2> ~/fd2; then
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
        whype -v $f
    done | fewer
}

# xxxxxxxxxxxxxxxxx

console_title_off () {
    if [[ -n $TERM_PROGRAM && $TERM_PROGRAM == "iTerm.app" ]]; then
        echo -e "]0;$1"
    elif env | grep -iq konsole 2> ~/fd2; then
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

# xxxxxxxxxxxxxxxxxxx_

publish_Localhost () {
    /bin/bash ~/jab/bin/publish_host.sh $HOME/public_html/index.html
}

# functions starting with an underscore are intended for use within this file only

dixx () {
    local command_=$1; shift
    local source_dir_="$1"; shift
    local destination_dir_="$1"; shift
    local number_in_both_=$(divv_get_difference_ "$1" "$2" | grep Files | wc -l)
    if [[ $number_in_both -gt 0 ]]; then
        echo
        echo "# Files 1 and 2 differ"
        divv_get_difference_ "$1" "$2" | grep Files | sed -e 's/Files /'$COMMAND_FOR_SAME_FILES' "/' -e 's/ and /" "/' -e 's/ differ/"/'
    fi
    local number_insource_=$(divv_get_difference_ "$1" "$2" | grep "Only in $source_dir_" | wc -l)
    if [[ $number_in_source -gt 0 ]]; then
        echo
        echo "Only in $source_dir_"
        divv_get_difference_ "$1" "$2" | grep "Only in $source_dir_" | sed -e "s/Only in/vim /" -e "s|: |/|"
    fi
    local number_in_destination_=$(divv_get_difference_ "$1" "$2" | grep "Only in $destination_dir_" | wc -l)
    if [[ $number_in_destination -gt 0 ]]; then
        echo
        echo "Only in $destination_dir_"
        divv_get_difference_ "$1" "$2" | grep "Only in $destination_dir_" | sed -e "s/Only in/vim /" -e "s|: |/|"
    fi
}

edit_source () {
    local filepath_=$1
    shift
    blank_script $filepath
    filedir=$(files_dirs $filepath)
    if [[ $filedir == "." ]]; then
        vv $filepath "$@"
    else
        pushq $filedir
        vv $filepath "$@"
        popq
    fi
    if [[ $filepath =~ alias ]]; then
        source_aliases $filepath
    else
        . $filepath "$@"
    fi
}

edit_locals () {
    local local_dir_=~/jalanb/local
    [[ -d "$local_dir" ]] || mkdir -p $local_dir
    local name_="$1" force_=
    shift
    [[ $1 =~ -f ]] && force_=--force
    [[ $force_ ]] || return 0
    editsource_ "$local_dir/$name_"
}

edit_work () {
    local local_dir_=~/jab/work
    [[ -d "$local_dir" ]] || mkdir -p $local_dir
    editsource_ $local_dir/$1
}

divv_get_difference () {
    local source_dir_="$1"
    local destination_dir_="$2"
    local source_gitignore_=
    [[ -f "$source_dir/.gitignore" ]] && source_gitignore_="--exclude-from=$source_dir_/.gitignore"
    local destination_gitignore_=
    [[ -f "$destination_dir/.gitignore" ]] && destination_gitignore_="--exclude-from=$destination_dir_/.gitignore"
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
        $source_gitignore_ \
        $destination_gitignore \
    "$source_dir_" "$destination_dir_" 2> ~/fd2
}

unremembered () {
    shift
    blank_script $filepath
    filedir=$(files_dirs $filepath)
    if [[ $filedir == "." ]]; then
        vv $filepath
    else
        pushq $filedir
        vv $filepath
        popq
    fi
    if echo $filepath | grep -q alias; then
        source_aliases $filepath
    else
        . $filepath "$@"
    fi
}

copy_from_work_server () {
    local server_name_=$1
    local source_="$2"
    local source_dir_=$(dirnames "$source_")
    local here_root_=$(homework $server_name_)
    [[ -d $here_root_ ]] || mkdir -p $here_root_
    local here_path_=$here_root_/"$source_dir_"
    [[ -d "$here_path_" ]] || mkdir -p "$here_path_"
    rsync -av $server_name_:"$source_" "$here_path_"
}

jalanb_hub ()
{
    ( cd ~/hub;
    grep slack -H */.travis.yml | sed -e "s/:.*//" -e "s:..travis.yml::" | grep -v -e old -e master -e suds | sort | uniq )
}
