#! /bin/bash

sudo yum update
sudo yum upgrade
test -f guest_additions.sh && /bin/bash guest_additions.sh
sudo /usr/bin/yum -y -q install -qq ipython ctags ack sshfs openssh-server
