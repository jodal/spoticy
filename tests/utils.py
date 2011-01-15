import datetime
import threading

import spoticy

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
