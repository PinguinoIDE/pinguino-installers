;------------------------------------------------------------------------------
;Pinguino IDE Installation Script
;Public Domain License 2014
;b1 to b3 : Coded by Victor Villarreal <mefhigoseth@gmail.com>
;b4 to b5 : Regis Blanchot <rblanchot@pinguino.cc>
;Translated to Portuguese-BR by Wagner de Queiroz <wagnerdequeiroz@gmail.com>
;Translated to Italian by Pasquale Fersini <basquale.fersini@gmail.com>
;Translated to French by Regis Blanchot <rblanchot@pinguino.cc>
;------------------------------------------------------------------------------

;--------------------------------
;Defines

!define PINGUINO_VERSION '11'
!define INSTALLER_VERSION '1.1.5.1'
!define PYTHON_VERSION '2.7.10'
!define PYSIDE_VERSION '1.2.2'
!define LIBUSB_VERSION '1.0.19'

!define PINGUINO_NAME 'pinguino'
!define INSTALLER_NAME '${PINGUINO_NAME}_v${PINGUINO_VERSION}-setup'
!define FILE_OWNER 'Pinguino Project'
!define FILE_URL 'http://www.pinguino.cc/'
!define MUI_ABORTWARNING
!define MUI_ICON "pinguino-logo-v2.ico"
!define MUI_UNICON "pinguino-logo-v2.ico"
!define MUI_INSTFILESPAGE_PROGRESSBAR "smooth"
!define MUI_WELCOMEFINISHPAGE_BITMAP "Pinguino-welcomePage.bmp"
!define MUI_UNWELCOMEFINISHPAGE_BITMAP "Pinguino-welcomePage.bmp"
!define ADD_REMOVE "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PINGUINO_NAME}"
!define PyPIP "get-pip.py"
!define SourceForge "http://downloads.sourceforge.net/pinguinoide"
!define pinguino-ide "pinguino-ide.zip"
!define pinguino-libraries "pinguino-libraries.zip"
!define pinguino-compiler32-8bits "pinguino-windows32-sdcc-mpic16.zip"
!define pinguino-compiler64-8bits "pinguino-windows64-sdcc-mpic16.zip"
!define pinguino-compiler32-32bits "pinguino-windows32-gcc-mips-elf.zip"
!define pinguino-compiler64-32bits "pinguino-windows64-gcc-mips-elf.zip"
!define libusb "libusb-win32-devel-filter-${LIBUSB_VERSION}"

;--------------------------------
;Includes

!include "MUI2.nsh"
!include "FileFunc.nsh"
!include "WinVer.nsh"
;!include "LogicLib.nsh"

;--------------------------------
;General Settings

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

;--------------------------------
;Pages

!insertmacro MUI_PAGE_WELCOME
;!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_UNPAGE_WELCOME
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_UNPAGE_FINISH

;--------------------------------
;Languages

!insertmacro MUI_LANGUAGE "English"
!insertmacro MUI_LANGUAGE "Spanish"
!insertmacro MUI_LANGUAGE "PortugueseBR"
!insertmacro MUI_LANGUAGE "Italian"
!insertmacro MUI_LANGUAGE "French"

Function .onInit

  !insertmacro MUI_LANGDLL_DISPLAY

FunctionEnd

Function un.onInit

  !insertmacro MUI_LANGDLL_DISPLAY

FunctionEnd

LangString msg_not_detected ${LANG_ENGLISH} "not detected in your system. Installing it..."
LangString msg_not_detected ${LANG_SPANISH} "no detectado en el sistema. Instalando..."
LangString msg_not_detected ${LANG_PORTUGUESEBR} "não foi detectado em seu sistema. Instalando..."
LangString msg_not_detected ${LANG_ITALIAN} "non trovato nel tuo sistema. Lo sto installando..."
LangString msg_not_detected ${LANG_FRENCH} "n'est pas installé sur votre système."

