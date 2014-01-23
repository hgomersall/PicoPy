PicoPy
======

Pythonic interface to the Picoscope 3000 series A/B devices. I shouldn't be
too difficult to extend to other devices, but I don't have one to work with.

Most of the code is well documented, so I suggest reading that to find out
how to use the code.

The current setup is pretty specific to my (Linux) system, but it shouldn't
be difficult to adapt to any platform for which there is a supported
libps3000a driver. I'm posting it on Github rather belatedly in the hope
it might be useful. Patches of all kinds gratefully received.

On my machine, I build with `python cython_setup.py build_ext` followed
by a `python setup.py install` or similar to get it installed. You'll have
to fiddle around with the paths for the driver. On Windows, you can probably
put the driver file inside the picopy directory. I suggest taking a look
at the `setup.py` file for my other project, 
[pyFFTW](https://github.com/hgomersall/pyFFTW). At some point, I'll update 
the `setup.py` in this project to more closely follow what I do there.
