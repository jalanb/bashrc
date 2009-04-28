import os
import sys
import path

try:
    screen_width = int(os.environ['COLUMNS'])
except KeyError:
    print >> sys.stderr, 'Please export $COLUMNS'
    sys.exit(1)

def get_dirs(args=None):
    if not args:
        dirs = [ path.path('.') ]
    else:
        dirs = [ p for p in [ path.path(a) for a in args ] if p.isdir() ]
        if not dirs:
            if len(args) == 1:
                raise ValueError('No such directory: %s' % args[0])
            else:
                raise ValueError('No such directories: %s' % ', '.join(args))
    return dirs

def show_dirs(dirs):
    os.system('/bin/ls -d %s' % ' '.join([ ' '.join(d.dirs()) for d in dirs]))
    print

def get_files(dirs=None):
    if not dirs: dirs = get_dirs()
    files = []
    here = path.path('.')
    for d in dirs:
        files.extend([ here.relpathto(f) for f in d.files()])
    return files

def show(groups):
    all = sorted([ (name,files) for name, files in groups.iteritems()])
    for name, files in all:
        print '%s: %s' % (name,', '.join([ f.name for f in files ]))
