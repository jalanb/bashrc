"""Python version of fizzbuzz


>>> assert fizzbuzz(0) == '0'
>>> assert fizzbuzz(1) == '1'
>>> assert fizzbuzz(2) == '2'
>>> assert fizzbuzz(3) == 'Fizz'
>>> assert fizzbuzz(4) == '4'
>>> assert fizzbuzz(5) == 'Buzz'
>>> assert fizzbuzz(6) == 'Fizz'
>>> assert fizzbuzz(7) == '7'
>>> assert fizzbuzz(14) == '14'
>>> assert fizzbuzz(15) == 'FizzBuzz'
>>> assert fizzbuzz(21) == 'Fizz'
>>> assert fizzbuzz(12345) == 'FizzBuzz'
>>> assert fizzbuzz(sys.maxsize + 8) == 'FizzBuzz'
>>> assert fizzbuzz(-0) == '0'
>>> fizzbuzz(-1) , '-1'
>>> assert fizzbuzz(-1) == '-1'
>>> assert fizzbuzz(-2) == '-2'
>>> assert fizzbuzz(-3) == '-Fizz'
>>> assert fizzbuzz(-5) == '-Buzz'
>>> assert fizzbuzz(-12345.0) == '-FizzBuzz'

>>> assert fizzbuzz(None) is None
>>> assert fizzbuzz('Fred') == 'Fred'
>>> assert fizzbuzz(['Fred']) == ['Fred']
"""

import sys
import doctest
from functools import singledispatch


@singledispatch
def fizzbuzz(n: int):

    def buzzer(i, words):
        result = ''
        if not words:
            return result
        head, *tail = words
        j, name = head
        if not i % j:
            result = name
            k = i // j
        else:
            k = i
        suffix = buzzer(k, tail)
        result = result + suffix
        return result


    sign, i = ('', n) if n >= 0 else ('-', -n)
    suffix = buzzer(i, [(3, 'Fizz'), (5, 'Buzz')])
    return i and f'{sign}{suffix}' or f'{sign}{i}'


@fizzbuzz.register(str)
def _(s):
    try:
        return int(s)
    except ValueError:
        return s


@fizzbuzz.register(type(None))
@fizzbuzz.register(list)
def _(n):
    return n

if __name__ == '__main__':
    print(fizzbuzz(0))
    print(fizzbuzz(1))
    print(fizzbuzz(2))
    print(fizzbuzz(3))
    print(fizzbuzz(4))
    print(fizzbuzz(5))
    print(fizzbuzz(6))
    print(fizzbuzz(7))
    print(fizzbuzz(15))
    print(fizzbuzz(-1))
    doctest.testmod()
