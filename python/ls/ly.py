import os
import sys
import path
'from optparse import OptParser'

try: any([])
except NameError:
	def any(x):
		return len(x) > 0

from l import get_dirs, get_files, screen_width, show_dirs

py_exts = [ '.py', '.test', '.tests' ]

def get_stems(files):
    stems = {}
    for f in files:
        stem = f.namebase
        got = stems.get(stem,[])
        got.append(f)
        try: stems[stem] = got
        except Exception, e: raise ', '.join([ str(got), str(stems), stem, f ])
    return stems
        
def filter_stems(stems,py_exts):
    remove = []
    for stem,files in stems.iteritems():
        if not any([f for f in files if f.ext in py_exts]):
            remove += [ stem ]
    for key in remove:
        del stems[key]

def pad(out, bands = 4):
    chars_per_band = screen_width / bands
    out_chars = len(out)
    out_bands = ( out_chars / chars_per_band ) + 1
    out_size = out_bands * chars_per_band
    assert out_size >= out_chars, '%d < %d' % ( out_size, out_chars )
    extra = out_size - out_chars
    return ''.join([out,' ' * extra])

def show(stems):
    all = sorted([ (name,[f.ext for f in files]) for name, files in stems.iteritems()])
    outs = []
    max_len = 0
    chars_remaining = 0
    for name, exts in all:
        out = pad('%s.%s' % (name,' '.join([e[1:] for e in exts])))
        out_len = len(out)
        if out_len > chars_remaining:
            chars_remaining = screen_width
            print '\r',
        print out,
        chars_remaining -= out_len
    print
        
def main(args):
    dirs = get_dirs(args)
    show_dirs(dirs)
    stems = get_stems(get_files(dirs))
    if not stems: return 0
    filter_stems(stems,py_exts)
    show(stems)
    return 0

if __name__ == '__main__':
    sys.exit(main(sys.argv[1:]))

