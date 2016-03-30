;-----------------------------------------------------------------------
; Pinguino IDE NSIS Installation Script
; Public Domain License 2014-2016
; 1.1 to 1.3 : Victor Villarreal <mefhigoseth@gmail.com>
; 1.4 to 1.7 : Regis Blanchot <rblanchot@pinguino.cc>
;-----------------------------------------------------------------------
; CHANGELOG
; 1.7.0.0 : Pinguino Stable or Testing installation
; 1.7.0.1 : Fixed embeded pinguino.bmp and curl.exe
;-----------------------------------------------------------------------
; TODO
; Better Operating System detection, cf. http://nsis.sourceforge.net/Get_Windows_version
; Compiler Uninstaller
;-----------------------------------------------------------------------
; To compile this script : makensis.exe Pinguino_x.x.x.x.nsi
;-----------------------------------------------------------------------

XPStyle on
RequestExecutionLevel admin				;Request application privileges
SetDatablockOptimize on
SetCompress force
SetCompressor /SOLID lzma
ShowInstDetails show					;Show installation logs

;-----------------------------------------------------------------------
;Includes
;-----------------------------------------------------------------------

;!include "Sections.nsh"
;!include "WinMessages.nsh"
!include "MUI2.nsh"
!include "FileFunc.nsh"
!include "WinVer.nsh"
!include "nsDialogs.nsh"
!include "LogicLib.nsh"

;-----------------------------------------------------------------------
;Defines
;-----------------------------------------------------------------------

!define INSTALLER_VERSION				'1.7.0.1'
!define PYTHON_VERSION					'2.7.10'
!define PYUSB_VERSION					'1.0.0rc1'
!define PYSIDE_VERSION					'1.2.2'
!define LIBUSB_VERSION					'1.0.20'
!define LIBUSBWIN32_VERSION				'1.2.6.0'

!define PINGUINO_NAME					'Pinguino'
!define PINGUINO_STABLE					'11'
!define PINGUINO_TESTING				'12'
!define PINGUINO_ICON					"pinguino11.ico"
!define PINGUINO_BMP					"pinguino11.bmp"
!define INSTALLER_NAME					'${PINGUINO_NAME}-installer'
!define FILE_OWNER						'Pinguino'
!define FILE_URL						'http://www.pinguino.cc'

!define CURL							"curl.exe"

!define PBS_MARQUEE						0x08

!define MUI_ABORTWARNING
!define MUI_INSTFILESPAGE_PROGRESSBAR	"smooth"
!define MUI_INSTFILESPAGE_COLORS		"00FF00 000000 " ; Green/Black Console Window
!define MUI_ICON						${PINGUINO_ICON}
!define MUI_UNICON						${PINGUINO_ICON}
!define MUI_WELCOMEFINISHPAGE_BITMAP	${PINGUINO_BMP}
!define MUI_UNWELCOMEFINISHPAGE_BITMAP	${PINGUINO_BMP}
;!define MUI_HEADERIMAGE
;!define MUI_HEADERIMAGE_RIGHT
;!define MUI_HEADERIMAGE_BITMAP			${PINGUINO_BMP}

!define MUI_FINISHPAGE_NOAUTOCLOSE
!define MUI_FINISHPAGE_RUN
!define MUI_FINISHPAGE_RUN_NOTCHECKED
!define MUI_FINISHPAGE_RUN_TEXT			"Start ${PINGUINO_NAME}"
!define MUI_FINISHPAGE_RUN_FUNCTION		"LaunchPinguinoIDE"
!define MUI_FINISHPAGE_SHOWREADME_NOTCHECKED
;!define MUI_FINISHPAGE_SHOWREADME $INSTDIR\README.md

!define ADD_REMOVE						"Software\Microsoft\Windows\CurrentVersion\Uninstall\${PINGUINO_NAME}"
!define PyPIP							"get-pip.py"
!define SFBASE							"https://sourceforge.net/projects/pinguinoide/files"
!define SFOS							"https://sourceforge.net/projects/pinguinoide/files/windows"
!define MCHP							"http://ww1.microchip.com"
!define pinguino-ide					"pinguino-ide.zip"
!define pinguino-libraries				"pinguino-libraries.zip"
!define pinguino-xc8					"xc8-v1.36-full-install-windows-installer.exe"
!define pinguino-sdcc32					"pinguino-windows32-sdcc-mpic16.zip"
!define pinguino-sdcc64					"pinguino-windows64-sdcc-mpic16.zip"
!define pinguino-gcc32					"pinguino-windows32-gcc-mips-elf.zip"
!define pinguino-gcc64					"pinguino-windows64-gcc-mips-elf.zip"

;-----------------------------------------------------------------------
;General Settings
;-----------------------------------------------------------------------

