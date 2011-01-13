cimport python_unicode

cimport libspotify

ENCODING = 'utf-8'


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


cdef void session_callback_logged_in(libspotify.sp_session* sp_session,
        libspotify.sp_error sp_error) with gil:
    cdef void* userdata = libspotify.sp_session_userdata(sp_session)
    cdef object session_callbacks
    cdef Session session
    if userdata is not NULL:
        session_callbacks = <object> userdata
        session = Session()
        session._session = sp_session
        session_callbacks.logged_in(session, sp_error)

cdef void session_callback_logged_out(libspotify.sp_session* sp_session) \
        with gil:
    cdef void* userdata = libspotify.sp_session_userdata(sp_session)
    cdef object session_callbacks
    cdef Session session
    if userdata is not NULL:
        session_callbacks = <object> userdata
        session = Session()
        session._session = sp_session
        session_callbacks.logged_out(session)

cdef void session_callback_connection_error(libspotify.sp_session* sp_session,
        libspotify.sp_error sp_error) with gil:
    cdef void* userdata = libspotify.sp_session_userdata(sp_session)
    cdef object session_callbacks
    cdef Session session
    if userdata is not NULL:
        session_callbacks = <object> userdata
        session = Session()
        session._session = sp_session
        session_callbacks.connection_error(session, sp_error)

cdef void session_callback_notify_main_thread(
        libspotify.sp_session* sp_session) with gil:
    cdef void* userdata = libspotify.sp_session_userdata(sp_session)
    cdef object session_callbacks
    cdef Session session
    if userdata is not NULL:
        session_callbacks = <object> userdata
        session = Session()
        session._session = sp_session
        session_callbacks.notify_main_thread(session)


### Session config

cdef class SessionConfig(object):
    cdef libspotify.sp_session_callbacks _callbacks
    cdef libspotify.sp_session_config _config
    cdef bytes _application_key
    cdef object _session_callbacks

    def __init__(self, bytes application_key, object session_callbacks,
            unicode cache_location=None, unicode settings_location=None,
            unicode user_agent=None, bint tiny_settings=False):

        assert application_key is not None
        assert session_callbacks is not None

        # Keep a reference to the objects so they're not lost
        self._application_key = application_key
        self._session_callbacks = session_callbacks

        self._config.api_version = libspotify.SPOTIFY_API_VERSION

        if cache_location is None:
            cache_location_str = ''
        else:
            cache_location_str = cache_location.encode(ENCODING)
        self._config.cache_location = cache_location_str

        if settings_location is None:
            settings_location_str = 'tmp'
        else:
            settings_location_str = settings_location.encode(ENCODING)
        self._config.settings_location = settings_location_str

        self._config.application_key = <void*>(<char*> self._application_key)
        self._config.application_key_size = len(self._application_key)

        if user_agent is None:
            user_agent_str = 'Spoticy'
        else:
            user_agent_str = user_agent.encode(ENCODING)
        self._config.user_agent = user_agent_str

        self._callbacks.logged_in = session_callback_logged_in
        self._callbacks.logged_out = session_callback_logged_out
        self._callbacks.metadata_updated = NULL # TODO
        self._callbacks.connection_error = session_callback_connection_error
        self._callbacks.message_to_user = NULL # TODO
        self._callbacks.notify_main_thread = \
            session_callback_notify_main_thread
        self._callbacks.music_delivery = NULL # TODO
        self._callbacks.play_token_lost = NULL # TODO
        self._callbacks.log_message = NULL # TODO
        self._callbacks.end_of_track = NULL # TODO
        self._callbacks.streaming_error = NULL # TODO
        self._callbacks.userinfo_updated = NULL # TODO
        self._callbacks.start_playback = NULL # TODO
        self._callbacks.stop_playback = NULL # TODO
        self._callbacks.get_audio_buffer_stats = NULL # TODO
        self._config.callbacks = &self._callbacks

        self._config.userdata = <void*> self._session_callbacks

        self._config.tiny_settings = tiny_settings

    property api_version:
        def __get__(self):
            return self._config.api_version

    property cache_location:
        def __get__(self):
            return self._config.cache_location.decode(ENCODING)

    property settings_location:
        def __get__(self):
            return self._config.settings_location.decode(ENCODING)

    property application_key:
        def __get__(self):
            return <char*> self._config.application_key

    property application_key_size:
        def __get__(self):
            return self._config.application_key_size

    property user_agent:
        def __get__(self):
            return self._config.user_agent.decode(ENCODING)

    property userdata:
        def __get__(self):
            return <object> self._config.userdata

    property tiny_settings:
        def __get__(self):
            return self._config.tiny_settings


### Session handling

CONNECTION_STATE_LOGGED_OUT = 0
CONNECTION_STATE_LOGGED_IN = 1
CONNECTION_STATE_DISCONNECTED = 2
CONNECTION_STATE_UNDEFINED = 3

cdef class Session(object):
    cdef libspotify.sp_session* _session

    def __init__(self, SessionConfig config=None):
        if config is not None:
            is_ok(libspotify.sp_session_create(
                &config._config, &self._session))
        else:
            pass # Assuming that you are setting _session directly
            # XXX Would be nice to be able to get a sp_session* as an argument
            # and set it before the end of __init__, so we're never in an
            # invalid state.

    def release(self):
        if self._session is not NULL:
            libspotify.sp_session_release(self._session)
            self._session = NULL

    property connection_state:
        def __get__(self):
            if self._session is not NULL:
                return libspotify.sp_session_connectionstate(self._session)

    def login(self, unicode username, unicode password):
        if self._session is NULL:
            raise Exception(u'Session not initialized')
        username_str = username.encode(ENCODING)
        password_str = password.encode(ENCODING)
        is_ok(libspotify.sp_session_login(
            self._session, username_str, password_str))

    def logout(self):
        if self._session is NULL:
            raise Exception(u'Session not initialized')
        is_ok(libspotify.sp_session_logout(self._session))

    def process_events(self):
        if self._session is NULL:
            raise Exception(u'Session not initialized')
        cdef int ms_to_next_time
        libspotify.sp_session_process_events(self._session, &ms_to_next_time)
        return ms_to_next_time
