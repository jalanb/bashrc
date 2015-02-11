"""Show a command to edit fred files"""

import os
import sys


from dotsite.paths import makepath, pwd


def get_freds(paths):
    if not paths:
        paths = [str('~/tmp/fred.%s' % _) for _ in ['py', 'sh', 'txt']]
    result = set()
    for path in paths:
        path = makepath(path)
        if path.isdir():
            result |= {p for p in path.files('fred*') if p[-1] != '~'}
        elif path.isfile() and path.name.startswith('fred'):
            result.add(path)
    return [pwd().relpathto(p) for p in result]


def main(args):
    freds = get_freds(args)
    if not freds:
        return not os.EX_OK
    print 'v %s' % ' '.join(freds)
    return os.EX_OK


if __name__ == '__main__':
    sys.exit(main(sys.argv[1:]))