Name									'${PINGUINO_NAME}'
InstallDir								'C:\${PINGUINO_NAME}'
OutFile									'${INSTALLER_NAME}-v${INSTALLER_VERSION}.exe'
BrandingText							'${FILE_URL}'

VIAddVersionKey "ProductName"       	'${INSTALLER_NAME}'
VIAddVersionKey "ProductVersion"    	'${INSTALLER_VERSION}'
VIAddVersionKey "CompanyName"       	'${FILE_OWNER}'
VIAddVersionKey "LegalCopyright"    	'2014-2016 ${FILE_OWNER}'
VIAddVersionKey "FileDescription"   	'Pinguino IDE & Compilers Installer'
VIAddVersionKey "FileVersion"       	'${INSTALLER_VERSION}'
VIProductVersion ${INSTALLER_VERSION}

;-----------------------------------------------------------------------
;Pages
;-----------------------------------------------------------------------

;Installer
!insertmacro MUI_PAGE_WELCOME           ; Displays a welcome message
!insertmacro MUI_PAGE_LICENSE			"LICENSE"
!insertmacro MUI_PAGE_LICENSE			"DISCLAIMER"
Page Custom  PAGE_RELEASE PAGE_RELEASE_LEAVE
!insertmacro MUI_PAGE_DIRECTORY         ; Install Directory
Page Custom  PAGE_COMPILERS PAGE_COMPILERS_LEAVE
!insertmacro MUI_PAGE_INSTFILES         ; Installation progress
!insertmacro MUI_PAGE_FINISH            ; End of the installation 

;Uninstaller : *** TODO UNPAGE RELEASE & COMPILERS ***
!insertmacro MUI_UNPAGE_WELCOME
!insertmacro MUI_UNPAGE_CONFIRM
;UninstPage Custom  un.PAGE_RELEASE un.PAGE_RELEASE_LEAVE
!insertmacro MUI_UNPAGE_INSTFILES
;UninstPage Custom  un.PAGE_COMPILERS un.PAGE_COMPILERS_LEAVE
!insertmacro MUI_UNPAGE_FINISH

;-----------------------------------------------------------------------
;Languages
;-----------------------------------------------------------------------

!insertmacro MUI_LANGUAGE "English"     ; ???
!insertmacro MUI_LANGUAGE "Spanish"     ; Victor Villarreal <mefhigoseth@gmail.com>
!insertmacro MUI_LANGUAGE "PortugueseBR"; Wagner de Queiroz <wagnerdequeiroz@gmail.com>
!insertmacro MUI_LANGUAGE "Italian"     ; Pasquale Fersini <basquale.fersini@gmail.com>
!insertmacro MUI_LANGUAGE "French"      ; Regis Blanchot <rblanchot@pinguino.cc>

;-----------------------------------------------------------------------
;Messages
;-----------------------------------------------------------------------

LangString msg_not_detected ${LANG_ENGLISH} "not detected in your system. Installing it..."
LangString msg_not_detected ${LANG_SPANISH} "no detectado en el sistema. Instalando..."
LangString msg_not_detected ${LANG_PORTUGUESEBR} "não foi detectado em seu sistema. Instalando..."
LangString msg_not_detected ${LANG_ITALIAN} "non trovato nel tuo sistema. Lo sto installando..."
LangString msg_not_detected ${LANG_FRENCH} "n'a pas été trouvé sur votre système."

LangString msg_installed ${LANG_ENGLISH} "installed."
LangString msg_installed ${LANG_SPANISH} "instalado correctamente."
LangString msg_installed ${LANG_PORTUGUESEBR} "Instalado."
LangString msg_installed ${LANG_ITALIAN} "Installato."
LangString msg_installed ${LANG_FRENCH} "installé"

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

LangString msg_downloaded ${LANG_ENGLISH} "download complete."
LangString msg_downloaded ${LANG_SPANISH} "descargado correctamente."
LangString msg_downloaded ${LANG_PORTUGUESEBR} "download completo."
LangString msg_downloaded ${LANG_ITALIAN} "download completato."
LangString msg_downloaded ${LANG_FRENCH} "téléchargé"

LangString msg_your_system_is ${LANG_ENGLISH} "Your Operating System is"
LangString msg_your_system_is ${LANG_SPANISH} "Tu Sistema Operativo es al menos"
LangString msg_your_system_is ${LANG_PORTUGUESEBR} "Seu sistema operacional é pelo menos"
LangString msg_your_system_is ${LANG_ITALIAN} "Il tuo sistema operativo deve essere almeno"
LangString msg_your_system_is ${LANG_FRENCH} "Votre système d'opération (OS) est"

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

;-----------------------------------------------------------------------
;Questions
;-----------------------------------------------------------------------

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

