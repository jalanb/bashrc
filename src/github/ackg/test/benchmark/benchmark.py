#! /usr/bin/env python

from __future__ import print_function
import os
import sys
import datetime
import multiprocessing
import timeit
import platform
import subprocess
import tempfile
from argparse import ArgumentParser

LINUX_KERNEL_GIT_URL = \
    "git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git"

CMDS = [
    "ackg system",
    "ackg --cpp -m 1000000 system",
    "ackg --cpp system",
    "ackg --cpp -j=-1 system",
    "ackg --cpp -j=2 system",
    "ackg --cpp -j=4 system",
    "ackg --cpp -j=8 system",
    # "ackg --cpp -j=-1 -m 10000 system",
    # "ackg --cpp -j=-1 -m 100 system",
    "ackg -j 4 --cpp --xargs system ",
    "ack-grep system",
    "ack-grep --cpp system",
    "ack-grep --no-group system",
    "grep -r system",
    ## get grin from source
    # "grin system"

    # "grep -ir system",
    # "ackg -i --cpp system",
    # "ack-grep -i --cpp system",
    # "ackg -i -j 10% --cpp system",
    # "ackg -i -j 150% --cpp system",
    # "ackg -i -j 2 --cpp system",
    # "ackg -i -j 4 --cpp system",
    # "ackg -i -j 8 --cpp system",
    # "ackg -i -j 0 --cpp system",
    # "ackg -i -j 4 --cpp --xargs --ack system ",
    # "ackg -i -j 4 --cpp system ",
    # "ackg -i -j 4 -m 100 --cpp --ack system ",
    # "ackg -i -j 4 -m 100 --cpp --ack --xargs system ",
    ]


# pylint: disable=R0904,C0111,C0103
def test_cmd(cmd):
    'run shell cmd'
    subprocess.check_call(cmd, shell=True)


def main():
    'main'
    parser = ArgumentParser(
        description="Benchmark comparing ack with ack-grep and grep")
    parser.add_argument("root_dir",
                        nargs='?',
                        default=None)
    parser.add_argument("--repeats",
                        nargs='?',
                        default=2)
    args = parser.parse_args()

    if not args.root_dir:
        root_directory = tempfile.mkdtemp()
    else:
        root_directory = args.root_dir
    print("test data in %s" % os.path.abspath(root_directory))

    today = datetime.date.today()
    print(today)
    print('CPUs: %s' % multiprocessing.cpu_count())
    print('Python', sys.version)
    print(platform.dist(), platform.release())
    print(platform.architecture())
    print(platform.machine())
    subprocess.call('ack-grep --version', shell=True)
    subprocess.call('ackg --version', shell=True)

    target_path = os.path.join(root_directory, 'linux')

    if not os.path.exists(target_path):
        subprocess.check_call('git clone %s %s' % (LINUX_KERNEL_GIT_URL,
                                                   target_path),
                              shell=True)

    # stats = {}

    results = []
    try:
        for cmd in CMDS:
            destination = '> /dev/null'
            statement = ("import subprocess;" +
                         "subprocess.call('%s %s %s', shell=True)" %
                         (cmd,
                          os.path.join(root_directory, 'linux'),
                          destination))
            timer = timeit.Timer(stmt=statement)
            try:
                result = timer.repeat(repeat=args.repeats, number=2)
                results.append((cmd, result))
            except:
                timer.print_exc()
                raise
    finally:
        def keyfun(result):
            return min(result[1])
        for cmd, numbers in sorted(results, key=keyfun):
            print("'%s': %s" % (cmd, ', '.join([str(x) for x in numbers])))


if __name__ == '__main__':
    main()
