cdef extern from 'libspotify/api.h':

    int SPOTIFY_API_VERSION

    # Define const types to get the generated C code to match libspotify
    ctypedef char* const_char_ptr "const char*"
    ctypedef void* const_void_ptr "const void*"
    cdef struct sp_audioformat
    ctypedef sp_audioformat const_sp_audioformat_ptr "const sp_audioformat*"

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

    cdef const_char_ptr sp_error_message(sp_error error) nogil

    ### Session handling

    cdef enum sp_connectionstate:
        pass

    cdef enum sp_sampletype:
        pass

    cdef struct sp_audioformat:
        sp_sampletype sample_type
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
        void message_to_user(sp_session* session, const_char_ptr message)
        void notify_main_thread(sp_session* session)
        int music_delivery(sp_session* session,
            const_sp_audioformat_ptr format,
            const_void_ptr frames, int num_frames)
        void play_token_lost(sp_session* session)
        void log_message(sp_session* session, const_char_ptr data)
        void end_of_track(sp_session* session)
        void streaming_error(sp_session* session, sp_error error)
        void userinfo_updated(sp_session* session)
        void start_playback(sp_session* session)
        void stop_playback(sp_session* session)
        void get_audio_buffer_stats(sp_session* session,
            sp_audio_buffer_stats* stats)

    cdef struct sp_session_config:
        int api_version
        const_char_ptr cache_location
        const_char_ptr settings_location
        const_void_ptr application_key
        size_t application_key_size
        const_char_ptr user_agent
        sp_session_callbacks* callbacks
        const_void_ptr userdata
        bint tiny_settings

    cdef sp_error sp_session_create(sp_session_config* config,
        sp_session** session) nogil

    cdef void sp_session_release(sp_session* session) nogil

    cdef sp_error sp_session_login(sp_session* session,
        const_char_ptr username, const_char_ptr password) nogil

    cdef sp_user* sp_session_user(sp_session* session) nogil

    cdef sp_error sp_session_logout(sp_session* session) nogil

    cdef sp_connectionstate sp_session_connectionstate(sp_session* session) \
        nogil

    cdef void* sp_session_userdata(sp_session* session) nogil

    cdef void sp_session_set_cache_size(sp_session* session, size_t size) nogil

    cdef void sp_session_process_events(sp_session* session, int* next_time) \
        nogil

    cdef sp_playlistcontainer* sp_session_playlistcontainer(
        sp_session* session) nogil

    cdef void sp_session_preferred_bitrate(sp_session* session,
        sp_bitrate bitrate) nogil

    cdef int sp_session_num_friends(sp_session* session) nogil

    cdef sp_user* sp_session_friend(sp_session* session, int index) nogil

    ### Playlist subsystem

    cdef struct sp_playlistcontainer_callbacks:
        void playlist_added(sp_playlistcontainer* pc, sp_playlist* p,
            int position, void* userdata)
        void playlist_removed(sp_playlistcontainer* pc, sp_playlist* p,
            int position, void* userdata)
        void playlist_moved(sp_playlistcontainer* pc, sp_playlist* p,
            int position, int new_position, void* userdata)
        void container_loaded(sp_playlistcontainer* pc, void* userdata)

    cdef void sp_playlistcontainer_add_callbacks(sp_playlistcontainer* pc,
        sp_playlistcontainer_callbacks* callbacks, void* userdata) nogil

    cdef void sp_playlistcontainer_remove_callbacks(sp_playlistcontainer* pc,
        sp_playlistcontainer_callbacks* callbacks, void* userdata) nogil

    cdef int sp_playlistcontainer_num_playlists(sp_playlistcontainer* pc) \
        nogil

    cdef sp_user* sp_playlistcontainer_owner(sp_playlistcontainer* pc) nogil

    ### User handling

    cdef enum sp_relation_type:
        pass

    cdef const_char_ptr sp_user_canonical_name(sp_user* user) nogil

    cdef const_char_ptr sp_user_display_name(sp_user* user) nogil

    cdef bint sp_user_is_loaded(sp_user* user) nogil

    cdef const_char_ptr sp_user_full_name(sp_user* user) nogil

    cdef const_char_ptr sp_user_picture(sp_user* user) nogil

    cdef sp_relation_type sp_user_relation_type(sp_session* session,
        sp_user* user) nogil
