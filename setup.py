from distutils.core import setup
from distutils.extension import Extension
from Cython.Distutils import build_ext

ext_modules = [
    Extension('spoticy.%s' % module, ['spoticy/%s.pyx' % module],
        include_dirs=['.'], libraries=['spotify'])
    for module in ('core', 'playlist', 'session', 'user')
]

setup(
    name = 'spoticy',
    cmdclass = {'build_ext': build_ext},
    ext_modules = ext_modules
)
