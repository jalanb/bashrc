#! /bin/bash

require $JAB/src/bash/repo.sh

#! /bin/bash

_set_jab () {
    JAB=$(path_to_this_repo)
    export JAB
    echo JAB = $JAB
}

_set_ssh () {
    local home_id=~/.ssh/id_jab
    [[ -f "$home_id" ]] && export JAB_ID=$home_id
    export JAB_PUB_ID=$JAB_ID.pub
    export JAB_SSH=$(dirname $JAB_PUB_ID)
}

_main () {
    _set_jab
    _set_ssh
}

_main
