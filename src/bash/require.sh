REQUIRE_SOURCE=source

require () {
    if [[ -z $WHAT_AQCQUIRED ]]; then
        if [[ -f $HUB/what/what.sh ]]; then
            source $HUB/what/what.sh
            REQUIRE_SOURCE=source_what
        else
            ls -l $HUB/what/what.sh
        fi
    fi
    $REQUIRE_SOURCE "$@"
}

export REQUIRE_SOURCE
