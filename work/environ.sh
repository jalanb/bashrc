export WORK=smbc
export WORK_COM=smbcgroup.com

set_vs_code_path () {
    CODE_DIR=$(ls -d $HOME/.vscode-server/cli/servers/Stable-*/server/bin/remote-cli 2>/dev/null)
    PATH="$PATH:$CODE_DIR"
    export PATH
}

set_environment () {
    # A list of Global Environment variables you can set in your bashrc, not all values will be relevant to you. Each value can be overridden in your project directory
    # Set the default remote user your connections will connect to the remote machine as.
    export ANSIBLE_REMOTE_USER=$USER
    # Set the default global become method that you will use to change to another user on the remote machine.
    # Setting to su if working with Linux servers
    export ANSIBLE_BECOME_METHOD=su
    # Set the default global become program to use when escalating permissions on a remote machine
    # Set this when working with Linux servers
    export ANSIBLE_BECOME_EXE='/usr/local/bin/ansible_escalator.sh sudo '
    # Set pipeling to tru globally
    export ANSIBLE_PIPELINING=True
    # Set the callback format used when printing STDOUT to the console
    export ANSIBLE_CALLBACK_RESULT_FORMAT=community.general.yaml
    # Set the default global timeout for how long an ssh connection will try before failing
    export ANSIBLE_TIMEOUT=60
    # Set the default global timeout for how long gather facts will attempt before failing
    export ANSIBLE_GATHER_TIMEOUT=60
    # Set the ansible to ignore duplicate dict items to ignore
    export ANSIBLE_DUPLICATE_YAML_DICT=ignore
    # Set the localhost warning to false
    export ANSIBLE_LOCALHOST_WARNING=False
    # Set host key checking to false
    export ANSIBLE_HOST_KEY_CHECKING=False
    # After setting all your exports please set this value to unset the collections path. 
    # if you are using an EE with all collections compiled inside the container
    unset ANSIBLE_COLLECTIONS_PATHS
}

set_galaxy () {
    # Setting for Automation Hub
    export ANSIBLE_GALAXY_IGNORE=True
    export ANSIBLE_GALAXY_SERVER_LIST=rh_certified_repo,validated_repo,smbc_repo,community_repo
    export ANSIBLE_GALAXY_SERVER_RH_CERTIFIED_REPO_URL=https://hub.aapprod.smbcgroup.com/api/galaxy/content/rh-certified/
    export ANSIBLE_GALAXY_SERVER_VALIDATED_REPO_URL=https://hub.aapprod.smbcgroup.com/api/galaxy/content/validated/
    export ANSIBLE_GALAXY_SERVER_SMBC_REPO_URL=https://hub.aapprod.smbcgroup.com/api/galaxy/content/smbc/
    export ANSIBLE_GALAXY_SERVER_COMMUNITY_REPO_URL=https://hub.aapprod.smbcgroup.com/api/galaxy/content/community/
}

set_environment
set_galaxy
set_vs_code_path
