#! /bin/bash

# export PATH=$PATH:

export VIP=192.168.111.222
export HVIP=http://192.168.111.222

. $JAB/src/bash/hub.sh

ssv () {
    ssh vagrant@$VIP "$@"
}

wwts () {
    # workon wwts
    add_to_a_path PATH /cygdrive/c/Users/AB13173/BabunVagrantAnsible/vagrant/bin
    c $GIT/parthenonsoftware/git-wwts/wwts-dashboard
}

restarts () {
    server=$1
    for name in uwsgi nginx redis mysqld; do
        ssh -q -t $server "sudo service $name restart";
    done
}

#######


gfb () {
    local _branch=$1
    local _merge_master=1
    [[ $_branch == master ]] && _merge_master=0
    if [[ -n $_branch ]]; then
        [[ -n $2 ]] && _merge_master=$2
    fi
    git merge --abort >/dev/null 2>&1
    git co ${_branch} | grep -v Switched
    [[ $_merge_master == 1 ]] && git merge master
    git branch -D fred
}

gfd () {
    gfb deployed_to_twkwbe95
}

gfm () {
    # viz gmf
    gfb master
}

gmf () {
    # viz gfm
    [[ -n $1 ]] && git co $1
    git co -b fred
    git merge master
}

go () {
    for branch in $(git branch -a | grep -v -e remotes -e master -e fred -e deploy -e 23430_call_certifications | sed -e "s/^./ /"); do
        echo ================================
        echo $branch
        git co $branch || break
        git status -s || break
        git co dashboard
        git pull --rebase
    done
}


