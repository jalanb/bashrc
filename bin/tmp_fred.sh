#! /bin/bash

PATH=/usr/local/bin:/usr/bin

pbpaste > ~/tmp/fred
vim ~/tmp/fred
cat ~/tmp/fred | pbcopy
