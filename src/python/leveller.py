import os
from os import path
import doctest

def add_dir(path_, name, dir_):
    assert path.isdir(dir_)
    return (name, path.join(dir_, path_))

def directories(
        needed=None, names=None, level=1, size_here=3, sizes=None):
    sizes = sizes or []
    sizes.append(size_here)
    size = sum(sizes)
    # print '%d, %d' % (size_here, size)
    _here = os.getcwd()
    add_as = lambda p, n, d: add_dir(p, n, d)
    add_here = lambda p: add_as(p, p, _here)
    add_here_as = lambda p, n: add_as(p, n, _here)
    if size < needed:
        return directories(
            needed, names, level + 1, 2 * size_here + 1, sizes)
    return level, size


def show_directories(needed, names=None, sizes=None):
    level, size = directories(needed, names = names, sizes = sizes)
    dirs, files = size == 1 and ('y', '') or ('ies','s')
    operator = size == needed and '==' or '>'
    print('Level %d can hold %d director%s and %d file%s %s %d' % (
        level, size, dirs, size, files, operator, needed))


def files(needed, available=1, level=1):
    if available < needed:
        return files(needed, 2 ** level + 1, level + 1)
    return sum(range(level + 1)), level, available, needed

def show_files(needed):
    print('level %d, can hold %d files, > %d' % files(needed)[1:])


def lines(needed, available=7, level=1):
    if available < needed:
        return lines(needed, available * 4 +1, level + 1)
    return ('\n',) * available

def text(needed, available=3, level=1, power=2):
    if available < needed:
        return text(needed, available * (2 ** power), level + 1)
    return '\n' * needed


def keys(pairs, level=1, power=2, availables=None):
    availables = availables or {'': None}
    available = len(availables)
    needed = len(pairs)
    if available < needed:
        new = available * power + 1
        level += 1
        for i in range(new, level):
            if i not in availables:
                availables[i] = None
        return keys(pairs, level + 1, 2 ** power, availables)
    pair_dict = {k:v for k, v in pairs}
    result = pair_dict
    needed = len(result)
    result.update({k: v for k, v in os.environ.items()})
    return result

if __name__ == '__main__':
    """
    >>> import things

    >>> things.show_directories(1)
    Level 1 can hold 3 directories and 3 files > 1

    >>> things.show_directories(106)
    Level 5 can hold 119 directories and 119 files > 106

    >>> things.show_files(106)
    level 8, can hold 129 files, > 106

    """
    doctest.testfile(__file__, module_relative=False)
