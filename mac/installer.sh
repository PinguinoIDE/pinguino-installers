#!/bin/bash
# Check if xcode is installed
if [ `xcode-select -p` = "/Applications/Xcode.app/Contents/Developer" ] ; then
    echo "Xcode Installed..."
else
    echo "ERROR: No Xcode Instalation found.
Please install Xcode and continue with this script"
    exit -1
fi

# Check for git
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

# Install python, python QT libraries and compiler
brew install python
brew install pyside sdcc

# Install python packages
pip install gitpython hgapi beautifulsoup4 pyusb

# Create pinguino directory in home folder
[ ! -d ~/.pinguino ] && mkdir -pv ~/.pinguino
[ ! -d /usr/share/pinguino-11 ] && sudo mkdir -pv /usr/share/pinguino-11

# Go to Pinguino folder
cd ~/.pinguino

# Get the basic pinguino IDE
git clone https://github.com/PinguinoIDE/pinguino-ide.git ~/.pinguino

# Get the libraries
wget --no-check-certificate https://github.com/PinguinoIDE/pinguino-libraries/archive/master.zip
unzip master.zip -d ~/.pinguino
rm master.zip

# Copy the libraries to pinguino main folder
cp -a ~/.pinguino/pinguino-libraries-master/p* ~/.pinguino

# Link the binaries to /usr folder
sudo ln -sfv /p8 /usr/share/pinguino-11/
sudo ln -sfv ~/.pinguino/p8/bin/sdcc /usr/bin/sdcc
alias pinguino='python ~/.pinguino/pinguino.py'
