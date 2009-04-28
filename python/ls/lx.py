import os
import sys
import path
'from optparse import OptParser'

from l import get_dirs, get_files, show, show_dirs

def get_exts(files):
    exts = {}
    for f in files:
        ext = f.ext
        got = exts.get(ext,[])
        got.append(f)
        try: exts[ext] = got
        except Exception, e: raise ', '.join([ str(got), str(exts), ext, f ])
    return exts
        
def main(args):
    dirs = get_dirs(args)
    show_dirs(dirs)
    exts = get_exts(get_files(dirs))
    if not exts: return 0
    show(exts)
    return 0

if __name__ == '__main__':
    sys.exit(main(sys.argv[1:]))
