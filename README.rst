Spoticy
=======

`libspotify <http://developer.spotify.com/en/libspotify/>`_ bindings for
`Python <http://www.python.org/>`_ written in
`Cython <http://www.cython.org/>`_.


Current status
--------------

This is currently a work in progress and is far from complete or usable.  You
should regard this project as sandbox for learning Cython, and use pyspotify
instead.

====================  ========  =====================
Subsystem             Priority  Status
====================  ========  =====================
Error handling        1         Fully implemented
Session handling      1         Partially implemented
Link subsystem        4         Not implemented
Track subsystem       2         Not implemented
Album subsystem       3         Not implemented
Artist subsystem      3         Not implemented
Album browsing        6         Not implemented
Artist browsing       6         Not implemented
Image handling        6         Not implemented
Search subsystem      5         Not implemented
Playlist subsystem    2         Not implemented
User handling         8         Not implemented
Toplist handling      7         Not implemented
Inbox subsystem       9         Not implemented
====================  ========  =====================


How to get started developing
-----------------------------

#. You need build tools, a C compiler, etc. If you're on Debian/Ubuntu, just::

      sudo apt-get install build-essential

#. Install libspotify from source or from http://apt.mopidy.com/. If you
   install from APT, make sure to install the ``libspotify-dev`` package to get
   the libspotify headers.

#. Install Cython. From APT::

       sudo apt-get install cython

   Or from PyPI::

       sudo pip install cython

#. Install nosetests. From APT::

       sudo apt-get install python-nose

   Or from PyPI::

       sudo pip install nose

#. Get the source code::

      git clone git://github.com/jodal/spoticy.git
      cd spoticy/

#. Create a file named ``tests/settings.py`` containing the following::

      SPOTIFY_USERNAME = u'alice'
      SPOTIFY_PASSWORD = u'secret'

   Replace ``alice`` and ``secret`` with your own Spotify Premium account.

#. Build and run tests::

      make

#. Change some code or tests. Continue at previous step.


License
-------

Source code is copyright Stein Magnus Jodal and licensed under the Apache
License, Version 2.0.

