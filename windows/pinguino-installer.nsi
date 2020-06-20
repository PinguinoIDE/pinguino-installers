;=======================================================================
; Pinguino IDE NSIS Installation Script
; Public Domain License 2014-2016
; 1.1 to 1.3 : Victor Villarreal <mefhigoseth@gmail.com>
; 1.4 to 1.8 : Regis Blanchot <rblanchot@pinguino.cc>
;-----------------------------------------------------------------------
; CHANGELOG (see README.md)
;-----------------------------------------------------------------------
; TODO
; Compilers Uninstaller ?
;-----------------------------------------------------------------------
; To compile this script you'll need version 3 or above of NSIS :
; http://nsis.sf_url.net/Download
; > makensis(.exe) Pinguino_x.x.x.x.nsi
;=======================================================================

XPStyle on
; This installer is running at admin level,
; which is necessary because we want to install Pinguino for all users (so to $PROGRAMFILES)
; If we wanted to do stuff at userlevel (such as writing to one user's documents),
; the whole install should be executed at userlevel.
; This means we should install to $APPDATA or $LOCALAPPDATA instead of $PROGRAMFILES,
; and write to HKCU instead of HKLM.
RequestExecutionLevel admin             ;Request application privileges
SetDatablockOptimize on
SetCompress force
SetCompressor /SOLID lzma
ShowInstDetails show                    ;Show installation logs

;=======================================================================
;Includes
;=======================================================================

;!include "Sections.nsh"
!include "WinMessages.nsh"
!include "MUI2.nsh"
!include "FileFunc.nsh"
!include "WinVer.nsh"
!include "nsDialogs.nsh"
!include "LogicLib.nsh"
!include "x64.nsh"

;=======================================================================
;Defines
;=======================================================================

!define PINGUINO_NAME                   'Pinguino'
!define PINGUINO_VERSION                '13'

!define INSTALLER_VERSION               '1.8.0.0'
!define LIBUSBWIN32_VERSION             '1.2.6.0'
!define GIT_VERSION                     '2.20.1'

!define PYTHON_MAJOR_VERSION            '3'				; Python 2 will be deprecated soon
!define PYTHON_MINOR_VERSION            '7'				; so we switched to version 3
!define PYTHON_PATCH_VERSION            '7'
!define PYTHON_SHORT_VERSION            '${PYTHON_MAJOR_VERSION}.${PYTHON_MINOR_VERSION}'
!define PYTHON_VERSION                  '${PYTHON_MAJOR_VERSION}.${PYTHON_MINOR_VERSION}.${PYTHON_PATCH_VERSION}'

!define PINGUINO_ICON                   "pinguino11.ico"
!define PINGUINO_BMP                    "pinguino11.bmp"
!define INSTALLER_NAME                  '${PINGUINO_NAME}-installer'
!define FILE_OWNER                      'Pinguino'
!define FILE_URL                        'http://www.pinguino.cc'

!define CURL                            "curl.exe"

!define PBS_MARQUEE                     0x08

!define MUI_ABORTWARNING
!define MUI_INSTFILESPAGE_PROGRESSBAR   "smooth"
!define MUI_INSTFILESPAGE_COLORS        "00FF00 000000 " ; Green/Black Console Window
!define MUI_ICON                        ${PINGUINO_ICON}
!define MUI_UNICON                      ${PINGUINO_ICON}
!define MUI_WELCOMEFINISHPAGE_BITMAP    ${PINGUINO_BMP}
!define MUI_UNWELCOMEFINISHPAGE_BITMAP  ${PINGUINO_BMP}
;!define MUI_HEADERIMAGE
;!define MUI_HEADERIMAGE_RIGHT
;!define MUI_HEADERIMAGE_BITMAP         ${PINGUINO_BMP}

!define MUI_FINISHPAGE_NOAUTOCLOSE
!define MUI_FINISHPAGE_RUN
!define MUI_FINISHPAGE_RUN_NOTCHECKED
!define MUI_FINISHPAGE_RUN_TEXT         "Start ${PINGUINO_NAME}"
!define MUI_FINISHPAGE_RUN_FUNCTION     "LaunchPinguinoIDE"
!define MUI_FINISHPAGE_SHOWREADME_NOTCHECKED
;!define MUI_FINISHPAGE_SHOWREADME $INSTDIR\README.md

!define REG_UNINSTALL                   "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\${PINGUINO_NAME}"
!define REG_PINGUINO                    "SOFTWARE\${PINGUINO_NAME}"
!define REG_XC8                         "SOFTWARE\Microchip\MPLAB XC8 C Compiler"
!define REG_PYTHON                      "SOFTWARE\Python\PythonCore\${PYTHON_SHORT_VERSION}\InstallPath"
!define REG_GIT                         "SOFTWARE\GitForWindows"
!define REG_USERDOC                     "SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders"

!define URL_SOURCEFORGE                 "https://sourceforge.net/projects"
!define URL_GITHUB                      "https://github.com/PinguinoIDE"
!define URL_PINGUINO                    "${URL_SOURCEFORGE}/pinguinoide/files"
!define URL_SFOS                        "${URL_PINGUINO}/windows"
!define URL_MCHP                        "http://www.microchip.com"
!define URL_LIBUSB                      "${URL_SOURCEFORGE}/libusb-win32/files/libusb-win32-releases"
!define URL_PYTHON                      "https://www.python.org/ftp/python"
!define URL_GIT                         "https://github.com/git-for-windows/git/releases/download"
!define URL_VISUALCPP                   "https://aka.ms/vs/16/release/"

!define pinguino-ide                    "pinguino-ide-master.zip"
!define pinguino-libraries              "pinguino-libraries.zip"
!define pinguino-xc8                    "xc8-v$xc8_version-full-install-windows-installer.exe"
!define pinguino-xc8-latest             "mplabxc8windows"
!define pinguino-sdcc32                 "pinguino-windows32-sdcc-mpic16.zip"
!define pinguino-sdcc64                 "pinguino-windows64-sdcc-mpic16.zip"
!define pinguino-gcc32                  "pinguino-windows32-gcc-mips-elf.zip"
!define pinguino-gcc64                  "pinguino-windows64-gcc-mips-elf.zip"

;=======================================================================
;General Settings
;=======================================================================

Name                                    '${PINGUINO_NAME}'
;Sets the default value of $INSTDIR, in case no other values can be found.
InstallDir                              'C:\${PINGUINO_NAME}'
OutFile                                 '${INSTALLER_NAME}-v${INSTALLER_VERSION}.exe'
BrandingText                            '${FILE_URL}'

VIAddVersionKey "ProductName"           '${INSTALLER_NAME}'
VIAddVersionKey "ProductVersion"        '${INSTALLER_VERSION}'
VIAddVersionKey "CompanyName"           '${FILE_OWNER}'
VIAddVersionKey "LegalCopyright"        '2014-2020 ${FILE_OWNER}'
VIAddVersionKey "FileDescription"       'Pinguino IDE & Compilers Installer'
VIAddVersionKey "FileVersion"           '${INSTALLER_VERSION}'
VIProductVersion ${INSTALLER_VERSION}

;=======================================================================
;Pages
;=======================================================================

;Installer
!insertmacro MUI_PAGE_WELCOME           ; Displays a welcome message
!insertmacro MUI_PAGE_LICENSE           "LICENSE"
!insertmacro MUI_PAGE_LICENSE           "DISCLAIMER"
Page Custom  PAGE_COMPILER PAGE_COMPILER_LEAVE  ; Which Compilers ?
!insertmacro MUI_PAGE_INSTFILES         ; Install Pinguino
!insertmacro MUI_PAGE_FINISH            ; End of the installation 

!insertmacro MUI_UNPAGE_WELCOME
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_UNPAGE_FINISH

;=======================================================================
;Languages
;=======================================================================

!insertmacro MUI_LANGUAGE "English"     ; ???
!insertmacro MUI_LANGUAGE "Spanish"     ; Victor Villarreal <mefhigoseth@gmail.com>
!insertmacro MUI_LANGUAGE "PortugueseBR"; Wagner de Queiroz <wagnerdequeiroz@gmail.com>
!insertmacro MUI_LANGUAGE "Italian"     ; Pasquale Fersini <basquale.fersini@gmail.com>
!insertmacro MUI_LANGUAGE "French"      ; Regis Blanchot <rblanchot@pinguino.cc>

;=======================================================================
;Messages
;=======================================================================

LangString msg_not_detected ${LANG_ENGLISH} "not found. Installing it ..."
LangString msg_not_detected ${LANG_SPANISH} "no detectado en el sistema. Instalando ..."
LangString msg_not_detected ${LANG_PORTUGUESEBR} "não foi detectado em seu sistema. Instalando ..."
LangString msg_not_detected ${LANG_ITALIAN} "non trovato nel tuo sistema. Lo sto installando ..."
LangString msg_not_detected ${LANG_FRENCH} "n'a pas été trouvé. Installation ..."

LangString msg_installing ${LANG_ENGLISH} "installing."
LangString msg_installing ${LANG_SPANISH} "instalado correctamente."
LangString msg_installing ${LANG_PORTUGUESEBR} "Instalado."
LangString msg_installing ${LANG_ITALIAN} "Installato."
LangString msg_installing ${LANG_FRENCH} "en cours d'installation."

LangString msg_installed ${LANG_ENGLISH} "installed."
LangString msg_installed ${LANG_SPANISH} "instalado correctamente."
LangString msg_installed ${LANG_PORTUGUESEBR} "Instalado."
LangString msg_installed ${LANG_ITALIAN} "Installato."
LangString msg_installed ${LANG_FRENCH} "installé"

LangString msg_updated ${LANG_ENGLISH} "updated."
LangString msg_updated ${LANG_SPANISH} "instalado correctamente."
LangString msg_updated ${LANG_PORTUGUESEBR} "Instalado."
LangString msg_updated ${LANG_ITALIAN} "Installato."
LangString msg_updated ${LANG_FRENCH} "mis à jour."

LangString msg_deleted ${LANG_ENGLISH} "deleted."
LangString msg_deleted ${LANG_SPANISH} "."
LangString msg_deleted ${LANG_PORTUGUESEBR} "."
LangString msg_deleted ${LANG_ITALIAN} "."
LangString msg_deleted ${LANG_FRENCH} "effacé"

LangString msg_downloading ${LANG_ENGLISH} "Downloading"
LangString msg_downloading ${LANG_SPANISH} "Descargado"
LangString msg_downloading ${LANG_PORTUGUESEBR} "Downloading"
LangString msg_downloading ${LANG_ITALIAN} "Downloading"
LangString msg_downloading ${LANG_FRENCH} "Téléchargement de"

LangString msg_downloaded ${LANG_ENGLISH} "download completed."
LangString msg_downloaded ${LANG_SPANISH} "descargado correctamente."
LangString msg_downloaded ${LANG_PORTUGUESEBR} "download completo."
LangString msg_downloaded ${LANG_ITALIAN} "download completato."
LangString msg_downloaded ${LANG_FRENCH} "téléchargé"

LangString msg_your_system_is ${LANG_ENGLISH} "Your Operating System is"
LangString msg_your_system_is ${LANG_SPANISH} "Tu Sistema Operativo es al menos"
LangString msg_your_system_is ${LANG_PORTUGUESEBR} "Seu sistema operacional é pelo menos"
LangString msg_your_system_is ${LANG_ITALIAN} "Il tuo sistema operativo deve essere almeno"
LangString msg_your_system_is ${LANG_FRENCH} "Votre OS est"

LangString msg_installing_drivers ${LANG_ENGLISH} "Installing the Pinguino drivers"
LangString msg_installing_drivers ${LANG_SPANISH} "Instalando los controladores para el dispositivo Pinguino Project"
LangString msg_installing_drivers ${LANG_PORTUGUESEBR} "Instalando os controladores para o dispositivo do Projeto Pinguino"
LangString msg_installing_drivers ${LANG_ITALIAN} "Sto installando i driver per la scheda Pinguino Project"
LangString msg_installing_drivers ${LANG_FRENCH} "Installation des pilotes Pinguino"

LangString msg_uptodate ${LANG_ENGLISH} "Your copy is up to date."
LangString msg_uptodate ${LANG_SPANISH} "Your copy is up to date."
LangString msg_uptodate ${LANG_PORTUGUESEBR} "Your copy is up to date."
LangString msg_uptodate ${LANG_ITALIAN} "Your copy is up to date."
LangString msg_uptodate ${LANG_FRENCH} "Votre installation est à jour."

;=======================================================================
;Questions
;=======================================================================

LangString Q_install_release ${LANG_ENGLISH} "Which release of Pinguino do you want to install?"
LangString Q_install_release ${LANG_SPANISH} "Deseas instalar el testing o stable Pinguino IDE?"
LangString Q_install_release ${LANG_PORTUGUESEBR} "Você deseja instalar o testing o stable PINGUINO IDE?"
LangString Q_install_release ${LANG_ITALIAN} "Vuoi installare il testing o stable Pinguino?"
LangString Q_install_release ${LANG_FRENCH} "Quelle version de Pinguino voulez-vous installer ?"

LangString Q_install_pinguino ${LANG_ENGLISH} "Do you want to install the new version of Pinguino ?"
LangString Q_install_pinguino ${LANG_SPANISH} "Do you want to install the new version of Pinguino ?"
LangString Q_install_pinguino ${LANG_PORTUGUESEBR} "Do you want to install the new version of Pinguino ?"
LangString Q_install_pinguino ${LANG_ITALIAN} "Do you want to install the new version of Pinguino ?"
LangString Q_install_pinguino ${LANG_FRENCH} "Voulez-vous installer la nouvelle version de Pinguino ?"

LangString Q_install_drivers ${LANG_ENGLISH} "Do you want to install the Pinguino device drivers ?"
LangString Q_install_drivers ${LANG_SPANISH} "Deseas instalar los drivers para la placa Pinguino ahora?"
LangString Q_install_drivers ${LANG_PORTUGUESEBR} "Você deseja instalar os Drivers para a placa do Pinguino Agora?"
LangString Q_install_drivers ${LANG_ITALIAN} "Vuoi installare ora i driver per la scheda Pinguino?"
LangString Q_install_drivers ${LANG_FRENCH} "Voulez-vous installer les pilotes USB pour les cartes Pinguino ?"

LangString Q_install_compilers ${LANG_ENGLISH} "Do you want to install compilers?"
LangString Q_install_compilers ${LANG_SPANISH} "Do you want to install compilers?"
LangString Q_install_compilers ${LANG_PORTUGUESEBR} "Do you want to install compilers?"
LangString Q_install_compilers ${LANG_ITALIAN} "Do you want to install compilers?"
LangString Q_install_compilers ${LANG_FRENCH} "Voulez-vous installer des compilateurs ?"

;=======================================================================
;Errors
;=======================================================================

LangString E_downloading ${LANG_ENGLISH} "download failed. Error was:"
LangString E_downloading ${LANG_SPANISH} "no se pudo descargar. El error fue:"
LangString E_downloading ${LANG_PORTUGUESEBR} "o download falhou. que pena!, o erro foi:"
LangString E_downloading ${LANG_ITALIAN} "Il download è fallito. L'errore è:"
LangString E_downloading ${LANG_FRENCH} "n'a pu être téléchargé. Erreur :"

LangString E_updating ${LANG_ENGLISH} "update failed. Error was:"
LangString E_updating ${LANG_SPANISH} "no se pudo descargar. El error fue:"
LangString E_updating ${LANG_PORTUGUESEBR} "o update falhou. que pena!, o erro foi:"
LangString E_updating ${LANG_ITALIAN} "Il update è fallito. L'errore è:"
LangString E_updating ${LANG_FRENCH} "n'a pu être mis à jour. Erreur :"

LangString E_extracting ${LANG_ENGLISH} "An error occur while extracting files from"
LangString E_extracting ${LANG_SPANISH} "Se ha producido un error mientras se descomprimia"
LangString E_extracting ${LANG_PORTUGUESEBR} "Houve uma falha no processo de extração de arquivos."
LangString E_extracting ${LANG_ITALIAN} "Si e' verificato un errore durante l'estrazione dei file da"
LangString E_extracting ${LANG_FRENCH} "Erreur pendant la décompression des fichiers de"

LangString E_copying ${LANG_ENGLISH} "An error occur while copying files to"
LangString E_copying ${LANG_SPANISH} "Se ha producido un error mientras se copiaban los archivos en el directorio"
LangString E_copying ${LANG_PORTUGUESEBR} "Um erro ocorreu durante a copia de arquivos para o diretório"
LangString E_copying ${LANG_ITALIAN} "Si e' verificato un errore durante la copia dei file in"
LangString E_copying ${LANG_FRENCH} "Erreur lors de la copie des fichiers dans"

LangString E_installing ${LANG_ENGLISH} "not installed. Error code was:"
LangString E_installing ${LANG_SPANISH} "no instalado. El error fue:"
LangString E_installing ${LANG_PORTUGUESEBR} "não instalado. o erro foi:"
LangString E_installing ${LANG_ITALIAN} "non installato. L'errore è:"
LangString E_installing ${LANG_FRENCH} "n'a pu être installé. Erreur:"

LangString E_starting ${LANG_ENGLISH} "not installed. Error code was:"
LangString E_starting ${LANG_SPANISH} "not installed. Error code was:"
LangString E_starting ${LANG_PORTUGUESEBR} "not installed. Error code was:"
LangString E_starting ${LANG_ITALIAN} "not installed. Error code was:"
LangString E_starting ${LANG_FRENCH} "ne s'est pas installé correctement. Erreur:"

LangString E_failed ${LANG_ENGLISH} "failed. Error code was:"
LangString E_failed ${LANG_SPANISH} "failed. Error code was:"
LangString E_failed ${LANG_PORTUGUESEBR} "failed. Error code was:"
LangString E_failed ${LANG_ITALIAN} "failed. Error code was:"
LangString E_failed ${LANG_FRENCH} "a échoué. Erreur:"

;=======================================================================
;Variables
;=======================================================================

Var /GLOBAL xc8_version                 ; Current XC8 version
Var /GLOBAL xc8_path                    ; Path to the XC8 compiler
Var /GLOBAL user_path                   ; Path to the Pinguino user data
Var /GLOBAL python_path                 ; Path to Python
Var /GLOBAL git_version                 ; Git's version
Var /GLOBAL git_path                    ; Path to Git
Var /GLOBAL dir                         ; Used by Install Macro
Var /GLOBAL url                         ; Used by Download Macro
Var /GLOBAL program                     ; Used by Install ans Download Macro

;=======================================================================
;Functions
;=======================================================================

;-----------------------------------------------------------------------
;Function Remove
;Delete a given file
;arg0: The file to delete
;-----------------------------------------------------------------------

!macro Remove file

    Delete "$EXEDIR\$file"
    DetailPrint "$file $(msg_deleted)"

!macroend

;-----------------------------------------------------------------------
;Fixed : AGentric reported that "" must be removed from xc8_path
;-----------------------------------------------------------------------

Function .onInit

    !insertmacro MUI_LANGDLL_DISPLAY
    InitPluginsDir

    ;Copy Embeded files
    SetOutPath $EXEDIR
    File ${CURL}
    File ${PINGUINO_BMP}

FunctionEnd

Function un.onInit

    !insertmacro MUI_LANGDLL_DISPLAY

FunctionEnd

;-----------------------------------------------------------------------
; Uninstaller Section
;-----------------------------------------------------------------------

Section "Uninstall"

    ;Uninstall for all users
    SetShellVarContext all

    ;Always delete uninstaller first
    Delete "$INSTDIR\pinguino-uninstaller.exe"
 
    ;Delete the install directory (but not the compilers)
    RMDir /r /REBOOTOK "$INSTDIR\"

    ;Delete the user directory
    ReadRegStr $user_path HKCU "${REG_USERDOC}" "Personal"
	StrCpy $user_path "\${PINGUINO_NAME}\v${PINGUINO_VERSION}"
    RMDir /r /REBOOTOK "$user_path"

    ;Delete Desktop Icon
    Delete "$DESKTOP\pinguino-ide.lnk"
    Delete "$DESKTOP\v${PINGUINO_VERSION}\${PINGUINO_NAME}.lnk"
    
    ;Delete Program Menu
    RMDir /r "$SMPROGRAMS\${PINGUINO_NAME}\v${PINGUINO_VERSION}\"
    
    ;Clean the registry base
    DeleteRegKey /ifempty HKCU "${REG_PINGUINO}\v${PINGUINO_VERSION}\"
    DeleteRegKey HKLM "${REG_UNINSTALL}"

SectionEnd

;-----------------------------------------------------------------------
; Installer Sections
;-----------------------------------------------------------------------

Section "Install"

    ;Install for all users
    SetShellVarContext all

	;Detect the architecture of host system (32 or 64 bits)
	${If} ${RunningX64}
		SetRegView 64
		StrCpy $INSTDIR "$PROGRAMFILES64\${PINGUINO_NAME}\v${PINGUINO_VERSION}"
	${Else}
		SetRegView 32
		StrCpy $INSTDIR "$PROGRAMFILES32\${PINGUINO_NAME}\v${PINGUINO_VERSION}"
	${endif}
	;DetailPrint "Installation path : $INSTDIR"

    ;Tells the installer where to find files
    ReadRegStr $user_path HKCU "${REG_USERDOC}" "Personal"
	StrCpy $user_path "$user_path\${PINGUINO_NAME}\v${PINGUINO_VERSION}"

    ;Tells the installer where to extract files
    SetOutPath $INSTDIR

    ;Install Compilers ($R0, $R1 and $R2 are checkboxes results)
    
    ;SDCC:
    StrCmp $R0 "0" XC8
    Call InstallSDCC

    XC8:
    StrCmp $R1 "0" NOTXC8
    Call InstallXC8

    NOTXC8:
    ;User don't want to install XC8
    ;But let's check if XC8 has been already installed
	;in order to update the pinguino.windows.conf file
    ;We look in the 32-bit registry database
    ${If} ${RunningX64}
        SetRegView 32
    ${endif}
    ReadRegStr $xc8_version HKLM "${REG_XC8}" "Version"
    ReadRegStr $xc8_path HKLM "${REG_XC8}" "Location"
    ${If} ${RunningX64}
        SetRegView 64
    ${endif}

    ${If} $xc8_version == ""
		DetailPrint "XC8 not found"
    ${Else}
		DetailPrint "XC8 $xc8_version path is $xc8_path"
		DetailPrint "XC8 $xc8_version $(msg_installed)"
    ${Endif}

    ;GCC:
    StrCmp $R2 "0" +2
    Call InstallGCC

    ;Detect and install Python, Pip and Pip modules...
    Call InstallPython
    Call InstallPythonDep

	;Install Visual C++ 2019 Redistributable...
	Call InstallVisualCpp

    ;Get Pinguino last update
    ;Call InstallGit
    Call InstallPinguino

	; Keep context to 'all' in case was modified above...
	SetShellVarContext all

    ;Install device drivers ?
    MessageBox MB_YESNO|MB_ICONQUESTION "$(Q_install_drivers)" IDNO NoDrivers
    MessageBox MB_OK|MB_ICONINFORMATION "Note Vendor:Product ID's$\r$\n$\r$\n 8-bit Pinguino : 04D8:FEAA$\r$\n32-bit Pinguino : 04D8:003C" IDNO NoDrivers
    ;Call InstallPinguinoDrivers
    Call InstallLibUSB
    NoDrivers:

    ;End of installation
    Call PublishInfo
    Call MakeShortcuts
    Call InstallComplete

    ;Create Uninstaller.
    WriteUninstaller "$INSTDIR\pinguino-uninstall.exe"

SectionEnd

;-----------------------------------------------------------------------
;Create a custom page to choose Compilers
;-----------------------------------------------------------------------

Var COMPILERS_SDCC
Var COMPILERS_XC8
Var COMPILERS_GCC
 
Function PAGE_COMPILER

    nsDialogs::Create 1018
    Pop $0
    ${If} $0 == error
        Abort
    ${endif}
    
    !insertmacro MUI_HEADER_TEXT "$(Q_install_compilers)" ""
    
    ${NSD_CreateCheckBox} 250 50 100% 10u  "SDCC for PIC18F"
    Pop $COMPILERS_SDCC
    
    ${NSD_CreateCheckBox} 250 100 100% 10u "XC8 for PIC16F and PIC18F"
    Pop $COMPILERS_XC8
    
    ${NSD_CreateCheckBox} 250 150 100% 10u "GCC for PIC32MX"
    Pop $COMPILERS_GCC

    ${NSD_CreateBitmap} 0 0 100% 50% ""
    Pop $0
    ${NSD_SetImage} $0 "$EXEDIR\${PINGUINO_BMP}" $1
    nsDialogs::Show
    ${NSD_FreeImage} $1

FunctionEnd

Function PAGE_COMPILER_LEAVE

    ${NSD_GetState} $COMPILERS_SDCC $R0
    ${NSD_GetState} $COMPILERS_XC8  $R1
    ${NSD_GetState} $COMPILERS_GCC  $R2

FunctionEnd

;-----------------------------------------------------------------------
;Removes leading & trailing whitespace from a string
;-----------------------------------------------------------------------

Function StrTrim

    Exch $R1 ; Original string
    Push $R2
 
    Loop:
    StrCpy $R2 "$R1" 1
    StrCmp "$R2" " " TrimLeft
    StrCmp "$R2" "\" TrimLeft
    StrCmp "$R2" "$\r" TrimLeft
    StrCmp "$R2" "$\n" TrimLeft
    StrCmp "$R2" "$\t" TrimLeft
    GoTo Loop2
    
    TrimLeft:   
    StrCpy $R1 "$R1" "" 1
    Goto Loop
 
    Loop2:
    StrCpy $R2 "$R1" 1 -1
    StrCmp "$R2" " " TrimRight
    StrCmp "$R2" "\" TrimRight
    StrCmp "$R2" "$\r" TrimRight
    StrCmp "$R2" "$\n" TrimRight
    StrCmp "$R2" "$\t" TrimRight
    GoTo Done

    TrimRight:  
    StrCpy $R1 "$R1" -1
    Goto Loop2
 
    Done:
    Pop $R2
    Exch $R1

FunctionEnd

!define StrTrim "!insertmacro StrTrim"
 
!macro StrTrim ResultVar String
    Push "${String}"
    Call StrTrim
    Pop "${ResultVar}"
!macroend

;-----------------------------------------------------------------------
;Download a file
; NB : ExecToLog will print the output to the log window
;-----------------------------------------------------------------------

Function Download

    ; Swap the TOP TWO values of the stack
    Exch
    Pop $url
    Pop $program
    
    Marquee::start /NOUNLOAD /swing /step=1 /scrolls=1 /top=0 /height=18 /width=-1 "$(msg_downloading) $program ..."
    DetailPrint "$(msg_downloading) $program ..."
    Start:
    ClearErrors
    nsExec::ExecToLog '"$EXEDIR\curl.exe" --progress-bar -Lk $url/$program -o "$EXEDIR\$program"'
    Pop $0
    StrCmp $0 "0" Done
    ;Abort "$program $(E_downloading) $0!"
    DetailPrint "$program $(E_downloading) $0!"
    DetailPrint "We try again."
    GoTo Start

    Done:
    DetailPrint "$program $(msg_downloaded)"
    Marquee::stop

FunctionEnd

!define Download "!insertmacro Download"
 
!macro Download URL PROGRAM
    Push "${URL}"
    Push "${PROGRAM}"
    Call Download
!macroend

;-----------------------------------------------------------------------
;Install a file
;-----------------------------------------------------------------------

Function Install

    ; Swap the TOP TWO values of the stack
    Exch
    Pop $dir
    Pop $program

    Marquee::start /NOUNLOAD /swing /step=1 /scrolls=1 /top=0 /height=18 /width=-1 "$(msg_installing) $program ..."
    DetailPrint "$(msg_installing) $program ..."
    ClearErrors
    nsisunz::UnzipToLog "$EXEDIR\$program" "$dir"
    Pop $0
    StrCmp $0 "success" Done
    Abort "$(E_extracting) $program $0"
    Done:
    DetailPrint "$program $(msg_installed) : $dir"
    Marquee::stop

FunctionEnd

!define Install "!insertmacro Install"
 
!macro Install DIR PROGRAM
    Push "${DIR}"
    Push "${PROGRAM}"
    Call Install
!macroend

;-----------------------------------------------------------------------
; Python detection and installation routine.
; See: https://nsis.sourceforge.io/Reference/ReadRegStr
; See: https://nsis.sourceforge.io/Docs/Chapter4.html#basicinstructions
;-----------------------------------------------------------------------

Function InstallPython

    ;Check Python's Install Path
	DetailPrint "Python registry key: HKLM/${REG_PYTHON}"
    ReadRegStr $0 HKEY_CURRENT_USER "${REG_PYTHON}" "ExecutablePath"
    IfErrors 0 Done

    ;Download the Python installer
    DetailPrint "Python v${PYTHON_VERSION} $(msg_not_detected)"

    ${If} ${RunningX64}
		${Download} "${URL_PYTHON}/${PYTHON_VERSION}" "python-${PYTHON_VERSION}-amd64.exe"
		ExecWait '"$EXEDIR\python-${PYTHON_VERSION}-amd64.exe"' $0
    ${Else}
		${Download} "${URL_PYTHON}/${PYTHON_VERSION}" "python-${PYTHON_VERSION}.exe"
		ExecWait '"$EXEDIR\python-${PYTHON_VERSION}.exe"' $0
    ${endif}

    ${If} $0 != "0"
        Abort "Python v${PYTHON_VERSION} $(E_installing) $0!"
    ${endif}
    ReadRegStr $0 HKEY_CURRENT_USER "${REG_PYTHON}" ""
  
    Done:
    DetailPrint "Python v${PYTHON_VERSION} @ $0"
    DetailPrint "Python v${PYTHON_VERSION} $(msg_installed)"
    ${StrTrim} $python_path $0
    
FunctionEnd

;-----------------------------------------------------------------------
; Visual C++ 2019 Redistributable installation routine.
; See: https://support.microsoft.com/es-es/help/2977003/the-latest-supported-visual-c-downloads
;-----------------------------------------------------------------------

Function InstallVisualCpp

    ${If} ${RunningX64}
		${Download} "${URL_VISUALCPP}" "vc_redist.x64.exe"
		ExecWait '"$EXEDIR\vc_redist.x64.exe"' $0
    ${Else}
		${Download} "${URL_VISUALCPP}" "vc_redist.x86.exe"
		ExecWait '"$EXEDIR\vc_redist.x86.exe"' $0
    ${endif}

FunctionEnd

;-----------------------------------------------------------------------
; Install or upgrade Pip, PySide, PyUSB, Wheel, BeautifullSoup4, Setuptools
; Note Pip is already installed when Python version > 2.7.9.
; The installer just need to update it
;-----------------------------------------------------------------------

Function InstallPythonDep

    nsExec::Exec '"$python_path\python.exe" -m pip install --upgrade --user pip'
    DetailPrint "Python pip $(msg_installed)"
	nsExec::Exec '"$python_path\python.exe" -m pip install --upgrade pipenv'
    DetailPrint "Python pipenv $(msg_installed)"
    nsExec::Exec '"$python_path\python.exe" -m pip install --upgrade --user pyside2'
    DetailPrint "Python pyside2 $(msg_installed)"
    nsExec::Exec '"$python_path\python.exe" -m pip install --upgrade --user pyusb'
    DetailPrint "Python pyusb $(msg_installed)"
    nsExec::Exec '"$python_path\python.exe" -m pip install --upgrade --user wheel'
    DetailPrint "Python wheel $(msg_installed)"
    nsExec::Exec '"$python_path\python.exe" -m pip install --upgrade --user beautifulsoup4'
    DetailPrint "Python beautifulsoup4 $(msg_installed)"
    nsExec::Exec '"$python_path\python.exe" -m pip install --upgrade --user setuptools'
    DetailPrint "Python setuptools $(msg_installed)"
    nsExec::Exec '"$python_path\python.exe" -m pip install --upgrade --user requests'
    DetailPrint "Python requests $(msg_installed)"
    Pop $0
    StrCmp $0 "0" Done
    Abort "Python dependencies $(E_installing) $0!"

    Done:
    ;Remove Pinguino's Python package if installed before
    DetailPrint "Delete Pinguino's Python package if it exists ..."
    nsExec::Exec '"$python_path\python.exe" -m pip --yes uninstall pinguino' $0
    DetailPrint "Python dependencies $(msg_installed)"

FunctionEnd

;-----------------------------------------------------------------------
; Git detection and installation routine.
;-----------------------------------------------------------------------

Function InstallGit

    ;Check Git's Install Path
    ReadRegStr $git_path HKLM "${REG_GIT}" "InstallPath"
    ReadRegStr $git_version HKLM "${REG_GIT}" "CurrentVersion"

    ${If} $git_version == ""

		;Download Git installer
		DetailPrint "Git $(msg_not_detected)"
		${If} ${RunningX64}
			${Download} "${URL_GIT}/v${GIT_VERSION}.windows.1" "Git-${GIT_VERSION}-64-bit.exe"
                        nsExec::Exec '"$EXEDIR\Git-${GIT_VERSION}-64-bit.exe"' $0
		${Else}
			${Download} "${URL_GIT}/v${GIT_VERSION}.windows.1" "Git-${GIT_VERSION}-32-bit.exe"
                        nsExec::Exec '"$EXEDIR\Git-${GIT_VERSION}-32-bit.exe"' $0
		${endif}

		${If} $0 != "0"
			Abort "Git $(E_installing) $0!"
		${endif}

		ReadRegStr $git_path HKLM "${REG_GIT}" "InstallPath"
		ReadRegStr $git_version HKLM "${REG_GIT}" "CurrentVersion"

	${Endif}

	DetailPrint "Git v$git_version $(msg_installed)"
        DetailPrint "Git v$git_version path is $git_path"
    
FunctionEnd

;-----------------------------------------------------------------------
; pinguino-ide installation routine.
;-----------------------------------------------------------------------

Function InstallPinguino

    ;Download the IDE
    DetailPrint "Pinguino IDE $(E_updating) $0!"
    ${Download} ${URL_GITHUB} pinguino-ide/archive/${pinguino-ide}
	ClearErrors
    nsisunz::UnzipToLog "$EXEDIR\${pinguino-ide}" "$EXEDIR"
    StrCmp $0 "0" Next
    Abort "Pinguino IDE $(E_installing) $0!"

    Next:
    ;Download the Libraries
	DetailPrint "Pinguino Libraries $(E_updating) $0!"
    ${Download} ${URL_GITHUB} pinguino-libraries/archive/${pinguino-libraries}
	ClearErrors
    nsisunz::UnzipToLog "$EXEDIR\${pinguino-libraries}" "$EXEDIR"

    ;ExecWait '"$git_path\bin\git" "-C" "$INSTDIR/pinguino-libraries" "pull"' $0
    ;StrCmp $0 "0" Done
    ;No Libraries detected, let's clone them
    ;DetailPrint "Pinguino Libraries $(E_updating) $0!"
    ;ExecWait '"$git_path\bin\git" "clone" "https://github.com/PinguinoIDE/pinguino-libraries.git" "$INSTDIR/pinguino-libraries"' $0
    ;StrCmp $0 "0" Done
    ;Abort "Pinguino Libraries $(E_installing) $0!"

    Done:
    ;Copy examples and sources folders in $user_path
    CopyFiles "$INSTDIR\pinguino-libraries\examples\*.*" "$user_path\examples\"
    CopyFiles "$INSTDIR\pinguino-libraries\source\*.*" "$user_path\source\"
    DetailPrint "Pinguino $(msg_installed)"
        
FunctionEnd

;-----------------------------------------------------------------------
; Pinguino device driver installation
;-----------------------------------------------------------------------

;Function InstallPinguinoDrivers

    ;Copy the drivers directory
    ;SetOutPath "$INSTDIR\drivers"
    ;File /r "drivers\*.*"

    ;Install all the drivers
    ;DetailPrint "$(msg_installing_drivers)..."
    ;nsExec::Exec '"rundll32" syssetup,SetupInfObjectInstallAction DefaultInstall 128 "$INSTDIR\drivers\mchpusb.inf"'
    ;nsExec::Exec '"rundll32" syssetup,SetupInfObjectInstallAction DefaultInstall 128 "$INSTDIR\drivers\mchpcdc.inf"'

    ;MessageBox MB_ICONINFORMATION "The Pinguino Drivers have been installed on your System. If you experience any problem, proceed to a manual installation : go to the drivers directory, right-clic and install mchpusb.inf and mchpcdc.inf"

;FunctionEnd

;-----------------------------------------------------------------------
;Install LibUSB and Pinguino Drivers
;-----------------------------------------------------------------------

Function InstallLibUSB

    ;Check if LibUSB is installed
    ;ReadRegStr $0 HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\LibUSB-Win32_is1" "Inno Setup: App Path"
    ;DetailPrint "LibUSB path is $0"
    ;IfErrors 0 Done

    ;Download LibUSB
    ${Download} "${URL_LIBUSB}/${LIBUSBWIN32_VERSION}" "libusb-win32-bin-${LIBUSBWIN32_VERSION}.zip"
    
    ;Unzip LibUSB
    ClearErrors
    nsisunz::UnzipToLog "$EXEDIR\$program" "$EXEDIR"
    IfErrors 0 +2
        Abort "$(E_extracting) $program"

    ;Run LibUSB
    nsExec::Exec '"$EXEDIR\libusb-win32-bin-${LIBUSBWIN32_VERSION}\bin\inf-wizard.exe"'
    Pop $0
    StrCmp $0 "0" Done
    Abort "LibUSB $(E_installing) $0!"
    ;Remove $program

    Done:
    DetailPrint "LibUSB $(msg_installed)"
    ;ReadRegStr $R0 HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\LibUSB-Win32_is1\InstallLocation" ""
    ;StrCpy $LibUSBPath $0

FunctionEnd

;-----------------------------------------------------------------------
; SDCC compiler installation routine.
;-----------------------------------------------------------------------

Function InstallSDCC

    ;Download SDCC
    ${If} ${RunningX64}
		${Download} ${URL_SFOS} ${pinguino-sdcc64}
    ${Else}
		${Download} ${URL_SFOS} ${pinguino-sdcc32}
    ${endif}

    ;Install SDCC
    ${Install} "$INSTDIR\pinguino-compilers" "$program"

FunctionEnd

;-----------------------------------------------------------------------
; XC8 compiler installation routine.
;-----------------------------------------------------------------------

Function InstallXC8

    ;Download XC8 Installer
    ${Download} ${URL_MCHP} ${pinguino-xc8-latest}

    ;Run XC8 Installer
    nsExec::Exec '"$EXEDIR\${pinguino-xc8-latest}"'
    Pop $0
    StrCmp $0 "0" +2
    DetailPrint "XC8 $(E_installing) : $0!"

    ${If} ${RunningX64}
        SetRegView 32
    ${endif}
    ReadRegStr $xc8_version HKLM "${REG_XC8}" "Version"
    ReadRegStr $xc8_path HKLM "${REG_XC8}" "Location"
    ${If} ${RunningX64}
        SetRegView 64
    ${endif}
    
    DetailPrint "XC8 $xc8_version path is $xc8_path"
    DetailPrint "XC8 $xc8_version $(msg_installed)"

FunctionEnd

;-----------------------------------------------------------------------
; 32-bits Pinguino compilers installation routine.
;-----------------------------------------------------------------------

Function InstallGCC

    ;Download GCC for Pinguino
    ${If} ${RunningX64}
    ${Download} ${URL_SFOS} ${pinguino-gcc64}
    ${Else}
    ${Download} ${URL_SFOS} ${pinguino-gcc32}
    ${endif}

    ;Install GCC for Pinguino
    ${Install} "$INSTDIR\pinguino-compilers" "$program"

FunctionEnd

;-----------------------------------------------------------------------
; Software installation info publish routine.
;-----------------------------------------------------------------------

Function PublishInfo

    DetailPrint "Writing Register Database ..."
    ;Uninstall
    WriteRegStr HKCU "Software\${PINGUINO_NAME}" "" "$INSTDIR"
    WriteRegStr HKLM "${REG_UNINSTALL}" "DisplayName" "${PINGUINO_NAME}"
    WriteRegStr HKLM "${REG_UNINSTALL}" "UninstallString" "$\"$INSTDIR\pinguino-uninstall.exe$\""
    WriteRegStr HKLM "${REG_UNINSTALL}" "QuietUninstallString" "$\"$INSTDIR\pinguino-uninstall.exe$\" /S"
    WriteRegStr HKLM "${REG_UNINSTALL}" "HelpLink" "${FILE_URL}"
    WriteRegStr HKLM "${REG_UNINSTALL}" "URLInfoAbout" "${FILE_URL}"
    WriteRegStr HKLM "${REG_UNINSTALL}" "Publisher" "${FILE_OWNER}"
    ;Info
    WriteRegStr HKLM "${REG_PINGUINO}" "PinguinoName" "${PINGUINO_NAME}"
    WriteRegStr HKLM "${REG_PINGUINO}" "PinguinoVersion" "${PINGUINO_VERSION}"
    WriteRegStr HKLM "${REG_PINGUINO}" "PinguinoRelease" "${PINGUINO_VERSION}"
    WriteRegStr HKLM "${REG_PINGUINO}" "PinguinoPath" "$INSTDIR"
    WriteRegStr HKLM "${REG_PINGUINO}" "XC8Version" "$xc8_version"
    WriteRegStr HKLM "${REG_PINGUINO}" "XC8Path" "$xc8_path"

FunctionEnd

;-----------------------------------------------------------------------
; Software shortcuts installation routine.
;-----------------------------------------------------------------------

Function MakeShortcuts

    DetailPrint "Adding shortcuts ..."
    ;Extract the icon file to the installation path
    ;/oname change the output name
    File "/oname=$INSTDIR\pinguino.ico" ${PINGUINO_ICON}

    ;Create desktop shortcut
    ;CreateShortCut  "$DESKTOP\${PINGUINO_NAME}.lnk" "$INSTDIR\pinguino.bat" "" "$INSTDIR\pinguino.ico" 2 SW_SHOWNORMAL CONTROL|ALT|P "Pinguino IDE"
    ;CreateShortCut  "$DESKTOP\${PINGUINO_NAME}-v${PINGUINO_VERSION}.lnk" "$INSTDIR\pinguino.bat" "" "$INSTDIR\pinguino.ico" 2 SW_SHOWNORMAL CONTROL|ALT|P "Pinguino IDE"
    CreateShortCut  "$DESKTOP\${PINGUINO_NAME}-v${PINGUINO_VERSION}.lnk" "$INSTDIR\pinguino.bat" "" "$INSTDIR\pinguino.ico" 0 SW_SHOWNORMAL CONTROL|SHIFT|P "Pinguino IDE"

    ;Create start-menu items
    CreateDirectory "$SMPROGRAMS\${PINGUINO_NAME}\v${PINGUINO_VERSION}\"
    CreateShortCut  "$SMPROGRAMS\${PINGUINO_NAME}\v${PINGUINO_VERSION}\${PINGUINO_NAME}.lnk" "$INSTDIR\pinguino.bat" "" "$INSTDIR\pinguino.ico" 2 SW_SHOWNORMAL CONTROL|SHIFT|P "Pinguino IDE"
    CreateShortCut  "$SMPROGRAMS\${PINGUINO_NAME}\v${PINGUINO_VERSION}\Uninstall.lnk" "$INSTDIR\pinguino-uninstall.exe" "" "$INSTDIR\pinguino.ico" 2 SW_SHOWNORMAL CONTROL|ALT|SHIFT|P "Pinguino Uninstaller"

FunctionEnd

;-----------------------------------------------------------------------
; Software Post Install routine.
;-----------------------------------------------------------------------

Function InstallComplete

    ;Update pinguino.windows.conf for all windows version
    DetailPrint "Updating pinguino.windows.conf ..."
    FileOpen  $0 $INSTDIR\pinguino-ide\pinguino\qtgui\config\pinguino.windows.conf w
    FileWrite $0 "[Paths]$\r$\n"
    FileWrite $0 "sdcc_bin = $INSTDIR\pinguino-compilers\p8\bin\$\r$\n"
    FileWrite $0 "gcc_bin  = $INSTDIR\pinguino-compilers\p32\bin\$\r$\n"
    FileWrite $0 "xc8_bin  = $xc8_path\bin$\r$\n"
    FileWrite $0 "pinguino_8_libs  = $INSTDIR\pinguino-libraries\p8\$\r$\n"
    FileWrite $0 "pinguino_32_libs = $INSTDIR\pinguino-libraries\p32\$\r$\n"
    FileWrite $0 "install_path = $INSTDIR\$\r$\n"
    FileWrite $0 "user_path = $user_path$\r$\n"
    FileWrite $0 "user_libs = $user_path\pinguinolibs$\r$\n"
    FileClose $0
    
    ;IfFileExists "$python_path\Lib\site-packages\pinguino\qtgui\config\pinguino.windows.conf" 0 +2
    ;Delete "$python_path\Lib\site-packages\pinguino\qtgui\config\pinguino.windows.conf"
    ;Rename "$INSTDIR\pinguino.windows.conf" "$python_path\Lib\site-packages\pinguino\qtgui\config\pinguino.windows.conf"

	;Update pinguino.bat
	DetailPrint "Updating pinguino.bat ..."
	;Delete  $INSTDIR\pinguino.bat
	FileOpen  $0 $INSTDIR\pinguino.bat w
	FileWrite $0 "CLS"
	FileWrite $0 "$\r$\n"
	FileWrite $0 "@ECHO OFF"
	FileWrite $0 "$\r$\n"
	FileWrite $0 "@REM Force latest Python 3.X version to be used"
	FileWrite $0 "$\r$\n"
	FileWrite $0 "SET BIN=py -3"
	FileWrite $0 "$\r$\n"
	FileWrite $0 "@REM Update Python's modules"
	FileWrite $0 "$\r$\n"
	FileWrite $0 "%BIN% -m pip install --upgrade --user pip"
	FileWrite $0 "$\r$\n"
	FileWrite $0 "%BIN% -m pip install --upgrade --user pyside2"
	FileWrite $0 "$\r$\n"
	FileWrite $0 "%BIN% -m pip install --upgrade --user pyusb"
	FileWrite $0 "$\r$\n"
	FileWrite $0 "%BIN% -m pip install --upgrade --user wheel"
	FileWrite $0 "$\r$\n"
	FileWrite $0 "%BIN% -m pip install --upgrade --user beautifulsoup4"
	FileWrite $0 "$\r$\n"
	FileWrite $0 "%BIN% -m pip install --upgrade --user setuptools"
	FileWrite $0 "$\r$\n"
	FileWrite $0 "%BIN% -m pip install --upgrade --user requests"
	FileWrite $0 "$\r$\n"
	FileWrite $0 "@REM Launch the Pinguino IDE"
	FileWrite $0 "$\r$\n"
	FileWrite $0 "CD $INSTDIR\pinguino-ide"
	FileWrite $0 "$\r$\n"
	FileWrite $0 "%BIN% pinguino-ide.py"
	FileWrite $0 "$\r$\n"
	FileClose $0

	;Execute pinguino-ide post_install routine...
	ExecWait '"$python_path\python" "$INSTDIR\pinguino-ide\pinguino\pinguino_reset.py"' $0
	StrCmp $0 "0" Done
	DetailPrint "Post-installation $(E_failed) $0!"

    Done:
    DetailPrint "Installation complete."

FunctionEnd

;-----------------------------------------------------------------------
; Launch Pinguino IDE
;-----------------------------------------------------------------------

Function LaunchPinguinoIDE

    ExecShell "" "$INSTDIR\pinguino.bat"

FunctionEnd
