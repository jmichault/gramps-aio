;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Gramps - a GTK+/GNOME based genealogy program
;
; This program is free software; you can redistribute it and/or modify
; it under the terms of the GNU General Public License as published by
; the Free Software Foundation; either version 2 of the License, or
; (at your option) any later version.
;
; This program is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU General Public License for more details.
;
; You should have received a copy of the GNU General Public License
; along with this program; if not, write to the Free Software
; Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
;
;Copyright (C) 2013-2021      Josip (pisoj), Paul Culley
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

!define APPNAME "GrampsAIO64"
!define APPVERSION "5.1.5"
!define APPBUILD "1"
!define APPNAMEANDVERSION "${APPNAME} ${APPVERSION}"
!define APP_PUBLISHER "The Gramps project"
!define APP_WEB_SITE "https://gramps-project.org"
BrandingText "Version ${APPVERSION}-${APPBUILD} -- a new maintenance release"

; Main Install settings
Name "${APPNAME}-${APPVERSION}-${APPBUILD}"
OutFile "GrampsAIO-${APPVERSION}-${APPBUILD}_win64.exe"

CRCCheck on
SetCompressor /SOLID /FINAL LZMA
SetCompressorDictSize 32
SetDatablockOptimize on
SetOverwrite try
XPStyle on
;RequestExecutionLevel admin
;AllowRootDirInstall false

!define MULTIUSER_EXECUTIONLEVEL Highest
!define MULTIUSER_MUI
!define MULTIUSER_INSTALLMODE_COMMANDLINE
!define MULTIUSER_USE_PROGRAMFILES64
!define MULTIUSER_INSTALLMODE_DEFAULT_REGISTRY_KEY "Software\${APPNAME}\${APPVERSION}"
!define MULTIUSER_INSTALLMODE_DEFAULT_REGISTRY_VALUENAME ""
!define MULTIUSER_INSTALLMODE_INSTDIR_REGISTRY_KEY "Software\${APPNAME}\${APPVERSION}"
!define MULTIUSER_INSTALLMODE_INSTDIR_REGISTRY_VALUENAME ""
!define MULTIUSER_INSTALLMODE_INSTDIR "${APPNAME}-${APPVERSION}"
!define UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAMEANDVERSION}"

!include MultiUser.nsh
!include MUI2.nsh
!include x64.nsh
!include WinVer.nsh
!include 'LogicLib.nsh'
!include StrFunc.nsh

!define MUI_ICON ".\gramps.ico"
!define MUI_HEADERIMAGE
;!define MUI_HEADERIMAGE_BITMAP ".\grampshd.bmp"
;!define MUI_WELCOMEFINISHPAGE_BITMAP ".\grampsbg.bmp"
;!define MUI_BGCOLOR
;!define MUI_LICENSEPAGE_BGCOLOR
;!define MUI_DIRECTORYPAGE_BGCOLOR
!define MUI_ABORTWARNING
!define MUI_FINISHPAGE_NOAUTOCLOSE
!define MUI_FINISHPAGE_RUN "$INSTDIR\gramps.exe"
;!define MUI_FINISHPAGE_RUN_PARAMETERS "-EO gramps"


;--------- Pages---------------------------------------------------------------
!insertmacro MUI_PAGE_WELCOME	
!insertmacro MUI_PAGE_LICENSE "..\share\doc\gramps\COPYING"
!insertmacro MULTIUSER_PAGE_INSTALLMODE
!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_DIRECTORY
;!insertmacro MUI_PAGE_STARTMENU
!insertmacro MUI_PAGE_INSTFILES 
!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES

