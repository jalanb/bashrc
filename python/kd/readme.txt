kd is intended to make cd'ing easier

The script gets a close match to a directory from command line arguments then prints that to stdout
	which allows a usage in bash like
		$ cd $(python kd.py /usr local bin)
	or
		$ cd $(python kd.py /bin/ls)

First argument is a directory
	subsequent arguments are prefixes of sub-directories
	For example:
		$ python kd.py /usr/local bi
		/usr/local/bin

Or first argument is a file
	$ python kd.py /bin/ls
	/bin

Or first argument is a stem of a directory/file
	kd.py will add * on to such a stem,
	and will always find directories first,
		looking ofr files only if there are no such directories
	$ python kd.py /bin/l
	/bin

If nothing matches then give directories in $PATH which have matching executables
	$ python kd.py ls
	/bin

For convenience a bash function is also provided, which can be set up like
	```bash
	$ source kd.sh
	```
	then one can use "kd" as a replacement for cd
	```bash
	$ cd /usr/local/lib/python2.7/site-packages
	$ kd /usr lo li py si
	```
