#! /bin/bash

install_software () {
	sudo apt-get update
	sudo apt-get upgrade
	if [[ -d /media/VBOXADDITIONS_4.2.6_82870/ ]]; then
		sudo apt-get -y -qq install dkms
		cd /media/VBOXADDITIONS_4.2.6_82870/
		sudo ./VBoxLinuxAdditions.run 
	fi
	sudo apt-get -y -q remove ack
	sudo apt-get -y -qq install apt-file subversion ctags tree gcc libc-dev rlwrap ack-grep tofrodos sshfs guake openssh-server
	sudo apt-get -y -q install zlib1g-dev libreadline6-dev libdb4.8-dev libncurses5-dev
	# for python, from http://askubuntu.com/questions/21547/what-are-the-packages-libraries-i-should-install-before-compiling-python-from-so
	sudo apt-get -y -q install build-essential libz-dev libncursesw5-dev libssl-dev libgdbm-dev libsqlite3-dev libbz2-dev

	cd /usr/bin
	sudo ln -s ack-grep ack
	sudo ln -s fromdos dos2unix
	sudo ln -s todos unix2dos
}

main () {
	install_software
}

main