LangString Q_install_drivers ${LANG_ENGLISH} "Do you want to install the device drivers for pinguino-board now?"
LangString Q_install_drivers ${LANG_SPANISH} "Deseas instalar los drivers para la placa Pinguino ahora?"
LangString Q_install_drivers ${LANG_PORTUGUESEBR} "Você deseja instalar os Drivers para a placa do Pinguino Agora?"
LangString Q_install_drivers ${LANG_ITALIAN} "Vuoi installare ora i driver per la scheda Pinguino?"
LangString Q_install_drivers ${LANG_FRENCH} "Voulez-vous installer les pilotes USB pour les cartes Pinguino ?"

LangString Q_install_compilers ${LANG_ENGLISH} "Do you want to install compilers?"
LangString Q_install_compilers ${LANG_SPANISH} "Do you want to install compilers?"
LangString Q_install_compilers ${LANG_PORTUGUESEBR} "Do you want to install compilers?"
LangString Q_install_compilers ${LANG_ITALIAN} "Do you want to install compilers?"
LangString Q_install_compilers ${LANG_FRENCH} "Voulez-vous installer des compilateurs ?"

LangString Q_install_sdcc ${LANG_ENGLISH} "Do you want to install the SDCC compiler for 8-bits PICs now?"
LangString Q_install_sdcc ${LANG_SPANISH} "Deseas instalar el compilador SDCC para PICs de 8-bits ahora?"
LangString Q_install_sdcc ${LANG_PORTUGUESEBR} "Você deseja instalar o compilador SDCC para PICs de 8-bits agora?"
LangString Q_install_sdcc ${LANG_ITALIAN} "Vuoi installare il compilatore SDCC per i PIC a 8-bits ora?"
LangString Q_install_sdcc ${LANG_FRENCH} "Voulez-vous procéder à l'installation du compilateur SDCC pour les PIC18F ?"

LangString Q_install_xc8 ${LANG_ENGLISH} "Do you want to install the XC8 compiler for 8-bits PICs now?"
LangString Q_install_xc8 ${LANG_SPANISH} "Deseas instalar el compilador XC8 para PICs de 8-bits ahora?"
LangString Q_install_xc8 ${LANG_PORTUGUESEBR} "Você deseja instalar o compilador XC8 para PICs de 8-bits agora?"
LangString Q_install_xc8 ${LANG_ITALIAN} "Vuoi installare il compilatore XC8 per i PIC a 8-bits ora?"
LangString Q_install_xc8 ${LANG_FRENCH} "Voulez-vous procéder à l'installation du compilateur XC8 pour les PIC16F et les PIC18F ?"

LangString Q_install_gcc ${LANG_ENGLISH} "Do you want to install Pinguino compilers for 32-bits PICs now?"
LangString Q_install_gcc ${LANG_SPANISH} "Deseas instalar el compilador Pinguino para PICs de 32-bits ahora?"
LangString Q_install_gcc ${LANG_PORTUGUESEBR} "Você deseja instalar o compilador Pinguino para PICs de 32-bits agora?"
LangString Q_install_gcc ${LANG_ITALIAN} "Vuoi installare il compilatore per i PIC a 32-bits ora?"
LangString Q_install_gcc ${LANG_FRENCH} "Voulez-vous procéder à l'installation du compilateur 32-bit (PIC32MX) ?"

;-----------------------------------------------------------------------
;Errors
;-----------------------------------------------------------------------

LangString E_downloading ${LANG_ENGLISH} "download failed. Error was:"
LangString E_downloading ${LANG_SPANISH} "no se pudo descargar. El error fue:"
LangString E_downloading ${LANG_PORTUGUESEBR} "o download falhou. que pena!, o erro foi:"
LangString E_downloading ${LANG_ITALIAN} "Il download è fallito. L'errore è:"
LangString E_downloading ${LANG_FRENCH} "n'a pu être téléchargé. Erreur :"

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

;-----------------------------------------------------------------------
;Variables
;-----------------------------------------------------------------------

Var /GLOBAL os_platform					; 32- or 64-bit OS
Var /GLOBAL os_version					; Windows XP, 7, 8 or 10
Var /GLOBAL pinguino_release			; stable or testing
Var /GLOBAL pinguino_version			; 11 or 12
Var /GLOBAL pinguino_actual_version
Var /GLOBAL pinguino_last_version
Var /GLOBAL SourceForge					; Path to SourceForge repository
Var /GLOBAL CompilersPath				; Path to the Pinguino compilers
Var /GLOBAL Python27Path				; Path to Python 2.7
Var /GLOBAL url							; Used by Download Macro
Var /GLOBAL program						; Used by Download Macro
Var Image
Var ImageHandle
;Var hwnd

;-----------------------------------------------------------------------
;Delete a file
;-----------------------------------------------------------------------

!macro Remove file

    Delete "$EXEDIR\$file"
    DetailPrint "$file $(msg_deleted)"

!macroend

;-----------------------------------------------------------------------
;Start
;-----------------------------------------------------------------------

