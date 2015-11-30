PicoPy
======

Pythonic interface to the Picoscope 4000 series A/B devices. It shouldn't be
too difficult to extend to other devices, but I don't have one to work with.

Most of the code is well documented, so I suggest reading that to find out
how to use the code.

The current setup is pretty specific to my (Linux) system, but it shouldn't
be difficult to adapt to any platform for which there is a supported driver. I'm posting it on Github rather belatedly in the hope
it might be useful. Patches of all kinds gratefully received.

Beginners' Tutorial to Building on Windows 7 for a PicoScope 4000
---------------------

This is a line-by line build tutorial for building PicoPy using Windows 7 64 bit with Anaconda 64-bit python 2.7.10. This will be a hand-holding tutorial for new users who are unfamiliar with compiling or installing from git. Note that the Anaconda specific options are optional. They are provided as a way for a new user to follow this guide without compromising an existing install by creating a new environment.

Open the windows command prompt.
>Start menu > Run... > cmd

Create new environment "picopy" with python 2.7. This will be the environment that we will use when we want to use the PicoPy module.
>conda create --name picopy python=2.7

Activate our new environment.
>activate picopy

We also require cython and pyparsing installed, so let's install those to the new environment.
> pip install cython pyparsing

Now we need to build PicoPy using the same compiler that was used to build our version of python. A helping hand are [these instructions for building Cython extensions on Windows](https://github.com/cython/cython/wiki/CythonExtensionsOnWindows). First check the python version to find how it was compiled by entering the python shell.
> python

> Python 2.7.10 |Continuum Analytics, Inc.| (default, Nov  7 2015, 13:18:40) [MSC
v.1500 64 bit (AMD64)] on win32

Exit the python shell

>  \>\>\>exit()

We can see that this version of python was compiled with MSC version 1500 64 bit. That's not very helpful, but we can use this [table](https://matthew-brett.github.io/pydagogue/python_msvc.html) to look up the compiler we actually need to install. MSC version 1500 corresponds to VC++ version 9.0, which is available on Visual Studio 2008. If we compile for 32 bit, you can use the Visual Studio Express package, which in our case would be Visual Studio 2008. For 64 bit, we need the matching SDK instead of Visual Studio. Using the [Cython build extension instructions](https://github.com/cython/cython/wiki/CythonExtensionsOnWindows#using-windows-sdk-cc-compiler-works-for-all-python-versions) we match the Python version to the SDK required.

We have Python 2.7, so we need the .NET 3.5 SP1 Windows SDK.
A web installer provided by Microsoft is located [here](https://www.microsoft.com/en-gb/download/details.aspx?id=3138) or an ISO installer located [here](https://www.microsoft.com/en-us/download/details.aspx?id=18950). We'll get the web installer as we don't want to burn a DVD or have the hassle of mounting the ISO file.

Run the newly downloaded web installer ([win_sdkweb.exe](https://www.microsoft.com/en-gb/download/details.aspx?id=3138)) and install to the default directories (`C:\Program Files\Microsoft SDKs\Windows\v7.0`). We don't need the full Documentation or Samples, so you may un-tick them to prevent them from installing. We do however require the Development Tools, so leave that ticked. Press next to download the SDK.

To build a package we need to start a SDK command prompt, or a regular CMD shell and then set our environment variables the match the SDK. Start our SDK command prompt from the start menu as it's easier than modifying the regular CMD shell.

> Start > Microsoft Windows SDK v7.0 > CMD Shell

You should be presented with a shell with coloured yellow text. Now we have to tell Python's DistUtils and SetupTools to use the SDK compiler. So in our shell enter:

> set DISTUTILS\_USE\_SDK=1

And then tell the compiler to use a 64 bit build as a release version. Enter:

> setenv /x64 /release

The text colour turns from yellow to green. We'll get the shell ready to build into out current Anaconda environment as we did with the previous shell.

> activate picopy

Now that we have shell ready we change directory (`cd`) to the build directory where PicoPy is located. If you have not downloaded PicoPy yet, either clone from git or download the repository as a ZIP file. Note that I'm using the pico4k branch for use with a Picoscope 4227.

> cd C:\Users\your\_user\_name\Documents\PicoPy

We can't build until the propeitary PicoScope DLLs and Libs are copied into PicoPy. To get them, we need to download the [Picoscope SDK for windows](https://www.picotech.com/downloads). Select PicoScope SDK 64 bit Stable and install to the default directory. Open the directory that the SDK installed to in `C:\Program Files\Pico Technology\SDK`. Copy `inc/ps4000Api.h` into PicoPy's `include/4k` folder, and `lib/ps4000.dll`, `lib/ps4000.lib` and `lib/picoipp.dll` into `picopy/`, so that `ps4000.dll` and `ps4000.lib` are in the same directory as `__init__.py`.

Build with
> python setup.py build-ext --inplace

Everything should build successfully. If not, check the .dll and.lib file locations and that you are sitting in the correct windows SDK command shell. Finally install to our environment using
> python setup.py install

Test by running python and importing picopy
> python

> \>\>\> import picopy


