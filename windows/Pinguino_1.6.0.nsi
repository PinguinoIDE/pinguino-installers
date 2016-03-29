;-----------------------------------------------------------------------
; Pinguino IDE Installation Script
; Public Domain License 2014
; 1.1.0.1 to 1.1.0.3 : Victor Villarreal <mefhigoseth@gmail.com>
; 1.1.0.4 to 1.1.0.6 : Regis Blanchot <rblanchot@pinguino.cc>
; Translated to Portuguese-BR by Wagner de Queiroz <wagnerdequeiroz@gmail.com>
; Translated to Italian by Pasquale Fersini <basquale.fersini@gmail.com>
; Translated to French by Regis Blanchot <rblanchot@pinguino.cc>
;
; To compile this script : makensis.exe /V4 Pinguino_x.x.x.x.nsi
; /V0=no output
; /V1=errors only
; /V2=warnings and errors
; /V3=info, warnings, and errors
; /V4=all output
;-----------------------------------------------------------------------

;-----------------------------------------------------------------------
;Defines
;-----------------------------------------------------------------------

!define PINGUINO_VERSION '11'
!define INSTALLER_VERSION '1.1.0.6'
!define PYTHON_VERSION '2.7.10'
!define PYSIDE_VERSION '1.2.2'
!define LIBUSB_VERSION '1.0.19'
!define LIBUSBWIN32_VERSION '1.2.6.0'

!define PINGUINO_NAME 'pinguino'
!define INSTALLER_NAME '${PINGUINO_NAME}_v${PINGUINO_VERSION}-setup'
!define FILE_OWNER 'Pinguino Project'
!define FILE_URL 'http://www.pinguino.cc/'

!define MUI_ABORTWARNING
!define MUI_INSTFILESPAGE_PROGRESSBAR "smooth"
!define MUI_ICON "pinguino11.ico"
!define MUI_UNICON "pinguino11.ico"
!define MUI_WELCOMEFINISHPAGE_BITMAP "pinguino11.bmp"
!define MUI_UNWELCOMEFINISHPAGE_BITMAP "pinguino11.bmp"

!define MUI_FINISHPAGE_NOAUTOCLOSE
!define MUI_FINISHPAGE_RUN
!define MUI_FINISHPAGE_RUN_NOTCHECKED
!define MUI_FINISHPAGE_RUN_TEXT "Start ${PINGUINO_NAME} v${PINGUINO_VERSION}"
!define MUI_FINISHPAGE_RUN_FUNCTION "LaunchPinguinoIDE"
!define MUI_FINISHPAGE_SHOWREADME_NOTCHECKED
;!define MUI_FINISHPAGE_SHOWREADME $INSTDIR\README.md

!define ADD_REMOVE "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PINGUINO_NAME}"
!define PyPIP "get-pip.py"
!define SourceForge "http://downloads.sourceforge.net/pinguinoide"
!define pinguino-ide "pinguino-ide.zip"
!define pinguino-libraries "pinguino-libraries.zip"
!define pinguino-compiler32-8bits "pinguino-windows32-sdcc-mpic16.zip"
!define pinguino-compiler64-8bits "pinguino-windows64-sdcc-mpic16.zip"
!define pinguino-compiler32-32bits "pinguino-windows32-gcc-mips-elf.zip"
!define pinguino-compiler64-32bits "pinguino-windows64-gcc-mips-elf.zip"

;-----------------------------------------------------------------------
;Includes
;-----------------------------------------------------------------------

!include "MUI2.nsh"
!include "FileFunc.nsh"
!include "WinVer.nsh"
;!include "LogicLib.nsh"

;-----------------------------------------------------------------------
;General Settings
;-----------------------------------------------------------------------

Name '${PINGUINO_NAME} ${PINGUINO_VERSION}'
OutFile '${INSTALLER_NAME}-v${INSTALLER_VERSION}.exe'
BrandingText '${FILE_OWNER}'
InstallDir 'C:\${PINGUINO_NAME}-${PINGUINO_VERSION}'
;ShowInstDetails show
;Request Admin execution level. Needed to install drivers.
RequestExecutionLevel admin

VIAddVersionKey "ProductName" '${INSTALLER_NAME}'
VIAddVersionKey "ProductVersion" '${INSTALLER_VERSION}'
VIAddVersionKey "CompanyName" '${FILE_OWNER}'
VIAddVersionKey "LegalCopyright" 'Copyright 2014-2015 ${FILE_OWNER}'
VIAddVersionKey "FileDescription" 'Pinguino Installer'
VIAddVersionKey "FileVersion" '${INSTALLER_VERSION}'
VIProductVersion ${INSTALLER_VERSION}

;-----------------------------------------------------------------------
;Pages
;-----------------------------------------------------------------------

