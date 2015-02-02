"""Provide paths for known scripts"""


import itertools


from dotsite import paths


def get(strings):
    hub = paths.environ_path('GITHUB')
    jab_python = paths.environ_path('JAB_PYTHON')
    jab_todo = paths.environ_path('JAB_TODO')
    config = paths.makepath('~/.config')
    abbreviations = {
        '2': [
            jab_todo,
            jab_python / 'todo.py',
        ], 'scripts': [
            jab_python / 'site/script_paths.py',
            jab_python / 'scripts.py',
        ], 'v': [
            jab_python / 'vim',
            jab_python / 'vim_script.py',
        ], 'rf': [
            jab_python / 'rf.py',
            config / 'rf/config',
        ], 'jpm': [
            hub / 'jpm/jpm/jpm.py',
            hub / 'jpm/bin/jpm',
        ], 'kd':  [
            hub / 'kd/kd.py',
            config / 'kd',
        ], 'main': [
            hub / 'main.py',
        ], 'paths': [
            hub / 'dotsite/dotsite/paths.py',
        ], 'what': [
            hub / 'what/what.sh',
            hub / 'what/what.py',
        ],
        #], '': [
        #    hub / '',
        #],
    }
    return list(
        itertools.chain(
            *[abbreviations[s] for s in strings if s in abbreviations]))
