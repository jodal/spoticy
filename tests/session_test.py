import unittest

import spoticy
from tests.settings import SPOTIFY_USERNAME, SPOTIFY_PASSWORD

class SessionTest(unittest.TestCase):
    def setUp(self):
        application_key = open('tests/spotify_appkey.key').read()
        callbacks = spoticy.SessionCallbacks()
        self.config = spoticy.SessionConfig(application_key, callbacks)

    def test_create_session_with_valid_config_should_succeed(self):
        session = spoticy.Session(self.config)
        self.assertEqual(0, session.connection_state)

    def test_session_without_config_should_not_be_usable(self):
        session = spoticy.Session()
        self.assertEqual(None, session.connection_state)
        self.assertRaises(Exception, session.login,
            SPOTIFY_USERNAME, SPOTIFY_PASSWORD)
        self.assertRaises(Exception, session.logout)

    def test_login_should_not_raise_exceptions(self):
        session = spoticy.Session(self.config)
        session.login(SPOTIFY_USERNAME, SPOTIFY_PASSWORD)
        # TODO After logged_in callback, this should be true:
        #self.assertEqual(1, session.connection_state)

    def test_logout_should_not_raise_exceptions(self):
        session = spoticy.Session(self.config)
        session.login(SPOTIFY_USERNAME, SPOTIFY_PASSWORD)
        session.logout()
        # TODO After logged_in callback, this should be true:
        #self.assertEqual(2, session.connection_state)

    def test_release_should_not_raise_exceptions(self):
        session = spoticy.Session(self.config)
        session.release()
        self.assertEqual(None, session.connection_state)