;Installer
!insertmacro MUI_PAGE_WELCOME           ; the wizard page displays a welcome
!insertmacro MUI_PAGE_LICENSE "LICENSE"
!insertmacro MUI_PAGE_LICENSE "DISCLAIMER"
!insertmacro MUI_PAGE_DIRECTORY         ; the wizard page shows the choice of security transfer directory
!insertmacro MUI_PAGE_INSTFILES         ; the wizard page displays the installation progress
!insertmacro MUI_PAGE_FINISH            ; the wizard page displays the end of the installation 

;Uninstaller
!insertmacro MUI_UNPAGE_WELCOME
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_UNPAGE_FINISH

;-----------------------------------------------------------------------
;Languages
;-----------------------------------------------------------------------

!insertmacro MUI_LANGUAGE "English"
!insertmacro MUI_LANGUAGE "Spanish"
!insertmacro MUI_LANGUAGE "PortugueseBR"
!insertmacro MUI_LANGUAGE "Italian"
!insertmacro MUI_LANGUAGE "French"

LangString msg_not_detected ${LANG_ENGLISH} "not detected in your system. Installing it..."
LangString msg_not_detected ${LANG_SPANISH} "no detectado en el sistema. Instalando..."
LangString msg_not_detected ${LANG_PORTUGUESEBR} "não foi detectado em seu sistema. Instalando..."
LangString msg_not_detected ${LANG_ITALIAN} "non trovato nel tuo sistema. Lo sto installando..."
LangString msg_not_detected ${LANG_FRENCH} "n'a pas été trouvé sur votre système."

;LangString msg_download_and_install ${LANG_ENGLISH} "We'll install it for you, in 5 secs."
;LangString msg_download_and_install ${LANG_SPANISH} "Lo instalaremos por ti, en 5 segundos."
;LangString msg_download_and_install ${LANG_PORTUGUESEBR} "Nós instalaremos para você, em 5 segundos."
;LangString msg_download_and_install ${LANG_ITALIAN} "Lo installeremo per te, in 5 secondi."
;LangString msg_download_and_install ${LANG_FRENCH} "L'installation débutera dans 5 secondes."

LangString msg_installed ${LANG_ENGLISH} "installed."
LangString msg_installed ${LANG_SPANISH} "instalado correctamente."
LangString msg_installed ${LANG_PORTUGUESEBR} "Instalado."
LangString msg_installed ${LANG_ITALIAN} "Installato."
LangString msg_installed ${LANG_FRENCH} "installé."

LangString msg_deleted ${LANG_ENGLISH} "deleted."
LangString msg_deleted ${LANG_SPANISH} "."
LangString msg_deleted ${LANG_PORTUGUESEBR} "."
LangString msg_deleted ${LANG_ITALIAN} "."
LangString msg_deleted ${LANG_FRENCH} "effacé."

LangString msg_downloaded ${LANG_ENGLISH} "download complete."
LangString msg_downloaded ${LANG_SPANISH} "descargado correctamente."
LangString msg_downloaded ${LANG_PORTUGUESEBR} "download completo."
LangString msg_downloaded ${LANG_ITALIAN} "download completato."
LangString msg_downloaded ${LANG_FRENCH} "téléchargé."

LangString msg_your_system_is ${LANG_ENGLISH} "Your Operating System is at least"
LangString msg_your_system_is ${LANG_SPANISH} "Tu Sistema Operativo es al menos"
LangString msg_your_system_is ${LANG_PORTUGUESEBR} "Seu sistema operacional é pelo menos"
LangString msg_your_system_is ${LANG_ITALIAN} "Il tuo sistema operativo deve essere almeno"
LangString msg_your_system_is ${LANG_FRENCH} "Votre système d'opération (OS) est"

LangString msg_installing_drivers ${LANG_ENGLISH} "Installing the Pinguino Project device drivers"
LangString msg_installing_drivers ${LANG_SPANISH} "Instalando los controladores para el dispositivo Pinguino Project"
LangString msg_installing_drivers ${LANG_PORTUGUESEBR} "Instalando os controladores para o dispositivo do Projeto Pinguino"
LangString msg_installing_drivers ${LANG_ITALIAN} "Sto installando i driver per la scheda Pinguino Project"
LangString msg_installing_drivers ${LANG_FRENCH} "Installation des pilotes Pinguino"

LangString msg_uptodate ${LANG_ENGLISH} "Your copy is up to date."
LangString msg_uptodate ${LANG_SPANISH} "Your copy is up to date."
LangString msg_uptodate ${LANG_PORTUGUESEBR} "Your copy is up to date."
LangString msg_uptodate ${LANG_ITALIAN} "Your copy is up to date."
LangString msg_uptodate ${LANG_FRENCH} "Votre installation est à jour."

