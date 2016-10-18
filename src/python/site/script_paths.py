"""Provide paths for known scripts"""


import itertools


from dotsite.paths import path


def get(strings):
    hub = path('~/hub')
    jab = path('~/jab')
    jab_bin = jab / 'bin'
    jab_src = jab / 'src'
    jab_python = jab_src / 'python'
    jab_todo = jab / 'todo.txt'
    config = path('~/.config')
    abbreviations = {
        '2': [
            jab_todo,
            jab_python / 'todo.py',
        ], 'scripts': [
            jab_python / 'scripts.py',
            jab_python / 'site/script_paths.py',
        ], 'v': [
            jab_python / 'vim.py',
            jab_python / 'vim_script.py',
            jab_python / 'site/script_paths.py',
        ], 'rf': [
            jab_python / 'rf.py',
            config / 'rf/config',
        ], 'jpm': [
            hub / 'jpm/jpm/jpm.py',
            hub / 'jpm/bin/jpm',
        ], 'kd':  [
            hub / 'kd/kd.sh',
            hub / 'kd/kd.py',
            config / 'kd',
        ], 'locate': [
            jab_bin / 'locate',
            jab_python / 'site/locate.py',
        ], 'main': [
            hub / 'main.py',
        ], 'paths': [
            hub / 'dotsite/dotpaths.py',
        ], 'whap': [
            hub / 'what/whap.py',
        ], 'what': [
            hub / 'what/what.sh',
            hub / 'what/what.py',
        ],
        # ], '': [
        #    hub / '',
        # ],
    }
    if strings:
        lists_of_paths = [abbreviations[s] for s in strings
                          if s in abbreviations]
    else:
        lists_of_paths = abbreviations.values()
    paths_ = list(itertools.chain(*lists_of_paths))
    return [_ for _ in paths_ if _.isfile()]
