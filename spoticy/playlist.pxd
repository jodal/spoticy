from spoticy cimport libspotify

cdef class Playlist(object):
    cdef libspotify.sp_playlist* _playlist

cdef class Playlists(object):
    cdef libspotify.sp_playlistcontainer* _playlist_container
    cdef libspotify.sp_playlistcontainer_callbacks _callbacks
    cdef object _playlists_callbacks