LangString please_plug_in_your_board ${LANG_ENGLISH} "1-Connect your board to your PC and press OK"
LangString please_plug_in_your_board ${LANG_SPANISH} "1-Conecta la placa."
LangString please_plug_in_your_board ${LANG_PORTUGUESEBR} "1-Conecte a placa"
LangString please_plug_in_your_board ${LANG_ITALIAN} "1-Connetti la scheda"
LangString please_plug_in_your_board ${LANG_FRENCH} "1-Connectez votre carte Pinguino au PC et cliquez OK"

LangString switch_to_bootloader_mode ${LANG_ENGLISH} "2-Switch to bootloader mode (see the Wiki for more info.) and press OK."
LangString switch_to_bootloader_mode ${LANG_SPANISH} "2-Presiona el boton de reset"
LangString switch_to_bootloader_mode ${LANG_PORTUGUESEBR} "2-Pressione o botão de reset"
LangString switch_to_bootloader_mode ${LANG_ITALIAN} "2-Premi il pulsante reset"
LangString switch_to_bootloader_mode ${LANG_FRENCH} "2-Passez en mode bootloader (voir le Wiki pour plus d'info.) et cliquez OK."

;LangString spot_the_pinguino_boards ${LANG_ENGLISH} "3-."
;LangString spot_the_pinguino_boards ${LANG_SPANISH} " "
;LangString spot_the_pinguino_boards ${LANG_PORTUGUESEBR} " "
;LangString spot_the_pinguino_boards ${LANG_ITALIAN} ""
;LangString spot_the_pinguino_boards ${LANG_FRENCH} "3-A la fin de l'installation de LibUSB, choisissez :\r\n[x] Launch Filer Intaller Wizard\r\npuis\r\nInstall Device Filter."

LangString spot_the_pinguino_boards ${LANG_ENGLISH} "4-You'll be presented a list of USB Devices connected to your computer, spot and select your Pinguino board (Vendor ID 0x04D8 (Microchip), Product ID 0xFEAA (8-bit) and/or 0x003C (32-bit) and press OK to proceed the installation."
LangString spot_the_pinguino_boards ${LANG_SPANISH} "."
LangString spot_the_pinguino_boards ${LANG_PORTUGUESEBR} "."
LangString spot_the_pinguino_boards ${LANG_ITALIAN} "."
LangString spot_the_pinguino_boards ${LANG_FRENCH} "4-Dans la liste des périphériques USB connectés à votre ordinateur qui va vous être présentée par la suite, repérez et sélectionnez votre carte Pinguino (Vendor ID 0x04D8 (Microchip), Product ID 0xFEAA (8-bit) et/ou 0x003C (32-bit) puis pressez le bouton OK pour procéder à l'installation des pilotes."

;LangString remember_install_manually_later ${LANG_ENGLISH} "Rememeber to install manually the ${libusb} package after you connect your board the first time."
;LangString remember_install_manually_later ${LANG_SPANISH} "Recuerda que deberas ejecutar el paquete ${libusb} manualmente, luego de conectar la placa por primera vez."
;LangString remember_install_manually_later ${LANG_PORTUGUESEBR} "Lembre-se de instalar manualmente o pacote ${libusb}, após conectar a sua placa pela primeira vez."
;LangString remember_install_manually_later ${LANG_ITALIAN} "Ricordati di installare manualmente il pacchetto ${libusb}, prima di connettere la scheda per la prima volta."
;LangString remember_install_manually_later ${LANG_FRENCH} "N'oubliez pas d'installer ${libusb} après la première connexion de votre carte."

;Questions
LangString Q_install_drivers ${LANG_ENGLISH} "Do you want to install the device drivers for pinguino-board now?"
LangString Q_install_drivers ${LANG_SPANISH} "Deseas instalar los drivers para la placa Pinguino ahora?"
LangString Q_install_drivers ${LANG_PORTUGUESEBR} "Você deseja instalar os Drivers para a placa do Pinguino Agora?"
LangString Q_install_drivers ${LANG_ITALIAN} "Vuoi installare ora i driver per la scheda Pinguino?"
LangString Q_install_drivers ${LANG_FRENCH} "Voulez-vous installer les pilotes USB pour les cartes Pinguino ?"

LangString Q_install_compiler8 ${LANG_ENGLISH} "Do you want to install Pinguino compilers for 8-bits PICs now?"
LangString Q_install_compiler8 ${LANG_SPANISH} "Deseas instalar el compilador Pinguino para PICs de 8-bits ahora?"
LangString Q_install_compiler8 ${LANG_PORTUGUESEBR} "Você deseja instalar o compilador Pinguino para PICs de 8-bits agora?"
LangString Q_install_compiler8 ${LANG_ITALIAN} "Vuoi installare il compilatore per i PIC a 8-bits ora?"
LangString Q_install_compiler8 ${LANG_FRENCH} "Voulez-vous procéder à l'installation du compilateur 8-bit (PIC18F) ?"

