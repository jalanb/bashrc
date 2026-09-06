#! /bin/cat

# x

p () {
    if [[ $1 == "-q" ]]; then
        shift
    else
        show_command python "$@"
    fi
    python "$@"
}

# xx

pg () {
    ps -ef | grep -v grep | grep "$@"
}

pm () {
    local option_=
    if [[ $1 == "-q" ]]; then
        shift
        option_=-q
    fi
    p $option_ -m "$@"
}

pv () {
    unhash_python_handlers
    [[ $1 == -f ]] && rm -rf .venv
    if [[ ! -d .venv && ( $1 == "-f" || -f pyproject.toml ) ]]; then
        python3 -m venv .venv
    fi
    [[ -d .venv ]] || return 9
    . .venv/bin/activate
    python -c "import sys; print(sys.executable)"
    python -V
}

pvf () {
    pv -f 
}

# xxx

. ~/bash/python.sh

pv_activable () {
   local dir_="$1"
   [[ -d "$dir_" ]] || return 1
   [[ "$dir_" == "/" ]] && return 2
   local blacklist_=("/opt/clones" "$HOME")
   for blacklisted_ in "${blacklist_[@]}"; do
       [[ "$dir_" == "$blacklisted_"* ]] && return 3
   done
   local activate_="$dir_/.venv/bin/activate"
   [[ -f "$activate_" ]] && echo "$activate_"
   return 0
}

pvv () {
   local __doc__='activate closest .venv found searching up from here'
   [[ -n "$VIRTUAL_ENV" ]] && deactivate
   
   local dir_="$PWD"
   
   while dir_=$(dirname "$dir_"); do
       local activate_script=$(pv_activable "$dir_") || break
       if [[ -f "$activate_script" ]]; then
           . "$activate_script"
           return 0
       fi
   done

   echo "nothing found activatable" >&2
}