LangString msg_download_and_install ${LANG_ENGLISH} "We'll install it for you, in 5 secs."
LangString msg_download_and_install ${LANG_SPANISH} "Lo instalaremos por ti, en 5 segundos."
LangString msg_download_and_install ${LANG_PORTUGUESEBR} "Nós instalaremos para você, em 5 segundos."
LangString msg_download_and_install ${LANG_ITALIAN} "Lo installeremo per te, in 5 secondi."
LangString msg_download_and_install ${LANG_FRENCH} "L'installation débutera dans 5 secondes."

LangString msg_installed ${LANG_ENGLISH} "installed."
LangString msg_installed ${LANG_SPANISH} "instalado correctamente."
LangString msg_installed ${LANG_PORTUGUESEBR} "Instalado."
LangString msg_installed ${LANG_ITALIAN} "Installato."
LangString msg_installed ${LANG_FRENCH} "installé."

LangString msg_not_installed ${LANG_ENGLISH} "not installed. Error code was:"
LangString msg_not_installed ${LANG_SPANISH} "no instalado. El error fue:"
LangString msg_not_installed ${LANG_PORTUGUESEBR} "não instalado. o erro foi:"
LangString msg_not_installed ${LANG_ITALIAN} "non installato. L'errore è:"
LangString msg_not_installed ${LANG_FRENCH} "n'a pu être installé. Erreur:"

LangString msg_download_complete ${LANG_ENGLISH} "download complete."
LangString msg_download_complete ${LANG_SPANISH} "descargado correctamente."
LangString msg_download_complete ${LANG_PORTUGUESEBR} "download completo."
LangString msg_download_complete ${LANG_ITALIAN} "download completato."
LangString msg_download_complete ${LANG_FRENCH} "téléchargé."

LangString msg_download_error ${LANG_ENGLISH} "download failed. Error was:"
LangString msg_download_error ${LANG_SPANISH} "no se pudo descargar. El error fue:"
LangString msg_download_error ${LANG_PORTUGUESEBR} "o download falhou. que pena!, o erro foi:"
LangString msg_download_error ${LANG_ITALIAN} "Il download è fallito. L'errore è:"
LangString msg_download_error ${LANG_FRENCH} "n'a pu être téléchargé. Erreur :"

LangString msg_error_while_extracting ${LANG_ENGLISH} "An error occur while extracting files from"
LangString msg_error_while_extracting ${LANG_SPANISH} "Se ha producido un error mientras se descomprimia"
LangString msg_error_while_extracting ${LANG_PORTUGUESEBR} "Houve uma falha no processo de extração de arquivos."
LangString msg_error_while_extracting ${LANG_ITALIAN} "Si e' verificato un errore durante l'estrazione dei file da"
LangString msg_error_while_extracting ${LANG_FRENCH} "Erreur pendant la décompression des fichiers."

LangString msg_error_while_copying ${LANG_ENGLISH} "An error occur while copying files to"
LangString msg_error_while_copying ${LANG_SPANISH} "Se ha producido un error mientras se copiaban los archivos en el directorio"
LangString msg_error_while_copying ${LANG_PORTUGUESEBR} "Um erro ocorreu durante a copia de arquivos para o diretório"
LangString msg_error_while_copying ${LANG_ITALIAN} "Si e' verificato un errore durante la copia dei file in"
LangString msg_error_while_copying ${LANG_FRENCH} "Erreur lors de la copie des fichiers dans"

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

LangString do_you_want_install_device_drivers ${LANG_ENGLISH} "Do you want to install the device drivers for pinguino-board now?"
LangString do_you_want_install_device_drivers ${LANG_SPANISH} "Deseas instalar los drivers para la placa Pinguino ahora?"
LangString do_you_want_install_device_drivers ${LANG_PORTUGUESEBR} "Você deseja instalar os Drivers para a placa do Pinguino Agora?"
LangString do_you_want_install_device_drivers ${LANG_ITALIAN} "Vuoi installare ora i driver per la scheda Pinguino?"
LangString do_you_want_install_device_drivers ${LANG_FRENCH} "Voulez-vous installer les pilotes USB pour les cartes Pinguino ?"

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