LangString Q_install_compiler32 ${LANG_ENGLISH} "Do you want to install Pinguino compilers for 32-bits PICs now?"
LangString Q_install_compiler32 ${LANG_SPANISH} "Deseas instalar el compilador Pinguino para PICs de 32-bits ahora?"
LangString Q_install_compiler32 ${LANG_PORTUGUESEBR} "Você deseja instalar o compilador Pinguino para PICs de 32-bits agora?"
LangString Q_install_compiler32 ${LANG_ITALIAN} "Vuoi installare il compilatore per i PIC a 32-bits ora?"
LangString Q_install_compiler32 ${LANG_FRENCH} "Voulez-vous procéder à l'installation du compilateur 32-bit (PIC32MX) ?"

LangString Q_retry ${LANG_ENGLISH} "Retry ?"
LangString Q_retry ${LANG_SPANISH} "Retry ?"
LangString Q_retry ${LANG_PORTUGUESEBR} "Retry ?"
LangString Q_retry ${LANG_ITALIAN} "Retry ?"
LangString Q_retry ${LANG_FRENCH} "Voulez-vous réessayer ?"

LangString Q_start_pinguinoIDE ${LANG_ENGLISH} "Do you want to start the "

;Errors
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
;Start
;-----------------------------------------------------------------------

Function .onInit

	!insertmacro MUI_LANGDLL_DISPLAY

FunctionEnd

Function un.onInit

	!insertmacro MUI_LANGDLL_DISPLAY

FunctionEnd

;-----------------------------------------------------------------------
; Uninstaller Section
;-----------------------------------------------------------------------

Section "Uninstall"

	;Tipo de instalacion: AllUsers.
	SetShellVarContext all

	;Eliminamos todos los ficheros que instalamos...
	RMDir /r /REBOOTOK "$INSTDIR\"

	Delete "$DESKTOP\pinguino-ide.lnk"
	RMDir /r "$SMPROGRAMS\${FILE_OWNER}\"
	DeleteRegKey /ifempty HKCU "Software\Pinguino"
	DeleteRegKey HKLM "${ADD_REMOVE}"

SectionEnd

;-----------------------------------------------------------------------
; Installer Sections
;-----------------------------------------------------------------------

Section "Install"

	;Default installation folder
	;strCpy $InstallDest '$PROGRAMFILES' 2
	;InstallDir '$InstallDest\${PINGUINO_NAME}

	;Seteamos el directorio de salida para las instrucciones FILE.
	SetOutPath "$INSTDIR"

	;Tipo de instalacion: AllUsers.
	SetShellVarContext all

	;ReadRegStr $0 HKCU "Software\Pinguino" ""
	;IfErrors 0 Done
	;!insertmacro Message "Pinguino $(msg_not_detected)"
	;!insertmacro MUI_PAGE_DIRECTORY

	;Done:
	;!insertmacro Message "Pinguino's path is $0"

	;Detect Architecture and OS...
	Call DetectArchitecture

	;Detect and install Python...
	Call InstallPython

	;Detect and install Python dependencies...
	Call InstallPythonDeps

	;Detect and install PySide...
	Call InstallPySide

	;Get Pinguino last update
	Call InstallPinguino
 
	;Install device drivers...
	MessageBox MB_YESNO|MB_ICONQUESTION "$(Q_install_drivers)" IDNO NoDrivers
	Call InstallLibUSB
	Call InstallPinguinoDrivers

	NoDrivers:

	;Publish the project info to the system...
	Call PublishInfo

	;Make shorcuts...
	Call MakeShortcuts

	;Pinguino post installation ...
	Call InstallPinguinoEnd

	;Create Uninstaller.
	WriteUninstaller "$INSTDIR\pinguino-uninstall.exe"

SectionEnd

;-----------------------------------------------------------------------
;Display a message
;-----------------------------------------------------------------------

!macro Message msg

	DetailPrint "${msg}"
	Sleep 500

!macroend

;-----------------------------------------------------------------------
;Download a file
;-----------------------------------------------------------------------

!macro Download url program

	;!insertmacro Message "${program} $(msg_download_and_install)"
	;Sleep 5000

	Retry:
	inetc::get "${url}/${program}" "$EXEDIR\${program}"
	Pop $R0
	StrCmp $R0 "OK" Complete
	MessageBox MB_YESNO|MB_ICONQUESTION "${program} $(E_downloading) $R0! $(Q_retry)" IDYES Retry
	Abort "${program} $(E_downloading) $R0!"

	Complete:
	!insertmacro Message "${program} $(msg_downloaded)"

