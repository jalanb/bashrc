#! /bin/bash
#
#
# colours
#
# http://en.wikipedia.org/wiki/ANSI_escape_sequences#Colors
#

export           NO_COLOUR="\033[0m"
export           NIGHT_OFF=$NO_COLOUR
export           LIGHT_OFF=$NO_COLOUR

export         NIGHT_BLACK="\033[0;30m"
export         LIGHT_BLACK="\033[1;30m"
export           NIGHT_RED="\033[0;31m"
export           LIGHT_RED="\033[1;31m"
export         NIGHT_GREEN="\033[0;32m"
export         LIGHT_GREEN="\033[1;32m"
export        NIGHT_YELLOW="\033[0;33m"
export        LIGHT_YELLOW="\033[1;33m"
export          NIGHT_BLUE="\033[0;34m"
export          LIGHT_BLUE="\033[1;34m"
export       NIGHT_MAGENTA="\033[0;35m"
export       LIGHT_MAGENTA="\033[1;35m"
export          NIGHT_CYAN="\033[0;36m"
export          LIGHT_CYAN="\033[1;36m"
export         NIGHT_WHITE="\033[0;37m"
export         LIGHT_WHITE="\033[1;37m"
export          NIGHT_GRAY="\033[0;38m"
export          LIGHT_GRAY="\033[1;38m"

export          BACK_BLACK="\033[40m"
export            BACK_RED="\033[41m"
export          BACK_GREEN="\033[42m"
export         BACK_YELLOW="\033[43m"
export           BACK_BLUE="\033[44m"
export        BACK_MAGENTA="\033[45m"
export           BACK_CYAN="\033[46m"
export          BACK_WHITE="\033[47m"
export           BACK_GRAY="\033[48m"
#
# I'm sure there was a good reason to have these, years ago
#     Somthing to with prompts on Linux?
#
export     OTHER_NO_COLOUR="\[\033[0m\]"
export           OTHER_RED="\[\033[0;31m\]"
export     OTHER_LIGHT_RED="\[\033[1;31m\]"
export         OTHER_GREEN="\[\033[0;32m\]"
export   OTHER_LIGHT_GREEN="\[\033[1;32m\]"
export        OTHER_YELLOW="\[\033[0;33m\]"
export  OTHER_LIGHT_YELLOW="\[\033[1;33m\]"
export          OTHER_BLUE="\[\033[0;34m\]"
export    OTHER_LIGHT_BLUE="\[\033[1;34m\]"
export       OTHER_MAGENTA="\[\033[0;35m\]"
export OTHER_LIGHT_MAGENTA="\[\033[1;35m\]"
export          OTHER_CYAN="\[\033[0;36m\]"
export    OTHER_LIGHT_CYAN="\[\033[1;36m\]"
export         OTHER_WHITE="\[\033[1;37m\]"
export    OTHER_LIGHT_GRAY="\[\033[0;37m\]"
export          OTHER_GRAY="\[\033[1;38m\]"
