#!/bin/bash
# Check if xcode is installed
if [ `xcode-select -p` = "/Applications/Xcode.app/Contents/Developer" ] ; then
    echo "Xcode Installed..."
else
    echo "ERROR: No Xcode Instalation found.
Please install Xcode and continue with this script"
    exit -1
fi

if [ `git --version` = "-bash: git: command not found" ] ; then
    echo "Installing developer tools..."
    xcode-select --install
else
    echo "Git installed..."
fi

# Check if homebrew is installed
if [ `brew --version` = "-bash: brew: command not found" ] ; then
    echo "Installing homebrew tools..."
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
    echo "Homebrew installed: updating"
    brew update
fi

# Check for brew doctor messages
if [ `brew doctor` = "Your system is ready to brew." ] ; then
    echo "Homebrew is up and ready... "
else
    echo "Homebrew seems to be sick run brew doctor and fix your problems, then come back."
    exit 2
fi

brew install python
brew install pyside sdcc

pip install gitpython hgapi beautifulsoup4 pyusb

[ ! -d ~/.pinguino ] && mkdir -pv ~/.pinguino
[ ! -d /usr/share/pinguino-11 ] && sudo mkdir -pv /usr/share/pinguino-11

git clone https://github.com/PinguinoIDE/pinguino-ide.git ~/.pinguino
git clone https://github.com/PinguinoIDE/pinguino-libraries.git ~/.pinguino

cd ~/.pinguino

sudo ln -sfv /p8 /usr/share/pinguino-11/
sudo ln -sfv ~/.pinguino/p8/bin/sdcc /usr/bin/sdcc
sudo ln -sfv ~/.pinguino/pinguino.py /usr/local/bin/pinguino