LangString spot_the_pinguino_boards ${LANG_ENGLISH} "3-."
LangString spot_the_pinguino_boards ${LANG_SPANISH} " "
LangString spot_the_pinguino_boards ${LANG_PORTUGUESEBR} " "
LangString spot_the_pinguino_boards ${LANG_ITALIAN} ""
LangString spot_the_pinguino_boards ${LANG_FRENCH} "3-A la fin de l'installation de LibUSB, choisissez :\r\n[x] Launch Filer Intaller Wizard\r\npuis\r\nInstall Device Filter."

LangString spot_the_pinguino_boards ${LANG_ENGLISH} "4-You'll be presented a list of USB Devices connected to your computer, spot and select your Pinguino board (Vendor ID 0x04D8 (Microchip), Product ID 0xFEAA (8-bit) and/or 0x003C (32-bit) and press OK to proceed the installation."
LangString spot_the_pinguino_boards ${LANG_SPANISH} " "
LangString spot_the_pinguino_boards ${LANG_PORTUGUESEBR} " "
LangString spot_the_pinguino_boards ${LANG_ITALIAN} ""
LangString spot_the_pinguino_boards ${LANG_FRENCH} "4-Dans la liste des périphériques USB connectés à votre ordinateur qui va vous être présentée par la suite, repérez et sélectionnez votre carte Pinguino (Vendor ID 0x04D8 (Microchip), Product ID 0xFEAA (8-bit) et/ou 0x003C (32-bit) puis pressez le bouton OK pour procéder à l'installation des pilotes."

LangString remember_install_manually_later ${LANG_ENGLISH} "Rememeber to install manually the ${libusb} package after you connect your board the first time."
LangString remember_install_manually_later ${LANG_SPANISH} "Recuerda que deberas ejecutar el paquete ${libusb} manualmente, luego de conectar la placa por primera vez."
LangString remember_install_manually_later ${LANG_PORTUGUESEBR} "Lembre-se de instalar manualmente o pacote ${libusb}, após conectar a sua placa pela primeira vez."
LangString remember_install_manually_later ${LANG_ITALIAN} "Ricordati di installare manualmente il pacchetto ${libusb}, prima di connettere la scheda per la prima volta."
LangString remember_install_manually_later ${LANG_FRENCH} "N'oubliez pas d'installer ${libusb} après la première connexion de votre carte."

LangString do_you_want_install_compilers_8bits ${LANG_ENGLISH} "Do you want to install Pinguino compilers for 8-bits PICs now?"
LangString do_you_want_install_compilers_8bits ${LANG_SPANISH} "Deseas instalar el compilador Pinguino para PICs de 8-bits ahora?"
LangString do_you_want_install_compilers_8bits ${LANG_PORTUGUESEBR} "Você deseja instalar o compilador Pinguino para PICs de 8-bits agora?"
LangString do_you_want_install_compilers_8bits ${LANG_ITALIAN} "Vuoi installare il compilatore per i PIC a 8-bits ora?"
LangString do_you_want_install_compilers_8bits ${LANG_FRENCH} "Voulez-vous procéder à l'installation du compilateur 8-bit (PIC18F) ?"

LangString do_you_want_install_compilers_32bits ${LANG_ENGLISH} "Do you want to install Pinguino compilers for 32-bits PICs now?"
LangString do_you_want_install_compilers_32bits ${LANG_SPANISH} "Deseas instalar el compilador Pinguino para PICs de 32-bits ahora?"
LangString do_you_want_install_compilers_32bits ${LANG_PORTUGUESEBR} "Você deseja instalar o compilador Pinguino para PICs de 32-bits agora?"
LangString do_you_want_install_compilers_32bits ${LANG_ITALIAN} "Vuoi installare il compilatore per i PIC a 32-bits ora?"
LangString do_you_want_install_compilers_32bits ${LANG_FRENCH} "Voulez-vous procéder à l'installation du compilateur 32-bit (PIC32MX) ?"

