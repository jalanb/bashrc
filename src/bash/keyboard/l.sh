#! /bin/cat

source ~/keys/q.sh

# x

l () {
    local args_=$1
    local ls_=$(ls_command)
    if [[ $1 ]]; then
        $(ls_command) "$@"
    else
        $(ls_command) .
    fi
}

# xx

l1 () {
    l -1 "$@"
}

l0 () {
    l -1 "$@"
}

lA () {
    l -a "$@"
}

la () {
    l -A "$@"
}

ld () {
    l -d "$@"
}

lg () {
    gl_ 2 "$@"
}

lf () {
    local one_= file_=
    for one_ in "$@"; do
        test -f $one_ || continue
        $file_ ="$one_"
        rlf "$file_"
    done
    [[ $file_ ]] && return 0
    rlf fred* 2>&1 | grep -q "No such" && echo "fredless" >&2
    return 1
}

lh () {
    l -lh  "$@"
}

lk () {
    l0 "$@"
}


ll () {
    local __doc__="""Long list the args"""
    local arg_= paths_= options_=-lh
    for arg_ in "$@"; do
        test -e $arg_ || continue
        if [[ -d "$arg_" ]]; then
            if [[ $arg_ =~ /$ ]]; then
                options_="$options_ -d"
                args_="${arg_}%/}"
            else
                options_="$options_ -A"
            fi
        fi
        paths_="${paths_} ${arg_}"
    done
    [[ $paths_ ]] || paths_=.
    green_line $PWD
    show_command -q l $options_ $paths_
    echo
    #(set +x
        local fred="$options_"
        local fred_=$paths_
        l "$options_" $paths_
    #)
}

lo () {
    l $(ls_dimension) "$@"
}

lp () {
    echo
    green -n $PWD
    echo
    l "$@"
}

lr () {
    l -tr "$@"
}

lt () {
    l -t 4 "$@"
}

lx () {
    l -xtr "$@"
}

