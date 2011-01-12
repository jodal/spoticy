# encoding: utf-8

import unittest

import spoticy

class SessionConfigTest(unittest.TestCase):
    def setUp(self):
        self.application_key = open('tests/spotify_appkey.key').read()
        self.callbacks = spoticy.SessionCallbacks()


    def test_api_version_is_read_from_libspotify(self):
        config = spoticy.SessionConfig(self.application_key, self.callbacks)
        self.assertEquals(6, config.api_version)


    def test_cache_location_defaults_to_no_cache(self):
        config = spoticy.SessionConfig(self.application_key, self.callbacks)
        self.assertEqual(unicode, type(config.cache_location))
        self.assertEqual(u'', config.cache_location)

    def test_cache_location_may_not_be_passed_as_bytestring(self):
        self.assertRaises(TypeError, spoticy.SessionConfig,
            self.application_key, self.callbacks, cache_location='/test_æøå')

    def test_cache_location_may_be_passed_as_unicode(self):
        config = spoticy.SessionConfig(self.application_key, self.callbacks,
            cache_location=u'/test_æøå')
        self.assertEqual(u'/test_æøå', config.cache_location)

    def test_cache_location_may_not_be_changed(self):
        config = spoticy.SessionConfig(self.application_key, self.callbacks)
        try:
            config.cache_location = u'/somewhere/else'
            self.fail(u'Should not be writable')
        except AttributeError:
            self.assertEqual(u'', config.cache_location)


    def test_settings_location_defaults_to_tmp_in_current_dir(self):
        config = spoticy.SessionConfig(self.application_key, self.callbacks)
        self.assertEqual(unicode, type(config.settings_location))
        self.assertEqual(u'tmp', config.settings_location)

    def test_settings_location_may_not_be_passed_as_bytestring(self):
        self.assertRaises(TypeError, spoticy.SessionConfig,
            self.application_key, self.callbacks, settings_location='/test_æøå')

    def test_settings_location_may_be_passed_as_unicode(self):
        config = spoticy.SessionConfig(self.application_key, self.callbacks,
            settings_location=u'/test_æøå')
        self.assertEqual(u'/test_æøå', config.settings_location)

    def test_settings_location_may_not_be_changed(self):
        config = spoticy.SessionConfig(self.application_key, self.callbacks)
        try:
            config.settings_location = u'/somewhere/else'
            self.fail(u'Should not be writable')
        except AttributeError:
            self.assertEqual(u'tmp', config.settings_location)


    def test_create_config_without_application_key_should_fail(self):
        self.assertRaises(AssertionError, spoticy.SessionConfig,
            None, self.callbacks)

    def test_application_key_may_not_be_passed_as_unicode(self):
        self.assertRaises(TypeError, spoticy.SessionConfig,
            u'123', self.callbacks)

    def test_application_key_may_be_passed_as_bytestring(self):
        config = spoticy.SessionConfig('123', self.callbacks)
        self.assertEqual(str, type(config.application_key))
        self.assertEqual('123', config.application_key)

    def test_application_key_may_not_be_changed(self):
        config = spoticy.SessionConfig('123', self.callbacks)
        try:
            config.application_key = '456'
            self.fail(u'Should not be writable')
        except AttributeError:
            self.assertEqual('123', config.application_key)


    def test_application_key_size_is_the_size_in_bytes(self):
        config = spoticy.SessionConfig('123', self.callbacks)
        self.assertEqual(3, config.application_key_size)
        config = spoticy.SessionConfig('12345', self.callbacks)
        self.assertEqual(5, config.application_key_size)

    def test_application_key_size_may_not_be_changed(self):
        config = spoticy.SessionConfig('123', self.callbacks)
        try:
            config.application_key_size = 5
            self.fail(u'Should not be writable')
        except AttributeError:
            self.assertEqual(3, config.application_key_size)


    def test_user_agent_defaults_to_spoticy(self):
        config = spoticy.SessionConfig(self.application_key, self.callbacks)
        self.assertEqual(unicode, type(config.user_agent))
        self.assertEqual(u'Spoticy', config.user_agent)

    def test_user_agent_may_not_be_passed_as_bytestring(self):
        self.assertRaises(TypeError, spoticy.SessionConfig,
            self.application_key, self.callbacks, user_agent='Test ÆØÅ')

    def test_user_agent_may_be_passed_as_unicode(self):
        config = spoticy.SessionConfig(self.application_key, self.callbacks,
            user_agent=u'Test ÆØÅ')
        self.assertEqual(u'Test ÆØÅ', config.user_agent)

    def test_user_agent_may_not_be_changed(self):
        config = spoticy.SessionConfig(self.application_key, self.callbacks)
        try:
            config.user_agent = u'Something else'
            self.fail(u'Should not be writable')
        except AttributeError:
            self.assertEqual(u'Spoticy', config.user_agent)


    # TODO callbacks


    def test_create_config_without_session_callbacks_should_fail(self):
        self.assertRaises(AssertionError, spoticy.SessionConfig,
            self.application_key, None)

    def test_session_callbacks_is_stored_as_userdata(self):
        config = spoticy.SessionConfig(self.application_key, self.callbacks)
        self.assertEqual(self.callbacks, config.userdata)


    def test_tiny_settings_defaults_to_false(self):
        config = spoticy.SessionConfig(self.application_key, self.callbacks)
        self.assertEqual(False, config.tiny_settings)

    def test_tiny_settings_may_be_set_to_false(self):
        config = spoticy.SessionConfig(self.application_key, self.callbacks,
            tiny_settings=False)
        self.assertEqual(False, config.tiny_settings)

    def test_tiny_settings_may_be_set_to_true(self):
        config = spoticy.SessionConfig(self.application_key, self.callbacks,
            tiny_settings=True)
        self.assertEqual(True, config.tiny_settings)

    def test_tiny_settings_may_not_be_changed(self):
        config = spoticy.SessionConfig(self.application_key, self.callbacks)
        try:
            config.tiny_settings = True
            self.fail(u'Should not be writable')
        except AttributeError:
            self.assertEqual(False, config.tiny_settings)