;------------------------------------------------------------------------
; Installer Sections
Section "Install"

  ;Default installation folder
  ;strCpy $InstallDest '$PROGRAMFILES' 2
  ;InstallDir '$InstallDest\${PINGUINO_NAME}

  ;Seteamos el directorio de salida para las instrucciones FILE.
  SetOutPath "$INSTDIR"
  
  ;Tipo de instalacion: AllUsers.
  SetShellVarContext all

  ; Detect and install Python...
  Call InstallPython

  ; Detect and install Python dependencies...
  Call InstallPythonDeps

  ; Detect and install PySide...
  Call InstallPySide

  ;Install pinguino-ide package...
  Call InstallPinguinoIde

  ;Install pinguino-libraries package...
  Call InstallPinguinoLibraries

  ;Detect the Architecture and O.S. Version...
  Call DetectArchitecture

  MessageBox MB_YESNO|MB_ICONQUESTION "$(do_you_want_install_compilers_8bits)" IDNO withoutCompilers-8bits

  ;Install 8-bits Pinguino compiler package...
  Call InstallPinguinoCompilers-8bits

  withoutCompilers-8bits:
  MessageBox MB_YESNO|MB_ICONQUESTION "$(do_you_want_install_compilers_32bits)" IDNO withoutCompilers-32bits

  ;Install 32-bits Pinguino compiler package...
  Call InstallPinguinoCompilers-32bits

  withoutCompilers-32bits:

  ;Install device drivers...
  Call InstallDrivers

  ;Publish the project info to the system...
  Call PublishInfo
  
  ;Make shorcuts...
  Call MakeShortcuts

  ;Creamos el Unistaller.
  WriteUninstaller "$INSTDIR\pinguino-uninstall.exe"

SectionEnd

;------------------------------------------------------------------------
; Uninstaller Section
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

;------------------------------------------------------------------------
; Python v2.7 detection and installation routine.
Function InstallPython

	IfFileExists "C:\Python27\python.exe" PythonAllreadyInstalled +1
	DetailPrint "Python v2.7 $(msg_not_detected)"
	Sleep 5000

	Var /GLOBAL Python27

    StrCpy $Python27 'python-${PYTHON_VERSION}.msi'
	StrCmp $PROGRAMFILES $PROGRAMFILES64 +2
	StrCpy $Python27 'python-${PYTHON_VERSION}.amd64.msi'
  
	inetc::get "https://www.python.org/ftp/python/${PYTHON_VERSION}/$Python27" "$EXEDIR\$Python27"

	ExecWait '"msiexec" /i "$EXEDIR\$Python27"' $0
	${if} $0 != "0"
		Abort "Python v2.7 $(msg_not_installed) $0!"
	${endif}
	DetailPrint "Python v2.7 $(msg_installed)"
	Delete "$EXEDIR\$Python27"
  
	PythonAllreadyInstalled:
FunctionEnd

;------------------------------------------------------------------------
; Detect and install PySide.
Function InstallPySide

	IfFileExists "C:\Python27\Lib\site-packages\PySide\__init__.py" PySideAllreadyInstalled +1
	DetailPrint "PySide $(msg_not_detected)"
	Sleep 5000

	Var /GLOBAL PySide

	StrCpy $PySide 'PySide-${PYSIDE_VERSION}.win32-py2.7.exe'
	StrCmp $PROGRAMFILES $PROGRAMFILES64 +2
	StrCpy $PySide 'PySide-${PYSIDE_VERSION}.win-amd64-py2.7.exe'

	inetc::get "https://download.qt.io/official_releases/pyside/$PySide" "$EXEDIR\$PySide"

	ExecWait '"$EXEDIR\$PySide"' $0
	${if} $0 != "0"
		Abort "PySide $(msg_not_installed) $0!"
	${endif}
	Delete "$EXEDIR\$PySide"

	PySideAllreadyInstalled:
FunctionEnd

