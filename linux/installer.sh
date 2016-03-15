#!/bin/bash

# ----------------------------------------------------------------------
# description:      Pinguino IDE Install Script
# author:           regis blanchot <rblanchot@gmail.com>
# first release:    25-04-2014
# ----------------------------------------------------------------------
# TODO
# ----------------------------------------------------------------------

UPDATE=14-03-2016

DOWNLOAD=1
INSTALL=1
INTERFACE=
RELEASE=1
STABLE=11
TESTING=12
XC8INST=xc8-v1.36-full-install-linux-installer.run

# Pinguino Sourceforge location
DLDIR=https://sourceforge.net/projects/pinguinoide/files/linux

# Compilers code
NONE=0
SDCC=1
XC8=2
GCC=3

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

# Download a package from Pinguino's SourceForge account
function fetch {
    #log $NORMAL "Downloading $1 package"
    wget ${DLDIR}/$1 --quiet --timestamping --progress=bar:force --show-progress
}

# Install a package
function install {
    #log $NORMAL "Installing $1 package"
    filename=$1
    extension="${filename##*.}"
    if [ "${extension}" == "deb" ]; then
        sudo dpkg --install --force-overwrite $1 > /dev/null
        sudo apt-get install -f > /dev/null
    else
        sudo chmod +x ${XC8INST}
        sudo ./${XC8INST} > /dev/null
    fi
    let "i=$i + $STEP"
    progress_bar ${BAR_WIDTH} ${i}
    echo -en "\r"
}

# TITLE
########################################################################

log $CLS
log $NORMAL ------------------------------------------------------------
log $NORMAL Pinguino IDE Installation Script
log $NORMAL Regis Blanchot - rblanchot@pinguino.cc
log $NORMAL Last update ${UPDATE}
log $NORMAL ------------------------------------------------------------

# DO WE RUN AS ADMIN ?
########################################################################

user=`env | grep '^USER=' | sed 's/^USER=//'`
if [ "$user" == "root" -a "$UID" == "0" ]; then
    log $ERROR "Don't run the installer as root"
    log $ERROR "Usage : ./installer.sh"
    println
    exit 1
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

    log $NORMAL "Which release of Pinguino do you want to install ?"
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

if [ $ARCH == RPi ]; then
    log $NORMAL "Host memory is too limited for 32-bit compiler."
    log $NORMAL "Do you want to install the 8-bit compiler ?"
    log $WARNING "1) no (default)"
    log $WARNING "2) yes"
else
    log $NORMAL "What compiler(s) do you want to install ?"
    log $WARNING "1) none of them (default)"
    log $WARNING "2) SDCC (PIC18F) only"
    log $WARNING "3) XC8 (PIC16F and PIC18F) only"
    log $WARNING "4) GCC (PIC32MX) only"
    log $WARNING "5) SDCC and XC8 (PIC16F and PIC18F) only"
    log $WARNING "6) all (SDCC, XC8 and GCC)"
fi

echo -e -n "\e[31;1m >\e[05m"
read what
echo -e -n "\e[00m"

case $what in
    2)  COMP=$SDCC
        STEP=33 ;;
    3)
        COMP=$XC8
        STEP=33 ;;
    4)
        COMP=$GCC
        STEP=33 ;;
    5)
        COMP=$((SDCC|XC8))
        STEP=25 ;;
    6)
        COMP=$((SDCC|XC8|GCC))
        STEP=20 ;;
    *)
        COMP=$NONE
        STEP=50 ;;
esac

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

    log $NORMAL "Downloading packages ..."

    i=0
    #RFETCH=0
    
    if [ $TK == YES ]; then
        fetch ${REL}/pinguino-ide-tk.deb
    else
        fetch ${REL}/pinguino-ide.deb
    fi
    
    fetch ${REL}/pinguino-libraries.deb

    if [ ! $COMP == 0 ]; then
    
        cd ..

        if [ $((COMP & SDCC)) ]; then
            fetch pinguino-linux${ARCH}-sdcc-mpic16.deb
        fi

        if [ $((COMP & XC8)) ]; then
            fetch ${XC8INST}
        fi

        if [ $((COMP & GCC)) ]; then
            fetch pinguino-linux${ARCH}-gcc-mips-elf.deb
        fi

        cd ${REL}

    fi
    
    #if [ ! $RFETCH == 0 ]; then
    #    log $ERROR "Error"
    #fi

    println

fi

# INSTALL
########################################################################

if [ ${INSTALL} ]; then

    log $NORMAL "Installing packages ..."

    i=0
    #RINST=0

    if [ ! $COMP == 0 ]; then

        cd ..

        if [ $((COMP & SDCC)) ]; then
            install pinguino-linux${ARCH}-sdcc-mpic16.deb
        fi

        if [ $((COMP & XC8)) ]; then
            install ${XC8INST}
        fi

        if [ $((COMP & GCC)) ]; then
            install pinguino-linux${ARCH}-gcc-mips-elf.deb
        fi

        cd ${REL}
    fi

    install pinguino-libraries.deb

    if [ $TK == YES ]; then
        install pinguino-ide-tk.deb
    else
        install pinguino-ide.deb
    fi

    #if [ ! $RINST == 0 ]; then
    #    log $ERROR "Error"
    #fi

    println

fi

# POSTINSTALL
########################################################################

echo ${REL}
if [ "${REL}" == "stable" ]; then
    python /opt/pinguino/v${STABLE}/post_install.py
fi

# LAUNCH
########################################################################

log $NORMAL "Do you want to launch the IDE ?"
log $WARNING "1) Yes (default)"
log $WARNING "2) No"
read what

case $what in
    2)  log $NORMAL "Installation complete." ;;

    *)  if [ "${REL}" == "stable" ]; then
            python /opt/pinguino/v${STABLE}/pinguino.py
        else
            python /opt/pinguino/v${TESTING}/pinguino-ide.py
        fi
        ;;
esac
