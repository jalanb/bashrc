#! /bin/bash

# alias python=python3
alias v="vim -p"

# This alias is used to run playbooks with ansible-navigator

# This alias is used to set the collection path
alias addcoll="export ANSIBLE_COLLECTIONS_PATHS=collections/"

# This alias is used to install collections
alias collinstall="ansible-galaxy install -r collections/requirements.yml --force -c"

# This alias is used to remove the local collection path when not using local collection and wish to use collections installed in the Execution Environment
alias remcoll="unset ANSIBLE_COLLECTIONS_PATHS"