;------------------------------------------------------------------------
; Detect and install Python dependencies.
Function InstallPythonDeps

	; PIP module detection and installation routine.
	PyPIP:
		IfFileExists "C:\Python27\Scripts\pip.exe" Wheel +1
		DetailPrint "PyPIP $(msg_not_detected)"
		Sleep 5000
		SetOutPath "$TEMP"
		File "${PyPIP}"
		ExecWait '"C:\Python27\python" "$TEMP\get-pip.py"' $0
		${if} $0 != "0"
			Abort "PyPIP $(msg_not_installed) $0!"
		${endif}
		Delete "$TEMP\${PyPIP}"

	; Wheel module detection and installation routine.
	Wheel:
		IfFileExists "C:\Python27\Scripts\wheel.exe" Soup4 +1
		DetailPrint "Wheel $(msg_not_detected)"
		nsExec::Exec '"C:\Python27\Scripts\pip.exe" install wheel'
		Pop $R0
		${if} $R0 != "0"
			Abort "Wheel $(msg_not_installed) $R0!"
		${endif}

	; BeautifullSoup4 module detection and installation routine.
	Soup4:
		IfFileExists "C:\Python27\Lib\site-packages\bs4\__init__.py" GITpython +1
		DetailPrint "BeautifullSoup4 $(msg_not_detected)"
		nsExec::Exec '"C:\Python27\Scripts\pip.exe" install beautifulsoup4'
		Pop $R0
		${if} $R0 != "0"
			Abort "beautifulsoup4 $(msg_not_installed) $R0!"
		${endif}

	; GIT for Python module detection and installation routine.
	GITpython:
		IfFileExists "C:\Python27\Lib\site-packages\git\__init__.py" PyUSB +1
		DetailPrint "GITpython $(msg_not_detected)"
		nsExec::Exec '"C:\Python27\Scripts\pip.exe" install gitpython'
		Pop $R0
		${if} $R0 != "0"
			Abort "GIT-Python $(msg_not_installed) $R0!"
		${endif}
	
	; PyUSB module detection and installation routine.
	PyUSB:
		IfFileExists "C:\Python27\Lib\site-packages\usb\__init__.py" PythonDepsAllreadyInstalled +1
		DetailPrint "PyUSB $(msg_not_detected)"
		nsExec::Exec '"C:\Python27\Scripts\pip.exe" install pyusb==1.0.0b1'
		Pop $R0
		${if} $R0 != "0"
			Abort "PyUSB $(msg_not_installed) $R0!"
		${endif}
	
	PythonDepsAllreadyInstalled:
FunctionEnd

;------------------------------------------------------------------------
; pinguino-ide installation routine.
Function InstallPinguinoIde

	DetailPrint "pinguino-ide: $(msg_download_and_install)"
	Sleep 5000

	IfFileExists "$EXEDIR\${pinguino-ide}" pinguinoIDEDownloaded
	pinguinoIDEretry:
	inetc::get "${SourceForge}/${pinguino-ide}" "$EXEDIR\${pinguino-ide}"
	Pop $R0
	StrCmp $R0 "OK" pinguinoIDEDownloaded
	MessageBox MB_YESNO|MB_ICONQUESTION "pinguino-ide $(msg_download_error) $R0! Retry?" IDYES pinguinoIDEretry
	Abort "pinguino-ide $(msg_download_error) $R0!"

	pinguinoIDEDownloaded:
	DetailPrint "pinguino-ide $(msg_download_complete)"

	ClearErrors
	nsisunz::Unzip "$EXEDIR\${pinguino-ide}" "C:\"
	IfErrors 0 +2
		Abort "$(msg_error_while_extracting) ${pinguino-ide}"
	ClearErrors

	DetailPrint "pinguino-ide $(msg_installed)"
FunctionEnd

