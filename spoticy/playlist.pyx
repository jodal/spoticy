from spoticy cimport libspotify
from spoticy.core cimport *
from spoticy.core import *
from spoticy.session cimport Session
from spoticy.user cimport User


cdef class Playlists(object):
    def __init__(self, Session session):
        if session.connection_state == CONNECTION_STATE_LOGGED_IN:
            self._playlist_container = \
                libspotify.sp_session_playlistcontainer(session._session)

    def __len__(self):
        if self._playlist_container is not NULL:
            return libspotify.sp_playlistcontainer_num_playlists(
                self._playlist_container)
        else:
            return 0

    property owner:
        def __get__(self):
            cdef User user = User()
            if self._playlist_container is not NULL:
                user._user = libspotify.sp_playlistcontainer_owner(
                    self._playlist_container)
                return user
