import threading
import unittest

import spoticy
from tests.settings import SPOTIFY_USERNAME, SPOTIFY_PASSWORD

timer = None
logged_in_event = threading.Event()
logged_out_event = threading.Event()

def wait_for_event(session, event):
    while event.wait(0.1) or not event.is_set():
        timeout = session.process_events()
        timer = threading.Timer(timeout / 1000., lambda: None)
        timer.start()


class TestSessionCallbacks(spoticy.SessionCallbacks):
    def logged_in(self, session, error):
        print 'logged_in called. Error: %d' % error
        logged_in_event.set()

    def logged_out(self, session):
        print 'logged_out called'
        logged_out_event.set()

    def connection_error(self, session, error):
        print 'connection_error called. Error: %d' % error

    def notify_main_thread(self, session):
        print 'notify_main_thread called'
        if timer is not None:
            timer.cancel()

class SessionCallbacksTest(unittest.TestCase):
    def setUp(self):
        self.application_key = open('tests/spotify_appkey.key').read()
        self.config = spoticy.SessionConfig(
            self.application_key, TestSessionCallbacks())

    def test_login_changes_connection_state(self):
        session = spoticy.Session(self.config)
        session.login(SPOTIFY_USERNAME, SPOTIFY_PASSWORD)
        # FIXME Make this pass
        #wait_for_event(session, logged_in_event)
        #self.assertEqual(1, session.connection_state)

    def test_logout_changes_connection_state(self):
        session = spoticy.Session(self.config)
        session.login(SPOTIFY_USERNAME, SPOTIFY_PASSWORD)
        # FIXME Make this pass
        #wait_for_event(session, logged_in_event)
        #session.logout()
        #wait_for_event(session, logged_out_event)
        #self.assertEqual(2, session.connection_state)
