#! /bin/bash

get_pandemic ()
{
	wget --no-check-certificate https://github.com/jwcxz/vim-pandemic/archive/master.zip
	unzip vim-pandemic-master.zip
	rm -rf vim-pandemic-master.zip
}

make_pandemic ()
{
	cd vim-pandemic-master
	sed -i -e "s|vim/bundle.remote|vim/bundle|" bin/pandemic
	python2.7 setup.py install --prefix=$HOME
	PANDEMIC=$PANDEMIC
	if [[ ! -f $PANDEMIC ]]
	then
		echo Installation of $PANDEMIC failed >&2
		exit 1
	else
		sed -i -e "s|vim/bundle.remote|vim/bundle|" $PANDEMIC
	fi
}

update_pandemic ()
{
	$PANDEMIC list | sed -e "s/:.*//" | xargs env GIT_SSL_NO_VERIFY=true pandemic update
}

clean_up ()
{
	cd $START_HERE
	test -d vim-pandemic-master && rm -rf vim-pandemic-master
	test -f vim-pandemic-master.zip && rm -f vim-pandemic-master.zip
}

main ()
{
	START_HERE=$PWD
	get_pandemic
	make_pandemic
	update_pandemic
}

trap cleanup EXIT
main $*
