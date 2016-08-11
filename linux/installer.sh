#!/bin/bash

# ----------------------------------------------------------------------
# description:      Pinguino IDE Install Script
# author:           regis blanchot <rblanchot@gmail.com>
# first release:    25-04-2014
# ----------------------------------------------------------------------
# CHANGELOG
# ----------------------------------------------------------------------
# 11-08-2016 : added pinguino.linux.conf updating
# 11-08-2016 : added latest XC8 version downloading
# 11-08-2016 : fixed XC8 installation by removing "/dev/null" direction 
# 11-08-2016 : added post-install procedure for the testing version
# 03-04-2016 : changed dpkg for gdebi
# 09-05-2016 : added "--mode text" option to XC8 installer
# 11-05-2016 : added update option to run git
# 31-03-2016 : removed wget "--show-progress" option (not supported on all Linux distro)
# ----------------------------------------------------------------------
# TODO
# ----------------------------------------------------------------------
# replace package installation with git clone ?
# replace package update with git pull ?
# update or install all necessary python modules ? 
# ----------------------------------------------------------------------

VERSION=11-08-2016

DOWNLOAD=1
INSTALL=1
INTERFACE=
RELEASE=1

STABLE=11
TESTING=12
DPKG=gdebi

#XC8INST=xc8-v1.36-full-install-linux-installer.run
XC8INST=mplabxc8linux

# Pinguino location
XC8DIR=www.microchip.com
# Pinguino location
PDIR=/opt/pinguino
# Pinguino Sourceforge location
DLDIR=https://sourceforge.net/projects/pinguinoide/files/linux

# Compilers code
NONE=0
SDCC=1
XC8=2
GCC=4

# ANSI Escape Sequences
RED='\e[31;1m'
BLINK='\e[5;1m'
GREEN='\e[32;1m'
YELLOW='\e[33;1m'
TERM='\e[0m'
CLS='\e[2J'

WARNING=${YELLOW}
ERROR=${RED}
NORMAL=${GREEN}
END=${TERM}

# Log a message out to the console
function log {
    echo -e $1"$*"$TERM
}

# Carriage return
function println {
    echo -e "\r\n"
}

# Progress-bar, author: Dotan Barak
BAR_WIDTH=50
BAR_CHAR_START="["
BAR_CHAR_END="]"
BAR_CHAR_EMPTY="."
BAR_CHAR_FULL="="
BRACKET_CHARS=2
MAX_PERCENT=100
LIMIT=100

function progress_bar()
{
    # Calculate how many characters will be full.
    let "full_limit = ((($1 - $BRACKET_CHARS) * $2) / $LIMIT)"

    # Calculate how many characters will be empty.
    let "empty_limit = ($1 - $BRACKET_CHARS) - ${full_limit}"

    # Prepare the bar.
    bar_line="${BAR_CHAR_START}"
    for ((j=0; j<full_limit; j++)); do
        bar_line="${bar_line}${BAR_CHAR_FULL}"
    done

    for ((j=0; j<empty_limit; j++)); do
        bar_line="${bar_line}${BAR_CHAR_EMPTY}"
    done

    bar_line="${bar_line}${BAR_CHAR_END}"

    printf " %3d%% %s" $2 ${bar_line}
}

# Download a package if newer
function fetch {
    log $NORMAL "* $1 package"
    if [ "$1" == "${XC8INST}" ]; then
        wget ${XC8DIR}/$1 --quiet --timestamping --progress=bar:force
    else
        wget ${DLDIR}/$1 --quiet --timestamping --progress=bar:force
    fi
}

# Install a package if newer
function install {
    log $NORMAL "* $1 package"
    filename=$1
    extension="${filename##*.}"
    if [ "${extension}" == "deb" ]; then
        sudo gdebi --non-interactive --quiet $1 > /dev/null
        #sudo dpkg --install --force-overwrite $1 > /dev/null
        #sudo apt-get install -f > /dev/null
    else
        sudo chmod +x ${XC8INST}
        NEWXC8VER=v1.$(sudo ./${XC8INST} --version  | grep -Po '(?<=v1.)\d\d')
        #log $ERROR ${XC8VER}
        if [ ! -d "/opt/microchip/xc8/$NEWXC8VER" ]; then
            sudo ./${XC8INST} --mode text
        fi
    fi
    #let "i=$i + $STEP"
    #progress_bar ${BAR_WIDTH} ${i}
    #echo -en "\r"
}

