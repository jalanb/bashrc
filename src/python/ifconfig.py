"""A script to run ifconfig, extract IP addresses"""


from __future__ import print_function
import os
import re
import sys
import commands

from pysyte import nets


def choose(string, args):
    for arg in args:
        if re.search(arg, string):
            return True
    return False


def main(args):
    """Run the program"""
    result = os.EX_UNAVAILABLE
    lines = nets.run_ifconfig()
    for ip_address in nets.get_ip_addresses(lines):
        if choose(ip_address, args):
            print(ip_address)
            result = os.EX_OK
    return result

if __name__ == '__main__':
    sys.exit(main(sys.argv[1:]))
