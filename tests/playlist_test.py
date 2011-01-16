import unittest

import spoticy
from tests import settings, utils

class PlaylistsTest(unittest.TestCase):
    def setUp(self):
        application_key = open('tests/spotify_appkey.key').read()
        callbacks = utils.TestSessionCallbacks()
        self.config = spoticy.SessionConfig(application_key, callbacks)
        self.session = spoticy.Session(self.config)

    def tearDown(self):
        if self.session is not None:
            self.session.release()

    def test_playlists_is_empty_when_logged_out(self):
        self.assertEqual(None, self.session.playlists.owner)
        self.assertEqual(0, len(self.session.playlists))

    def test_playlists_is_available_when_logged_in(self):
        self.session.login(settings.USERNAME, settings.PASSWORD)
        utils.wait_for_event(self.session, utils.logged_in_event)

        self.assertEqual(self.session.user.canonical_name,
            self.session.playlists.owner.canonical_name)

        self.assert_(len(self.session.playlists) >= 0)
