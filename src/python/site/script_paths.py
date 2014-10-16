"""Provide paths for known scripts"""


import itertools


from dotsite import paths


def get(strings):
    hub = paths.environ_path('GITHUB_SOURCES')
    jab_python = paths.environ_path('JAB_PYTHON')
    jab_todo = paths.environ_path('JAB_TODO')
    config = paths.makepath('~/.config')
    abbreviations = {
        'jpm': [hub / 'jpm/jpm/jpm.py',
                hub / 'jpm/bin/jpm'],
        'kd':  [hub / 'kd/kd.py',
                config / 'kd'],
        'rf': [jab_python / 'rf.py',
               config / 'rf/config'],
        'main': [hub / 'main.py'],
        'what': [hub / 'what/what.sh',
                 hub / 'what/what.py'],
        'scripts': [jab_python / 'scripts.py',
                    jab_python / 'site/script_paths.py'],
        'v': [jab_python / 'vim',
              jab_python / 'vim_script.py'],
        '2': [jab_python / 'todo.py',
              jab_todo],
        #'': [
        #    hub / '',],
    }
    aliases = {
        'c': 'kd'
    }
    for key, value in aliases.items():
        if key in strings:
            abbreviated_paths = abbreviations[value]
            abbreviations.update({key: abbreviated_paths})
    result = [abbreviations[s] for s in strings if s in abbreviations]
    return list(itertools.chain(*result))
