"""Test """

import unittest


class TestClass(unittest.TestCase):
    def setUp(self):
        pass

    def test_case(self):
        self.assertNotEqual(True, False)

    def tearDown(self):
        pass
