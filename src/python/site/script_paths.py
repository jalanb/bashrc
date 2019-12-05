"""Provide paths for known scripts"""


from pysyte.types import paths

args = {
    '2': ['~/jab/todo.txt', '~/python/todo.py'],
    'scripts': ['~/python/scripts.py', '~/python/site/script_paths.py'],
    'try': ['~/python/testing/try.py'],
    'v': ['~/python/vim.py', '~/python/vim_script.py', '~/python/site/script_paths.py'],
    'rf': ['~/python/rf.py', '~/.config/rf/config'],
    'jpm': ['~/hub/jpm/jpm/jpm.py', '~/hub/jpm/bin/jpm'],
    'cd':  ['~/hub/cde/cde.sh', '~/hub/cde/cde.py', '~/.config/cd'],
    'locate': ['~/jab/bin/locate', '~/python/site/locate.py'],
    'main': ['~/hub/main.py'],
    'paths': ['~/hub/pysyte/pysyte/paths.py'],
    'whap': ['~/hub/what/whap.py'],
    'whyp': ['~/hub/whyp/whyp.sh', '~/hub/whyp/whyp.py'],
}

def sift(sys_args):
    return {a: args[a] for a in sys_args if a in args}


def arg_paths(sys_args):
    sifted = sift(sys_args)
    values = sifted.values()
    arg_paths = [paths.path(p) for v in sifted.values() for p in v]
    if arg_paths:
        return arg_paths
    expanded = [paths.pyc_to_py(a) for a in
            paths.tab_complete(sys_args, paths.add_stars)]
    return [p for p in expanded if hasattr(p, 'isfile')]