!macroend

;-----------------------------------------------------------------------
;Detect the architecture of host system (32 or 64 bits)
;and the Operating System Version.
;-----------------------------------------------------------------------

Function DetectArchitecture

	Var /GLOBAL os_platform
	Var /GLOBAL os_version

	StrCpy $os_platform "x86"
	StrCmp $PROGRAMFILES $PROGRAMFILES64 +2
	StrCpy $os_platform "amd64"

	${If} ${AtLeastWinVista}
		; System is Microsoft Windows Vista or later...
		StrCpy $os_version "Vista"
	${Else}
		; System is Microsoft Windows XP...
		StrCpy $os_version "XP"
	${EndIf}

	!insertmacro Message "$(msg_your_system_is) Microsoft Windows $os_version ($os_platform)."

FunctionEnd

;-----------------------------------------------------------------------
; Python v2.7 detection and installation routine.
;-----------------------------------------------------------------------

Function InstallPython

	Var /GLOBAL Python27
	Var /GLOBAL Python27Path

	ReadRegStr $0 HKLM "SOFTWARE\Python\PythonCore\2.7\InstallPath" ""
	!insertmacro Message "Python v2.7 path is $0"
	IfErrors 0 Done
	!insertmacro Message "Python v2.7 $(msg_not_detected)"

	StrCpy $Python27 'python-${PYTHON_VERSION}.msi'
	StrCmp $PROGRAMFILES $PROGRAMFILES64 +2
	StrCpy $Python27 'python-${PYTHON_VERSION}.amd64.msi'

	!insertmacro Download "https://www.python.org/ftp/python/${PYTHON_VERSION}" "$Python27"

	ExecWait '"msiexec" /i "$EXEDIR\$Python27"' $0
	${if} $0 != "0"
		Abort "Python v2.7 $(E_installing) $0!"
	${endif}
	Delete "$EXEDIR\$Python27"
  
	Done:
	!insertmacro Message "Python v2.7 $(msg_installed)"
	ReadRegStr $0 HKLM "SOFTWARE\Python\PythonCore\2.7\InstallPath" ""
	StrCpy $Python27Path $0

FunctionEnd

;-----------------------------------------------------------------------
; Detect and install LibUSB.
;	MessageBox MB_USERICON|MB_OK "$(please_plug_in_your_board)"
;	MessageBox MB_USERICON|MB_OK "$(switch_to_bootloader_mode)"
;	MessageBox MB_USERICON|MB_OK "$(spot_the_pinguino_boards)"
;-----------------------------------------------------------------------

Function InstallLibUSB

	Var /GLOBAL LibUSB
	Var /GLOBAL LibUSBPath

	ReadRegStr $0 HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\LibUSB-Win32_is1" "Inno Setup: App Path"
	!insertmacro Message "LibUSB path is $0"
	IfErrors 0 Done
	!insertmacro Message "LibUSB $(msg_not_detected)"

    ;LibUSB
    ;StrCpy $LibUSB 'libusb-${LIBUSB_VERSION}-rc1-win.7z'
	;!insertmacro Download "ftp://ftp.heanet.ie/pub/download.sourceforge.net/pub/sourceforge/l/li/libusb/libusb-1.0/libusb-${LIBUSB_VERSION}" "$LibUSB"
	;ClearErrors
	;nsisunz::Unzip "$EXEDIR\$LibUSB" "$INSTDIR\compilers"
	;IfErrors 0 +2
	;	Abort "$(E_extracting) $LibUSB"

	;LibUSB-Win32
	StrCpy $LibUSB 'libusb-win32-devel-filter-${LIBUSBWIN32_VERSION}.exe'
	;!insertmacro Download "https://sourceforge.net/projects/libusb-win32/files/libusb-win32-releases/${LIBUSBWIN32_VERSION}" "$LibUSB"

	;ExecWait '"$EXEDIR\$LibUSB"' $0
	ExecWait '"$INSTDIR\drivers\$LibUSB"' $0
	${if} $0 != "0"
		Abort "LibUSB $(E_installing) $0!"
	${endif}
	;Delete "$EXEDIR\$LibUSB"

	Done:
	!insertmacro Message "LibUSB $(msg_installed)"
	ReadRegStr $R0 HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\LibUSB-Win32_is1\InstallLocation" ""
	StrCpy $LibUSBPath $0

FunctionEnd

;-----------------------------------------------------------------------
; Detect and install PySide.
;-----------------------------------------------------------------------

