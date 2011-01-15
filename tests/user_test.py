import unittest

import spoticy
from tests import utils, settings

class UserTest(unittest.TestCase):
    def setUp(self):
        application_key = open('tests/spotify_appkey.key').read()
        callbacks = utils.TestSessionCallbacks()
        self.config = spoticy.SessionConfig(application_key, callbacks)
        self.session = None

    def tearDown(self):
        if self.session is not None:
            self.session.release()

    def test_user_is_not_available_when_not_logged_in(self):
        self.session = spoticy.Session(self.config)
        self.assertEqual(None, self.session.user)

    def test_user_is_available_when_logged_in(self):
        self.session = spoticy.Session(self.config)
        self.session.login(settings.USERNAME, settings.PASSWORD)
        utils.wait_for_event(self.session, utils.logged_in_event)

        self.assertTrue(self.session.user.is_loaded)

        self.assertEqual(settings.USER_CANONICAL_NAME,
            self.session.user.canonical_name)
        self.assertEqual(settings.USER_DISPLAY_NAME,
            self.session.user.display_name)
        self.assertEqual(settings.USER_FULL_NAME, self.session.user.full_name)
        self.assertEqual(settings.USER_PICTURE_URL,
            self.session.user.picture_url)
