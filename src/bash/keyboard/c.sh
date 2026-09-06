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

cc () {
    cd "$CDE_DIR"
}
#
# cd () {
#     command cd "$@" || return 1
#     local cde_=$HOME/cde
#     PYTHONPATH=$cde_ $cde_/.venv/bin/python3 -m cde --QUIETLY --add .
# }

cg () {
    local _where=.
    [[ "$*" ]] && _where="$@"
    cde $(git -C "$_where" rev-parse --show-toplevel)
}

ch () {
    cde ~/hub/
}

cj () {
    cde ~/jab/
}

cl () {
    clean_clear_ls --clear "$@"
}

cr () {
    clean_clear_ls --clean "$@"
}

# cp is hashed (/usr/local/gnu/cp)

cs () {
    claude_subinit
}

cw () {
    cde $WHYP_SOURCE
}

cv () {
    bash ~/jab/bin/clipvim.sh
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

ccd () {
    cd $1
    clear
    pwd
    l
}

cd- () {
    cd -
    [[ -f .venv/bin/activate ]] && source .venv/bin/activate
}

cdj () {
    local __doc__="cd to jalanb dir [and run a command (a, f, h, l, r)]"
    cd /opt/clones/github/jalanb/ || return 1
    if [[ -n "${1-}" && -d "$1" ]]; then
        cd "$1" || return 1
        shift
    fi
    [[ "$*" ]] || return 0
    local command_=
    case "${1-}" in
        a) command_=ack;    shift ;;
        f) command_=fd;     shift ;;
        h) command_=hub;    shift ;;
        l) command_=l;      shift ;;
        r) command_=ranger; shift ;;
    esac
    [[ "$command_" ]] || return 0
    if [[ "$command_" == hub ]]; then
        fd -td hub "$@" .
    else
        "$command_" "$@" .
    fi
}

cdl () {
    [[ -d "$1" ]] && cd "$1"
    l,
}

cdr () {
    local dir_=$(get_root)
    if [[ ! $dir_ ]]; then
        show_fail "No git root directory found"
        return 1
    fi
    if ! cdq $dir_; then
        show_fail "Cannot cd to \"$dir_\""
        return 1
    fi
    white "Origin: "; green_line $(git remote get-url origin)
    white " Local: "; green_line $(rlf .)
}

cdw () {
    cd ~/whyp/
}

cjy () {
    cd ~/jab/src/python "$@"
}

cla () {
    clean_clear_ls --all "$@"
}

cll () {
    clean_clear_ls --long "$@"
}

clo () {
    cde $(locate "$@")
}

cls () {
    clean_clear_ls --wide "$@"
}

csf () {
    claude_subinit --force "$@"
}

# xxxx

cdjj () {
    (cdj "$@")
}

# clla () {
#     clean_clear_ls --long --all "$@"
# }
#

code () {
    local cmd_=(/opt/homebrew/bin/cmd --create --read --trust)
    (
        if [[ -d "$1" ]] then
            cd "$1"
            shift
        fi
        "${cmd_[@]}" "$@"
    )
}

# _xxx
# xxxxx

cdclo () {
    cde /opt/clones/"$@"
}

cdhub () {
    cdclo github/"$@"
}

cdlab () {
    cdclo gitlab/"$@"
}

clean () {
    rf -q "$@"
}

# _xxxx
# xxxxxx
# _xxxxx

ccl_option () {
    [[ $1 =~ ^(-$2|--$3) ]]
}

clean_clear_ls () {
    local __doc__="clean, clear, ls"
    [[ $1 =~ ^[-][-]* ]] || return 1
    local dir_=. ls_=ls
    ccl_option $1 l ls && ls_=l
    local arg_=
    ccl_option $1 a all && arg_=a
    ccl_option $1 1 one && arg_=1tr
    ccl_option $1 o long && arg_=lhtr
    ccl_option $1 w wide && arg_=C
    shift
    local option_=
    [[ $arg_ ]] && option_=" -$arg_" || option_=" -C"
    [[ "$1" ]] && dir_="$1"
    [[ -d "$dir_" ]] || return 1
    [[ $ls_ ]] || return 0
    clean
    clear
    green_line $PWD
    echo
    $(ls_program ls) $(ls_options) $option_ "$dir_"
}

