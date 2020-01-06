# Add python-like backtraces to your bash shell scripts!
#
#
# If you're using this, chances are high that you should switch from bash to a
# more modern programming language.
#

# Copyright (c) 2014- Stripe, Inc. (https://stripe.com)
#
# bash-backtrace.sh is published under the MIT license


if [ -z "${BASH_VERSION-}" ]; then
    echo >&2 "Error: this script only works in bash"
    return 1 || exit 1
fi

set -E

# References:
# - https://gist.github.com/ryo1kato/3102982
# - https://gist.github.com/kergoth/6395873

bash_backtrace() {
    local ret=$?
    local i=0
    local FRAMES=${#BASH_SOURCE[@]}


    echo >&2 "Traceback (most recent call last):"

    for ((frame=FRAMES-2; frame >= 0; frame--)); do
        local lineno=${BASH_LINENO[frame]}

        printf >&2 '  File "%s", line %d, in %s\n' \
            "${BASH_SOURCE[frame+1]}" "$lineno" "${FUNCNAME[frame+1]}"

        sed >&2 -n "${lineno}s/^[   ]*/    /p" "${BASH_SOURCE[frame+1]}"
    done

    printf >&2 "Exiting with status %d\n" "$ret"
}

trap bash_backtrace ERR
