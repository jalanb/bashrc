#! /bin/cat

[[ -n $WELCOME_BYE ]] && echo Welcome to $(basename $BASH_SOURCE) in $(dirname $(readlink -f $BASH_SOURCE)) on $(hostname -f)

export DASHBOARD=~/src/git/wwts/dashboard

. $DASHBOARD/deployment/bin/deploying.sh

ans () {
    (cd ~/wwts/dashboard/deployment
    ansible --inventory-file=inventory "$@")
}

ansd () {
    (cd ~/wwts/dashboard/deployment
    ansible --inventory-file=dev "$@")
}

reo () {
    if [[ -d testing/portaltest ]]; then
        reorder-python-imports --application-directories .:testing/portaltest "$@"
        ~/jab/bin/imports -u "$@"
    else
        echo "Cannot find ./dashboard, ./testing" >&2
        return 1
    fi
}

gc8i () {
    git commit -m "SAAS-433: PEP 8 imports
    
https://www.python.org/dev/peps/pep-0008/#id23"

}

gc8l () {
    git commit -m "SAAS-61: PEP 8 line length
    
https://www.python.org/dev/peps/pep-0008/#id19"

}

[[ -n $WELCOME_BYE ]] && echo Bye from $(basename $BASH_SOURCE) in $(dirname $(readlink -f $BASH_SOURCE)) on $(hostname -f)
