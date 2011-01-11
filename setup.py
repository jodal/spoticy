from distutils.core import setup
from distutils.extension import Extension
from Cython.Distutils import build_ext

ext_modules = [
    Extension('spoticy', ['src/spoticy.pyx'], libraries=['spotify'])
]

setup(
    name = 'spoticy',
    cmdclass = {'build_ext': build_ext},
    ext_modules = ext_modules
)
