"""Script to act as a template"""

import os
import sys
import tarfile


from dotsite.paths import makepath


def type_of_tarball(path):
    ext = path.ext
    if ext == '.tar':
        return 'tar'
    if ext in ['.gz', '.bz2']:
        stem, _ = path.splitext()
        if stem.ext == '.tar':
            return ext[1:]
    return None


def is_tarball(path):
    return path.isfile() and type_of_tarball(path) is not None


def directory_tarballs(paths):
    directories = [p for p in paths if p.isdir()]
    result = []
    for directory in directories:
        result.extend([
            path for path in directory.parent.glob(directory.name + '.tar*')
            if is_tarball(path)])
    return result


def find_tarballs(args):
    paths = [makepath(a) for a in args]
    tarballs = [p for p in paths if is_tarball(p)]
    tarballs.extend(directory_tarballs(paths))
    return tarballs


def removable_contents(tarball):
    names = {n.split('/', 1)[0] for n in tarfile.open(tarball).getnames()}
    paths = [makepath(n) for n in names]
    return [p for p in paths if p.isfile() or p.isdir()]


def remove(tarballs):
    for tarball in tarballs:
        for path in removable_contents(tarball):
            if path.isdir():
                print 'rm -rf', path
            else:
                print 'rm -f', path
        print 'rm -vf', tarball


def main(args):
    tarballs = find_tarballs(args)
    remove(tarballs)
    return os.EX_OK


if __name__ == '__main__':
    sys.exit(main(sys.argv[1:]))
