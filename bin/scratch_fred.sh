#! /bin/bash

pbpaste > ~/tmp/fred
/usr/local/bin/vim ~/tmp/fred
cat ~/tmp/fred | pbcopy