Function .onInit

    !insertmacro MUI_LANGDLL_DISPLAY
	InitPluginsDir

	;Detect the architecture of host system (32 or 64 bits)
    StrCpy $os_platform "x86"
    StrCmp $PROGRAMFILES $PROGRAMFILES64 +2
    StrCpy $os_platform "amd64"

    ;Detect the Operating System
	;TODO : http://nsis.sourceforge.net/Get_Windows_version
	;${if} ${AtLeastWindows7}
        ; System is Microsoft Windows 7, 8 or later...
		;StrCpy $os_version "W7"
    ;${else}
		${if} ${AtLeastWinVista}
			; System is Microsoft Windows Vista...
			StrCpy $os_version "Vista"
		${else}
			; System is Microsoft Windows XP...
			StrCpy $os_version "XP"
		${endif}
    ;${endif}

    DetailPrint "$(msg_your_system_is) Microsoft Windows $os_version ($os_platform)."

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
	;Delete the install directory
    RMDir /r /REBOOTOK "$INSTDIR\"
    ;Delete "$DESKTOP\pinguino-ide.lnk"
    RMDir /r "$SMPROGRAMS\${FILE_OWNER}\"
    ;DeleteRegKey /ifempty HKCU "Software\Pinguino"
    ;DeleteRegKey HKLM "${ADD_REMOVE}"

SectionEnd

;-----------------------------------------------------------------------
; Installer Sections
;-----------------------------------------------------------------------

Section "Install"

    ;Install for all users
    SetShellVarContext all

	;Embedded files
    SetOutPath $EXEDIR
    File ${CURL}
	File ${PINGUINO_BMP}
	;Copy curl.exe and pinguino.bmp
	;CopyFiles ${CURL} $EXEDIR\${CURL}
	;CopyFiles ${PINGUINO_BMP} $EXEDIR\${PINGUINO_BMP}

    ;Install path
    SetOutPath $INSTDIR
	;DetailPrint "INSTDIR=$INSTDIR"
	;DetailPrint "EXEDIR=$EXEDIR"

    ;Detect and install Python, Pip and Pip modules ......
    Call InstallPython
    Call InstallPip
    Call InstallPySide
    Call InstallPyUSB
	Call InstallWheel
	${if} $pinguino_version == "11"
		Call InstallBS4
	${else}
		Call InstallSetuptools
	${endif}
	
    ;Get Pinguino last update
    Call InstallPinguino

    ;Install device drivers ?
    MessageBox MB_YESNO|MB_ICONQUESTION "$(Q_install_drivers)" IDNO NoDrivers
    MessageBox MB_OK|MB_ICONINFORMATION "Note Vendor:Product ID's$\r$\n$\r$\n 8-bit Pinguino : 04D8:FEAA$\r$\n32-bit Pinguino : 04D8:003C" IDNO NoDrivers
    ;Call InstallPinguinoDrivers
    Call InstallLibUSB
    NoDrivers:

	${If} $R0 = 1
		Call InstallSDCC
	${EndIf}

	${If} $R1 = 1
		Call InstallXC8
	${EndIf}

	${If} $R2 = 1
		Call InstallGCC
	${EndIf}

    ;End of installation
    Call PublishInfo
    Call MakeShortcuts
    Call InstallComplete

    ;Create Uninstaller.
    WriteUninstaller "$INSTDIR\pinguino-uninstall.exe"

SectionEnd

;-----------------------------------------------------------------------
;Create a custom page to choose Pinguino release
;-----------------------------------------------------------------------

Var RELEASE_STABLE
Var RELEASE_TESTING
Var RELEASE_STATE

Function PAGE_RELEASE

	nsDialogs::Create 1018
	Pop $0
	${If} $0 == error
		Abort
	${EndIf}
	
	!insertmacro MUI_HEADER_TEXT "$(Q_install_release)" ""
	
	${NSD_CreateRadioButton} 250 75 100% 10u "Stable (v${PINGUINO_STABLE})"
	Pop $RELEASE_STABLE
	
	${NSD_CreateRadioButton} 250 125 100% 10u "Testing (v${PINGUINO_TESTING})"
	Pop $RELEASE_TESTING

	${If} $RELEASE_STATE = 1

		${NSD_SetState} $RELEASE_TESTING  ${BM_SETCHECK}

	${Else}

		${NSD_SetState} $RELEASE_STABLE  ${BM_SETCHECK}

	${EndIf}

	${NSD_CreateBitmap} 0 0 100% 80% ""
	Pop $Image
	${NSD_SetImage} $Image "$EXEDIR\${PINGUINO_BMP}" $ImageHandle
	;${NSD_SetStretchedImage} $Image ${PINGUINO_BMP} $ImageHandle
	nsDialogs::Show
	${NSD_FreeImage} $ImageHandle

FunctionEnd