# TITLE
########################################################################

log $CLS
log $NORMAL ------------------------------------------------------------
log $NORMAL Pinguino IDE Installation Script
log $NORMAL Regis Blanchot - rblanchot@pinguino.cc
log $NORMAL Last update ${VERSION}
log $NORMAL ------------------------------------------------------------

# DO WE RUN AS ADMIN ?
########################################################################

user=`env | grep '^USER=' | sed 's/^USER=//'`
if [ "$user" == "root" -a "$UID" == "0" ]; then
    log $ERROR "Don't run the installer as Root or Super User."
    log $ERROR "Admin's password will be asked later."
    log $ERROR "Usage : ./installer.sh"
    println
    exit 1
fi

# DO WE HAVE WGET ?
########################################################################

if [ ! -e "/usr/bin/wget" ]; then
    log $WARNING "Wget not found, installing it ..."
    sudo apt-get install wget
fi

# DO WE HAVE GDEBI ?
########################################################################

if [ ! -e "/usr/bin/gdebi" ]; then
    log $WARNING "Gdebi not found, installing it ..."
    sudo apt-get install gdebi
fi

# DO WE HAVE GIT ?
########################################################################

if [ ! -e "/usr/bin/git" ]; then
    log $WARNING "Git not found, installing it ..."
    sudo apt-get install git
fi

# ARCHITECTURE
########################################################################

if [ `uname -m` == "armv6l" ]; then
    ARCH=RPi
    log $NORMAL "Host is a Raspberry Pi."
elif [ `uname -m` == "armv7l" ]; then
    ARCH=RPi
    log $NORMAL "Host is a Raspberry Pi 2."
elif [ `uname -m` == "x86_64" ]; then
    ARCH=64
    log $NORMAL "Host is a ${ARCH}-bit GNU/Linux."
else
    ARCH=32
    log $NORMAL "Host is a ${ARCH}-bit GNU/Linux."
fi

# RELEASE
########################################################################

if [ ${RELEASE} ]; then

    log $NORMAL "Which release of Pinguino do you want to update/install ?"
    log $WARNING "1) Stable  (default)"
    log $WARNING "2) Testing"

    echo -e -n "\e[31;1m >\e[05m"
    read what
    echo -e -n "\e[00m"

    case $what in
        2) REL=testing ;;
        *) REL=stable  ;;
    esac

else

    REL=stable

fi

mkdir -p ${REL}
cd ${REL}

# DOWNLOAD
########################################################################

if [ ${DOWNLOAD} ]; then

    if [ $ARCH == RPi ]; then

        log $NORMAL "Host memory is too limited for 32-bit compiler."
        log $NORMAL "Do you want to install the 8-bit compiler ?"
        log $WARNING "1) no (default)"
        log $WARNING "2) yes"

    else

        if [ "${REL}" == "stable" ]; then

            log $NORMAL "Which compiler(s) do you want to install ?"
            log $WARNING "1) none of them (default)"
            log $WARNING "2) SDCC (PIC18F) only"
            log $WARNING "3) GCC (PIC32MX) only"
            log $WARNING "4) both (SDCC and GCC)"

        else

            log $NORMAL "Which compiler(s) do you want to install ?"
            log $WARNING "1) none of them (default)"
            log $WARNING "2) SDCC (PIC18F) only"
            log $WARNING "3) XC8 (PIC16F and PIC18F) only"
            log $WARNING "4) GCC (PIC32MX) only"
            log $WARNING "5) SDCC and XC8 (PIC16F and PIC18F) only"
            log $WARNING "6) all (SDCC, XC8 and GCC)"

        fi

    fi

    echo -e -n "\e[31;1m >\e[05m"
    read what
    echo -e -n "\e[00m"

    if [ "${REL}" == "stable" ]; then

        case $what in
            2)  COMP=$SDCC
                STEP=33 ;;
            3)  COMP=$GCC
                STEP=33 ;;
            4)  COMP=$((SDCC|GCC))
                STEP=25 ;;
            *)  COMP=$NONE
                STEP=50 ;;
        esac

    else

        case $what in
            2)  COMP=$SDCC
                STEP=33 ;;
            3)  COMP=$XC8
                STEP=33 ;;
            4)  COMP=$GCC
                STEP=33 ;;
            5)  COMP=$((SDCC|XC8))
                STEP=25 ;;
            6)  COMP=$((SDCC|XC8|GCC))
                STEP=20 ;;
            *)  COMP=$NONE
                STEP=50 ;;
        esac

    fi

