# Henry Gomersall
# heng@kedevelopments.co.uk
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#    http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

from distutils.core import setup
from distutils.extension import Extension
from distutils.util import get_platform

import os
import numpy


include_dirs = [numpy.get_include()]
library_dirs = []
package_data = {}

if get_platform() == 'win32':
    libraries = ['ps3000a', 'usb_pico-1.0']
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
        'packages':['PicoPy'],
        'ext_modules': ext_modules,
        'include_dirs': include_dirs,
        'package_data': package_data,
  }

if __name__ == '__main__':
    setup(**setup_args)
