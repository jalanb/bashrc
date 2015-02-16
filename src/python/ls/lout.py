import os
import argv


import ls_colours
from dotsite.paths import makepath

argv.add_options([
    ('quiet', 'hide directories, blank lines, etc', False),
    ('lines', 'separate by returns (tabs is default)', False),
])


def local_rules(*_):
    pass
lout_rules = local_rules


def screen_width():
    try:
        return int(os.environ['COLUMNS']) - 1
    except KeyError:
        return 0


def show_dirs(dirs):
    if argv.options.quiet:
        return
    here = makepath('.')
    sub_dirs = []
    for Dir in dirs:
        sub_dirs.extend([here.relpathto(p.realpath()) for p in Dir.dirs()])
    os.system('/bin/ls -d %s' % ' '.join(sub_dirs))
    print


def pad(out, bands=4):
    chars_per_band = screen_width() / bands
    out_chars = len(out)
    out_bands = (out_chars / chars_per_band) + 1
    out_size = out_bands * chars_per_band
    assert out_size >= out_chars, '%d < %d' % (out_size, out_chars)
    extra = out_size - out_chars
    return ''.join([out, ' ' * extra])


def sort_by_name(x):
    return sorted(x)


def format_names(names):
    names_and_extensions = []
    for name, files in names.iteritems():
        ordered_exts = ['py', 'j', 'g', 'test', 'tests', 'fail', 'pyc', 'pyo']
        try:
            missing = [e for e in argv.options.exts
                       if e[1:] not in ordered_exts]
            assert not missing
        except AttributeError:
            pass
        f_exts = [f.ext[1:] for f in files]
        lout_rules(f_exts)
        exts = [e for e in ordered_exts
                if e in f_exts or e not in ordered_exts]
        coloured_exts = [ls_colours.colourize_extension(ext) for ext in exts]
        lout_rules(f_exts)
        if '' not in coloured_exts:
            name_and_extensions = '%s.%s' % (name, ','.join(coloured_exts))
        else:
            if len(coloured_exts) == 1:
                name_and_extensions = name
            else:
                coloured_exts.remove('')
                coloured_exts.insert(0, '')
                name_and_extensions = '%s.%s' % (name, ','.join(coloured_exts))
        lout_rules(name_and_extensions)
        names_and_extensions.append(name_and_extensions)
    return sort_by_name(names_and_extensions)


def show_line(outs, columns_per_line):
    cpl = columns_per_line
    columns_this_line, remainder = outs[:cpl], outs[cpl:]
    separator = ''
    if argv.options.lines:
        separator = '\n'
    print separator.join(columns_this_line)
    if remainder:
        show_line(remainder, cpl)


def show(outs):
    try:
        column_width = max([len(o) for o in outs]) + 1
    except ValueError:
        return
    columns_per_line = screen_width() / column_width
    padded = ['%-*s' % (column_width, o) for o in outs]
    show_line(padded, columns_per_line)