fi

########################################################################

if [ ${INTERFACE} ]; then

    log $NORMAL "Which graphic interface do you want to install ?"
    log $WARNING "1) Tkinter-based IDE (simple and light)"
    log $WARNING "2) Qt4-based IDE (default)"
    read what

    case $what in
        1) TK=YES ;;
        *) TK=NO  ;;
    esac

else

    TK=NO

fi

########################################################################

if [ ${DOWNLOAD} ]; then

    log $WARNING "Downloading packages ..."

    i=0

    # Pinguino files
    
    if [ $TK == YES ]; then
        fetch ${REL}/pinguino-ide-tk.deb
    else
        fetch ${REL}/pinguino-ide.deb
    fi
    
    fetch ${REL}/pinguino-libraries.deb

    # Compilers

    cd ..
    case 1 in
        $(( (COMP & SDCC) >0 )) ) fetch pinguino-linux${ARCH}-sdcc-mpic16.deb;;&
        $(( (COMP &  XC8) >0 )) ) fetch ${XC8INST};;&
        $(( (COMP &  GCC) >0 )) ) fetch pinguino-linux${ARCH}-gcc-mips-elf.deb;;&
    esac
    cd ${REL}

fi

# INSTALL
########################################################################

if [ ${INSTALL} ]; then

    log $WARNING "Installing packages ..."

    i=0

    # Pinguino files
    
    if [ $TK == YES ]; then
        install pinguino-ide-tk.deb
    else
        install pinguino-ide.deb
    fi

    install pinguino-libraries.deb

    # Compilers

    cd ..
    case 1 in
        $(( (COMP & SDCC) >0 )) ) install pinguino-linux${ARCH}-sdcc-mpic16.deb;;&
        $(( (COMP &  XC8) >0 )) ) install ${XC8INST};;&
        $(( (COMP &  GCC) >0 )) ) install pinguino-linux${ARCH}-gcc-mips-elf.deb;;&
    esac
    cd ${REL}

fi

# POSTINSTALL
########################################################################

if [ "${REL}" == "stable" ]; then
    python /opt/pinguino/v${STABLE}/post_install.py > /dev/null 2>&1
#else
    #python /opt/pinguino/v${TESTING}/pinguino/pinguino_reset.py
    #python /opt/pinguino/v${TESTING}/cmd/pinguino-reset.py
fi

# UPDATE LINUX CONFIG FILE
########################################################################

if [ ${NEWXC8VER} ]; then

    PCONF=/opt/pinguino/v${TESTING}/pinguino/qtgui/config/pinguino.linux.conf
    CURXC8VER=v1.$(cat $PCONF | grep -Po '(?<=v1.)\d\d')
    if [ "${NEWXC8VER}" != "${CURXC8VER}" ]; then
        log $WARNING Updating XC8 ${CURXC8VER} to ${NEWXC8VER}
        sed -i -e "s/${CURXC8VER}/${NEWXC8VER}/g" ${PCONF}
        #cat ${PCONF}
    fi
fi

# LAUNCH
########################################################################

log $NORMAL "Do you want to launch the IDE ?"
log $WARNING "1) Yes (default)"
log $WARNING "2) No"

echo -e -n "\e[31;1m >\e[05m"
read what
echo -e -n "\e[00m"

case $what in
    2)  log $NORMAL "Installation complete." ;;

    *)  if [ "${REL}" == "stable" ]; then
            python /opt/pinguino/v${STABLE}/pinguino.py
        else
            python /opt/pinguino/v${TESTING}/pinguino-ide.py
        fi
        ;;
esac
