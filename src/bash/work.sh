#! /bin/cat



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
