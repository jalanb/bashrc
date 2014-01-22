import path
import argv
import l
import lout


try:
    Any = any
except NameError:
    def Any(x):
        return [a for a in x if a]


def _post_parse(options, args):
    wanted = {
        'tests' : ['.test', '.tests'],
        'compiled' : ['.pyc', '.pyo'],
        'grammar' : ['.g', '.j'],
        'fails' : ['.fail'],
    }
    options.exts = ['.py', ]
    options.wanted = ['.py', ]
    for k, v in options.__dict__.iteritems():
        try:
            if v:
                options.wanted.extend(wanted[k])
            options.exts.extend(wanted[k])
        except KeyError:
            pass
    return options, args

def prepare_argv():
    argv.post_parses.append(_post_parse)
    argv.add_options([
        ('all', 'show all python related files', False),
        ('compiled', 'show compiled python', False),
        ('fails', 'show fails', False),
        ('grammar', 'show grammars', False),
        ('others', 'show non python related files as well', False),
        ('tests', 'show tests', False),
        ('ython', 'hide python scripts', False),
    ])


def _python_wanted(path_to_file):
    ext = path_to_file.ext
    if ext == '.py':
        return not argv.options.ython
    if argv.options.others:
        return True
    if argv.options.all:
        return ext in argv.options.exts
    return ext in argv.options.wanted


def _filter_names(names):
    remove = []
    for name, files in names.iteritems():
        wanted_files = [f for f in files if _python_wanted(f)]
        if not Any(wanted_files):
            remove.append(name)
        else:
            names[name] = wanted_files
            exts = [f.ext for f in wanted_files]
            ly_rules(exts)
    for key in remove:
        del names[key]


def ly_rules(things):
    try:
        exts = [f.ext for f in things]
    except AttributeError:
        if ',' in things:
            exts = things.split(',')
            if exts[0].endswith('.py'):
                exts[0] = '.py'
        else:
            if type(things) == type(''):
                things = [things]
            exts = [path.path(f).ext for f in things]
    python_present = '.py' in exts or 'py' in exts
    hide_python = argv.options.ython
    if hide_python:
        assert not python_present, str(exts)
    if python_present:
        assert not hide_python, str(exts)


lout.lout_rules = ly_rules


def show():
    try:
        dirs = l.get_dirs(argv.args)
    except ValueError, e:
        print e
        return
    lout.show_dirs(dirs)
    files = l.get_files(dirs)
    if not argv.options.notice:
        files = l.remove_ignored(files)
    names = l.get_names(files)
    if not names:
        return 0
    _filter_names(names)
    outs = lout.format_names(names)
    lout.show(outs)
    if not argv.options.quiet:
        print
        print
    return 0


def main():
    show()


if __name__ == '__main__':
    prepare_argv()
    argv.main(main)

