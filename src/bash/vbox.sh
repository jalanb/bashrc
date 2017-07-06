#! /bin/cat


_vm_name () {
    VM_NAME=$(VBoxManage list runningvms | cut -d'"' -f2)
    if [[ -z $VM_NAME ]]; then
        vagrant up
        VM_NAME=$(VBoxManage list runningvms | cut -d'"' -f2)
    fi
}

v_up () {
    _vm_name
    vagrant halt
    VBoxManage modifyvm $VM_NAME --natdnshostresolver1 on
    vagrant up
    restarts default
}

v_net () {
    _vm_name
    VBoxManage modifyvm $VM_NAME --natdnshostresolver1 on
}


