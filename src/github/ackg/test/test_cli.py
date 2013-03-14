from __future__ import absolute_import, print_function, unicode_literals
import os
import unittest
import tempfile
import shutil
import sys
import imp

imp.load_source(
    'ackg',
    os.path.join(os.path.dirname(__file__), '..', 'bin', 'ackg'))
import ackg


def _add_to_file(path, content):
    """Util function to append to file to get a modification"""
    with open(path, 'ab') as fhand:
        fhand.write(content.encode('UTF-8'))


def run_command(path, cmd, expect=0):
    'runs ackg command and captures output'
    os.chdir(path)
    sys.stdout = outputs = StringIO()
    errcode = ackg.main(cmd, capture_out=True)
    assert errcode == expect
    sys.stdout = sys.__stdout__
    return outputs.getvalue()


# pylint: disable=R0904,C0111,C0103
class StringIO:
    """
    StringIO.StringIO does not exist in python3
    io.StringIO cannot cope with unicode
    """

    def __init__(self):
        self.stream = ''

    def write(self, data):
        self.stream += data

    def flush(self):
        pass

    def __getattr__(self, attr):
        return getattr(self.stream, attr)

    def getvalue(self):
        return self.stream


class AckgIntegrationTest(unittest.TestCase):
    'tests using shell command and parsing output'

    @classmethod
    def setUpClass(cls):
        cls.root_path = tempfile.mkdtemp()
        cls.subfolder1 = os.path.join(cls.root_path, 'sub1')
        cls.subfolder2 = os.path.join(cls.root_path, 'sub2')
        os.makedirs(cls.subfolder1)
        os.makedirs(cls.subfolder2)
        # xml
        _add_to_file(os.path.join(cls.root_path, "foo.xml"), '<foo></foo>')
        _add_to_file(os.path.join(cls.root_path, "bar.xml"), '<bar></bar>')
        _add_to_file(os.path.join(cls.subfolder1, "sub.xml"), '<sub></sub>')
        # make
        _add_to_file(os.path.join(cls.root_path, "CMakeLists.txt"),
                     'project(foo)')
        # py
        _add_to_file(os.path.join(cls.root_path, "foo.py"), 'import foo')
        _add_to_file(os.path.join(cls.root_path, "bar.py"), 'import bar')
        _add_to_file(os.path.join(cls.subfolder2, "sub.py"), 'import sub')
        _add_to_file(os.path.join(cls.root_path, "script"),
                     '#! /usr/bin/env python')

    @classmethod
    def tearDownClass(cls):
        shutil.rmtree(cls.root_path)

    def test_find_files(self):
        result = run_command(self.root_path, ['--sorted'])
        self.assertEqual('''./bar.py
./bar.xml
./CMakeLists.txt
./foo.py
./foo.xml
./script
./sub1/sub.xml
./sub2/sub.py
''', result)

    def test_find_py_files(self):
        result = run_command(self.root_path, ['--python', '--sorted'])
        self.assertEqual('''./bar.py
./foo.py
./script
./sub2/sub.py
''', result)

    def test_find_make_files(self):
        result = run_command(self.root_path, ['--make', '--sorted'])
        self.assertEqual('''./CMakeLists.txt
''', result)

    def test_find_foo_files(self):
        result = run_command(self.root_path, ['foo', '--nogroup', '--sorted'])
        self.assertEqual('''./CMakeLists.txt:1:project(foo)
./foo.py:1:import foo
./foo.xml:1:<foo></foo>
''', result)