;--------- Languages ----------------------------------------------------------
!insertmacro MUI_LANGUAGE English
!insertmacro MUI_LANGUAGE Albanian
!insertmacro MUI_LANGUAGE Arabic
!insertmacro MUI_LANGUAGE Bulgarian
!insertmacro MUI_LANGUAGE Catalan
!insertmacro MUI_LANGUAGE Croatian
!insertmacro MUI_LANGUAGE Czech
!insertmacro MUI_LANGUAGE Danish
!insertmacro MUI_LANGUAGE Dutch
!insertmacro MUI_LANGUAGE Esperanto
!insertmacro MUI_LANGUAGE Finnish
!insertmacro MUI_LANGUAGE French
!insertmacro MUI_LANGUAGE German
!insertmacro MUI_LANGUAGE Greek
!insertmacro MUI_LANGUAGE Hebrew
!insertmacro MUI_LANGUAGE Hungarian
!insertmacro MUI_LANGUAGE Icelandic
!insertmacro MUI_LANGUAGE Italian
!insertmacro MUI_LANGUAGE Japanese
!insertmacro MUI_LANGUAGE Lithuanian
!insertmacro MUI_LANGUAGE Norwegian
!insertmacro MUI_LANGUAGE NorwegianNynorsk
!insertmacro MUI_LANGUAGE Polish
!insertmacro MUI_LANGUAGE Portuguese
!insertmacro MUI_LANGUAGE PortugueseBR
!insertmacro MUI_LANGUAGE Russian
!insertmacro MUI_LANGUAGE Serbian
!insertmacro MUI_LANGUAGE SerbianLatin
!insertmacro MUI_LANGUAGE SimpChinese
!insertmacro MUI_LANGUAGE Slovak
!insertmacro MUI_LANGUAGE Slovenian
!insertmacro MUI_LANGUAGE Spanish
!insertmacro MUI_LANGUAGE SpanishInternational
!insertmacro MUI_LANGUAGE Swedish
!insertmacro MUI_LANGUAGE TradChinese
!insertmacro MUI_LANGUAGE Turkish
!insertmacro MUI_LANGUAGE Ukrainian
!insertmacro MUI_LANGUAGE Vietnamese

;--------- Reserve Files ------------------------------------------------------
!insertmacro MUI_RESERVEFILE_LANGDLL
;ReserveFile "${NSISDIR}\Plugins\x86-ansi\*.dll"
ReserveFile "${NSISDIR}\Plugins\unicode\*.dll"

ShowInstDetails show

Section "Gramps" Section1
	SectionIn RO
	SetOverwrite on

	;;; Set Section Files and Shortcuts
	SetOutPath "$INSTDIR\"
	File "..\"

	SetOutPath "$INSTDIR\lib\"
	File /r  "..\lib\"
	
	SetOutPath "$INSTDIR\etc\"
	File /r "..\etc\"
	
	SetOutPath "$INSTDIR\share\"
		File /r  "..\share\doc"
		File /r  "..\share\glib-2.0"
		File /r  "..\share\gramps"
		File /r  "..\share\icons"
		File /r  "..\share\xml"
		
	SetOutPath "$INSTDIR\gramps\"
	File /r  "..\gramps\"
	
	SetOutPath "$INSTDIR\src\"
	File /r  ".\"
	
	CreateDirectory "$INSTDIR\var\cache\fontconfig"

	SetOutPath "$INSTDIR\"
	CreateShortCut "$DESKTOP\${APPNAMEANDVERSION}.lnk" "$INSTDIR\grampsw.exe"  "" "" "" "" "" "Gramps"
	CreateDirectory "$SMPROGRAMS\${APPNAMEANDVERSION}"
	CreateShortCut "$SMPROGRAMS\${APPNAMEANDVERSION}\${APPNAMEANDVERSION}.lnk" "$INSTDIR\grampsw.exe" "" "" "" "" "" "Gramps"
	CreateShortCut "$SMPROGRAMS\${APPNAMEANDVERSION}\${APPNAMEANDVERSION}-console.lnk" "$INSTDIR\gramps.exe" "" "" "" "" "" "Gramps (console)"
	
	DetailPrint "Writing resource-path ..."
	FileOpen $4 "$INSTDIR\gramps\gen\utils\resource-path" w
	FileWrite $4 "share"
	FileClose $4

	DetailPrint "Writing branding ..."
	FileOpen $4 "$INSTDIR\gramps\version.py" a
	FileSeek $4 0 END
	FileWrite $4 "$\r$\n" ; we write a new line
	FileWrite $4 "VERSION = 'AIO64-${APPVERSION}-${APPBUILD}'"
	FileWrite $4 "$\r$\n" ; we write an extra line
	FileClose $4 ; and close the file

	DetailPrint "Compiling GLib schemas ..."
	nsExec::ExecToStack '"$INSTDIR\glib-compile-schemas.exe" $INSTDIR\share\glib-2.0\schemas'	
	
	DetailPrint "Caching gdk-pixbuf-query-loaders ..."
	nsExec::ExecToStack '"$INSTDIR\gdk-pixbuf-query-loaders.exe" --update-cache'	
