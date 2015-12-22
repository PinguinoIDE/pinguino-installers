#!/bin/bash

# ----------------------------------------------------------------------
# description:		Pinguino IDE Install Script
# author:			regis blanchot <rblanchot@gmail.com>
# first release:	25-04-2014
# last release:		21-01-2014
# ----------------------------------------------------------------------
# TODO
# ----------------------------------------------------------------------
# zenity GUI
# ----------------------------------------------------------------------

DOWNLOAD=1
INSTALL=1
INTERFACE=

DLDIR=https://sourceforge.net/projects/pinguinoide/files/linux/
#DLDIR=http://optimate.dl.sourceforge.net/project/pinguinoide/linux
#DLDIR=http://master.dl.sourceforge.net/project/pinguinoide/linux
#DLDIR=http://skylink.dl.sourceforge.net/project/pinguinoide/linux
#DLDIR=http://softlayer-ams.dl.sourceforge.net/project/pinguinoide/linux

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
    wget --quiet --timestamping ${DLDIR}/$1.deb
    let "RFETCH=$RFETCH + $?"
    let "i=$i + $STEP"
    progress_bar ${BAR_WIDTH} ${i}
    echo -en "\r"
}

function install {
    #log $NORMAL "Installing $1 package"
    #sudo dpkg -r $1.deb
    #sudo dpkg -P $1.deb
    sudo dpkg --install --force-overwrite $1.deb > /dev/null
    sudo apt-get install -f > /dev/null
    let "i=$i + $STEP"
    progress_bar ${BAR_WIDTH} ${i}
    echo -en "\r"
}

#0 - TITLE

log $CLS
log $NORMAL ---------------------------------------------------------------
log $NORMAL Pinguino IDE Installation Script
log $NORMAL Regis Blanchot - rblanchot@pinguino.cc
log $NORMAL Last update 16-12-2014
log $NORMAL ---------------------------------------------------------------

#1 - ARCHITECTURE

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

#2 - DOWNLOAD

if [ $ARCH == RPi ]; then
    log $NORMAL "Host memory is too limited for 32-bit compiler."
    log $NORMAL "Do you want to install the 8-bit compiler ?"
    log $WARNING "1) no (default)"
    log $WARNING "2) yes"
else
    log $NORMAL "What compiler(s) do you want to install ?"
    log $WARNING "1) none of them (default)"
    log $WARNING "2) the  8-bit (PIC18F)  compiler only"
    log $WARNING "3) the 32-bit (PIC32MX) compiler only"
    log $WARNING "4) both 8- and 32-bit compilers"
fi

echo -e -n "\e[31;1m >\e[05m"
read what
echo -e -n "\e[00m"

case $what in
    2)
        C8=YES
        C32=NO
        STEP=33
        ;;
    3)
        C8=NO
        C32=YES
        STEP=33
        ;;
    4)
        C8=YES
        C32=YES
        STEP=25
        ;;
    *)
        C8=NO
        C32=NO
        STEP=50
        ;;
esac

if [ ${INTERFACE} ]; then

    log $NORMAL "Which graphic interface do you want to install ?"
    log $WARNING "1) Tkinter-based IDE (simple and light)"
    log $WARNING "2) Qt4-based IDE (default)"
    read what

    case $what in
        1)
            TK=YES
            ;;
        *)
            TK=NO
            ;;
    esac

else

    TK=NO

fi

if [ ${DOWNLOAD} ]; then

    log $NORMAL "Downloading packages ..."

    i=0
    RFETCH=0
    
    if [ $TK == YES ]; then
        fetch pinguino-ide-tk
    else
        fetch pinguino-ide
    fi
    
    fetch pinguino-libraries

    if [ $C8 == YES ]; then
        fetch pinguino-linux${ARCH}-sdcc-mpic16
    fi

    if [ $C32 == YES ]; then
        fetch pinguino-linux${ARCH}-gcc-mips-elf
    fi

    if [ ! $RFETCH == 0 ]; then
        log $ERROR "Error"
    fi

    echo -e "\r\n"

fi

#3 - INSTALL

if [ ${INSTALL} ]; then

    log $NORMAL "Installing packages ..."

    i=0
    RINST=0

    if [ $C8 == YES ]; then
        install pinguino-linux${ARCH}-sdcc-mpic16
    fi

    if [ $C32 == YES ]; then
        install pinguino-linux${ARCH}-gcc-mips-elf
    fi

    install pinguino-libraries

    if [ $TK == YES ]; then
        install pinguino-ide-tk
    else
        install pinguino-ide
    fi

    if [ ! $RINST == 0 ]; then
        log $ERROR "Error"
    fi

    echo -e "\r\n"

fi

#4 - POSTINSTALL

python /usr/share/pinguino-11/post_install.py

#5 - END

log $NORMAL "Installation complete."
