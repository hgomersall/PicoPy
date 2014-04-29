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
from Cython.Distutils import build_ext
from setup import setup_args, libraries, library_dirs, include_dirs
import os

ext_modules = [
        #Extension(
        #    'picopy.pico3k',
        #    sources = [os.path.join('picopy', 'pico3k.pyx')], 
        #    include_dirs = ['picopy', 'include'],
        #    libraries=libraries,
        #    library_dirs=library_dirs),
        Extension(
            'picopy.pico4k',
            sources = [os.path.join('picopy', 'pico4k.pyx')], 
            libraries=libraries,
            include_dirs=include_dirs,
            library_dirs=library_dirs),
        Extension(
            'picopy.pico_status',
            sources=[os.path.join('picopy', 'pico_status.pyx')], 
            include_dirs=include_dirs)]

setup_args['cmdclass'] = {'build_ext': build_ext}
setup_args['ext_modules'] = ext_modules

setup(**setup_args)