SectionEnd

SectionGroup "Dictionaries" sec_d
Section "en_GB" d_engb
	SectionIn RO
	SetOutPath "$INSTDIR\share\enchant\"
		File "..\share\enchant\enchant.ordering"
	SetOutPath "$INSTDIR\share\enchant\myspell\"
		File "..\share\enchant\myspell\en_GB.*"
SectionEnd
Section /o "fr_FR" d_fr
	SetOutPath "$INSTDIR\share\enchant\myspell\"
		File "..\share\enchant\myspell\fr_FR.*"
SectionEnd
SectionGroupEnd

SectionGroup "Translations" sec_t
Section /o "ar" ar
	SetOutPath "$INSTDIR\share\locale\"
		File /r "..\share\locale\ar"
SectionEnd
Section /o "bg" bg
	SetOutPath "$INSTDIR\share\locale\"
		File /r "..\share\locale\bg"
SectionEnd
Section /o "ca" ca
	SetOutPath "$INSTDIR\share\locale\"
		File /r "..\share\locale\ca"
SectionEnd
Section /o "cs" cs
	SetOutPath "$INSTDIR\share\locale\"
		File /r "..\share\locale\cs"
SectionEnd
Section /o "da" da
	SetOutPath "$INSTDIR\share\locale\"
		File /r "..\share\locale\da"
SectionEnd
Section /o "de" de
	SetOutPath "$INSTDIR\share\locale\"
		File /r "..\share\locale\de"
SectionEnd
Section /o "el" el
	SetOutPath "$INSTDIR\share\locale\"
		File /r "..\share\locale\el"
SectionEnd
Section "en_GB" en_GB
	SectionIn RO
	SetOutPath "$INSTDIR\share\locale\"
		File /r "..\share\locale\en_GB"
SectionEnd
Section /o "eo" eo
	SetOutPath "$INSTDIR\share\locale\"
		File /r "..\share\locale\eo"
SectionEnd
Section /o "es" es
	SetOutPath "$INSTDIR\share\locale\"
		File /r "..\share\locale\es"
SectionEnd
Section /o "fi" fi
	SetOutPath "$INSTDIR\share\locale\"
		File /r "..\share\locale\fi"
SectionEnd
Section /o "fr" fr
	SetOutPath "$INSTDIR\share\locale\"
		File /r "..\share\locale\fr"
SectionEnd
Section /o "he" he
	SetOutPath "$INSTDIR\share\locale\"
		File /r "..\share\locale\he"
SectionEnd
Section /o "hr" hr
	SetOutPath "$INSTDIR\share\locale\"
		File /r "..\share\locale\hr"
SectionEnd
Section /o "hu" hu
	SetOutPath "$INSTDIR\share\locale\"
		File /r "..\share\locale\hu"
SectionEnd
Section /o "is" is
	SetOutPath "$INSTDIR\share\locale\"
		File /r "..\share\locale\is"
SectionEnd
Section /o "it" it
	SetOutPath "$INSTDIR\share\locale\"
		File /r "..\share\locale\it"
SectionEnd
Section /o "ja" ja
	SetOutPath "$INSTDIR\share\locale\"
		File /r "..\share\locale\ja"
SectionEnd
Section /o "lt" lt
	SetOutPath "$INSTDIR\share\locale\"
		File /r "..\share\locale\lt"
SectionEnd
Section /o "nb" nb
	SetOutPath "$INSTDIR\share\locale\"
		File /r "..\share\locale\nb"
SectionEnd
Section /o "nl" nl
	SetOutPath "$INSTDIR\share\locale\"
		File /r "..\share\locale\nl"
SectionEnd
Section /o "nn" nn
	SetOutPath "$INSTDIR\share\locale\"
		File /r "..\share\locale\nn"
SectionEnd
Section /o "pl" pl
	SetOutPath "$INSTDIR\share\locale\"
		File /r "..\share\locale\pl"
