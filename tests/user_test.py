import unittest

import spoticy
from tests import utils, settings

class UserTest(unittest.TestCase):
    def setUp(self):
        application_key = open('tests/spotify_appkey.key').read()
        callbacks = utils.TestSessionCallbacks()
        self.config = spoticy.SessionConfig(application_key, callbacks)
        self.session = spoticy.Session(self.config)

    def tearDown(self):
        if self.session is not None:
            self.session.release()

    def test_user_is_not_available_when_not_logged_in(self):
        self.assertEqual(None, self.session.user)

    def test_user_is_available_when_logged_in(self):
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

    def test_friends_is_a_sequence_and_you_got_relations_to_friends(self):
        self.session.login(settings.USERNAME, settings.PASSWORD)
        utils.wait_for_event(self.session, utils.logged_in_event)

        num_friends = len(self.session.friends)
        self.assert_(num_friends >= 0)
        if num_friends > 0:
            try:
                friend = self.session.friends[num_friends - 1]
                self.assertTrue(friend.is_loaded)
                self.assert_(self.session.relation_type(friend) in range(0, 5))
            except IndexError:
                self.fail(u'Should be able to read elements from sequence')
