#! /bin/cat

source ~/keys/q.sh

# x

l () {
    $(ls_command) "$@"
}

# xx

l1 () {
    l -1 "$@"
}

l0 () {
    l -1 "$@"
}

la () {
    l -a "$@"
}

ld () {
    l -d "$@"
}

lg () {
    gl_ 2 "$@"
}

lf () {
  l fred* 2>&1 | grep -q "No such" && echo "fredless" >&2 
  fdf fred
}

lh () {
    l -lh  "$@"
}

lk () {
    l0 "$@"
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

lO () {
    l -C "$@"
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
    local _dir=.
    [[ -d "$1" ]] && _dir="$1" 
    l ${_dir}/*.py
}

# xxx

l1d () {
    ld -1 "$@"
}

lao () {
    la -C "$@"
}

lal () {
    l -a -l "$@"
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
    local _sought=$1
    if [[ -f $_sought ]]; then
        l $_sought
        return 0
    fi
    while [[ -n $_sought ]]; do
        if l -d $_sought 2>/dev/null; then
            break
        fi
        _sought=$(dirnames $_sought)
        if [[ $_sought == / ]]; then
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
    l --color=always -lrth "$@" | tel
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
    local _status=$(git status -s)
    if [[ -n $_status ]]; then
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
            3y -L 2 --noreport . | grep -v -e bdist -e " _build$" -e __init__.py -e .egg-info
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
    local __doc__="""Use gls if available, or ls if not"""
    local gls_=$(quietly which gls)
    local ls_=$(quietly which ls)
    local which_=${gls:-$ls_}
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

ls_options () {
    local __doc__="""Use available options"""
    local by_dir_= colour_=-G classify_=-F
    local dimension_=-C
    [[ $1 =~ -[v1] ]] && dimension_=-1
    if ls_has_option $colour_; then
        colour_=--color
        by_dir_=--group-directories-first
        classify_=--classify
    fi
    echo "-h $dimension_ $colour_ $by_dir_ $classify_"

}


ls_command () {
    echo "$(ls_program)" "$(ls_options "$@")"
}

# _xxxxxxxxxx



LS_COMMAND=$(ls_command) LS_OPTIONS=$(ls_options) LS_PROGRAM=$(ls_program)
export LS_COMMAND LS_OPTIONS LS_PROGRAM
