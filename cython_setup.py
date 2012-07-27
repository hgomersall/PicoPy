# Copyright 2012 Knowledge Economy Developments Ltd
#
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
from Cython.Distutils import build_ext
from setup import setup_args, libraries, library_dirs
import os

ext_modules = [
        Extension(
            'picopy.pico3k',
            sources = [os.path.join('picopy', 'pico3k.pyx')], 
            include_dirs = ['picopy'],
            libraries=libraries,
            library_dirs=library_dirs),
        Extension(
            'picopy.pico_status',
            sources = [os.path.join('picopy', 'pico_status.pyx')], 
            include_dirs = ['picopy'])]

setup_args['cmdclass'] = {'build_ext': build_ext}
setup_args['ext_modules'] = ext_modules

setup(**setup_args)
