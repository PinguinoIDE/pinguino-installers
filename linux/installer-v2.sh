#!/usr/bin/env sh
#
# Pinguino IDE v13 install script for GNU/Linux
# Author: Victor Villarreal <mefhigoseth@gmail.com>
# Version: v20.10 [2020-10-04]
#
# NOTES:
#   - Don't exec this script as root.
#   - Don't use 'sudo'.
#   - Require 'curl' or 'wget' commands.
#   - Require 'python3', 'pip'  and 'pipenv' package.
#
# Thanks to the acme.sh project for their Bash Fu.
#
#----------------------------------------------------
#====================================================

ENABLE_DEBUG=0
PINGUINO_VERSION=13
CONFIG_FILE=pinguino.linux.conf
PINGUINO_SH=pinguino.sh
PINGUINO_DIR=${HOME}/.pinguino/v13
USER_DIR=${HOME}/Pinguino/v13
#IDE_URL="https://github.com/PinguinoIDE/pinguino-ide/archive/master.zip"
IDE_URL="https://github.com/MefhigosetH/pinguino-ide/archive/fix/linux-support.zip"
IDE_DIR="pinguino-ide-fix-linux-support"
LIB_URL="https://github.com/PinguinoIDE/pinguino-libraries/archive/master.zip"
LIB_DIR="pinguino-libraries-master"
CMP_DIR="pinguino-compilers"
P8_URL="https://github.com/PinguinoIDE/pinguino-compilers/releases/download/v20.10/pinguino-linux64-p8.zip"
P8_DIR="p8"
P32_URL="https://github.com/PinguinoIDE/pinguino-compilers/releases/download/v20.10/pinguino-linux64-p32.zip"
P32_DIR="p32"

#============ BEGIN FUNCTIONS ==================

__INTERACTIVE=""
if [ -t 1 ]; then
  __INTERACTIVE="1"
fi

__green() {
  if [ "${__INTERACTIVE}${NO_COLOR:-0}" = "10" -o "${FORCE_COLOR}" = "1" ]; then
    printf '\33[1;32m%b\33[0m' "$1"
    return
  fi
  printf -- "%b" "$1"
}

__red() {
  if [ "${__INTERACTIVE}${NO_COLOR:-0}" = "10" -o "${FORCE_COLOR}" = "1" ]; then
    printf '\33[1;31m%b\33[0m' "$1"
    return
  fi
  printf -- "%b" "$1"
}

_printargs() {
  _exitstatus="$?"
  if [ -z "$NO_TIMESTAMP" ] || [ "$NO_TIMESTAMP" = "0" ]; then
    printf -- "%s" "[$(date)] "
  fi
  if [ -z "$2" ]; then
    printf -- "%s" "$1"
  else
    printf -- "%s" "$1='$2'"
  fi
  printf "\n"
  # return the saved exit status
  return "$_exitstatus"
}

_log() {
  [ -z "$LOG_FILE" ] && return
  _printargs "$@" >>"$LOG_FILE"
}

_info() {
  _log "$@"
  _printargs "$@"
}

_debug() {
  _log "$@"
  [ -z $ENABLE_DEBUG ] && _printargs "$@"
}

_err() {
  _log "$@"
  if [ -z "$NO_TIMESTAMP" ] || [ "$NO_TIMESTAMP" = "0" ]; then
    printf -- "%s" "[$(date)] " >&2
  fi
  __red "$1" >&2
  printf "\n" >&2
  return 1
}

_verbose() {
  _log "$@"
  if [ -z "$NO_TIMESTAMP" ] || [ "$NO_TIMESTAMP" = "0" ]; then
    printf -- "%s" "[$(date)] " >&2
  fi
  __green "$1" >&2
  printf "\n" >&2
  return 1
}

_exists() {
  cmd="$1"
  if [ -z "$cmd" ]; then
    _usage "Usage: _exists cmd"
    return 1
  fi

  if eval type type >/dev/null 2>&1; then
    eval type "$cmd" >/dev/null 2>&1
  elif command >/dev/null 2>&1; then
    command -v "$cmd" >/dev/null 2>&1
  else
    which "$cmd" >/dev/null 2>&1
  fi
  ret="$?"
  _debug "$cmd exists=$ret"
  return $ret
}