Function PAGE_RELEASE_LEAVE

	${NSD_GetState} $RELEASE_STABLE  $R0
	${NSD_GetState} $RELEASE_TESTING $R1

	${If} $R0 = 1

		StrCpy $pinguino_version ${PINGUINO_STABLE}
		StrCpy $pinguino_release "stable"
		StrCpy $RELEASE_STATE 1

	${Else}

		StrCpy $pinguino_version ${PINGUINO_TESTING}
		StrCpy $pinguino_release "testing"
		StrCpy $RELEASE_STATE 1

	${EndIf}

    StrCpy $INSTDIR "C:\${PINGUINO_NAME}\v$pinguino_version"
	StrCpy $CompilersPath "C:\${PINGUINO_NAME}\compilers"
    CreateDirectory "$CompilersPath"
	StrCpy $SourceForge "${SFOS}/$pinguino_release"

FunctionEnd

;-----------------------------------------------------------------------
;Create a custom page to choose Compilers
;-----------------------------------------------------------------------

Var COMPILERS_SDCC
Var COMPILERS_XC8
Var COMPILERS_GCC
 
Function PAGE_COMPILERS

	nsDialogs::Create 1018
	Pop $0
	${If} $0 == error
		Abort
	${EndIf}
	
	!insertmacro MUI_HEADER_TEXT "$(Q_install_compilers)" ""
	
	${NSD_CreateCheckBox} 250 50 100% 10u  "SDCC for PIC18F"
	Pop $COMPILERS_SDCC
	
	${NSD_CreateCheckBox} 250 100 100% 10u "XC8 for PIC16F and PIC18F"
	Pop $COMPILERS_XC8

	${NSD_CreateCheckBox} 250 150 100% 10u "GCC for PIC32MX"
	Pop $COMPILERS_GCC

	${NSD_CreateBitmap} 0 0 100% 80% ""
	Pop $Image
	${NSD_SetImage} $Image "$EXEDIR\${PINGUINO_BMP}" $ImageHandle
	;${NSD_SetStretchedImage} $Image ${PINGUINO_BMP} $ImageHandle
	nsDialogs::Show

FunctionEnd

Function PAGE_COMPILERS_LEAVE

    ;${NSD_CreateProgressBar} 0 0 100% 10% "Compilers Installation"
    ;Pop $hwnd
    ;${NSD_AddStyle} $hwnd ${PBS_MARQUEE}

	; Call NSD_Timer.Callback every 10ms
    ;${NSD_CreateTimer} NSD_Timer.Callback 10

	${NSD_GetState} $COMPILERS_SDCC $R0
	${NSD_GetState} $COMPILERS_XC8  $R1
	${NSD_GetState} $COMPILERS_GCC  $R2

FunctionEnd

;Function NSD_Timer.Callback

	; Kill the timer
    ;${NSD_KillTimer} NSD_Timer.Callback

    ;SendMessage $hwnd ${PBM_SETMARQUEE} 1 50 ; start=1|stop=0 interval(ms)=+N
    ;_again:
    ;MessageBox MB_YESNO "Stop the marquee?" IDNO _again
    ;SendMessage $hwnd ${PBM_SETMARQUEE} 0 0
 
;FunctionEnd

;-----------------------------------------------------------------------
;Removes leading & trailing whitespace from a string
;-----------------------------------------------------------------------

Function StrTrim

	Exch $R1 ; Original string
	Push $R2
 
	Loop:
	StrCpy $R2 "$R1" 1
	StrCmp "$R2" " " TrimLeft
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
;-----------------------------------------------------------------------

Function Download

	DetailPrint "$(msg_downloading) $program ..."
	nsExec::ExecToLog '"$EXEDIR\curl.exe" --progress-bar -Lk $url/$program -o "$EXEDIR\$program"'
    Pop $0
    StrCmp $0 "0" Complete
    Abort "$program $(E_downloading) $0!"

    Complete:
    DetailPrint "$program $(msg_downloaded)"

FunctionEnd

;-----------------------------------------------------------------------
; Python v2.7 detection and installation routine.
;-----------------------------------------------------------------------

Function InstallPython

	;Check if Python is installed
    ReadRegStr $0 HKLM "SOFTWARE\Python\PythonCore\2.7\InstallPath" ""
    IfErrors 0 Done

    ;Download the Python installer
    DetailPrint "Python v2.7 $(msg_not_detected)"
    StrCpy $url "https://www.python.org/ftp/python/${PYTHON_VERSION}"
    StrCpy $program 'python-${PYTHON_VERSION}.msi'
    StrCmp $PROGRAMFILES $PROGRAMFILES64 +2
    StrCpy $program 'python-${PYTHON_VERSION}.amd64.msi'
	Call Download

	;Install Python
    ExecWait '"msiexec" /i "$EXEDIR\$program"' $0
    ${if} $0 != "0"
        Abort "Python v2.7 $(E_installing) $0!"
    ${endif}
    ReadRegStr $0 HKLM "SOFTWARE\Python\PythonCore\2.7\InstallPath" ""
    ;Remove $program
  
    Done:
    DetailPrint "Python v2.7 path is $0"
    DetailPrint "Python v2.7 $(msg_installed)"
    StrCpy $Python27Path $0

