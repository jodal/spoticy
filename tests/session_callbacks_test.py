import datetime
import threading
import unittest

import spoticy
from tests.settings import SPOTIFY_USERNAME, SPOTIFY_PASSWORD

def log(message, **data):
    print '%s [%s] %s %s' % (datetime.datetime.now(),
        threading.current_thread().name, message, data)

awoken = threading.Event()
timer = None
logged_in_event = threading.Event()
logged_out_event = threading.Event()

def wait_for_event(session, event):
    while not event.is_set():
        awoken.clear()
        timeout = session.process_events()
        timer = threading.Timer(timeout / 1000., awoken.set)
        timer.start()
        awoken.wait()
        timer.cancel()
    event.clear()


class TestSessionCallbacks(spoticy.SessionCallbacks):
    def logged_in(self, session, error):
        log('logged_in called', error=error)
        logged_in_event.set()
        awoken.set()

    def logged_out(self, session):
        log('logged_out called')
        logged_out_event.set()
        awoken.set()

    def connection_error(self, session, error):
        log('connection_error called', error=error)

    def notify_main_thread(self, session):
        log('notify_main_thread called')
        awoken.set()


class SessionCallbacksTest(unittest.TestCase):
    def setUp(self):
        self.application_key = open('tests/spotify_appkey.key').read()
        self.config = spoticy.SessionConfig(
            self.application_key, TestSessionCallbacks())

    def test_login_and_logout_changes_connection_state(self):
        session = spoticy.Session(self.config)
        self.assertEqual(spoticy.CONNECTION_STATE_LOGGED_OUT,
            session.connection_state)

        session.login(SPOTIFY_USERNAME, SPOTIFY_PASSWORD)
        wait_for_event(session, logged_in_event)
        self.assertEqual(spoticy.CONNECTION_STATE_LOGGED_IN,
            session.connection_state)

        session.logout()
        wait_for_event(session, logged_out_event)
        self.assertEqual(spoticy.CONNECTION_STATE_LOGGED_OUT,
            session.connection_state)
