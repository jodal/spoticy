from spoticy cimport libspotify


### Settings

COMPATIBLE_API_VERSION = 6
ENCODING = 'utf-8'


### Constants

BITRATE_160k = 0
BITRATE_320k = 1
CONNECTION_STATE_LOGGED_OUT = 0
CONNECTION_STATE_LOGGED_IN = 1
CONNECTION_STATE_DISCONNECTED = 2
CONNECTION_STATE_UNDEFINED = 3
ERROR_OK = 0
RELATION_TYPE_UNKNOWN = 0
RELATION_TYPE_NONE = 1
RELATION_TYPE_UNIDIRECTIONAL = 2
RELATION_TYPE_BIDIRECTIONAL = 3


### API version check

assert libspotify.SPOTIFY_API_VERSION == COMPATIBLE_API_VERSION, (
    u'This Spoticy version requires libspotify API version %(compatible)d, '
    u'but libspotify API version %(actual)d was found.') % {
        'compatible': COMPATIBLE_API_VERSION,
        'actual': libspotify.SPOTIFY_API_VERSION,
    }


### Error handling

class SpotifyException(Exception):
    def __init__(self, sp_error):
        self.error_code = sp_error
        message = '%s (sp_error=%d)' % (
            libspotify.sp_error_message(sp_error), sp_error)
        super(Exception, self).__init__(message)

cpdef bint is_ok(libspotify.sp_error sp_error) except False:
    if sp_error == ERROR_OK:
        return True
    else:
        raise SpotifyException(sp_error)
        return False