# Check dependencies
_checkEnv() {
  output=$(uname -m)
  ret="$?"
  _info "Arch: $output"
  if [ "$ret" != "0" ] && [ "$output" != "x86_64" ]; then
    _err "Sory. This installer works with 64-bits GNU/Linux only."
    exit 1
  fi

  if [ -z "$_USE_CURL" ] && _exists "curl"; then
    _USE_CURL="curl --silent "
  elif [ -z "$_USE_WGET" ] && _exists "wget"; then
    _USE_WGET="wget -q "
  else
    _err "curl or wget not found."
    _please_install
    exit 1
  fi

  if [ -z "$_USE_UNZIP" ] && _exists "unzip"; then
    _USE_UNZIP="unzip "
  else
    _err "unzip not found."
    _please_install
    exit 1
  fi

  if [ -z "$_USE_PYTHON3" ] && _exists "python3"; then
    _USE_PYTHON3="python3"
  else
    _err "Python3 not found."
    _please_install
    exit 1
  fi

  output=$($_USE_PYTHON3 --version)
  ret="$?"
  if [ "$ret" != "0" ]; then
    _err "Python3 not found."
    _please_install
    exit 1
  fi
  _info "$output"

  output=$($_USE_PYTHON3 -m pipenv --version)
  ret="$?"
  if [ "$ret" != "0" ]; then
    _err "Python3 Pipenv package not found. Installing"
    output=$($_USE_PYTHON3 -m pip install pipenv)

    ret="$?"
    if [ "$ret" != "0" ]; then
      _err "We can't install Python3 Pipenv module."
      _please_install
      exit 1
    fi
  else
    _info "$output"
  fi
}

_please_install(){
  _err "**********************************************************"
  _err "One or more dependencies are missing."
  _err "- -"
  _err "In Debian/Ubuntu based distros, type the following:"
  _err "sudo apt install -y curl wget unzip python3 python3-pip"
  _err "sudo pip3 install pipenv"
  _err "- -"
  _err "In RedHat/Centos/Fedora based distros, type the followign:"
  _err "sudo yum install -y curl wget unzip python3"
  _err "sudo pip3 install pipenv"
  _err "- -"
  _err "Then, execute again this installer."
  _err "**********************************************************"
}

_endswith() {
  _str="$1"
  _sub="$2"
  echo "$_str" | grep -- "$_sub\$" >/dev/null 2>&1
}

_checkSudo() {
  if [ "$SUDO_COMMAND" ]; then
    _err "sudo detected."
    return 0
  fi
  _info "No sudo detected."
  return 1
}

# url getheader timeout
_get() {
  _debug GET
  url="$1"
  f="$2"
  t="$3"
  _debug url "$url"
  _debug "timeout=$t"
  _debug "f=$f"

  if [ "$_USE_CURL" ]; then
    _CURL="$_USE_CURL -L"
    if [ "$t" ]; then
      _CURL="$_CURL --connect-timeout $t"
    fi
    if [ "$f" ]; then
      $_CURL "$url" > $f
    else
      $_CURL "$url" -O
    fi
    ret=$?
    if [ "$ret" != "0" ]; then
      _err "Please refer to https://curl.haxx.se/libcurl/c/libcurl-errors.html for error code: $ret"
    fi
  elif [ "$_USE_WGET" ]; then
    _WGET="$_USE_WGET"
    if [ "$t" ]; then
      _WGET="$_WGET --timeout=$t"
    fi
    _debug "_WGET" "$_WGET"
    $_WGET -O - "$url"
    ret=$?
    if [ "$ret" = "8" ]; then
      ret=0
      _debug "wget returns 8, the server returns a 'Bad request' response, lets process the response later."
    fi
    if [ "$ret" != "0" ]; then
      _err "Please refer to https://www.gnu.org/software/wget/manual/html_node/Exit-Status.html for error code: $ret"
    fi
  else
    ret=$?
    _err "Neither curl nor wget is found, can not do GET."
    exit 1
  fi
  _debug "ret" "$ret"
  return $ret
}

_unzip() {
  if [ -z "$_USE_UNZIP" ]; then
    _err "unzip command not found."
    exit 1
  fi
  f="$1"
  $_USE_UNZIP -qq "$f"
  ret=$?
  if [ "$ret" != "0" ]; then
    ret=0
    _err "unzip returns error $ret"
  fi
  return $ret
}

_prepareInstallDir() {
  _info "mkdir $PINGUINO_DIR"
  mkdir -p $PINGUINO_DIR/${CMP_DIR}
  if [ "$?" != "0" ]; then
    _err "Error al crear $PINGUINO_DIR"
    exit 1
  fi
}

