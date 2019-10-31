#! /usr/bin/env python3
import re

from pysyte.cli.main import run

import work

def add_args(parser):
    p = parser
    p.boolean('-a', '--ab13173')
    p.boolean('-b', '--builder')
    p.boolean('-r', '--root')
    p.string('server')
    return parser


def server_regexp(string):
    return re.compile(work.server(string))


def portal_regexp(server):
    return server_regexp(f'{server}[a-z]*')


def server_project(server):
    projects = {
        ('bots', server_regexp('(git|bots)')),
        ('soso', portal_regexp('soso')),
        ('wmp', portal_regexp('wmp')),
        ('eop', portal_regexp('eop')),
        ('eop', portal_regexp('dow')),
        ('eop', portal_regexp('order')),
        ('eop', portal_regexp('corteva')),
        ('opp', portal_regexp('opp')),
    }
    for project, regexp in projects:
        if regexp.match(server):
            return project
    raise KeyError(server)


def ssw(args):
    sudo = False
    user = 'builder'
    if args.builder:
        user = 'builder'
    elif args.ab13173:
        user = 'ab13173'
    if args.root:
        sudo = True
    options = sudo and '-t' or ''
    server = work.server(args.server)
    credentials = f'{user}@{server}'
    private_key = ''
    if user == 'ab13173':
        private_key= f'-i ~/.ssh/work/{user}.key'
    elif user == 'builder':
        project = server_project(server)
        private_key = f'-i ~/.ssh/work/{project}/{user}.key'
    command = sudo and '"sudo su -"' or ''
    print(f'ssh {options} {private_key} {credentials} {command}')
    return True


def main(args):
    """Run the program"""
    try:
        ssw(args)
    except SystemExit as e:
        return True


run(main, add_args)