Function InstallPySide

	Var /GLOBAL PySide

	IfFileExists "$Python27Path\Lib\site-packages\PySide\__init__.py" Done +1
	!insertmacro Message "PySide $(msg_not_detected)"

	StrCpy $PySide 'PySide-${PYSIDE_VERSION}.win32-py2.7.exe'
	StrCmp $PROGRAMFILES $PROGRAMFILES64 +2
	StrCpy $PySide 'PySide-${PYSIDE_VERSION}.win-amd64-py2.7.exe'

	!insertmacro Download "http://download.qt.io/official_releases/pyside/" "$PySide"

	ExecWait '"$EXEDIR\$PySide"' $0
	${if} $0 != "0"
		Abort "PySide $(E_installing) $0!"
	${endif}
	Delete "$EXEDIR\$PySide"

	Done:
	!insertmacro Message "PySide $(msg_installed)"

FunctionEnd

;-----------------------------------------------------------------------
; Pinguino device driver installation with DPINST.
;
; /F     Force install if the driver package is not better than the current one.
; /LM    Legacy mode. Accepts unsigned driver packages and packages with missing
;        files. These packages won't install on the latest version of Windows.
; /SW    Suppresses the Device Installation Wizard, the operating system might
;        still pop-up user dialogs.
; /SA    Suppress the Add/Remove Programs entry normally created for each driver
;        package.
; /PATH  Search for driver packages under the given path.
;-----------------------------------------------------------------------

Function InstallPinguinoDrivers

	SetOutPath "$INSTDIR\drivers"
	File /r "drivers\*.*"
	!insertmacro Message "$(msg_installing_drivers)..."

	nsExec::Exec '$INSTDIR\drivers\DPInst-$os_platform.exe /F /LM /SW /SA /PATH $INSTDIR\drivers\$os_version\'

	ExecWait '"$LibUSBPath\bin\install-filter.exe" install --device=USB\Vid_04D8.Pid_FEAA' $0
	${if} $0 != "0"
		!insertmacro Message "Driver for 8-bit USB Pinguino $(E_installing)"
	${endif}

	ExecWait '"$LibUSBPath\bin\install-filter.exe" install --device=USB\Vid_04D8.Pid_FEAB' $0
	${if} $0 != "0"
		!insertmacro Message "Driver for 8-bit CDC Pinguino $(E_installing)"
	${endif}

	ExecWait '"$LibUSBPath\bin\install-filter.exe" install --device=USB\Vid_04D8.Pid_003C' $0
	${if} $0 != "0"
		!insertmacro Message "Driver for 32-bit USB Pinguino $(E_installing)"
    ${endif}

FunctionEnd

;-----------------------------------------------------------------------
; Detect and install Python dependencies.
;-----------------------------------------------------------------------

Function InstallPythonDeps

	; PIP module detection and installation routine.
	IfFileExists "$Python27Path\Scripts\pip.exe" Wheel +1
	!insertmacro Message "PyPIP $(msg_not_detected)"
	SetOutPath "$TEMP"
	!insertmacro Download "https://bootstrap.pypa.io/" "${PyPIP}"
	ExecWait '"$Python27Path\python" "$TEMP\${PyPIP}"' $0
	${if} $0 != "0"
		Abort "PyPIP $(E_installing) $0!"
	${endif}
	Delete "$TEMP\${PyPIP}"

	; Wheel module detection and installation routine.
	Wheel:
	!insertmacro Message "PyPIP $(msg_installed)"
	IfFileExists "$Python27Path\Scripts\wheel.exe" Soup4 +1
	!insertmacro Message "Wheel $(msg_not_detected)"
	nsExec::Exec '"$Python27Path\Scripts\pip.exe" install wheel'
	Pop $R0
	${if} $R0 != "0"
		Abort "Wheel $(E_installing) $R0!"
	${endif}

	; BeautifullSoup4 module detection and installation routine.
	Soup4:
	!insertmacro Message "Wheel $(msg_installed)"
	IfFileExists "$Python27Path\Lib\site-packages\bs4\__init__.py" GITpython +1
	!insertmacro Message "BeautifullSoup4 $(msg_not_detected)"
	nsExec::Exec '"$Python27Path\Scripts\pip.exe" install beautifulsoup4'
	Pop $R0
	${if} $R0 != "0"
		Abort "beautifulsoup4 $(E_installing) $R0!"
	${endif}

	; GIT for Python module detection and installation routine.
	GITpython:
	!insertmacro Message "BeautifullSoup4 $(msg_installed)"
	IfFileExists "$Python27Path\Lib\site-packages\git\__init__.py" PyUSB +1
	!insertmacro Message "GITpython $(msg_not_detected)"
	nsExec::Exec '"$Python27Path\Scripts\pip.exe" install gitpython'
	Pop $R0
	${if} $R0 != "0"
		Abort "GIT-Python $(E_installing) $R0!"
	${endif}

	; PyUSB module detection and installation routine.
	PyUSB:
	!insertmacro Message "GITpython $(msg_installed)"
	IfFileExists "$Python27Path\Lib\site-packages\usb\__init__.py" PythonDepsAllreadyInstalled +1
	!insertmacro Message "PyUSB $(msg_not_detected)"
	nsExec::Exec '"$Python27Path\Scripts\pip.exe" install pyusb==1.0.0b1'
	Pop $R0
	${if} $R0 != "0"
		Abort "PyUSB $(E_installing) $R0!"
	${endif}

	PythonDepsAllreadyInstalled:
	!insertmacro Message "PyUSB $(msg_installed)"

