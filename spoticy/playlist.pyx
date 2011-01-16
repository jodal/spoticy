from spoticy cimport libspotify
from spoticy.core cimport *
from spoticy.core import *
from spoticy.session cimport Session
from spoticy.user cimport User


cdef class Playlist(object):
    pass # TODO


class PlaylistsCallbacks(object):
    """
    Playlist container related callback methods

    To provide your own implementation of the callbacks, subclass this class,
    instantiate your subclass, and pass it to :meth:`Playlists.add_callbacks`.
    """

    def playlist_added(self, playlists, added_playlist, added_position):
        pass

    def playlist_removed(self, playlists, removed_playlist, removed_position):
        pass

    def playlist_moved(self, playlists, moved_playlist,
            old_position, new_position):
        pass

    def container_loaded(self, playlists):
        pass


cdef void playlists_callback_playlist_added(
        libspotify.sp_playlistcontainer* pc, libspotify.sp_playlist* p,
        int position, void* userdata) with gil:
    cdef object playlists_callbacks
    cdef Playlists playlists = Playlists()
    cdef Playlist playlist = Playlist()
    if userdata is not NULL:
        playlists_callbacks = <object> userdata
        playlists._playlist_container = pc
        playlist._playlist = p
        playlists_callbacks.playlist_added(playlists, playlist, position)

cdef void playlists_callback_playlist_removed(
        libspotify.sp_playlistcontainer* pc, libspotify.sp_playlist* p,
        int position, void* userdata) with gil:
    cdef object playlists_callbacks
    cdef Playlists playlists = Playlists()
    cdef Playlist playlist = Playlist()
    if userdata is not NULL:
        playlists_callbacks = <object> userdata
        playlists._playlist_container = pc
        playlist._playlist = p
        playlists_callbacks.playlist_removed(playlists, playlist, position)

cdef void playlists_callback_playlist_moved(
        libspotify.sp_playlistcontainer* pc, libspotify.sp_playlist* p,
        int position, int new_position, void* userdata) with gil:
    cdef object playlists_callbacks
    cdef Playlists playlists = Playlists()
    cdef Playlist playlist = Playlist()
    if userdata is not NULL:
        playlists_callbacks = <object> userdata
        playlists._playlist_container = pc
        playlist._playlist = p
        playlists_callbacks.playlist_moved(
            playlists, playlist, position, new_position)

cdef void playlists_callback_container_loaded(
        libspotify.sp_playlistcontainer* pc, void* userdata) with gil:
    cdef object playlists_callbacks
    cdef Playlists playlists = Playlists()
    if userdata is not NULL:
        playlists_callbacks = <object> userdata
        playlists._playlist_container = pc
        playlists_callbacks.container_loaded(playlists)


cdef class Playlists(object):
    def __init__(self):
        self._callbacks.playlist_added = playlists_callback_playlist_added
        self._callbacks.playlist_removed = playlists_callback_playlist_removed
        self._callbacks.playlist_moved = playlists_callback_playlist_moved
        self._callbacks.container_loaded = playlists_callback_container_loaded

    def add_callbacks(self, object playlists_callbacks):
        if self._playlist_container is not NULL:
            self._playlists_callbacks = playlists_callbacks
            libspotify.sp_playlistcontainer_add_callbacks(
                self._playlist_container, &self._callbacks,
                <void*> self._playlists_callbacks)

    def remove_callbacks(self):
        if self._playlist_container is not NULL:
            libspotify.sp_playlistcontainer_remove_callbacks(
                self._playlist_container, &self._callbacks,
                <void*> self._playlists_callbacks)

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
