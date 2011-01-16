from spoticy cimport libspotify

cdef class Session(object):
    cdef libspotify.sp_session* _session
