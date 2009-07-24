import os
import sys
import path
import argv

from l import get_dirs, get_files
import lout

def get_exts(files):
	exts = {}
	for f in files:
		if f.name.startswith('.'):
			ext = '.'
		else:
			ext = f.ext
		got = exts.get(ext,[])
		got.append(f)
		try: exts[ext] = got
		except Exception, e: raise ', '.join([ str(got), str(exts), ext, f ])
	return exts

def main():
	argv.parse_args()
	dirs = get_dirs(argv.args)
	lout.show_dirs(dirs)
	exts = get_exts(get_files(dirs))
	if not exts: return 0
	lout.show(exts)
	return 0

if __name__ == '__main__':
	sys.exit(main())
