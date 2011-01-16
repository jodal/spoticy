from spoticy cimport libspotify
from spoticy.session cimport Session

cdef class User(object):
    cdef libspotify.sp_user* _user

cdef class Friends(object):
    cdef Session session
