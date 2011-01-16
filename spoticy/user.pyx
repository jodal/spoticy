from spoticy cimport libspotify
from spoticy.core cimport *
from spoticy.core import *


cdef class User(object):
    property is_loaded:
        def __get__(self):
            if self._user is NULL:
                return False
            return libspotify.sp_user_is_loaded(self._user)

    property canonical_name:
        def __get__(self):
            if self.is_loaded:
                return libspotify.sp_user_canonical_name(
                    self._user).decode(ENCODING)

    property display_name:
        def __get__(self):
            if self.is_loaded:
                return libspotify.sp_user_display_name(
                    self._user).decode(ENCODING)

    property full_name:
        def __get__(self):
            cdef libspotify.const_char_ptr full_name
            if self.is_loaded:
                full_name = libspotify.sp_user_full_name(self._user)
                if full_name is not NULL:
                    return full_name.decode(ENCODING)

    property picture_url:
        def __get__(self):
            cdef libspotify.const_char_ptr picture_url
            if self.is_loaded:
                picture_url = libspotify.sp_user_picture(self._user)
                if picture_url is not NULL:
                    return picture_url.decode(ENCODING)


cdef class Friends(object):
    def __init__(self, Session session):
        self.session = session

    def __len__(self):
        if self.session.connection_state == CONNECTION_STATE_LOGGED_IN:
            return libspotify.sp_session_num_friends(self.session._session)
        else:
            return 0

    def __getitem__(self, index):
        cdef User user = User()
        if 0 <= index < len(self):
            user._user = libspotify.sp_session_friend(
                self.session._session, index)
            return user
        else:
            raise IndexError(u'list index out of range')
