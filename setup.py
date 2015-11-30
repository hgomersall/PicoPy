# Copyright 2012 Knowledge Economy Developments Ltd
#
# Henry Gomersall
# heng@kedevelopments.co.uk
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
#

from setuptools import setup
from distutils.extension import Extension
from distutils.util import get_platform
from distutils.ccompiler import get_default_compiler

import os
import numpy
import sys

try:
    from Cython.Distutils import build_ext as build_ext
    pico4k_sources = [os.path.join('picopy', 'pico4k.pyx')]
    pico_status_sources = [os.path.join('picopy', 'pico_status.pyx')]
except ImportError:
    # We can't cythonize, but that might have been done already in a
    # source distribution, so carry on and see...
    from distutils.command.build_ext import build_ext
    pico4k_sources = [os.path.join('picopy', 'pico4k.c')]
    pico_status_sources = [os.path.join('picopy', 'pico_status.c')]

include_dirs = [os.path.join('include', '4k'), numpy.get_include()]
library_dirs = []
package_data = {}

if get_platform() in ('win32', 'win-amd64'):
    libraries = ['PS4000']
    #include_dirs.append(os.path.join('include', 'win'))
    library_dirs.append(os.path.join(os.getcwd(),'picopy'))
    package_data['picopy'] = ['PS4000.dll', 'PicoIpp.dll', 'PS4000.lib']
else:
    library_dirs.append(os.path.join('/', 'opt', 'picoscope', 'lib'))
    libraries = ['ps4000']
    #libraries = ['ps3000a', 'usb_pico-1.0']

class custom_build_ext(build_ext):
    def finalize_options(self):

        build_ext.finalize_options(self)

        if self.compiler is None:
            compiler = get_default_compiler()
        else:
            compiler = self.compiler

        if compiler == 'msvc':
            # Add msvc specific hacks
            
            if (sys.version_info.major, sys.version_info.minor) < (3, 3):
                # The check above is a nasty hack. We're using the python
                # version as a proxy for the MSVC version. 2008 doesn't
                # have stdint.h, so is needed. 2010 does.
                #
                # We need to add the path to msvc includes
                include_dirs.append(os.path.join('include', 'msvc_2008'))

            # We need to prepend lib to all the library names
            _libraries = []
            for each_lib in self.libraries:
                _libraries.append('lib' + each_lib)

            self.libraries = _libraries

ext_modules = [
        Extension('picopy.pico4k',
            sources=pico4k_sources,
            libraries=libraries,
            include_dirs=include_dirs,
            library_dirs=library_dirs),
        Extension(
            'picopy.pico_status',
            sources = pico_status_sources, 
            include_dirs=include_dirs)]
        
#include_dirs = [numpy.get_include()]
#library_dirs = []
#package_data = {}
#
#if get_platform() == 'win32':
#    #libraries = ['PS3000a']
#    libraries = ['PS4000']
#    include_dirs.append('picopy')
#    include_dirs.append(os.path.join('include', '4k'))
#    library_dirs.append(os.path.join(os.getcwd(),'picopy'))
#    package_data['picopy'] = ['PS4000.dll', 'PicoIpp.dll', 'PS4000.lib']
#else:
#    libraries = ['ps3000a', 'usb_pico-1.0']
#
#
#ext_modules = [
#    #Extension('picopy.pico3k',
#    #        sources=[os.path.join('picopy', 'pico3k.c')],
#    #        libraries=libraries,
#    #        library_dirs=library_dirs),
#    Extension('picopy.pico4k',
#            sources=[os.path.join('picopy', 'pico4k.c')],
#            libraries=libraries,
#            include_dirs=include_dirs,
#            library_dirs=library_dirs),
#    Extension(
#            'picopy.pico_status',
#            sources = [os.path.join('picopy', 'pico_status.c')], 
#           include_dirs=include_dirs)]

version = '0.0.1'

long_description = '''
'''

setup_args = {
        'name': 'PicoPy',
        'version': version,
        'author': 'Henry Gomersall',
        'author_email': 'heng@kedevelopments.co.uk',
        'description': 'A pythonic wrapper around the PicoScope (3000 and 4000 series) API.',
        'url': 'http://hgomersall.github.com/PicoPy/',
        'long_description': long_description,
        'classifiers': [
            'Programming Language :: Python',
            'Programming Language :: Python :: 3',
            'Development Status :: 3 - Alpha',
            'License :: OSI Approved :: GNU General Public License (GPL)',
            'Operating System :: OS Independent',
            'Intended Audience :: Developers',
            'Intended Audience :: Science/Research',
            'Topic :: Scientific/Engineering',
            ],
        'packages':['picopy'],
        'ext_modules': ext_modules,
        'include_dirs': include_dirs,
        'package_data': package_data,
        'cmdclass': {'build_ext': custom_build_ext},
  }

if __name__ == '__main__':
    setup(**setup_args)