FunctionEnd

;-----------------------------------------------------------------------
; Detect and install Pip.
;-----------------------------------------------------------------------

Function InstallPip

    ;PIP module detection
    IfFileExists "$Python27Path\Scripts\pip.exe" Done +1

	;Download PIP
    DetailPrint "PyPIP $(msg_not_detected)"
    ;SetOutPath "$TEMP"
    StrCpy $url "https://bootstrap.pypa.io/"
	StrCpy $program "${PyPIP}"
    Call Download

	;Install PIP
    ;ExecWait '"$Python27Path\python" "$TEMP\${PyPIP}"' $0
    ExecWait '"$Python27Path\python" "$EXEDIR\${PyPIP}"' $0
    StrCmp $0 "0" Done
    Abort "PyPIP $(E_installing) $0!"
    ;Remove $program
	
	Done:
    DetailPrint "PyPIP $(msg_installed)"

FunctionEnd

;-----------------------------------------------------------------------
; Detect and install PySide.
;-----------------------------------------------------------------------

Function InstallPySide

	;Check if PySide is installed
    IfFileExists "$Python27Path\Lib\site-packages\PySide\__init__.py" Done +1

	;Install PySide
    DetailPrint "PySide $(msg_not_detected)"
    nsExec::Exec '"$Python27Path\Scripts\pip.exe" install pyside'
    Pop $0
    StrCmp $0 "0" Done
    Abort "Wheel $(E_installing) $0!"

    Done:
    DetailPrint "PySide $(msg_installed)"

FunctionEnd

;-----------------------------------------------------------------------
; Detect and install PyUSB.
;-----------------------------------------------------------------------

Function InstallPyUSB

    ;Check if PyUSB is installed
    IfFileExists "$Python27Path\Lib\site-packages\usb\__init__.py" Done +1

	;Install PyUSB
    DetailPrint "PyUSB $(msg_not_detected)"
    nsExec::Exec '"$Python27Path\Scripts\pip.exe" install pyusb==${PYUSB_VERSION}'
    Pop $0
    StrCmp $0 "0" Done
    Abort "PyUSB $(E_installing) $0!"

    Done:
    DetailPrint "PyUSB $(msg_installed)"

FunctionEnd

;-----------------------------------------------------------------------
; Detect and install Wheel.
;-----------------------------------------------------------------------

Function InstallWheel

    ;Check if Wheel is installed
    IfFileExists "$Python27Path\Scripts\wheel.exe" Done +1

    ;Install Wheel
    DetailPrint "Wheel $(msg_not_detected)"
    nsExec::Exec '"$Python27Path\Scripts\pip.exe" install wheel'
    Pop $0
    StrCmp $0 "0" Done
    Abort "Wheel $(E_installing) $0!"

	Done:
	DetailPrint "Wheel $(msg_installed)"

FunctionEnd

;-----------------------------------------------------------------------
; Detect and install Python BeautifullSoup4.
;-----------------------------------------------------------------------

Function InstallBS4
	
	;Check if BeautifullSoup4 is installed
	IfFileExists "$Python27Path\Lib\site-packages\bs4\__init__.py" Done +1

	;Install BS4
	DetailPrint "BeautifullSoup4 $(msg_not_detected)"
	nsExec::Exec '"$Python27Path\Scripts\pip.exe" install beautifulsoup4'
	Pop $0
	StrCmp $0 "0" Done
	Abort "beautifulsoup4 $(E_installing) $0!"
	
	Done:
	DetailPrint "BeautifullSoup4 $(msg_installed)"

FunctionEnd

;-----------------------------------------------------------------------
; Detect and install Python Git.
;-----------------------------------------------------------------------

;Function InstallGit
;
;	;GIT for Python module detection and installation routine.
;	IfFileExists "$Python27Path\Lib\site-packages\git\__init__.py" Done +1
;	DetailPrint "GITpython $(msg_not_detected)"
;	
;	nsExec::Exec '"$Python27Path\Scripts\pip.exe" install gitpython'
;	Pop $R0
;	${if} $R0 != "0"
;	    Abort "GIT-Python $(E_installing) $R0!"
;	${endif}
;	
;	Done:
;	DetailPrint "GITpython $(msg_installed)"
;
;FunctionEnd

;-----------------------------------------------------------------------
; Detect and install Python Setuptools.
;-----------------------------------------------------------------------

