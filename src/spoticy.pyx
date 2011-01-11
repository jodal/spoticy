cimport python_unicode

cimport libspotify

ENCODING = 'utf-8'

class SpoticyException(Exception):
    def __init__(self, sp_error):
        message = libspotify.sp_error_message(sp_error)
        message = '%s (sp_error=%d)' % (message, sp_error)
        super(Exception, self).__init__(message)

def check_error(sp_error):
    if sp_error:
        raise SpoticyException(sp_error)

cdef class Session(object):
    cdef libspotify.sp_session* session
    cdef libspotify.sp_session_config config

    def __init__(self, bytes application_key, unicode user_agent=u'Spoticy'):
        assert application_key is not None

        self.config.api_version = 6
        self.config.cache_location = ""
        self.config.settings_location = "tmp"

        self.config.application_key = <void*>(<char*> application_key)
        self.config.application_key_size = len(application_key)

        user_agent_str = user_agent.encode(ENCODING)
        self.config.user_agent = user_agent_str

        check_error(libspotify.sp_session_create(&self.config, &self.session))

    # FIXME This causes segfaults in lots of tests
    #def __dealloc__(self):
    #    libspotify.sp_session_release(self.session)

    property connection_state:
        def __get__(self):
            return libspotify.sp_session_connectionstate(self.session)

    def login(self, unicode username, unicode password):
        username_str = username.encode(ENCODING)
        password_str = password.encode(ENCODING)
        check_error(libspotify.sp_session_login(self.session, username_str,
            password_str))

    def logout(self):
        check_error(libspotify.sp_session_logout(self.session))
