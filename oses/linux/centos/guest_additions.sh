#! /bin/bash

bits=$(uname -i)
wget http://packages.sw.be/rpmforge-release/rpmforge-release-0.5.2-2.el5.rf.${bits}.rpm
rpm --import http://apt.sw.be/RPM-GPG-KEY.dag.txt
rpm -K rpmforge-release-0.5.2-2.el5.rf.${bits}.rpm
rpm -i rpmforge-release-0.5.2-2.el5.rf.${bits}.rpm

alias yum="/usr/bin/yum -y"

yum --enablerepo rpmforge install dkms
yum update
yum groupinstall "Development Tools"
yum install kernel-devel
cd /media/VBOXADDITIONS_4.2.6_82870/
/bin/bash VBoxLinuxAdditions.run
reboot
