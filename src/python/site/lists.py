"""This module provides methods to handle lists"""

def doublets(items):
    """[prev, curr] for each element of the list

    >>> doublets([0, 1, 2])
    [[None, 0], [0, 1], [1, 2]]
    """
    if not items:
        return []
    results = []
    one = None
    for two in items[0:]:
        results.append([one, two])
        one = two
    return results

def triplets(items):
    """[prev, curr, next] for each element of the list

    >>> triplets([0, 1, 2])
    [[None, 0, 1], [0, 1, 2], [1, 2, None]]
    """
    if not items:
        return []
    results = []
    one = None
    try:
        two = items[0]
    except IndexError:
        return []
    for three in items[1:]:
        results.append([one, two, three])
        one, two = two, three
    results.append([one, two, None])
    return results

def groups(match, items):
    """Split the list of items into sub-lists based on the match method

    match takes two items and returns true if they are in the same group
    >>> groups(lambda a, b: a == b, [0, 0, 0, 1, 1, 0, 1, 1, '1'])
    [[0, 0, 0], [1, 1], [0], [1, 1], ['1']]
    """
    if not items:
        return []
    result = []
    try:
        group = [items[0]]
    except IndexError:
        return []
    for item in items[1:]:
        if match(item, group[-1]):
            group.append(item)
        else:
            result.append(group)
            group = [item]
    result.append(group)
    return result


def before(items, i):
    """Split the list of items into two lists: everything before index i, and the rest

    >>> before('Fred', 2)
    ('Fr', 'ed')
    """
    return  items[:i], items[i:]


def before_and_after(items, i):
    """Split the list of items into three parts: everything before index i, at i, and all after it

    >>> before_and_after('Fred was here', 4)
    ('Fred', ' ', 'was here')
    """
    a, b = before(items, i)
    c, d = before(b, 1)
    return a, c, d


def befores_and_afters(items):
    """A generator giving before and after for each item in a list

    >>> for items in befores_and_afters('Fred'): print items
    ('', 'F', 'red')
    ('F', 'r', 'ed')
    ('Fr', 'e', 'd')
    ('Fre', 'd', '')
    """
    for i, _item in enumerate(items):
        yield before_and_after(items, i)


def head_rest(items):
    """Return the head and the rest of a list

    >>> items = [23, 45, 67, 99, 45]
    >>> head, rest = head_rest(items)
    >>> head == items[0] and rest == items[1:]
    True
    """
    heads, rest = before(items, 1)
    return heads[0], rest