;--------------------------------------------------------------------------
; pinguino-libraries installation routine.
Function InstallPinguinoLibraries

	DetailPrint "pinguino-libraries: $(msg_download_and_install)"
	Sleep 5000

	IfFileExists "$EXEDIR\${pinguino-libraries}" +6 +1
	inetc::get "${SourceForge}/${pinguino-libraries}" "$EXEDIR\${pinguino-libraries}"
	Pop $R0
	StrCmp $R0 "OK" +2
	Abort "pinguino-libraries $(msg_download_error) $R0!"
	DetailPrint "pinguino-libraries $(msg_download_complete)"

	ClearErrors
	nsisunz::Unzip "$EXEDIR\${pinguino-libraries}" "C:\"
	IfErrors 0 +2
		Abort "$(msg_error_while_extracting) ${pinguino-libraries}"

	ClearErrors

	DetailPrint "pinguino-libraries $(msg_installed)"
FunctionEnd

;---------------------------------------------------------------------
;Detect the architecture of host system (32 or 64 bits)
;and the Operating System Version.
Function DetectArchitecture

	Var /GLOBAL os_platform
	StrCpy $os_platform "x86"
	StrCmp $PROGRAMFILES $PROGRAMFILES64 +2
	StrCpy $os_platform "amd64"

	Var /GLOBAL os_version

	${If} ${AtLeastWinVista}
		; System is Microsoft Windows Vista or later...
		StrCpy $os_version "Vista"
	${Else}
		; System is Microsoft Windows XP...
		StrCpy $os_version "XP"
	${EndIf}

	DetailPrint "$(msg_your_system_is) Microsoft Windows $os_version ($os_platform)."
FunctionEnd

;------------------------------------------------------------------------
; pinguino-compilers installation routine.
Function InstallPinguinoCompilers-8bits

	DetailPrint "pinguino-compiler-8bits: $(msg_download_and_install)"
	Sleep 5000
	CreateDirectory "$INSTDIR\compilers"

	Var /GLOBAL compiler_8bits
	StrCpy $compiler_8bits ${pinguino-compiler32-8bits}
	StrCmp $os_platform "x86" +2
	StrCpy $compiler_8bits ${pinguino-compiler64-8bits}

	IfFileExists "$EXEDIR\$compiler_8bits" +6 +1
	inetc::get "${SourceForge}/$compiler_8bits" "$EXEDIR\$compiler_8bits"
	Pop $R0
	StrCmp $R0 "OK" +2
	Abort "pinguino-compilers-8bits $(msg_download_error) $R0!"
	DetailPrint "pinguino-compilers-8bits $(msg_download_complete)"

	ClearErrors
	nsisunz::Unzip "$EXEDIR\$compiler_8bits" "$INSTDIR\compilers"
	IfErrors 0 +2
		Abort "$(msg_error_while_extracting) $compiler_8bits"

FunctionEnd

;------------------------------------------------------------------------
; 32-bits Pinguino compilers installation routine.
Function InstallPinguinoCompilers-32bits

	DetailPrint "pinguino-compiler-32bits: $(msg_download_and_install)"
	Sleep 5000
	CreateDirectory "$INSTDIR\compilers"

	Var /GLOBAL compiler_32bits
	StrCpy $compiler_32bits ${pinguino-compiler32-32bits}
	StrCmp $os_platform "x86" +2
	StrCpy $compiler_32bits ${pinguino-compiler64-32bits}

	IfFileExists "$EXEDIR\$compiler_32bits" +6 +1
	inetc::get "${SourceForge}/$compiler_32bits" "$EXEDIR\$compiler_32bits"
	Pop $R0
	StrCmp $R0 "OK" +2
	Abort "pinguino-compilers-32bits $(msg_download_error) $R0!"
	DetailPrint "pinguino-compilers-32bits $(msg_download_complete)"

	ClearErrors
	nsisunz::Unzip "$EXEDIR\$compiler_32bits" "$INSTDIR\compilers"
	IfErrors 0 +2
		Abort "$(msg_error_while_extracting) $compiler_32bits"

FunctionEnd