_installIde() {
  cd $PINGUINO_DIR

  _info "get Pinguino IDE"
  _get "$IDE_URL"
  if [ "$?" != "0" ]; then
    exit 1
  fi
  _info "OK"

  _info "unzip Pinguino IDE"
  _unzip "linux-support.zip"
  if [ "$?" != "0" ]; then
    exit 1
  fi
  _info "OK"

  cd ${IDE_DIR}
  cat /dev/null > ${PINGUINO_SH}
  echo "#!/bin/sh" >> ${PINGUINO_SH}
  echo "#" >> ${PINGUINO_SH}
  echo "# Launch Pinguino's IDE" >> ${PINGUINO_SH}
  echo "cd $PINGUINO_DIR/$IDE_DIR" >> ${PINGUINO_SH}
  echo "python3 -m pipenv run python pinguino-ide.py" >> ${PINGUINO_SH}
  chmod +x ${PINGUINO_SH}

  $_USE_PYTHON3 -m pipenv --rm
  [ "$?" != "0" ] && _err "Error on 'pipenv --rm'" && exit 1
  $_USE_PYTHON3 -m pipenv install
  [ "$?" != "0" ] && _err "Error on 'pipenv install'" && exit 1
}

_installLibs() {
  cd $PINGUINO_DIR

  _info "get Pinguino Libraries"
  _get "$LIB_URL"
  if [ "$?" != "0" ]; then
    exit 1
  fi
  _info "OK"

  _info "unzip Pinguino Libraries"
  _unzip "master.zip"
  if [ "$?" != "0" ]; then
    exit 1
  fi
  _info "OK"
}

_installP8(){
  cd "$PINGUINO_DIR/${CMP_DIR}"

  _info "get Pinguino P8 Compiler"
  _get "$P8_URL"
  if [ "$?" != "0" ]; then
    exit 1
  fi
  _info "OK"

  _info "unzip Pinguino P8 Compiler"
  _unzip "pinguino-linux64-p8.zip"
  if [ "$?" != "0" ]; then
    exit 1
  fi
  _info "OK"
}

_installP32() {
  cd "$PINGUINO_DIR/${CMP_DIR}"

  _info "get Pinguino P32 Compiler"
  _get "$P32_URL"
  if [ "$?" != "0" ]; then
    exit 1
  fi
  _info "OK"

  _info "unzip Pinguino P32 Compiler"
  _unzip "pinguino-linux64-p32.zip"
  if [ "$?" != "0" ]; then
    exit 1
  fi
  _info "OK"
}

_prepareUserDir() {
  _info "mkdir $USER_DIR"
  mkdir -p $USER_DIR
  if [ "$?" != "0" ]; then
    _err "Error al crear $USER_DIR"
  fi

  # Empty and then write the config. file if necessary
  if [ ! -f ${USER_DIR}/pinguino.conf ]; then
    _info "Write the config. file ..."
    cd ${PINGUINO_DIR}/${IDE_DIR}/pinguino/qtgui/config
    cat /dev/null > ${CONFIG_FILE}
    echo [Paths] >> ${CONFIG_FILE}
    echo sdcc_bin = ${PINGUINO_DIR}/${CMP_DIR}/p8/bin >> ${CONFIG_FILE}
    echo gcc_bin  = ${PINGUINO_DIR}/${CMP_DIR}/p32/bin >> ${CONFIG_FILE}
    echo xc8_bin  = /opt/microchip/xc8/v${XC8_VERSION}/bin >> ${CONFIG_FILE}
    echo pinguino_8_libs = ${PINGUINO_DIR}/${LIB_DIR}/p8 >> ${CONFIG_FILE}
    echo pinguino_32_libs = ${PINGUINODIR}/${LIB_DIR}/p32 >> ${CONFIG_FILE}
    echo install_path = ${PINGUINO_DIR}/${IDE_DIR} >> ${CONFIG_FILE}
    echo user_path = ${USER_DIR} >> ${CONFIG_FILE}
    echo user_libs = ${USER_DIR}/pinguinolibs >> ${CONFIG_FILE}
  fi

  if [ ! -d ${USER_DIR}/examples ]; then
    _info "Copy examples files ..."
    cp -r ${PINGUINO_DIR}/${LIB_DIR}/examples ${USER_DIR}/examples
  fi

  if [ ! -d ${USER_DIR}/source ]; then
    _info "Copy sources files ..."
    cp -r ${PINGUINO_DIR}/${LIB_DIR}/source ${USER_DIR}/source
  fi

  # Fix error related to reserved.pickle file
  cp ${PINGUINO_DIR}/${IDE_DIR}/reserved.pickle ${USER_DIR}
}

_header() {
  _verbose "*********************************"
  _verbose " Pinguino IDE v13 install script"
  _verbose "*********************************"
}

_footer() {
  _verbose "Installation OK"
  _verbose "To open PinguinoIde, type in your console:"
  _verbose "$PINGUINO_DIR/$IDE_DIR/$PINGUINO_SH"
}

#============ END FUNCTIONS ==================#
#============ BEGIN SCRIPT ==================#

_header
_checkEnv
_checkSudo

_prepareInstallDir
_installLibs
_installP8
_installP32
_installIde
_prepareUserDir

_footer

#============ END SCRIPT ==================#