FunctionEnd

;-----------------------------------------------------------------------
; get pinguino last update
;-----------------------------------------------------------------------

Function InstallPinguino

	Var /GLOBAL pinguino_actual_version
	Var /GLOBAL pinguino_last_version

	;get the installed version
	FileOpen  $0 "$INSTDIR\update" r

	IfErrors 0 +3                          
	StrCpy $pinguino_actual_version 'unknown'
	Goto GetLastVersion

	FileRead  $0 $pinguino_actual_version
	FileClose $0
	!insertmacro Message "Pinguino last update $pinguino_actual_version"

	GetLastVersion:
	;get the latest version

	!insertmacro Download "${SourceForge}" "update"
	FileOpen  $0 "$EXEDIR\update" r
	IfErrors Download
	FileRead  $0 $pinguino_last_version
	FileClose $0
	!insertmacro Message "Pinguino available update $pinguino_last_version"

	;compare the 2 versions
	StrCmp $pinguino_actual_version $pinguino_last_version UpToDate 0

	Download:

	IfFileExists "$INSTDIR\update" 0 +2
	Delete "$INSTDIR\update"
	Rename "$EXEDIR\update" "$INSTDIR\update"
	!insertmacro Message "A new version ($pinguino_last_version) of Pinguino is available ..."
	MessageBox MB_YESNO|MB_ICONQUESTION "A new version ($pinguino_last_version) of Pinguino is available ..." IDNO Compiler

	Call InstallPinguinoIde
	Call InstallPinguinoLibraries

	UpToDate:
	!insertmacro Message "$(msg_uptodate)"
	MessageBox MB_OK|MB_ICONINFORMATION "$(msg_uptodate)"
    
    Compiler:

	;Install 8-bits Pinguino compiler package...
	MessageBox MB_YESNO|MB_ICONQUESTION "$(Q_install_compiler8)" IDNO NoCompiler8
	Call InstallPinguinoCompiler8

	NoCompiler8:

	;Install 32-bits Pinguino compiler package...
	MessageBox MB_YESNO|MB_ICONQUESTION "$(Q_install_compiler32)" IDNO NoCompiler32
	Call InstallPinguinoCompiler32

	NoCompiler32:

FunctionEnd

;-----------------------------------------------------------------------
; pinguino-ide installation routine.
;-----------------------------------------------------------------------

Function InstallPinguinoIde

	!insertmacro Download "${SourceForge}" "${pinguino-ide}"

	ClearErrors
	nsisunz::Unzip "$EXEDIR\${pinguino-ide}" "$INSTDIR\.."
	IfErrors 0 +2
		Abort "$(E_extracting) ${pinguino-ide}"
	ClearErrors
	!insertmacro Message "${pinguino-ide} $(msg_installed)"

	Delete "$EXEDIR\${pinguino-ide}"
	!insertmacro Message "${pinguino-ide} $(msg_deleted)"
    
FunctionEnd

;-----------------------------------------------------------------------
; pinguino-libraries installation routine.
;-----------------------------------------------------------------------

Function InstallPinguinoLibraries

	!insertmacro Download "${SourceForge}" "${pinguino-libraries}"

	ClearErrors
	nsisunz::Unzip "$EXEDIR\${pinguino-libraries}" "$INSTDIR\.."
	IfErrors 0 +2
		Abort "$(E_extracting) ${pinguino-libraries}"
	ClearErrors
	!insertmacro Message "${pinguino-libraries} $(msg_installed)"

	Delete "$EXEDIR\${pinguino-libraries}"
	!insertmacro Message "${pinguino-libraries} $(msg_deleted)"

FunctionEnd

;-----------------------------------------------------------------------
; pinguino-compilers installation routine.
;-----------------------------------------------------------------------

Function InstallPinguinoCompiler8

	CreateDirectory "$INSTDIR\compilers"

	Var /GLOBAL compiler8
	StrCpy $compiler8 ${pinguino-compiler32-8bits}
	StrCmp $os_platform "x86" +2
	StrCpy $compiler8 ${pinguino-compiler64-8bits}

	!insertmacro Download "${SourceForge}" "$compiler8"

	ClearErrors
	nsisunz::Unzip "$EXEDIR\$compiler8" "$INSTDIR\compilers"
	IfErrors 0 +2
		Abort "$(E_extracting) $compiler8"
	!insertmacro Message "$compiler8 $(msg_installed)"

	Delete "$EXEDIR\$compiler8"
	!insertmacro Message "$compiler8 $(msg_deleted)"

