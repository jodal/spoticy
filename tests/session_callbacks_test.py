import unittest

import spoticy
from tests import utils
from tests.settings import SPOTIFY_USERNAME, SPOTIFY_PASSWORD

class SessionCallbacksTest(unittest.TestCase):
    def setUp(self):
        self.application_key = open('tests/spotify_appkey.key').read()
        self.config = spoticy.SessionConfig(
            self.application_key, utils.TestSessionCallbacks())
        self.session = None

    def tearDown(self):
        if self.session is not None:
            self.session.release()

    def test_login_and_logout_changes_connection_state(self):
        self.session = spoticy.Session(self.config)
        self.assertEqual(spoticy.CONNECTION_STATE_LOGGED_OUT,
            self.session.connection_state)

        self.session.login(SPOTIFY_USERNAME, SPOTIFY_PASSWORD)
        utils.wait_for_event(self.session, utils.logged_in_event)
        self.assertEqual(spoticy.CONNECTION_STATE_LOGGED_IN,
            self.session.connection_state)

        self.session.logout()
        utils.wait_for_event(self.session, utils.logged_out_event)
        self.assertEqual(spoticy.CONNECTION_STATE_LOGGED_OUT,
            self.session.connection_state)