SectionEnd
Section /o "pt_BR" pt_BR
	SetOutPath "$INSTDIR\share\locale\"
		File /r "..\share\locale\pt_BR"
SectionEnd
Section /o "pt_PT" pt_PT
	SetOutPath "$INSTDIR\share\locale\"
		File /r "..\share\locale\pt_PT"
SectionEnd
Section /o "ru" ru
	SetOutPath "$INSTDIR\share\locale\"
		File /r "..\share\locale\ru"
SectionEnd
Section /o "sk" sk
	SetOutPath "$INSTDIR\share\locale\"
		File /r "..\share\locale\sk"
SectionEnd
Section /o "sl" sl
	SetOutPath "$INSTDIR\share\locale\"
		File /r "..\share\locale\sl"
SectionEnd
Section /o "sq" sq
	SetOutPath "$INSTDIR\share\locale\"
		File /r "..\share\locale\sq"
SectionEnd
Section /o "sr" sr
	SetOutPath "$INSTDIR\share\locale\"
		File /r "..\share\locale\sr"
SectionEnd
Section /o "sv" sv
	SetOutPath "$INSTDIR\share\locale\"
		File /r "..\share\locale\sv"
SectionEnd
Section /o "tr" tr
	SetOutPath "$INSTDIR\share\locale\"
		File /r "..\share\locale\tr"
SectionEnd
Section /o "uk" uk
	SetOutPath "$INSTDIR\share\locale\"
		File /r "..\share\locale\uk"
SectionEnd
Section /o "vi" vi
	SetOutPath "$INSTDIR\share\locale\"
		File /r "..\share\locale\vi"
SectionEnd
Section /o "zh_CN" zh_CN
	SetOutPath "$INSTDIR\share\locale\"
		File /r "..\share\locale\zh_CN"
SectionEnd
Section /o "zh_HK" zh_HK
	SetOutPath "$INSTDIR\share\locale\"
		File /r "..\share\locale\zh_HK"
SectionEnd
Section /o "zh_TW" zh_TW
	SetOutPath "$INSTDIR\share\locale\"
		File /r "..\share\locale\zh_TW"
SectionEnd
SectionGroupEnd

