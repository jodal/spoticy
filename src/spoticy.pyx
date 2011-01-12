cimport python_unicode
cimport stdlib

cimport libspotify

### String handling

cdef unicode to_unicode(char* s):
    return s.decode('UTF-8', 'strict')

cdef char* to_string(unicode u):
    s = u.encode('UTF-8', 'strict')
    return s


### Error handling

class SpotifyException(Exception):
    def __init__(self, sp_error):
        message = '%s (sp_error=%d)' % (
            libspotify.sp_error_message(sp_error), sp_error)
        super(Exception, self).__init__(message)

cpdef bint is_ok(libspotify.sp_error sp_error) except False:
    if sp_error == 0:
        return True
    else:
        raise SpotifyException(sp_error)
        return False


### Session callbacks

class SessionCallbacks(object):
    """
    Session related callback methods

    To provide your own implementations of the callbacks, subclass this class,
    instantiate your subclass, and pass it to the :class:`SessionConfig`
    instance which is used to create the :class:`Session`.
    """

    def logged_in(self, session, error):
        pass

    def logged_out(self, session):
        pass

    def metadata_updated(self, session):
        pass

    def connection_error(self, session, error):
        pass

    def message_to_user(self, session, message):
        pass

    def notify_main_thread(self, session):
        pass

    def music_delivery(self, session, audio_format, frames, num_frames):
        pass

    def play_token_lost(self, session):
        pass

    def log_message(self, session, message):
        pass

    def end_of_track(self, session):
        pass

    def streaming_error(self, session, error):
        pass

    def userinfo_updated(self, session):
        pass

    def start_playback(self, session):
        pass

    def stop_playback(self, session):
        pass

    def get_audio_buffer_stats(self, session, audio_buffer_stats):
        pass


cdef void logged_in_callback(libspotify.sp_session* sp_session,
        libspotify.sp_error sp_error):
    cdef void* userdata = libspotify.sp_session_userdata(sp_session)
    cdef object session_callbacks
    cdef Session session
    if userdata is not NULL:
        session_callbacks = <object> userdata
        session = Session()
        session._c_session = sp_session
        session_callbacks.logged_in(session_callbacks, session, sp_error)


### Session config

cdef class SessionConfig(object):
    cdef libspotify.sp_session_callbacks* _c_callbacks
    cdef libspotify.sp_session_config _c_config
    cdef bytes _application_key
    cdef object _session_callbacks

    def __cinit__(self):
        self._c_callbacks = <libspotify.sp_session_callbacks*> \
            stdlib.malloc(sizeof(libspotify.sp_session_callbacks))

    def __dealloc__(self):
        if self._c_config.callbacks is not NULL:
            stdlib.free(self._c_callbacks)

    def __init__(self, bytes application_key, object session_callbacks,
            unicode cache_location=None, unicode settings_location=None,
            unicode user_agent=None, bint tiny_settings=False):

        assert application_key is not None
        assert session_callbacks is not None

        # Keep a reference to the objects so they're not lost
        self._application_key = application_key
        self._session_callbacks = session_callbacks

        self._c_config.api_version = libspotify.SPOTIFY_API_VERSION

        if cache_location is None:
            cache_location = u''
        cache_location_str = to_string(cache_location)
        self._c_config.cache_location = cache_location_str

        if settings_location is None:
            settings_location = u'tmp'
        settings_location_str = to_string(settings_location)
        self._c_config.settings_location = settings_location_str

        self._c_config.application_key = <void*>(<char*> self._application_key)
        self._c_config.application_key_size = len(self._application_key)

        if user_agent is None:
            user_agent = u'Spoticy'
        user_agent_str = to_string(user_agent)
        self._c_config.user_agent = user_agent_str

        self._c_callbacks.logged_in = logged_in_callback
        # TODO Assign pointer to callback struct to config struct

        self._c_config.userdata = <void*> self._session_callbacks

        self._c_config.tiny_settings = tiny_settings

    property api_version:
        def __get__(self):
            return self._c_config.api_version

    property cache_location:
        def __get__(self):
            return to_unicode(<char*> self._c_config.cache_location)

    property settings_location:
        def __get__(self):
            return to_unicode(<char*> self._c_config.settings_location)

    property application_key:
        def __get__(self):
            return <char*> self._c_config.application_key

    property application_key_size:
        def __get__(self):
            return self._c_config.application_key_size

    property user_agent:
        def __get__(self):
            return to_unicode(<char*> self._c_config.user_agent)

    property userdata:
        def __get__(self):
            return <object> self._c_config.userdata

    property tiny_settings:
        def __get__(self):
            return self._c_config.tiny_settings


### Session handling

cdef class Session(object):
    cdef libspotify.sp_session* _c_session

    def __init__(self, SessionConfig config=None):
        if config is not None:
            is_ok(libspotify.sp_session_create(
                &config._c_config, &self._c_session))
        else:
            pass # Assuming that you are setting _c_session directly
            # XXX Would be nice to be able to get a sp_session* as an argument
            # and set it before the end of __init__, so we're never in an
            # invalid state.

    def release(self):
        if self._c_session is not NULL:
            libspotify.sp_session_release(self._c_session)
            self._c_session = NULL

    property connection_state:
        def __get__(self):
            if self._c_session is not NULL:
                return libspotify.sp_session_connectionstate(self._c_session)

    def login(self, unicode username, unicode password):
        if self._c_session is NULL:
            raise Exception(u'Session not initialized')
        username_str = to_string(username)
        password_str = to_string(password)
        is_ok(libspotify.sp_session_login(
            self._c_session, username_str, password_str))

    def logout(self):
        if self._c_session is NULL:
            raise Exception(u'Session not initialized')
        is_ok(libspotify.sp_session_logout(self._c_session))