ly () {
    local dir_=.
    [[ -d "$1" ]] && dir_="$1"
    l ${dir_}/*.py
}

# xxx

l1d () {
    ld -1 "$@"
}

lao () {
    la $(ls_dimension) "$@"
}

lal () {
    l -a -lh "$@"
}

lda () {
    ls -1da "$@"
}

lff () {
    ls fred*
}

lka () {
    l -a "$@"
}

lkk () {
    l -a "$@"
}

lkl () {
    lkra "$@"
}

lkq () {
    local sought_=$1
    if [[ -f $sought_ ]]; then
        l $sought_
        return 0
    fi
    while [[ -n $sought_ ]]; do
        if l -d $sought_ 2>/dev/null; then
            break
        fi
        sought_=$(dirnames $sought_)
        if [[ $sought_ == / ]]; then
            break
        fi
    done
}

lkr () {
    l -lhtr "$@"
}

lib () {
    lr ~/.bashrc
}

lla () {
    ll -a "$@"
}

llg () {
    gl_ 3 "$@"
}

lll () {
    rlg "$@"
    ll -tr "$@"
}

llo () {
    rlg "$@"
    lo -tr "$@"
}

llr () {
    rlg "$@"
    ll -htr "$@"
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

lns () {
    ln -s "$@"
}

loa () {
    lo -a "$@"
}

loc () {
    locate "$@"
}

lof () {
    locate -f "$@"
}

lr1 () {
    shift_dir "$@" && shift
    l -1tr --color=always "$dir" | tel
}

lra () {
    lr -a "$@"
}

lrd () {
    lr -d "$@"
}

lrt () {
    l --color=always -lhtr "$@" | tel
}

ls1 () {
    l0 "$@" | sort
}

lsh () {
    l *.sh
}

ltr () {
    lt -r "$@"
}

lyi () {(
    local package_=pym
    local package_dir_=~/hub/jalanb/$package_
    [[ -d ~/$package_ ]] && package_dir_=~/$package_
    local package_bin_=$package_dir_/bin
    if [[ -d $package_bin_ ]]; then
        [[ $PATH ]] && PATH="$package_bin_:$PATH" || PATH=$package_bin_
    fi
    local package_python_=$package_dir_/$package_
    if [[ -d $package_python_ ]]; then
        [[ $PYTHONPATH ]] && PYTHONPATH="$package_python_:$PYTHONPATH" || PYTHONPATH=$package_python_
    fi
    cd $package_dir_
    [[ -f .venv/bin/activate ]] || show_fail "-f $package_dir_/.venv/bin/activate"
    [[ -f .venv/bin/activate ]] || return 1
    source .venv/bin/activate
    if [[ -n $* ]]; then
        if shift_dir "$@"; then
            shift
            cd $dir
        fi
    fi
    pwd
    local status_=$(git status -s)
    if [[ -n $status_ ]]; then
        echo -n "\$ git status -s: "
        git status -s
    else
        local has_dirs=
        for item in $(ls); do
            if [[ -d "$item" ]]; then
                has_dirs=1
                break
            fi
        done
        if [[ $has_dirs == 1 ]]; then
            3y -L 2 --noreport . | grep -v -e bdist -e " build_$" -e __init__.py -e .egg-info
        fi
        echo
    fi
    if [[ -n $(ls *.py | grep -v __init__.py > /dev/null) ]]; then ly -q
    elif [[ -n $(ls * | grep -v __init__.py) ]]; then lo
    fi
    echo
    [[ -n $* ]] && "$@"
)}


lyy () {
    reset=$(shopt -p dotglob)
    shopt -s dotglob
    l -xd $(ls -F |grep \/$)
    echo
    lx *.tests 2>/dev/null
    echo
    lx *.test 2>/dev/null
    echo
    lx *.py 2>/dev/null
    $reset
}

loo () {
    local dir_=.
    [[ -f $1 ]] && dir_=$(dirname $1)
    [[ -d $1 ]] && dir_=$1
    [[ -d $dir_ ]] || return 1
    shift
    loa $dir_ "$@"
}

# xxxx

lllg () {
    gl_ 5 "$@"
}

llll () {
    lll -a "$@"
}

llllg () {
    gl_ 8 "$@"
}

lllllg () {
    gl_ 13 "$@"
}

lllllg () {
    gl_ 21 "$@"
}

llllllg () {
    gl_ 33 "$@"
}

lllllllg () {
    gl_ 54 "$@"
}

llllllllg () {
    gl_ 87 "$@"
}

lllllllllg () {
    gl_ 141 "$@"
}


# _xxxxxxxxx

ls_program () {
    local __doc__="""Use eza if availabe, else gls, else ls"""
    local eza_=$(quietly which eza)
    local gls_=$(quietly which gls)
    local ls_=$(quietly which ls)
    local best_ls_=${gls_:-$ls_}
    local which_=${eza_:-$best_ls_}
    [[ $which_ ]] || show_fail "No ls available"
    [[ $which_ ]] || return 1
    local link_=$(readlink -f $which_)
    [[ -x $link_ ]] || return 1
    echo $link_
}

ls_has_option () {
    local ls_=$(ls_program) || return 1
    $ls_ --help 2>/dev/null | grep -q -- $1 && return 0
    return 2
}

ls_dimension () {
    if ls_has_option '-C'; then
        echo "-C"
    elif ls_has_option '-G'; then
        echo "-G"
    elif [[ $1 =~ -[v1] ]]; then
        echo "-1"
    else
        return 1
    fi
    return 0
}

ls_options () {
    local __doc__="""Use available options"""
    local dimension_=$(ls_dimension "$1")
    local colour_=-G classify_=-F by_dir_=
    if ls_has_option '--color' ; then
        colour_="--color=auto"
        classify_=--classify
        by_dir_=--group-directories-first
    fi
    echo "-h $dimension_ $colour_ $classify_ $by_dir_"
}


ls_command () {
    local __doc__="ls_command ""$@"
    local __program__="$(ls_program)"
    local __options__="$(ls_options)"
    echo "$(ls_program)" "$(ls_options)" "$@"
}

# _xxxxxxxxxx

ls_colours () {
    [[ $LS_COLORS ]] || eval $(dircolors ~/.dircolors)
}



LS_COMMAND=$(ls_command) LS_OPTIONS=$(ls_options) LS_PROGRAM=$(ls_program)
export LS_COMMAND LS_OPTIONS LS_PROGRAM
