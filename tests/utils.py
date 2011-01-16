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
playlists_loaded_event = threading.Event()

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

class TestPlaylistsCallbacks(spoticy.PlaylistsCallbacks):
    def playlist_added(self, playlists, added_playlist, added_position):
        log('playlist_added called')

    def playlist_removed(self, playlists, removed_playlist, removed_position):
        log('playlist_removed called')

    def playlist_moved(self, playlists, moved_playlist,
            old_position, new_position):
        log('playlist_moved called')

    def container_loaded(self, playlists):
        log('container_loaded called')
        playlists_loaded_event.set()
        awoken.set()
