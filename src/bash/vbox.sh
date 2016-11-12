#! /bin/cat


v_up () {
    VM_NAME=$(VBoxManage list runningvms | cut -d'"' -f2)
    if [[ -z $VM_NAME ]]; then
        vagrant up
        VM_NAME=$(VBoxManage list runningvms | cut -d'"' -f2)
    fi
    vagrant halt
    VBoxManage modifyvm $VM_NAME --natdnshostresolver1 on
    vagrant up
    restarts default
}

v_net () {
    VBoxManage modifyvm dashboard_default_1455031800759_50753 --natdnshostresolver1 on
}