!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
	!insertmacro MUI_DESCRIPTION_TEXT ${Section1} "Gramps application with all dependencies"
	
	;; Description of dictionaries
	!insertmacro MUI_DESCRIPTION_TEXT ${sec_d} "Dictionaries for various languages"
	!insertmacro MUI_DESCRIPTION_TEXT ${d_ca} "Catalan"
	!insertmacro MUI_DESCRIPTION_TEXT ${d_cs} "Czech"
	!insertmacro MUI_DESCRIPTION_TEXT ${d_da} "Danish"
	!insertmacro MUI_DESCRIPTION_TEXT ${d_de} "German"
	!insertmacro MUI_DESCRIPTION_TEXT ${d_enau} "English (Australia)"
	!insertmacro MUI_DESCRIPTION_TEXT ${d_engb} "English (United Kingdom)"
	!insertmacro MUI_DESCRIPTION_TEXT ${d_enus} "English (USA)"
	!insertmacro MUI_DESCRIPTION_TEXT ${d_es} "Spanish"
	!insertmacro MUI_DESCRIPTION_TEXT ${d_fr} "French"
	!insertmacro MUI_DESCRIPTION_TEXT ${d_hr} "Croatian"
	!insertmacro MUI_DESCRIPTION_TEXT ${d_it} "Italian"
	!insertmacro MUI_DESCRIPTION_TEXT ${d_nb} "Norwegian Bokmal"
	!insertmacro MUI_DESCRIPTION_TEXT ${d_nl} "Dutch"
	!insertmacro MUI_DESCRIPTION_TEXT ${d_nn} "Norwegian Nynorsk"
	!insertmacro MUI_DESCRIPTION_TEXT ${d_pl} "Polish"
	!insertmacro MUI_DESCRIPTION_TEXT ${d_ru} "Russian"
	!insertmacro MUI_DESCRIPTION_TEXT ${d_sk} "Slovak"
	!insertmacro MUI_DESCRIPTION_TEXT ${d_sl} "Slovenian"
	!insertmacro MUI_DESCRIPTION_TEXT ${d_sv} "Swedish"

	;; Description of translations
  !insertmacro MUI_DESCRIPTION_TEXT ${sec_t} "Translation of Gramps in various languages"
	!insertmacro MUI_DESCRIPTION_TEXT ${ar} "Arabic"
	!insertmacro MUI_DESCRIPTION_TEXT ${bg} "Bulgarian"
	!insertmacro MUI_DESCRIPTION_TEXT ${ca} "Catalan"
	!insertmacro MUI_DESCRIPTION_TEXT ${cs} "Czech"
	!insertmacro MUI_DESCRIPTION_TEXT ${da} "Danish"
	!insertmacro MUI_DESCRIPTION_TEXT ${de} "German"
	!insertmacro MUI_DESCRIPTION_TEXT ${el} "Greek"
	!insertmacro MUI_DESCRIPTION_TEXT ${en_GB} "English (United Kingdom)"
	!insertmacro MUI_DESCRIPTION_TEXT ${eo} "Esperanto"
	!insertmacro MUI_DESCRIPTION_TEXT ${es} "Spanish"
	!insertmacro MUI_DESCRIPTION_TEXT ${fi} "Finnish"
	!insertmacro MUI_DESCRIPTION_TEXT ${fr} "French"
	!insertmacro MUI_DESCRIPTION_TEXT ${he} "Hebrew"
	!insertmacro MUI_DESCRIPTION_TEXT ${hr} "Croatian"
	!insertmacro MUI_DESCRIPTION_TEXT ${hu} "Hungarian"
	!insertmacro MUI_DESCRIPTION_TEXT ${is} "Icelandic"
	!insertmacro MUI_DESCRIPTION_TEXT ${it} "Italian"
	!insertmacro MUI_DESCRIPTION_TEXT ${ja} "Japanese"
	!insertmacro MUI_DESCRIPTION_TEXT ${lt} "Lithuanian"
	;!insertmacro MUI_DESCRIPTION_TEXT ${mk} "Macedonian"
	!insertmacro MUI_DESCRIPTION_TEXT ${nb} "Norwegian Bokmal"
	!insertmacro MUI_DESCRIPTION_TEXT ${nl} "Dutch"
	!insertmacro MUI_DESCRIPTION_TEXT ${nn} "Norwegian Nynorsk"
	!insertmacro MUI_DESCRIPTION_TEXT ${pl} "Polish"
	!insertmacro MUI_DESCRIPTION_TEXT ${pt_BR} "Portuguese (Brazil)"
	!insertmacro MUI_DESCRIPTION_TEXT ${pt_PT} "Portuguese (Portugal)"
	!insertmacro MUI_DESCRIPTION_TEXT ${ru} "Russian"
	!insertmacro MUI_DESCRIPTION_TEXT ${sk} "Slovak"
	!insertmacro MUI_DESCRIPTION_TEXT ${sl} "Slovenian"
	!insertmacro MUI_DESCRIPTION_TEXT ${sq} "Albanian"
	!insertmacro MUI_DESCRIPTION_TEXT ${sr} "Serbian"
	!insertmacro MUI_DESCRIPTION_TEXT ${sv} "Swedish"
	!insertmacro MUI_DESCRIPTION_TEXT ${tr} "Turkish"
	!insertmacro MUI_DESCRIPTION_TEXT ${uk} "Ukrainian"
	!insertmacro MUI_DESCRIPTION_TEXT ${vi} "Vietnamese"
	!insertmacro MUI_DESCRIPTION_TEXT ${zh_CN} "Chinese (Simplified)"
	!insertmacro MUI_DESCRIPTION_TEXT ${zh_HK} "Chinese (Hong Kong)"
	!insertmacro MUI_DESCRIPTION_TEXT ${zh_TW} "Chinese (Traditional)"
!insertmacro MUI_FUNCTION_DESCRIPTION_END

