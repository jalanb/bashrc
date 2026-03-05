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

cdb () {
    cde /opt/clones/github/brightbeam/
}

cdh () {
    cd /opt/clones/github/jalanb/jalanb/hub/hub
}

cdj () {
    local __doc__="cd to jalanb dir [and run a command (a, f, h, l, r)]"
    cd /opt/clones/github/jalanb/ || return 1
    if [[ -n "${1-}" && -d "$1" ]]; then
        cd "$1" || return 1
        shift
    fi
    [[ "$@" ]] || return 0
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

cdr () {
    local dir_=$(get_root)
    if [[ ! $dir_ ]]; then
        show_error "No git root directory found" >&2
        return 1
    fi
    cdq $dir_
    white "Origin: "; green_line $(git remote get-url origin)
    white " Local: "; green_line $(rlf .)
}

cjy () {
    cd ~/jab/src/python "$@"
}

cla () {
    clean_clear_ls --all "$@"
}

cdl () {
    [[ -d "$1" ]] && cd "$1"
    l,
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

clean () {
    rf -q "$@"
}

# _xxxx
# xxxxxx
# _xxxxx

cclot () {
    local option_=$1
    local arg_=$2
    local i_=$3 name_=$4
    [[ $option_ =~ (-$i_|--$name_) ]]
    [[ $arg_ ]] && echo "option_=${option_}$arg_"
}

clean_clear_ls () {
    local __doc__="clean, clear, ls"
    [[ $1 =~ ^[-][-] ]] || return 1
    local option_=$1; shift
    local dir_=. ls_=ls
    cclot "$option_" n clean && clean
    cclot "$option_" r clear && clear
    cclot "$option_" l ls && ls_=l
    cclot "$option_" a all && option_="${option_}a"
    cclot "$option_" 1 one && option_="${option_}1tr"
    cclot "$option_" o long && option_="${option_}lhtr"
    cclot "$option_" w wide && option_="${option_}C"
    [[ $option_ ]] || option_="${option_}C"
    [[ -d "$1" ]] && dir_="$1"
    [[ -d "$dir_" ]] || return 1
    [[ $ls_ ]] || return 0
    [[ $option_ ]] && option_=-$option_
    $ls_ $option_ "$dir_"
}

