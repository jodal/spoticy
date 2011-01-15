import unittest

import spoticy
from tests.settings import SPOTIFY_USERNAME, SPOTIFY_PASSWORD

class SessionTest(unittest.TestCase):
    def setUp(self):
        application_key = open('tests/spotify_appkey.key').read()
        callbacks = spoticy.SessionCallbacks()
        self.config = spoticy.SessionConfig(application_key, callbacks)
        self.session = None

    def tearDown(self):
        if self.session is not None:
            self.session.release()

    def test_create_session_with_valid_config_should_succeed(self):
        self.session = spoticy.Session(self.config)
        self.assertEqual(0, self.session.connection_state)

    def test_session_without_config_should_not_be_usable(self):
        self.session = spoticy.Session()
        self.assertEqual(None, self.session.connection_state)
        self.assertRaises(Exception, self.session.login,
            SPOTIFY_USERNAME, SPOTIFY_PASSWORD)
        self.assertRaises(Exception, self.session.logout)
        self.assertRaises(Exception, self.session.process_events)

    def test_release_should_not_raise_exceptions(self):
        self.session = spoticy.Session(self.config)
        self.session.release()
        self.assertEqual(None, self.session.connection_state)
        self.assertRaises(Exception, self.session.login,
            SPOTIFY_USERNAME, SPOTIFY_PASSWORD)
        self.assertRaises(Exception, self.session.logout)
        self.assertRaises(Exception, self.session.process_events)

    def test_process_events_should_return_ms_to_wait_before_next_call(self):
        self.session = spoticy.Session(self.config)
        result = self.session.process_events()
        self.assert_(result > 0)