Function InstallSetuptools

	;Check if Setuptools is installed
	IfFileExists "$Python27Path\Lib\site-packages\setuptools\__init__.py" Done +1

	;Install Setuptools
	DetailPrint "Setuptools $(msg_not_detected)"
	nsExec::Exec '"$Python27Path\Scripts\pip.exe" install setuptools'
	Pop $0
	StrCmp $0 "0" Done
	Abort "Wheel $(E_installing) $0!"

	Done:
	DetailPrint "Setuptools $(msg_installed)"
	
FunctionEnd

;-----------------------------------------------------------------------
; Install Pinguino last update
;-----------------------------------------------------------------------

Function InstallPinguino

	${if} $pinguino_version == "11"

		;get the installed version
		${if} ${FileExists} "$INSTDIR\update"
			FileOpen  $0 "$INSTDIR\update" r
			FileRead  $0 $1
			FileClose $0
			${StrTrim} $pinguino_actual_version $1
		${else}
			;DetailPrint "*** update not found ***"
			StrCpy $pinguino_actual_version 'unknown'
		${endif}

		DetailPrint "Pinguino last update $pinguino_actual_version"

		;get the latest version
		StrCpy $url ${SFBASE}
		StrCpy $program "update"
		Call Download

		${if} ${FileExists} "$EXEDIR\update"
			FileOpen  $0 "$EXEDIR\update" r
			FileRead  $0 $1
			FileClose $0
			${StrTrim} $pinguino_last_version $1
		${else}
			StrCpy $pinguino_last_version 'unknown'
		${endif}

		DetailPrint "Pinguino available update $pinguino_last_version"

		;compare the 2 versions
		;StrCmp str1 str2 jump_if_equal [jump_if_not_equal]
		StrCmp $pinguino_last_version 'unknown' StartDownload +1
		StrCmp $pinguino_actual_version 'unknown' StartDownload +1
		StrCmp $pinguino_actual_version $pinguino_last_version UpToDate +1

		StartDownload:

		;IfFileExists "$INSTDIR\update" 0 +2
		;Delete "$INSTDIR\update"
		Rename "$EXEDIR\update" "$INSTDIR\update"
		DetailPrint "New version available : $pinguino_last_version"
		;MessageBox MB_YESNO|MB_ICONQUESTION "$(Q_install_pinguino) : ($pinguino_last_version)" IDNO Compilers

		Call InstallPinguinoIde
		Call InstallPinguinoLibraries

		UpToDate:
		DetailPrint "$(msg_uptodate)"
		MessageBox MB_OK|MB_ICONINFORMATION "$(msg_uptodate)"

	${else}

		;Install Pinguino IDE
		nsExec::Exec '"$Python27Path\Scripts\pip.exe" install pinguino'
		Pop $R0
		${if} $R0 != "0"
			Abort "Pinguino IDE $(E_installing) $R0!"
		${endif}

		;Install Pinguino libraries
		Call InstallPinguinoLibraries
		DetailPrint "Pinguino IDE $(msg_installed)"
	
	${endif}
	
FunctionEnd

;-----------------------------------------------------------------------
; pinguino-ide installation routine.
;-----------------------------------------------------------------------

Function InstallPinguinoIde

    ;Download Pinguino IDE
    StrCpy $url $SourceForge
    StrCpy $program "${pinguino-ide}"
    Call Download

    ;Install Pinguino IDE
    ClearErrors
    nsisunz::UnzipToLog "$EXEDIR\${pinguino-ide}" "$INSTDIR\.."
    IfErrors 0 +2
        Abort "$(E_extracting) ${pinguino-ide}"
    DetailPrint "${pinguino-ide} $(msg_installed)"
    ;Remove $program
    
FunctionEnd

;-----------------------------------------------------------------------
; pinguino-libraries installation routine.
;-----------------------------------------------------------------------

Function InstallPinguinoLibraries

    ;Download Pinguino libraries
    StrCpy $url $SourceForge
    StrCpy $program "${pinguino-libraries}"
    Call Download

    ;Install Pinguino libraries
    ClearErrors
    nsisunz::UnzipToLog "$EXEDIR\${pinguino-libraries}" "$INSTDIR\.."
    IfErrors 0 +2
        Abort "$(E_extracting) ${pinguino-libraries}"
    DetailPrint "${pinguino-libraries} $(msg_installed)"
    ;Remove $program

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
	StrCpy $url "https://sourceforge.net/projects/libusb-win32/files/libusb-win32-releases/${LIBUSBWIN32_VERSION}"
	StrCpy $program "libusb-win32-bin-${LIBUSBWIN32_VERSION}.zip"
	Call Download
	
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
    StrCpy $url ${SFOS}
    StrCpy $program ${pinguino-sdcc32}
    StrCmp $os_platform "x86" +2
    StrCpy $program ${pinguino-sdcc64}
	Call Download

	;Install SDCC
    ClearErrors
    nsisunz::UnzipToLog "$EXEDIR\$program" "$CompilersPath"
	Pop $0
	StrCmp $0 "success" Done
    Abort "$(E_extracting) $program $0"
	Done:
    DetailPrint "$program $(msg_installed)"
    ;Remove $program

