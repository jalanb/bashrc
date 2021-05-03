#! /bin/bash

pbpaste > ~/tmp/fred
vim ~/tmp/fred
cat ~/tmp/fred | pbcopy

