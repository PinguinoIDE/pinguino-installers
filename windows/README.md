# Pinguino IDE official Windows installer

## Features

* Detects and installs all the required software for the Pinguino IDE.
  + Python v3.7
  + PySIDE
  + PyPIP
  + Wheel
  + BeautifullSoup4
  + Setuptools
  + PyUSB
  + LibUSB
  + pinguino-ide package
  + pinguino-libraries package
  + Compilers packages
* Allow semi-automatic Pinguino device drivers installation
  +  8-bit Pinguino boards : VID 04D8 / PID FEAA
  +  8-bit Pinguino boards : VID 04D8 / PID FEAB
  + 32-bit Pinguino boards : VID 04D8 / PID 003C
* Installer size: 1229 KB.
* Multi-language: English, French, Italian, Portuguese and Spanish

## Supported OS

* This installer should work fine on the following Microsoft O.S.:
  + Windows 7 (32 and 64-bits).
  + Windows 8 (32 and 64-bits).
  + Windows 10 (32 and 64-bits).
* Note: about 300Mb free space on disk required.

Tested on:

* Windows 7 Ultimate 32-bit
* Windows 7 Premium 64-bit
* Windows 8.1 32-bit
* Windows 10 64-bit

## Develop

This installer was build with NullSoft Install System v3.

### Folders in this repo

- `nsis_plugins`: You need to install these NSIS plugins in order to compile the .nsis file
- `graphics`: Here you can find all the images and incons used by the installer.
- `old`: All the previous version of the installer stay here.
 
## Help & Resources

* Pinguino Site: http://www.pinguino.cc
* Pinguino IDE repo: https://github.com/PinguinoIDE
* Pinguino IDE installers: https://github.com/PinguinoIDE/pinguino-installers

Questions about this installer ? No problem! Drop us an email.

[mefhigoseth at gmail dot com]
[rblanchot at gmail dot com]
