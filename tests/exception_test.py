import unittest

import spoticy

class SpotifyExceptionTest(unittest.TestCase):
    def test_error_message_is_looked_up(self):
        exc = spoticy.SpotifyException(5)
        self.assertEqual('Invalid application key (sp_error=5)', str(exc))

    def test_error_code_0_means_no_error(self):
        exc = spoticy.SpotifyException(0)
        self.assertEqual('No error (sp_error=0)', str(exc))
