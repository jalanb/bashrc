#! /bin/cat

Welcome_to $BASH_SOURCE


ans () {
    (cd_deployment
    ansible --inventory-file=inventory "$@")
}

anp () {
    (cd_deployment
    ansible-playbook site.yml --inventory-file=inventory "$@")
}

ansd () {
    (cd_deployment
    ansible --inventory-file=dev "$@")
}

anpd () {
    (cd_deployment
    ansible-playbook site.yml --inventory-file=dev --limit default "$@")
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

Bye_from $BASH_SOURCE
