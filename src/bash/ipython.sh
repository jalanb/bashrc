#! /bin/cat


ipp () {
    local __doc__="Run ipython with tab title"
    local me=$USER
    local here=$(jostname)
    local options=-noconfirm_exit
    local _ipython=${IPYTHON:-ipython}
    if [[ $($_ipython --help | grep no.*confirm) == "--no-confirm-exit" ]]; then
        options=--no-confirm-exit
    fi
    console_title_on "ipython@${here}" && \
        $_ipython $options "$@" && \
        console_title_off "${me}@${here}"
}