Function sel_langs
    StrCmp $LANGUAGE ${LANG_ARABIC} 0 +2
        SectionSetFlags ${ar} 1
    StrCmp $LANGUAGE ${LANG_BULGARIAN} 0 +2
        SectionSetFlags ${bg} 1
    StrCmp $LANGUAGE ${LANG_CATALAN} 0 +3
        SectionSetFlags ${ca} 1
    StrCmp $LANGUAGE ${LANG_CZECH} 0 +3
        SectionSetFlags ${cs} 1
    StrCmp $LANGUAGE ${LANG_DANISH} 0 +3
        SectionSetFlags ${da} 1
    StrCmp $LANGUAGE ${LANG_GERMAN} 0 +3
        SectionSetFlags ${de} 1
    StrCmp $LANGUAGE ${LANG_GREEK} 0 +2
        SectionSetFlags ${el} 1
    StrCmp $LANGUAGE ${LANG_ESPERANTO} 0 +2
        SectionSetFlags ${eo} 1
    StrCmp $LANGUAGE ${LANG_SPANISH} 0 +3
        SectionSetFlags ${es} 1
    StrCmp $LANGUAGE ${LANG_FINNISH} 0 +2
        SectionSetFlags ${fi} 1
    StrCmp $LANGUAGE ${LANG_FRENCH} 0 +3
        SectionSetFlags ${fr} 1
        SectionSetFlags ${d_fr} 1
    StrCmp $LANGUAGE ${LANG_HEBREW} 0 +2
        SectionSetFlags ${he} 1
    StrCmp $LANGUAGE ${LANG_CROATIAN} 0 +3
        SectionSetFlags ${hr} 1
    StrCmp $LANGUAGE ${LANG_HUNGARIAN} 0 +2
        SectionSetFlags ${hu} 1
    StrCmp $LANGUAGE ${LANG_ICELANDIC} 0 +2
        SectionSetFlags ${is} 1
    StrCmp $LANGUAGE ${LANG_ITALIAN} 0 +3
        SectionSetFlags ${it} 1
    StrCmp $LANGUAGE ${LANG_JAPANESE} 0 +2
        SectionSetFlags ${ja} 1
    StrCmp $LANGUAGE ${LANG_LITHUANIAN} 0 +2
        SectionSetFlags ${lt} 1
    StrCmp $LANGUAGE ${LANG_NORWEGIAN} 0 +5
        SectionSetFlags ${nb} 1
        SectionSetFlags ${nn} 1
    StrCmp $LANGUAGE ${LANG_DUTCH} 0 +3
        SectionSetFlags ${nl} 1
    StrCmp $LANGUAGE ${LANG_POLISH} 0 +3
        SectionSetFlags ${pl} 1
    StrCmp $LANGUAGE ${LANG_PORTUGUESEBR} 0 +2
        SectionSetFlags ${pt_BR} 1
    StrCmp $LANGUAGE ${LANG_PORTUGUESE} 0 +2
        SectionSetFlags ${pt_PT} 1
    StrCmp $LANGUAGE ${LANG_RUSSIAN} 0 +3
        SectionSetFlags ${ru} 1
    StrCmp $LANGUAGE ${LANG_SLOVAK} 0 +3
        SectionSetFlags ${sk} 1
    StrCmp $LANGUAGE ${LANG_SLOVENIAN} 0 +3
        SectionSetFlags ${sl} 1
    StrCmp $LANGUAGE ${LANG_ALBANIAN} 0 +2
        SectionSetFlags ${sq} 1
    StrCmp $LANGUAGE ${LANG_SERBIAN} 0 +2
        SectionSetFlags ${sr} 1
    StrCmp $LANGUAGE ${LANG_SWEDISH} 0 +3
        SectionSetFlags ${sv} 1
    StrCmp $LANGUAGE ${LANG_TURKISH} 0 +2
        SectionSetFlags ${tr} 1
    StrCmp $LANGUAGE ${LANG_UKRAINIAN} 0 +2
        SectionSetFlags ${uk} 1
    StrCmp $LANGUAGE ${LANG_VIETNAMESE} 0 +2
        SectionSetFlags ${vi} 1
    StrCmp $LANGUAGE ${LANG_SIMPCHINESE} 0 +3
        SectionSetFlags ${zh_CN} 1
        SectionSetFlags ${zh_HK} 1
    StrCmp $LANGUAGE ${LANG_TRADCHINESE} 0 +3
        SectionSetFlags ${zh_TW} 1
        SectionSetFlags ${zh_HK} 1

