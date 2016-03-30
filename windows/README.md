Pinguino-IDE Windows Installer
==============================

### Features

* Detects and installs all the required software for the Pinguino IDE.
  + Python v2.7
  + PyPIP
  + Wheel
  + BeautifullSoup4
  + PyUSB
  + PySIDE
  + LibUSB
  + pinguino-ide package
  + pinguino-libraries package
  + Compilers packages
  + Pinguino device drivers.
* Allow semi-automatic Pinguino device drivers installation
  +  8-bit Pinguino boards : VID 04D8 / PID FEAA
  +  8-bit Pinguino boards : VID 04D8 / PID FEAB
  + 32-bit Pinguino boards : VID 04D8 / PID 003C
* Installer size: 1229 KB.
* Multi-language: English, French, Italian, Portuguese and Spanish

### Supported OS

* This installer should work fine on the following Microsoft O.S.:
  + Windows XP (32-bits only).
  + Windows Vista (32 and 64-bits).
  + Windows 7 (32 and 64-bits).
  + Windows 8 (32 and 64-bits).
* 300Mb free space on disk for all the installed software.

Tested on:

* Windows XP Professional SP2 and SP3 32-bit
* Windows 7 Ultimate 32-bit
* Windows 7 Premium 64-bit

### Changelog
v1.7.0.2
* Fixed English translation
* Better logo management
* Download the compilers before the drivers
* XC8 installation only for the testing version 
v1.7.0.1
* Fixed the way curl.exe and pinguino11.bmp are wrapped up
v1.7.0.0
* Build with Nullsoft Scriptable Install System v3.0b3
* Added stable/testing choice
* Added xc8 compiler choice
v1.6.0.0
* Added start Pinguino IDE functionnality
* Added automatic transparent driver installation
* Added CDC driver
* Added USB\VID_04D8&PID_003C in mchpusb.inf
* Pinguino can now be installed everywhere
* Created a Display macro
* Added LICENSE
* Fixed HKEY_CURRENT_USER\Software\Pinguino
* Changed libusb-win32 to libusb (see libusb.info)
* No more embedded programs
* Created Download macro
* Updated detection routine
* Python can now be installed anywhere not only on C:
v1.5.0.0
* Added Python support for X86 and X86-64
* Added PySide support for X86 and X86-64
* Python and PySide are no more embedded but downloaded during installation
v1.4.0.0
* Build with Nullsoft Scriptable Install System v3.0b1
* Added latest Python 2.7.10 support
v1.3.0.0
* Updated drivers installation info.
* Fixed Windows Vista and later Pinguino device driver pre-install.
* PIC32 compilers and libraries added.
* French language translation, thanks to Regis Blanchot.
* Unicode support.
* Download the proper Pinguino Compiler based on system architecture (32/64).
* Allows user to select the compilers to be installed (PIC8 and/or PIC32).
* The installer get the latest Pinguino packages from SourceForge.
v1.2.0.0
* Unzip routine speed-up improvement.
* Italian language translation update, thanks to Pasquale Fersini.
* Portugese Brazil language translation update, thanks to Wagner de Queiroz.
v1.1.0.0
* Build with Nullsoft Scriptable Install System v2.46
v1.0.0.0
* Test version

### Help & Resources

* Pinguino Site: http://www.pinguino.cc
* Pinguino IDE repo: https://github.com/PinguinoIDE
* Pinguino IDE installers: https://github.com/PinguinoIDE/pinguino-installers

Questions about this installer ? No problem! Drop us an email.

[mefhigoseth at gmail dot com]
[rblanchot at gmail dot com]
