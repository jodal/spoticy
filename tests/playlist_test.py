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
        playlists = self.session.get_playlists()
        self.assertEqual(None, playlists.get_owner())
        self.assertEqual(0, len(playlists))

    def test_playlists_is_available_when_logged_in(self):
        self.session.login(settings.USERNAME, settings.PASSWORD)
        utils.wait_for_event(self.session, utils.logged_in_event)
        playlists = self.session.get_playlists()

        self.assertEqual(self.session.get_user().canonical_name,
            playlists.get_owner().canonical_name)

        self.assertEqual(0, len(playlists))
        playlists.add_callbacks(utils.TestPlaylistsCallbacks())
        utils.wait_for_event(self.session, utils.playlists_loaded_event)
        num_playlists = len(playlists)
        self.assert_(num_playlists >= 0)
