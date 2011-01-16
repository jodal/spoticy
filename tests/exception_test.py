import unittest

import spoticy

class SpotifyErrorTest(unittest.TestCase):
    def test_error_message_is_looked_up(self):
        exc = spoticy.SpotifyError(0)
        self.assertEqual('No error (sp_error=0)', str(exc))
        exc = spoticy.SpotifyError(1)
        self.assertEqual('Invalid library version (sp_error=1)', str(exc))
        exc = spoticy.SpotifyError(5)
        self.assertEqual('Invalid application key (sp_error=5)', str(exc))

    def test_error_code_is_available(self):
        exc = spoticy.SpotifyError(5)
        self.assertEqual(5, exc.error_code)

    def test_error_code_must_be_integer(self):
        self.assertRaises(TypeError, spoticy.SpotifyError, '0')

    def test_is_ok_returns_true_and_raises_no_exception_on_0(self):
        self.assertEqual(True, spoticy.is_ok(0))

    def test_is_ok_raises_exception_on_anything_but_0(self):
        for i in range(1, 21):
            self.assertRaises(spoticy.SpotifyError, spoticy.is_ok, i)