FunctionEnd

;-----------------------------------------------------------------------
; XC8 compiler installation routine.
;-----------------------------------------------------------------------

Function InstallXC8

	;Download XC8 Installer
    StrCpy $url ${SFOS}
    StrCpy $program ${pinguino-xc8}
    Call Download

	;Run XC8 Installer
	nsExec::Exec '"$EXEDIR\${pinguino-xc8}"'
	Pop $0
	StrCmp $0 "0" Done
	Abort "XC8 $(E_installing) $0!"
	Done:
    DetailPrint "$program $(msg_installed)"
    ;Remove $program

FunctionEnd

;-----------------------------------------------------------------------
; 32-bits Pinguino compilers installation routine.
;-----------------------------------------------------------------------

Function InstallGCC

	;Download GCC for Pinguino
    StrCpy $url ${SFOS}
    StrCpy $program ${pinguino-gcc32}
    StrCmp $os_platform "x86" +2
    StrCpy $program ${pinguino-gcc64}
	Call Download

	;Install GCC for Pinguino
    ClearErrors
    nsisunz::UnzipToLog "$EXEDIR\$program" "$CompilersPath"
	Pop $0
	StrCmp $0 "success" Done
    Abort "$(E_extracting) $program $0"
	Done:
    DetailPrint "$program $(msg_installed)"
    ;Remove $program

FunctionEnd

;-----------------------------------------------------------------------
; Software installation info publish routine.
;-----------------------------------------------------------------------

Function PublishInfo

    DetailPrint "Writing Register Database ..."
    WriteRegStr HKCU "Software\Pinguino" "" "$INSTDIR"
    WriteRegStr HKLM "${ADD_REMOVE}" "DisplayName" "${PINGUINO_NAME}"
    WriteRegStr HKLM "${ADD_REMOVE}" "UninstallString" "$\"$INSTDIR\pinguino-uninstall.exe$\""
    WriteRegStr HKLM "${ADD_REMOVE}" "QuietUninstallString" "$\"$INSTDIR\pinguino-uninstall.exe$\" /S"
    WriteRegStr HKLM "${ADD_REMOVE}" "HelpLink" "${FILE_URL}"
    WriteRegStr HKLM "${ADD_REMOVE}" "URLInfoAbout" "${FILE_URL}"
    WriteRegStr HKLM "${ADD_REMOVE}" "Publisher" "${FILE_OWNER}"

FunctionEnd

;-----------------------------------------------------------------------
; Software shortcuts install routine.
;-----------------------------------------------------------------------

Function MakeShortcuts

    ;Make shortcuts into desktop and start menu to our program...
    DetailPrint "Adding shortcut ..."
    File "/oname=$INSTDIR\pinguino.ico" ${PINGUINO_ICON}

    CreateShortCut  "$DESKTOP\pinguino-ide.lnk" "$INSTDIR\pinguino.bat" "" "$INSTDIR\pinguino.ico"
    CreateDirectory "$SMPROGRAMS\${PINGUINO_NAME}\"
    CreateShortCut  "$SMPROGRAMS\${PINGUINO_NAME}\pinguino-ide.lnk" "$INSTDIR\pinguino.bat" "" "$INSTDIR\pinguino.ico"

FunctionEnd

;-----------------------------------------------------------------------
; Software Post Install routine.
;-----------------------------------------------------------------------

Function InstallComplete

    StrCmp $pinguino_version ${PINGUINO_TESTING} Done +1

    ;Update pinguino.bat
    DetailPrint "Updating pinguino.bat ..."
    FileOpen  $0 "$INSTDIR\pinguino.bat" w
    FileWrite $0 "@ECHO OFF"
    FileWrite $0 "$\r$\n"
    FileWrite $0 "CD $INSTDIR\"
    FileWrite $0 "$\r$\n"
    FileWrite $0 "$Python27Path\python pinguino.py"
    FileWrite $0 "$\r$\n"
    FileClose $0

    ;Execute pinguino-ide post_install routine...
    ExecWait '"$Python27Path\python" "$INSTDIR\post_install.py"' $0
    StrCmp $0 "0" Done
    Abort "post_install $(E_installing) $0!"
    Done:
    DetailPrint "Installation complete."

FunctionEnd

;-----------------------------------------------------------------------
; Launch Pinguino IDE
;-----------------------------------------------------------------------

Function LaunchPinguinoIDE

    StrCmp $pinguino_version "11" Start +1
	CopyFiles "$Python27Path\Lib\site-packages\pinguino\pinguino.bat" "$INSTDIR\pinguino.bat"
	
	Start:
    ExecShell "" "$INSTDIR\pinguino.bat"

FunctionEnd
