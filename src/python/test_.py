"""Test """

import unittest


class TestClass(unittest.TestCase):
    def setUp(self):
        pass

    def test_case(self):
        self.assertEqual(True, False)

    def tearDown(self):
        pass
