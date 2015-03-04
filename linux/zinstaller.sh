#!/bin/bash

# ----------------------------------------------------------------------
# description:		Pinguino IDE Installation Script
# author:			regis blanchot <rblanchot@gmail.com>
# first release:	25-04-2014
# last release:		04-03-2015
# ----------------------------------------------------------------------

DOWNLOAD=1
INSTALL=1
INTERFACE=

DLDIR=https://sourceforge.net/projects/pinguinoide/files/linux/

# Download a package from Pinguino's SourceForge account
function fetch {
    wget --quiet --timestamping ${DLDIR}/$1.deb | \
    zenity  --progress \
            --title="Pinguino IDE Installer" \
            --text="Checking and downloading $1 package" \
            --height=250 --width=400 \
            --auto-close
}

# Install DEB package
function install {
    sudo dpkg --install --force-overwrite $1.deb | \
    zenity  --progress \
            --title="Pinguino IDE Installer" \
            --text="Installing $1 package" \
            --height=250 --width=400 \
            --auto-close
    sudo apt-get install -f > /dev/null
}

#0 - ARCHITECTURE

if [ `uname -m` == "armv6l" ]; then
    ARCH=RPi
    ARCHTXT="Raspberry Pi"
elif [ `uname -m` == "x86_64" ]; then
    ARCH=64
    ARCHTXT="${ARCH}-bit GNU/Linux."
else
    ARCH=32
    ARCHTXT="${ARCH}-bit GNU/Linux."
fi

#1 - TITLE

zenity  --question \
        --height=250 --width=400 \
        --title="Pinguino IDE Installer" \
        --text "\
<span color=\"red\"><b><big>Pinguino IDE Installer</big></b></span>
<span>Author:\tRégis Blanchot</span>
<span>Contact:\trblanchot@pinguino.cc</span>
<span>Version:\t04-03-2015</span>
<span>Host:\t<b>${ARCHTXT}</b></span>

<span>Do you want to proceed ?</span>"

if [ $? == 1 ]; then
    exit 0
fi

#2 - DOWNLOAD COMPILERS

if [ $ARCH == RPi ]; then

    zenity  --question \
            --height=250 --width=400 \
            --title="Pinguino IDE Installer" \
            --text="Do you want to install the 8-bit compiler ?"

    case $? in
        0) C8=NO  C32=NO  ;;
        1) C8=YES C32=NO  ;;
    esac

else

    zenity  --list \
            --title="Pinguino IDE Installer" \
            --height=250 --width=400 \
            --radiolist \
            --text "What compiler(s) do you want to install ?" \
            --column "Select..." --column 'Compiler(s)' \
    TRUE "none of them" \
    FALSE "the  8-bit (PIC18F)  compiler only" \
    FALSE "the 32-bit (PIC32MX) compiler only" \
    FALSE "both 8- and 32-bit compilers"

echo $?

    case $? in
        0) C8=NO  C32=NO  ;;
        1) C8=YES C32=NO  ;;
        2) C8=NO  C32=YES ;;
        3) C8=YES C32=YES ;;
    esac

fi

#2 - DOWNLOAD INTERFACE

if [ ${INTERFACE} ]; then

    zenity  --list \
            --title="Pinguino IDE Installer" \
            --height=250 --width=400 \
            --radiolist \
            --text "Which graphic interface do you want to install ?" \
            --column "Select..." --column 'Interface' \
    TRUE "Tkinter-based IDE (simple and light)" \
    FALSE "Qt4-based IDE (default)"

    case $? in
        1) TK=YES ;;
        *) TK=NO  ;;
    esac

else

    TK=NO

fi

if [ ${DOWNLOAD} ]; then
    
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

fi

#3 - INSTALL

if [ ${INSTALL} ]; then

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

#4 - POSTINSTALL

python /usr/share/pinguino-11/post_install.py

fi


#5 - END

wget --quiet --timestamping ${DLDIR}/changelog 

if zenity  --question \
        --height=250 --width=400 \
        --title="Pinguino IDE Installer" \
        --filename="changelog" \
        --text="Installation complete.\n\rDo you want to launch the IDE ?"
then
    python /usr/share/pinguino-11/pinguino.py
fi

