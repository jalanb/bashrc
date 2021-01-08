#! /usr/bin/env python3 -W once

# -W action can be once, ignore, module, ... "man python"

import sys

import requests

from pysyte.gurls import Url


def get(string):
    url = Url(string)
    try:
        response = requests.get(url)
    except Exception as e:
        import pudb; pudb.set_trace()  # pylint: disable=multiple-statements


def main(args):
    result = 0
    for arg in args:
        response = get(arg)
        if not response.ok:
            result += 1
            print(arg, response)
            continue
        print(response)
    return result


if __name__ == '__main__':
    sys.exit(main(sys.argv[1:]))

