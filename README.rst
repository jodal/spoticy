Spoticy
=======

`libspotify <http://developer.spotify.com/en/libspotify/>`_ bindings for
`Python <http://www.python.org/>`_ written in
`Cython <http://www.cython.org/>`_.

.. warning::

    This is currently a work in progress and is far from complete or usable.
    You should regard this project as sandbox for learning Cython, and use
    pyspotify instead.


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

#. Build and run tests::

      make

#. Change some code or tests. Continue at previous step.


License
-------

Source code is copyright Stein Magnus Jodal and licensed under the Apache
License, Version 2.0.

