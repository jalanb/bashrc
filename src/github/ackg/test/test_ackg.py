from __future__ import absolute_import, print_function, unicode_literals
import os
import imp

imp.load_source(
    'ackg',
    os.path.join(os.path.dirname(__file__), '..', 'bin', 'ackg'))
import ackg

import unittest


def get_args(args=None):
    '''wrapper around ackg.parse_args'''
    return ackg.get_arg_parser().parse_args(args)


# pylint: disable=R0904,C0111,C0103
class TestAckg(unittest.TestCase):

    def test_mappings(self):
        for key in ackg.MAPPING_FULL:
            self.assertTrue(key in ackg.MAPPING_EXT)

    def test_get_arg_parser(self):
        parser = ackg.get_arg_parser()
        self.assertIsNotNone(parser)

    def test_create_find_cmd(self):
        args = get_args()
        result = ackg.create_find_cmd(args)
        self.assertTrue(result.startswith('find'), result)
        self.assertTrue(' -type f ' in result, result)
        args = get_args(['--make'])
        result = ackg.create_find_cmd(args)
        self.assertTrue(result.startswith('find'), result)
        self.assertTrue(' -type f ' in result, result)
        self.assertTrue('\|make\|' in result, result)
        self.assertTrue('CMakeLists.txt' in result, result)
        self.assertFalse('\|cpp\|' in result, result)

    def test_create_defer_cmd(self):
        args = get_args()
        result = ackg.create_defer_cmd(args)
        self.assertTrue(result.startswith('xargs'), result)
        self.assertTrue(' -0 ' in result, result)
        self.assertTrue(' -n 100' in result, result)
        args = get_args(['-j2'])
        result = ackg.create_defer_cmd(args)
        self.assertTrue(result.startswith('parallel'), result)
        self.assertTrue(' -0 ' in result, result)
        self.assertTrue(' -n 100' in result, result)
        args = get_args(['-j2', '--xargs'])
        result = ackg.create_defer_cmd(args)
        self.assertTrue(result.startswith('xargs'), result)
        self.assertTrue(' -0 ' in result, result)
        self.assertTrue(' -n 100' in result, result)

    def test_create_grep_cmd(self):
        args = get_args()
        result = ackg.create_grep_cmd(args)
        self.assertEqual('', result)
        args = get_args(['foo'])
        result = ackg.create_grep_cmd(args)
        self.assertTrue(result.startswith('grep'), result)
        self.assertTrue(' --binary-files=without-match ' in result, result)
        self.assertTrue(' --color ' in result, result)
        self.assertTrue(' --line-number ' in result, result)
        self.assertTrue(' --with-filename ' in result, result)

    def test_create_grep_cmd_complex(self):
        args = get_args(['\(import.*distribution\|distribution.*import\)'])
        result = ackg.create_grep_cmd(args)
        self.assertTrue(
            '"\(import.*distribution\|distribution.*import\)"' in result,
            result)
