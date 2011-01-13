cdef extern from 'libspotify/api.h':

    int SPOTIFY_API_VERSION

    ### Opaque types/handles

    cdef struct sp_session:
        pass
    cdef struct sp_track:
        pass
    cdef struct sp_album:
        pass
    cdef struct sp_artist:
        pass
    cdef struct sp_artistbrowse:
        pass
    cdef struct sp_albumbrowse:
        pass
    cdef struct sp_toplistbrowse:
        pass
    cdef struct sp_search:
        pass
    cdef struct sp_link:
        pass
    cdef struct sp_image:
        pass
    cdef struct sp_user:
        pass
    cdef struct sp_playlist:
        pass
    cdef struct sp_playlistcontainer:
        pass
    cdef struct sp_inbox:
        pass

    ### Error handling

    cdef enum sp_error:
        pass

    cdef char* sp_error_message(sp_error error)

    ### Session handling

    cdef enum sp_connectionstate:
        pass

    cdef enum sp_sampletype:
        pass

    cdef struct sp_audioformat:
        sp_sampletype sampletype
        int sample_rate
        int channels

    cdef enum sp_bitrate:
        pass

    cdef enum sp_playlist_type:
        pass

    cdef struct sp_audio_buffer_stats:
        int samples
        int stutter

    cdef struct sp_session_callbacks:
        void logged_in(sp_session* session, sp_error error)
        void logged_out(sp_session* session)
        void metadata_updated(sp_session* session)
        void connection_error(sp_session* session, sp_error error)
        void message_to_user(sp_session* session, char* message)
        void notify_main_thread(sp_session* session)
        void music_delivery(sp_session* session, sp_audioformat* format,
            void* frames, int num_frames)
        void play_token_lost(sp_session* session)
        void log_message(sp_session* session, char* data)
        void end_of_track(sp_session* session)
        void streaming_error(sp_session* session, sp_error error)
        void userinfo_updated(sp_session* session)
        void start_playback(sp_session* session)
        void stop_playback(sp_session* session)
        void get_audio_buffer_stats(sp_session* session,
            sp_audio_buffer_stats* stats)

    cdef struct sp_session_config:
        int api_version
        char* cache_location
        char* settings_location
        void* application_key
        size_t application_key_size
        char* user_agent
        sp_session_callbacks* callbacks
        void* userdata
        bint tiny_settings

    cdef sp_error sp_session_create(sp_session_config* config, sp_session**
            session)

    cdef void sp_session_release(sp_session* session)

    cdef sp_error sp_session_login(sp_session* session, char* username, char*
            password)

    cdef sp_user* sp_session_user(sp_session* session)

    cdef sp_error sp_session_logout(sp_session* session)

    cdef sp_connectionstate sp_session_connectionstate(sp_session* session)

    cdef void* sp_session_userdata(sp_session* session)

    cdef void* sp_session_process_events(sp_session* session, int* next_time)
