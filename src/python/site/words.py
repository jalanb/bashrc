"""This module provides methods to handle some features of English words"""


import re
from itertools import ifilter


def match_case(string1, string2):
    """Matches the case of string1 in string2

    >>> match_case('MATCHcase', 'somestuff')
    'SOMEStuff'
    """
    if string1.isupper():
        return string2.upper()
    list2 = list(string2)
    for i, char in enumerate(string1[:len(string2)]):
        if char.isupper():
            list2[i] = list2[i].upper()
        elif char.islower():
            list2[i] = list2[i].lower()
    return ''.join(list2)


def _any_true(function, iterable):
    """Returns true if any element in iterable satisfies the function.

    >>> _any_true(lambda x: x > 5, (3, 6))
    True
    """
    for _ in ifilter(function, iterable):
        return True
    return False


def _vowels():
    """Letter pronounced with an open vocal tract

    >>> _vowels() == 'aeiouy'
    True
    """
    return 'aeiouy'


def _consonants():
    """Letters that are not vowels

    >>> import random
    >>> _consonants().isalpha() and random.choice(_vowels()) not in _consonants()
    True
    """
    return 'bcdfghjklmnpqrstvwxz'


def _ends_in_consonant_suffix(string, suffix):
    """Whether that string ends in a consonant followed by the suffix

    >>> _ends_in_consonant_suffix('pretty', 'y')
    True
    """
    regexp = re.compile('[%s]%s$' % (_consonants(), suffix))
    return regexp.search(string) is not None


def _ends_in_consonant_y(string):
    """Whether that string ends in a consonant and a y

    >>> _ends_in_consonant_y('pretty')
    True
    """
    return _ends_in_consonant_suffix(string, 'y')


def _ends_in_consonant_ies(string):
    """Whether that string ends in a consonant and ies

    >>> _ends_in_consonant_ies('pretties')
    True
    """
    return _ends_in_consonant_suffix(string, 'ies')


def _uncountables():
    """Nouns which are same in plural as singular"""
    return [
        'cowes',
        'deer',
        'equipment',
        'fish',
        'haiku',
        'information',
        'money',
        'rice',
        'series',
        'sheep',
        'species',
        'species',
    ]


def _exceptional_plurals():
    """Nouns whose plural is just plain weird"""
    return {
        'child': 'children',
        'fungus' : 'fungi',
        'louse': 'lice',
        'man' : 'men',
        'mouse': 'mice',
        'woman' : 'women',
    }


def pluralize(string):
    """Returns the plural of string.

    >>> pluralize('Index')  == 'Indices'
    True
    """
    lowered = string.lower()
    result = string + 's'
    try:
        result = _exceptional_plurals()[lowered]
    except KeyError:
        if lowered in _uncountables():
            result = string
        elif lowered.endswith('ex'):
            result = lowered[:-2] + 'ices'
        elif _any_true(lowered.endswith, ['x', 'ch', 'sh', 'ss', 'z']):
            result = string+'es'
        elif lowered.endswith('o'):
            eos = ['echo', 'hero', 'potato', 'veto', 'tomato']
            if lowered in eos:
                result = string + 'es'
            else:
                result = string + 's'
        elif _ends_in_consonant_y(lowered):
            result = string[:-1] + 'ies'
        else:
            regexp, subs = re.compile(r'([^f])fe$', re.IGNORECASE), r'\1ves'
            if regexp.search(string):
                return regexp.sub(subs, string)
    return match_case(string, result)


def depluralize(string):
    """Returns the singular of string.

    >>> depluralize('Cows') == 'Cow'
    True
    """
    lowered = string.lower()
    try:
        return match_case(string, _exceptional_plurals()[lowered])
    except KeyError:
        pass
    if lowered in _uncountables():
        return string
    if _any_true(lowered.endswith, ['ches', 'shes', 'sses']):
        return string[:-2]
    if _ends_in_consonant_ies(lowered):
        return string[:-3] + 'y'
    if lowered.endswith('s'):
        return string[:-1]  # Chop off 's'.
    raise NotImplementedError("Do not know how to depluralize %r" % string)


def number_name(i):
    """The English name for that number

    >>> number_name(5) == 'five'
    True
    """
    number_names = [
        'zero',
        'one',
        'two',
        'three',
        'four',
        'five',
        'six',
        'seven',
        'eight',
        'nine',
    ]
    try:
        return number_names[int(i)]
    except (ValueError, IndexError):
        return str(i)
