from spoticy cimport libspotify

cdef class Playlists(object):
    cdef libspotify.sp_playlistcontainer* _playlist_container