FunctionEnd

;-----------------------------------------------------------------------
; 32-bits Pinguino compilers installation routine.
;-----------------------------------------------------------------------

Function InstallPinguinoCompiler32

	CreateDirectory "$INSTDIR\compilers"

	Var /GLOBAL compiler32
	StrCpy $compiler32 ${pinguino-compiler32-32bits}
	StrCmp $os_platform "x86" +2
	StrCpy $compiler32 ${pinguino-compiler64-32bits}

	!insertmacro Download "${SourceForge}" "$compiler32"

	ClearErrors
	nsisunz::Unzip "$EXEDIR\$compiler32" "$INSTDIR\compilers"
	IfErrors 0 +2
		Abort "$(E_extracting) $compiler32"
	!insertmacro Message "$compiler32 $(msg_installed)"

	Delete "$EXEDIR\$compiler32"
	!insertmacro Message "$compiler32 $(msg_deleted)"

FunctionEnd

;-----------------------------------------------------------------------
; Software installation info publish routine.
;-----------------------------------------------------------------------

Function PublishInfo

	!insertmacro Message "Writing Register Database ..."
	WriteRegStr HKCU "Software\Pinguino" "" "$INSTDIR"
	WriteRegStr HKLM "${ADD_REMOVE}" "DisplayName" "${PINGUINO_NAME} v${PINGUINO_VERSION}"
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
	!insertmacro Message "Adding shortcut ..."
	File "/oname=$INSTDIR\pinguino11.ico" pinguino11.ico

	CreateShortCut "$DESKTOP\pinguino-ide.lnk" "$INSTDIR\pinguino.bat" "" "$INSTDIR\pinguino11.ico"
	CreateDirectory "$SMPROGRAMS\${FILE_OWNER}\"
	CreateShortCut "$SMPROGRAMS\${FILE_OWNER}\pinguino-ide.lnk" "$INSTDIR\pinguino.bat" "" "$INSTDIR\pinguino11.ico"

FunctionEnd

;-----------------------------------------------------------------------
; Software Post Install routine.
;-----------------------------------------------------------------------

Function InstallPinguinoEnd

	;Update pinguino.bat
	!insertmacro Message "Updating pinguino.bat ..."
	FileOpen  $0 "$INSTDIR\pinguino.bat" w
	FileWrite $0 "@ECHO OFF"
	FileWrite $0 "$\r$\n"
	FileWrite $0 "CD $INSTDIR\"
	FileWrite $0 "$\r$\n"
	FileWrite $0 "$Python27Path\python pinguino.py"
	FileWrite $0 "$\r$\n"
	FileClose $0

	;Update pinguino conf...
	!insertmacro Message "Updating pinguino.conf ..."
	Delete "$INSTDIR\user\pinguino.conf"
	FileOpen  $0 "$INSTDIR\qtgui\config\pinguino.windows.conf" w
	IfErrors Done
	FileWrite $0 "[Paths]"
	FileWrite $0 "$\r$\n"
	FileWrite $0 "sdcc_bin = $INSTDIR\compilers\p8\bin\"
	FileWrite $0 "$\r$\n"
	FileWrite $0 "gcc_bin = $INSTDIR\compilers\p32\bin\"
	FileWrite $0 "$\r$\n"
	FileWrite $0 "pinguino_8_libs = $INSTDIR\p8\"
	FileWrite $0 "$\r$\n"
	FileWrite $0 "pinguino_32_libs = $INSTDIR\p32\"
	FileWrite $0 "$\r$\n"
	FileClose $0

	;Update pinguino path...
	!insertmacro Message "Updating pinguino path ..."
	FileOpen  $0 "$INSTDIR\paths.cfg" w
	IfErrors Done
	FileWrite $0 "[paths-windows]"
	FileWrite $0 "$\r$\n"
	FileWrite $0 "install_path = $INSTDIR\"
	FileWrite $0 "$\r$\n"
	FileWrite $0 "user_path = $INSTDIR\user"
	FileWrite $0 "$\r$\n"
	FileClose $0

	;Execute pinguino-ide post_install routine...
	ExecWait '"$Python27Path\python" "$INSTDIR\post_install.py"' $0

    Done:
	${if} $0 != "0"
		Abort "post_install $(E_installing) $0!"
	${endif}

FunctionEnd

;-----------------------------------------------------------------------
; Launch Pinguino IDE
;-----------------------------------------------------------------------

Function LaunchPinguinoIDE

	ExecShell "" "$INSTDIR\pinguino.bat"

FunctionEnd
