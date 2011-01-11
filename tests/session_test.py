import unittest

import spoticy
from tests.settings import SPOTIFY_USERNAME, SPOTIFY_PASSWORD

class SessionTest(unittest.TestCase):
    def setUp(self):
        self.application_key = open('tests/spotify_appkey.key').read()

    def test_create_session_without_application_key_should_fail(self):
        self.assertRaises(AssertionError, spoticy.Session, None)

    def test_create_session_should_not_raise_exceptions(self):
        session = spoticy.Session(self.application_key)
        self.assertEqual(0, session.connection_state)

    def test_login_should_not_raise_exceptions(self):
        session = spoticy.Session(self.application_key)
        session.login(SPOTIFY_USERNAME, SPOTIFY_PASSWORD)
        # TODO After logged_in callback, this should be true:
        #self.assertEqual(1, session.connection_state)

    def test_logout_should_not_raise_exceptions(self):
        session = spoticy.Session(self.application_key)
        session.login(SPOTIFY_USERNAME, SPOTIFY_PASSWORD)
        session.logout()
        # TODO After logged_in callback, this should be true:
        #self.assertEqual(2, session.connection_state)
