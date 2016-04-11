#!/bin/bash

# ----------------------------------------------------------------------
# description:      Pinguino IDE Install Script
# author:           regis blanchot <rblanchot@gmail.com>
#                   ??
# first release:    25-04-2014
# ----------------------------------------------------------------------
# CHANGELOG
# ----------------------------------------------------------------------
# TODO
# ----------------------------------------------------------------------

UPDATE=11-04-2016

echo "Which release of Pinguino do you want to install ?"
echo "1) Stable  (default)"
echo "2) Testing"
read what
case $what in
    2) RELEASE=testing
       BRANCH=v12-dev
       MAJOR=12 ;;
    *) RELEASE=stable
       BRANCH=master
       MAJOR=11 ;;
esac

USERDIR=~/Pinguino/v${MAJOR}

# Check if xcode is installed
if [`xcode-select -p`="/Applications/Xcode.app/Contents/Developer"]; then
    echo "Xcode Installed..."
else
    echo "ERROR: No Xcode Instalation found.
Please install Xcode and continue with this script"
    exit -1
fi

# Check for git
if [`git --version`="-bash: git: command not found"]; then
    echo "Installing developer tools..."
    xcode-select --install
else
    echo "Git installed..."
fi

# Check if homebrew is installed
if [`brew --version`="-bash: brew: command not found"]; then
    echo "Installing homebrew tools..."
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
    echo "Homebrew installed: updating"
    brew update
fi

# Check for brew doctor messages
if [`brew doctor`="Your system is ready to brew."]; then
    echo "Homebrew is up and ready... "
else
    echo "Homebrew seems to be sick run brew doctor and fix your problems, then come back."
    exit 2
fi

# Install python, python QT libraries and compiler
brew install python
brew install pyside sdcc

# Install python packages
pip install gitpython hgapi beautifulsoup4 pyusb setuptools pinguino

# Create pinguino directory in home folder
[ ! -d ${USERDIR} ] && mkdir -pv ${USERDIR}
[ ! -d /opt/pinguino/v${MAJOR} ] && sudo mkdir -pv /opt/pinguino/v${MAJOR}

# Go to Pinguino folder
cd ${USERDIR}

# Get the basic pinguino IDE
#git checkout ${BRANCH}
#git clone https://github.com/PinguinoIDE/pinguino-ide.git ${USERDIR}

# Get the libraries
wget --no-check-certificate https://github.com/PinguinoIDE/pinguino-libraries/archive/master.zip
unzip master.zip -d ${USERDIR}
rm master.zip

# Copy the libraries to pinguino main folder
cp -a ${USERDIR}/pinguino-libraries-master/p* ${USERDIR}

# Link the binaries to /usr folder
sudo cp -aR p8 /opt/pinguino/v${MAJOR}/
sudo ln -sfv /usr/local/bin/sdcc /usr/bin/sdcc
# Check if alias exits in ~/.bash_profile
if grep -q "alias pinguino" ~/.bash_profile|wc -l
then
    echo "Instalation successful, you can run pinguino-IDE with command 'pinguino'."
else
    echo "alias pinguino='python ${USERDIR}/pinguino.py'" >> ~/.bash_profile
    source ~/.bash_profile
    echo "Instalation successful, you can run pinguino-IDE with command 'pinguino'."
fi