;------------------------------------------------------------------------
; Software installation info publish routine.
Function PublishInfo

  ;Publish info for the "Add & Remove Software" system tool...
  DetailPrint "PublishInfo begin..."
  WriteRegStr HKCU "Software\Pinguino" "" "$INSTDIR\v${PINGUINO_VERSION}"
  WriteRegStr HKLM "${ADD_REMOVE}" "DisplayName" "${PINGUINO_NAME} v${PINGUINO_VERSION}"
  WriteRegStr HKLM "${ADD_REMOVE}" "UninstallString" "$\"$INSTDIR\pinguino-uninstall.exe$\""
  WriteRegStr HKLM "${ADD_REMOVE}" "QuietUninstallString" "$\"$INSTDIR\pinguino-uninstall.exe$\" /S"
  WriteRegStr HKLM "${ADD_REMOVE}" "HelpLink" "${FILE_URL}"
  WriteRegStr HKLM "${ADD_REMOVE}" "URLInfoAbout" "${FILE_URL}"
  WriteRegStr HKLM "${ADD_REMOVE}" "Publisher" "${FILE_OWNER}"
FunctionEnd

;------------------------------------------------------------------------
; Software shortcuts install routine.
Function MakeShortcuts

  ;Make shortcuts into desktop and start menu to our program...
  DetailPrint "MakeShortcuts begin..."
  File "/oname=$INSTDIR\pinguino-logo-v2.ico" pinguino-logo-v2.ico
  CreateShortCut "$DESKTOP\pinguino-ide.lnk" "$INSTDIR\pinguino.bat" "" "$INSTDIR\pinguino-logo-v2.ico"
  CreateDirectory "$SMPROGRAMS\${FILE_OWNER}\"
  CreateShortCut "$SMPROGRAMS\${FILE_OWNER}\pinguino-ide.lnk" "$INSTDIR\pinguino.bat" "" "$INSTDIR\pinguino-logo-v2.ico"

  ;Execute pinguino-ide post_install routine...
	ExecWait '"C:\Python27\python" "$INSTDIR\post_install.py"' $0
	${if} $0 != "0"
		Abort "post_install $(msg_not_installed) $0!"
	${endif}

FunctionEnd

;------------------------------------------------------------------------
; Pinguino device driver pre-installation and LibUSB routine.
Function InstallDrivers

	SetOutPath "$INSTDIR\drivers"
	File /r "drivers\*.*"
	DetailPrint "$(msg_installing_drivers)..."

	; Pinguino device driver install routine...
	nsExec::Exec '$INSTDIR\drivers\DPInst-$os_platform.exe /F /LM /SW /SA /PATH $INSTDIR\drivers\$os_version\'

	MessageBox MB_YESNO|MB_ICONQUESTION "$(do_you_want_install_device_drivers)" IDNO withoutBoard
    
	inetc::get "ftp://ftp.heanet.ie/pub/download.sourceforge.net/pub/sourceforge/l/li/libusb/libusb-1.0/libusb-${LIBUSB_VERSION}/libusb-${LIBUSB_VERSION}-win.7z" "$EXEDIR\${libusb}"

	ExecWait '"$EXEDIR\${libusb}"' $0
	${if} $0 != "0"
		Abort "LibUSB $(msg_not_installed) $0!"
	${endif}
	Delete "$EXEDIR\${libusb}"

	MessageBox MB_USERICON|MB_OK "$(please_plug_in_your_board)"
	MessageBox MB_USERICON|MB_OK "$(switch_to_bootloader_mode)"
	MessageBox MB_USERICON|MB_OK "$(spot_the_pinguino_boards)"

	; LibUSB libraries installation routine... Needed only for XP.
	;StrCmp $os_version "Vista" Done
	ExecWait '"$INSTDIR\drivers\LibUSB\${libusb}"' $0
	${if} $0 != "0"
		Abort "LibUSB $(msg_not_installed) $0!"
	${endif}

	Return

	withoutBoard:
		MessageBox MB_ICONEXCLAMATION|MB_OK "$(remember_install_manually_later)"
	Done:
FunctionEnd
