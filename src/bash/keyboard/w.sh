#! /bin/cat

! type ww >/dev/null 2>&1 && test  -f ~/whyp.sh && . ~/whyp.sh

# # x
# 
# w () {
#     local __doc__='Show whether the first argument is a text file, alias or function'
#     if is_alias $1; then
#         alias $1
#     elif is_function $1; then
#         _parse_function $1
#         echo "$1 is a function in '$path_to_file':$line_number"
#     elif is_executable $1; then
#         real_path=$(type -p $1)
#         real_name=$(basename "$real_path")
#         [[ "$real_name" == "$1" ]] || echo "$1 is a file $real_path"
#         ls -l $(realpath $(which $1))
#     else
#         type $1
#     fi
# }
# 
# # xx
# 
# ww () {
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
#     ww ${1:0:${#1}-1} && return $PASS
#     return $FAIL
# }
# 
# # xxx
# 
# www () {
#     . ~/hub/whyp/whyp.sh
#     (DEBUGGING=www;
#     local _command=$1; shift
#     ww $_command;
#     w $_command;
#     if is_function $_command; then
#         (set -x; $_command "$@")
#     elif is_alias $_command; then
#         (set -x; $_command "$@")
#     elif file $_command  | grep -q -e script -e text; then
#         what_wwm $_command "$@"
#     else
#         echo 0
#     fi)
# }
# # xxxx
# # xxxxx
# # xxxxxx
# # xxxxxxx
# # xxxxxxxx