FunctionEnd

Section -FinishSection
	DetailPrint "Configuring GraphViz Dot..."
	nsExec::ExecToLog '"$INSTDIR\dot.exe" -c'
    System::Call 'Kernel32::SetEnvironmentVariable(t, t)i ("FC_DEBUG", "128").r0'
	DetailPrint "Creating fontconfig cache (might take a while)..."
	nsExec::ExecToLog '"$INSTDIR\fc-cache.exe" -fv'
    System::Call 'Kernel32::SetEnvironmentVariable(t, n)i ("FC_DEBUG", "").r0'

	WriteRegStr SHCTX "${UNINST_KEY}" "DisplayName" "${APPNAME}"
	WriteRegStr SHCTX "${UNINST_KEY}" "DisplayVersion" "${APPVERSION}"
	WriteRegStr SHCTX "${UNINST_KEY}" "Publisher" "${APP_PUBLISHER}"
	WriteRegStr SHCTX "${UNINST_KEY}" "URLInfoAbout" "${APP_WEB_SITE}"
	WriteRegStr SHCTX "${UNINST_KEY}" "UninstallString" \
		"$\"$INSTDIR\uninstall.exe$\" /$MultiUser.InstallMode"
	WriteRegStr SHCTX "${UNINST_KEY}" "QuietUninstallString" \
		"$\"$INSTDIR\uninstall.exe$\" /$MultiUser.InstallMode /S"
	WriteUninstaller "$INSTDIR\uninstall.exe"
SectionEnd

Section Uninstall
	DeleteRegKey SHCTX "${UNINST_KEY}"
	Delete "$DESKTOP\${APPNAMEANDVERSION}.lnk"
	Delete "$SMPROGRAMS\${APPNAMEANDVERSION}\${APPNAMEANDVERSION}.lnk"
	Delete "$SMPROGRAMS\${APPNAMEANDVERSION}\${APPNAMEANDVERSION}-console.lnk"
	RMDir "$SMPROGRAMS\${APPNAMEANDVERSION}\"
	Delete "$INSTDIR\uninstall.exe"
	Delete "$INSTDIR\uninstall.exe"
	RMDir /r "$INSTDIR\etc"
	RMDir /r "$INSTDIR\lib"
	RMDir /r "$INSTDIR\share"
	RMDir /r "$INSTDIR\src"
	RMDir /r "$INSTDIR\gramps"
	RMDir /r "$INSTDIR\var"
	RMDir /r "$INSTDIR"
SectionEnd

Function .onInit
  !insertmacro MULTIUSER_INIT
  
   ;; Prevent multiple instances.
   System::Call 'kernel32::CreateMutexA(i 0, i 0, t "GrampsInstaller") i .r1 ?e'
   Pop $R0
   StrCmp $R0 0 +3
      MessageBox MB_OK|MB_ICONEXCLAMATION "The GrampsAIO installer is already running."
			Abort
  
  ${IfNot} ${RunningX64}
    MessageBox MB_OK "64bit Windows version required"
    Quit
  ${EndIf}

  ${If} ${AtMostWinXP}
    MessageBox MB_OK "Windows Vista and above required"
    Quit
  ${EndIf}
  ;StrCpy $LANGUAGE ${LANG_FRENCH}
  Call sel_langs
FunctionEnd

Function un.onInit
  !insertmacro MULTIUSER_UNINIT
   ;; MessageBox MB_OK|MB_ICONEXCLAMATION "Gramps will uninstall now"
  ;; Prevent uninstallation if Gramps is running.
   System::Call 'kernel32::CreateMutex(i 0, b 0, t "org.gramps-project.gramps") i .R0 ?e'
   Pop $0
   ;; MessageBox MB_OK|MB_ICONEXCLAMATION "Gramps Mutex Error $0, return $R0"
   IntCmpU $0 183 0 notRunning notRunning
    System::Call 'kernel32::CloseHandle(i $R0)'
    MessageBox MB_OK|MB_ICONEXCLAMATION "Gramps is running. Please close it first"
    Abort
notRunning:
FunctionEnd
