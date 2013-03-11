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

from distutils.core import setup
from distutils.extension import Extension
from distutils.util import get_platform

import os
import numpy


include_dirs = [numpy.get_include()]
library_dirs = []
package_data = {}

if get_platform() == 'win32':
    libraries = ['PS3000a']
    include_dirs.append('picopy')
    library_dirs.append(os.path.join(os.getcwd(),'picopy'))
else:
    libraries = ['ps3000a', 'usb_pico-1.0']


ext_modules = [
        Extension('picopy.pico3k',
            sources=[os.path.join('picopy', 'pico3k.c')],
            libraries=libraries,
            library_dirs=library_dirs),
    Extension(
            'picopy.pico_status',
            sources = [os.path.join('picopy', 'pico_status.c')], 
            include_dirs = ['picopy'])]

version = '0.0.1'

long_description = '''
'''

setup_args = {
        'name': 'PicoPy',
        'version': version,
        'author': 'Henry Gomersall',
        'author_email': 'heng@kedevelopments.co.uk',
        'description': 'A pythonic wrapper around the PicoScope (3000 series) API.',
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
  }

if __name__ == '__main__':
    setup(**setup_args)
