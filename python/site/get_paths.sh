#! /bin/bash

set -x
REPO="$SVN/amg/trunk/trackers/python/site-packages"
svn cat $REPO/path.py > path.py
svn cat $REPO/paths.py > paths.py
svn cat $REPO/path.test > path.test
svn cat $REPO/paths.test > paths.test
if [[ -d $TRACKERS ]]
then
	python $TRACKERS/testing/try.py path.
	python $TRACKERS/testing/try.py paths.
else
	try path.
	try paths.
fi
