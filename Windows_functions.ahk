; global savedCLASS = "ahk_class Notepad++"
; global savedEXE = "notepad++.exe" ;BEFORE the #include is apparently the only place these can go.
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance force
#WinActivateForce

Menu, Tray, Icon, shell32.dll, 16 ;this changes the icon into a little laptop thingy. just useful for making it distinct from the others.




GroupAdd, ExplorerGroup, ahk_class #32770 ;This is for all the Explorer-based "save" and "load" boxes, from any program!

;lololol I have to have tippy(), but i can't redefine an existing function, so I either have to put it in another .ahk script and #include it, or I could go the lazy route and just add a "2" to the end of ALL of them in this file, because I am a such a bad spaghetti coder that I don't even know what that means.
Tippy2(tipsHere, wait:=333)
{
ToolTip, %tipsHere%,,,8
SetTimer, notip2, %wait% ;--in 1/3 seconds by default, remove the tooltip
}
notip2:
	ToolTip,,,,8
	;removes the tooltip
return

GetFromClipboard()
{
  ClipSaved := ClipboardAll ;Save the clipboard
  Clipboard = ;Empty the clipboard
  SendInput, ^c
  ClipWait, 2
  if ErrorLevel
  {
    ;; MsgBox % "Failed attempt to copy text to clipboard."
    MsgBox,,,"Failed attempt to copy text to clipboard.",0.7
    return
  }
  NewClipboard := Trim(Clipboard)
  ; StringReplace, NewClipboard, NewClipBoard, `r`n, `n, All ;comment this in to remove whitespace automaticaly
  Clipboard := ClipSaved ;Restore the clipboard
  ClipSaved = ;Free the memory in case the clipboard was very large.
  return NewClipboard
}

search(){
if winactive("ahk_exe Adobe Premiere Pro.exe")
	{
	if IsFunc("effectsPanelType") {
	Func := Func("effectsPanelType")
	RetVal := Func.Call(directory,"") 
	}
	;effectsPanelType("") ;set to macro key G1 on my logitech G15 keyboard. 
	
	;This just CLEARS the effects panel search bar so that you can type something in.
	;previously was ^+0
	}
else if winactive("ahk_exe notepad++.exe")
	sendinput ^f
else if winactive("ahk_exe firefox.exe")
	sendinput ^e
else if winactive("ahk_exe chrome.exe")
	sendinput ^e{Backspace}
else if winactive("ahk_class CabinetWClass"){
	sendinput ^e
	Sleep 200
	sendinput ^a
	Sleep 200
	sendinput {Backspace} 
}else if winactive("ahk_exe Spotify.exe")
	sendinput ^l
}



#IfWinActive



saveLocation2(){
f_text = 0
SetTitleMatchMode Slow
WinGet, f_window_id, ID, A
WinGetClass, f_class, ahk_id %f_window_id%
;;msgbox,,,%f_class%, 1
if f_class in ExploreWClass,CabinetWClass ; if the window class is an Explorer window of either kind.
	{
	; WinGetTitle, Title, ahk_class CabinetWClass
	WinGetTitle, title, ahk_id %f_window_id% ;super lame way to do this, does not always work.
	;msgbox, address is `n%title%
	;sorry, I tried to NOT have to refer to these folder paths directly, but it always failed spectacularly:
	FileDelete, C:\Users\matya\Desktop\PremiereAHK\SavedExplorerAddress.txt
	FileAppend, %title% , C:\Users\matya\Desktop\PremiereAHK\SavedExplorerAddress.txt
	SavedExplorerAddress = %title%
	;checkForFile("Thumbnail","Template.psd")
	msgbox, , , %title%`n`nwas saved as root, 0.3
	}
else
	msgbox,,, this is not an explorer window you chump,0.5
;for some reason, after this script runs, it sometimes activates the last active window. It doesn't make any sense...
}
;for further reading:
;https://autohotkey.com/board/topic/60985-get-paths-of-selected-items-in-an-explorer-window/
;end of savelocation2()


;in progress
checkForFile(subDirectory, filename)
{
FileRead, SavedExplorerAddress, C:\Users\matya\Desktop\PremiereAHK\SavedExplorerAddress.txt
;msgbox, current directory is`n%directory%
directory = %SavedExplorerAddress%
msgbox, new directory is`n%directory%

;filetype := """" . filetype . """" ;this ADDS quotation marks around a string in case you need that.
StringReplace, directory,directory,", , All ;" ; this REMOVES the quotation marks around the a string if they are present.

finalDirectory = %directory% . %subDirectory%

;msgbox, directory is %directory%`n and filetype is %filetype%
Loop, Files,%finalDirectory%, F
{

If (A_LoopFileTimeModified>Rec)
  {
  IfNotInString, A_LoopFileFullPath, ~$
	FPath=%A_LoopFileFullPath%
  Rec=%A_LoopFileTimeModified%
  }
}
MsgBox, 3,, Select YES to open the latest %filetype% at Fpath:`n`n%Fpath%
IfMsgBox, Yes
	{
	Run %Fpath%
	}
}



openSavedDir()
{
	FileRead, SavedExplorerAddress, C:\Users\matya\Desktop\PremiereAHK\SavedExplorerAddress.txt
	directory = %SavedExplorerAddress%
    StringReplace, directory,directory,", , All ;" ; this REMOVES the quotation marks around the a string if they are present.
	instantExplorer(directory)
}


;;;; SCRIPT TO ALWAYS OPEN THE MOST RECENTLY SAVED OR AUTOSAVED FILE OF A GIVEN FILETYPE, IN ANY GIVEN FOLDER (AND ALL SUBFOLDERS.);;;;
;;script partially obtained from https://autohotkey.com/board/topic/57475-open-most-recent-file-date-created-in-a-folder/
openlatestfile(directory, filetype)
{
if directory = 1
	{
	FileRead, SavedExplorerAddress, C:\Users\matya\Desktop\PremiereAHK\SavedExplorerAddress.txt
	;msgbox, current directory is`n%directory%
	directory = %SavedExplorerAddress%
	;msgbox, new directory is`n%directory%
	}
;filetype := """" . filetype . """" ;this ADDS quotation marks around a string in case you need that.
StringReplace, directory,directory,", , All ;" ; this REMOVES the quotation marks around the a string if they are present.

;Keyshower(directory,"openlatestfile")
if IsFunc("Keyshower") {
	Func := Func("Keyshower")
	RetVal := Func.Call(directory,"openlatestfile") 
}

;I need some method of excluding ~$ files, since those clutter everything up (MS Word .docx ...)

;msgbox, directory is %directory%`n and filetype is %filetype%
Loop, Files,%directory%\*%filetype%, FR
{

If (A_LoopFileTimeModified>Rec)
  {
  IfNotInString, A_LoopFileFullPath, ~$
	FPath=%A_LoopFileFullPath%
  Rec=%A_LoopFileTimeModified%
  }
}
;try to get this to work with an ENTER press from thne stream deck...
MsgBox, 3,, Select YES to open the latest %filetype% at Fpath:`n`n%Fpath%
IfMsgBox, Yes
	{
	Run %Fpath%
	}

; ; USING THE SCRIPT
; !n::
; examplePath = "Z:\Linus\6. Channel Super Fun\Flicking football"
; openlatestfile(examplePath, ".prproj") ;<--- notice how i INCLUDE the period in the parameters. IDK if it might be better to add the period later.
; return
}
; end of openlatestfile()


;MOVED FROM PREMIERE SCRIPTS
;function to start, then activate any given application
openApp(theClass, theEXE, theTitle := ""){
IfWinNotExist, %theClass%
	Run, % theEXE
if not WinActive(theClass)
	{
	WinActivate %theClass%
	;WinGetTitle, Title, A
	WinRestore %theTitle%
	}
}

;MOVED FROM PREMIERE SCRIPTS
;this should probably all be replaced with instantexplorer, since that will work to change any existing Save as dialouges or whatever.
runexplorer(foo)
{
send {SC0E8} ;the scan code of an unassigned key ;;sending even a single keystroke like this, which comes "from" the secondary keyboard, will prevent the taskbar icon from sometimes flashing pointlessly rather than opening.
sleep 5
Run, % foo
sleep 10
;Send,{LCtrl down}{NumpadAdd}{LCtrl up} ;windows shortcut to resize name feild to fit.
;alt v o down enter will sort by date modified, but it is stupid...

;I'm commenting this code out for now because it hasn't been working lately...
; if WinActive("ahk_exe explorer.exe")
	; {
	; tooltip, explorer is open already, now doing NAVRUN
	; NavRun(foo)
	; }
; Else
	; {
	; tooltip, else was triggered meaning we are not in explorer)
	; Run, % foo
	; }
; Return
}


;-------The below script origninally from: https://autohotkey.com/board/topic/102127-navigating-explorer-directories/
; ; Hotkeys 1 & 2
; 1::NavRun("C:\")
; 2::NavRun(A_MyDocuments)
; http://msdn.microsoft.com/en-us/library/bb774094
GetActiveExplorer() {
	tooltip, getactiveexplorer code now
    static objShell := ComObjCreate("Shell.Application")
    WinHWND := WinActive("A")    ; Active window
    for Item in objShell.Windows
        if (Item.HWND = WinHWND)
            return Item        ; Return active window object
    return -1    ; No explorer windows match active window
}

NavRun(Path) {
    if (-1 != objIE := GetActiveExplorer())
        objIE.Navigate(Path)
    else
        Run, % Path
}
;--------The above script origninally from: https://autohotkey.com/board/topic/102127-navigating-explorer-directories/







; #ifwinactive
; F7::
	; Send ^s
	; sleep 200
    ; SoundBeep, 1100, 500
	; Reload  ;The only thing you need here is the Reload
; Return








#IfWinActive

;BEGIN savage-folder-navigation CODE!
;I got MOST of this code from https://autohotkey.com/docs/scripts/FavoriteFolders.htm
;and modified it to work with any given keypress, rather than middle mouse click as it had before.

;NEED to include this too: file locator modified Explorer window with shitty edit2 control
;Locate File '\\?\Z:\Linus\1. Linus Tech Tips\Pending\Maxine Settings Computer\Delivery\Maxine Settings Computer rc3.mov'
;ahk_class #32770
;ahk_exe Adobe Premiere Pro.exe
;

;;;NEEDED: must not get address by looking at title text, it is unreliable. if you search for a thing for example, it will open a new window. this may or may not be a bad thing... also i can have it clear the search - that WOULD be bad. must do more experiments with this one...
InstantExplorer(f_path)
{
;this has been heavily modified from https://autohotkey.com/docs/scripts/FavoriteFolders.htm

send {SC0E8} ;scan code of an unassigned key. This is needed to prevent the item from merely FLASHING on the task bar, rather than opening the folder. Don't ask me why, but this works.

if !FileExist(f_path)
{
    MsgBox,,, No such path exists.,0.7
	GOTO, instantExplorerEnd
}

f_path := """" . f_path . """" ;this adds quotation marks around everything so that it works as a string, not a variable.
;msgbox, f_path is now finally %f_path%
;SoundBeep, 900, 400 ;this is dumb because you cant change the volume, or tell it NOT to wait while the sound plays...


; These first few variables are set here and used by f_OpenFavorite:
WinGet, f_window_id, ID, A
WinGetClass, f_class, ahk_id %f_window_id%
WinGetTitle, f_title, ahk_id %f_window_id% ;to be used later to see if this is the export dialouge window in Premiere...
if f_class in #32770,ExploreWClass,CabinetWClass  ; if the window class is a save/load dialog, or an Explorer window of either kind.
	ControlGetPos, f_Edit1Pos, f_Edit1PosY,,, Edit1, ahk_id %f_window_id%


	;edit2
/*
if f_AlwaysShowMenu = n  ; The menu should be shown only selectively.
{
	if f_class in #32770,ExploreWClass,CabinetWClass  ; Dialog or Explorer.
	{
		if f_Edit1Pos =  ; The control doesn't exist, so don't display the menu
			return
	}
	else if f_class <> ConsoleWindowClass
		return ; Since it's some other window type, don't display menu.
}
; Otherwise, the menu should be presented for this type of window:
;Menu, Favorites, show
*/

; msgbox, A_ThisMenuItemPos %A_ThisMenuItemPos%
; msgbox, A_ThisMenuItem %A_ThisMenuItem%
; msgbox, A_ThisMenu %A_ThisMenu%

;;StringTrimLeft, f_path, f_path%A_ThisMenuItemPos%, 0
; msgbox, f_path: %f_path%`n f_class:  %f_class%`n f_Edit1Pos:  %f_Edit1Pos%

; f_OpenFavorite:
;msgbox, BEFORE:`n f_path: %f_path%`n f_class:  %f_class%`n f_Edit1Pos:  %f_Edit1Pos%

; Fetch the array element that corresponds to the selected menu item:
;;StringTrimLeft, f_path, f_path%A_ThisMenuItemPos%, 0
if f_path =
	return
if f_class = #32770    ; It's a dialog.
	{
	;msgbox, f_title is %f_title%
	; IF f_title is NOT "export settings," with the exe "premiere pro.exe"
	;go to the end or do something else, since you are in Premiere's export media dialouge box... which has the same #23770 classNN for some reason...
	;msgbox,,,test code E1,0.5
	if f_title = Export Settings
		{
		msgbox,,,you are in Premiere's export window, but NOT in the "Save as" inside of THAT window. no bueno, 1
		GOTO, instantExplorerEnd 
		;return ;no, I don't want to return because i still want to open an explorer window.
		}
	if WinActive("ahk_exe Adobe Premiere Pro.exe")
		{
		if f_title = Save As or f_title = Save Project ;IDK if this OR is properly nested....
			{
			ControlFocus, Edit1, ahk_id %f_window_id% ;this is really important.... it doesn't work if you don't do this...
			; msgbox, is it in focus?
			; MouseMove, f_Edit1Pos, f_Edit1PosY, 0
			; sleep 10
			; click
			; sleep 10
			; msgbox, how about now? x%f_Edit1Pos% y%f_Edit1PosY%
			;msgbox, Edit1 has been clicked maybe
			
			; Activate the window so that if the user is middle-clicking
			; outside the dialog, subsequent clicks will also work:
			WinActivate ahk_id %f_window_id%
			; Retrieve any filename that might already be in the field so
			; that it can be restored after the switch to the new folder:
			ControlGetText, f_text, Edit1, ahk_id %f_window_id%
			
			ControlSetText, Edit1, %f_path%, ahk_id %f_window_id%
			ControlSend, Edit1, {Enter}, ahk_id %f_window_id%
			Sleep, 100  ; It needs extra time on some dialogs or in some cases.
			ControlSetText, Edit1, %f_text%, ahk_id %f_window_id%
			;msgbox, AFTER:`n f_path: %f_path%`n f_class:  %f_class%`n f_Edit1Pos:  %f_Edit1Pos%
			
			tooltip,
			return
			}
		}
	;if WinActive("ahk_exe Adobe Premiere Pro.exe") and f_title = Save Project
	; Save As
	;OR Save Project
; ahk_class #32770
; ahk_exe Adobe Premiere Pro.exe
	
	if f_Edit1Pos <>   ; And it has an Edit1 control.
		{

		ControlFocus, Edit1, ahk_id %f_window_id% ;this is really important.... it doesn't work if you don't do this...
		tippy2("DIALOUGE WITH EDIT1`n`nwait really?`n`nLE controlfocus of edit1 for f_window_id was just engaged.", 1000)
		; msgbox, is it in focus?
		; MouseMove, f_Edit1Pos, f_Edit1PosY, 0
		; sleep 10
		; click
		; sleep 10
		; msgbox, how about now? x%f_Edit1Pos% y%f_Edit1PosY%
		;msgbox, edit1 has been clicked maybe
		
		; Activate the window so that if the user is middle-clicking
		; outside the dialog, subsequent clicks will also work:
		WinActivate ahk_id %f_window_id%
		
		; Retrieve any filename that might already be in the field so
		; that it can be restored after the switch to the new folder:
		ControlGetText, f_text, Edit1, ahk_id %f_window_id%
		Sleep 20
		ControlSetText, Edit1, %f_path%, ahk_id %f_window_id%
		Sleep 50
		ControlSend, Edit1, {Enter}, ahk_id %f_window_id%
		Sleep, 100  ; It needs extra time on some dialogs or in some cases.
		
		;now RESTORE the filename in that text field. I don't like doing it this way...
		ControlSetText, Edit1, %f_text%, ahk_id %f_window_id%
		;msgbox, AFTER:`n f_path: %f_path%`n f_class:  %f_class%`n f_Edit1Pos:  %f_Edit1Pos%
		
		ControlFocus, DirectUIHWND2, ahk_id %f_window_id% ;to try to get the focus back into the center area, so you can now type letters and have it go to a file or fodler, rather than try to SEARCH or try to change the FILE NAME by default.
		return
		}
	; else fall through to the bottom of the subroutine to take standard action.
	}

;for some reason, the following code just doesn't work well at all.
/*
else if f_class in ExploreWClass,CabinetWClass  ; In Explorer, switch folders.
{
	tooltip, f_class is %f_class% and f_window_ID is %f_window_id%
	if f_Edit1Pos <>   ; And it has an Edit1 control.
	{
		Tippy2("EXPLORER WITH EDIT1 only 2 lines of code here....", 1000)
		ControlSetText, Edit1, %f_path%, ahk_id %f_window_id%
		msgbox, ControlSetText happened. `nf_class is %f_class% and f_window_ID is %f_window_id%`nAND f_Edit1Pos is %f_Edit1Pos%
		; Tekl reported the following: "If I want to change to Folder L:\folder
		; then the addressbar shows http://www.L:\folder.com. To solve this,
		; I added a {right} before {Enter}":
		ControlSend, Edit1, {Right}{Enter}, ahk_id %f_window_id%
		return
	}
	; else fall through to the bottom of the subroutine to take standard action.
}
*/

else if f_class = ConsoleWindowClass ; In a console window, CD to that directory
	{
	WinActivate, ahk_id %f_window_id% ; Because sometimes the mclick deactivates it.
	SetKeyDelay, 0  ; This will be in effect only for the duration of this thread.
	IfInString, f_path, :  ; It contains a drive letter
		{
		StringLeft, f_path_drive, f_path, 1
		Send %f_path_drive%:{enter}
		}
	Send, cd %f_path%{Enter}
	return
	}
ending2:
; Since the above didn't return, one of the following is true:
; 1) It's an unsupported window type but f_AlwaysShowMenu is y (yes).
; 2) It's a supported type but it lacks an Edit1 control to facilitate the custom
;    action, so instead do the default action below.
Tippy2("end was reached.",333)
;SoundBeep, 800, 300 ;this is nice but the whole damn script WAITS for the sound to finish before it continues...
; Run, Explorer %f_path%  ; Might work on more systems without double quotes.

;msgbox, f_path is %f_path%

; SplitPath, f_path, , OutDir, , ,
; var := InStr(FileExist(OutDir), "D")

; if (var = 0)
	; msgbox, directory does not exist
; else if var = 1
	Run, %f_path%  ; I got rid of the "Explorer" part because it caused redundant windows to be opened, rather than just switching to the existing window
;else
;	msgbox,,,Directory does not exist,1

instantExplorerEnd:

}
;end of instantexplorer()






;BEGIN INSTANT APPLICATION SWITCHER SCRIPTS;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


#IfWinActive


windowSaver()
{
WinGet, lolexe, ProcessName, A
WinGetClass, lolclass, A ; "A" refers to the currently active window
global savedCLASS = "ahk_class "lolclass
global savedEXE = lolexe ;is this the way to do it? IDK.
;msgbox, %savedCLASS%
;msgbox, %savedEXE%
}

;SHIFT + macro key G14


global savedCLASS = "ahk_class Notepad++"
global savedEXE = "notepad++.exe"

switchToSavedApp(savedCLASS)
{
;msgbox,,, savedCLASS is %savedCLASS%,0.5
;msgbox,,, savedexe is %savedEXE%,0.5
if savedCLASS = ahk_class Notepad++
	{
	;msgbox,,, is notepad++,0.5
	if WinActive("ahk_class Notepad++")
		{
		sleep 5
		Send ^{tab}
		}
	}
;msgbox,,,got to here,0.5
windowSwitcher(savedCLASS, savedEXE)
}





back(){
;; if WinActive("ahk_class MozillaWindowClass")
;tooltip, baaaack
if WinActive("ahk_class Chrome_WidgetWin_1")
	Send {Browser_Back}
if WinActive("ahk_class Notepad++")
	Send ^+{tab}
if WinActive("ahk_exe Adobe Premiere Pro.exe")
	Send ^+b ;ctrl alt shift B  is my shortcut in premiere for "go back"(in bins)(the project panel)
if WinActive("ahk_exe explorer.exe")
	Send !{left} ;alt left is the explorer shortcut to go "back" or "down" one folder level.
if WinActive("ahk_class OpusApp")
	sendinput, {F2} ;"go to previous comment" in Word.
}

;macro key 16 on my logitech G15 keyboard. It will activate firefox,, and if firefox is already activated, it will go to the next window in firefox.

; This is a script that will always go to The last explorer window you had open.
; If explorer is already active, it will go to the NEXT last Explorer window you had open.
; CTRL Numpad2 is pressed with a single button stoke from my logitech G15 keyboard -- Macro key 17. 

switchToExplorer(){
IfWinNotExist, ahk_class CabinetWClass
	Run, explorer.exe
GroupAdd, taranexplorers, ahk_class CabinetWClass
if WinActive("ahk_exe explorer.exe")
	GroupActivate, taranexplorers, r
else
	WinActivate ahk_class CabinetWClass ;you have to use WinActivatebottom if you didn't create a window group.
}

; ;trying to activate these windows in reverse order from the above. it does not work.
; ^+F2::
; IfWinNotExist, ahk_class CabinetWClass
	; Run, explorer.exe
; GroupAdd, taranexplorers, ahk_class CabinetWClass
; if WinActive("ahk_exe explorer.exe")
	; GroupActivate, taranexplorers ;but NOT most recent.
; else
	; WinActivatebottom ahk_class CabinetWClass ;you have to use WinActivatebottom if you didn't create a window group.
; Return

;closes all explorer windows :/
;^!F2 -- for searchability

closeAllExplorers()
{
WinClose,ahk_group taranexplorers
}


switchToPremiere(){
IfWinNotExist, ahk_class Premiere Pro
	{
	;Run, Adobe Premiere Pro.exe
	;Adobe Premiere Pro CC 2017
	; Run, C:\Program Files\Adobe\Adobe Premiere Pro CC 2017\Adobe Premiere Pro.exe ;if you have more than one version instlaled, you'll have to specify exactly which one you want to open.
	Run, C:\Program Files\Adobe\Adobe Premiere Pro 2020\Adobe Premiere Pro.exe
	}
if WinActive("ahk_class Premiere Pro")
	{
	IfWinNotExist, ahk_exe notepad++.exe
		{
		Run, notepad++.exe
		sleep 200
		}
	WinActivate ahk_exe notepad++.exe ;so I have this here as a workaround to a bug. Sometimes Premeire becomes unresponsive to keyboard input. (especially after timeline scrolling, especially with a playing video.) Switching to any other application and back will solve this problem. So I just hit the premiere button again, in those cases.g
	sleep 10
	WinActivate ahk_class Premiere Pro
	}
else
	WinActivate ahk_class Premiere Pro
}

switchToWord()
{
 Process, Exist, WINWORD.EXE
;msgbox errorLevel `n%errorLevel%
	 If errorLevel = 0
		 Run, WINWORD.EXE
	 else
	 {
	GroupAdd, taranwords, ahk_class OpusApp
	if WinActive("ahk_class OpusApp")
		GroupActivate, taranwords, r
	else
		WinActivate ahk_class OpusApp
	 }
}

switchToPowerpoint()
{
IfWinNotExist, ahk_exe POWERPNT.EXE
	Run, POWERPNT.EXE

if WinActive("ahk_exe POWERPNT.EXE")
	Sendinput ^{tab}
else
	WinActivate ahk_exe POWERPNT.EXE
}


switchToChrome()
{
IfWinNotExist, ahk_exe chrome.exe
	Run, chrome.exe

if WinActive("ahk_exe chrome.exe")
	Sendinput ^{tab}
else
	WinActivate ahk_exe chrome.exe
}

switchToNotepad()
{
IfWinNotExist, ahk_exe notepad++.exe
	Run, notepad++.exe

if WinActive("ahk_exe notepad++.exe")
	Sendinput ^+{tab}
else
	WinActivate ahk_exe notepad++.exe
}

switchToVSCode()
{
IfWinNotExist, ahk_exe Code.exe
	Run, C:\Program Files\Microsoft VS Code\Code.exe

if WinActive("ahk_exe Code.exe")
	Sendinput ^+{tab}
else
	WinActivate ahk_exe Code.exe
}

switchToFusion360()
{
IfWinNotExist, ahk_exe Fusion360.exe
	Run, C:\Users\matya\AppData\Local\Autodesk\webdeploy\production\6a0c9611291d45bb9226980209917c3d\FusionLauncher.exe
else
	WinActivate ahk_exe Fusion360.exe
}

switchToSpotify()
{
IfWinNotExist, ahk_exe Spotify.exe
	Run, C:\Users\matya\AppData\Roaming\Spotify\Spotify.exe
else
	WinActivate ahk_exe Spotify.exe
}

switchToDiscord()
{
IfWinNotExist, ahk_exe Discord.exe
	Run, C:\Users\matya\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Discord Inc\Discord.lnk
if WinActive("ahk_exe Discord.exe")
	Sendinput ^!{Down}
else
	WinActivate ahk_exe Discord.exe
}

switchToAE()
{
IfWinNotExist, ahk_exe AfterFX.exe
	Run, C:\Program Files\Adobe\Adobe After Effects 2020\Support Files\AfterFX.exe
else
	WinActivate ahk_exe AfterFX.exe
}

switchToPS()
{
IfWinNotExist, ahk_exe Photoshop.exe
	Run, Photoshop.exe
else
	WinActivate ahk_exe Photoshop.exe
}

switchToBlender()
{
IfWinNotExist, ahk_exe blender.exe
	Run, C:\Program Files\Blender 2.8 BETA\blender.exe
else
	WinActivate ahk_exe blender.exe
}

switchToOutlook()
{
IfWinNotExist, ahk_exe OUTLOOK.EXE
	Run, OUTLOOK.EXE
else
	WinActivate ahk_exe OUTLOOK.EXE
}


#IfWinActive
windowSwitcher(theClass, theEXE)
{
;msgbox,,, switching to `nsavedCLASS = %theClass% `nsavedEXE = %theEXE%, 0.5
IfWinNotExist, %theClass%
	Run, % theEXE
if not WinActive(theClass)
	WinActivate %theClass%
}


sortExplorerByName(){
IfWinActive, ahk_class CabinetWClass
	{
	;Send,{LCtrl down}{NumpadAdd}{LCtrl up} ;expand name field
	send {alt}vo{enter} ;sort by name
	;tippy2("sort Explorer by name")

	}

}

sortExplorerByDate(){
IfWinActive, ahk_class CabinetWClass
	{
	;Send,{LCtrl down}{NumpadAdd}{LCtrl up} ;expand name field
	send {alt}vo{down}{enter} ;sort by date modified, but it functions as a toggle...
	;tippy2("sort Explorer by date")

	}

}






;---------------------

ExplorerViewChange_Window(explorerHwnd)
{
;https://autohotkey.com/boards/viewtopic.php?t=28304
	if (!explorerHwnd)
		return
	;msgbox,,, % explorerHwnd, 0.5
	Windows := ComObjCreate("Shell.Application").Windows
	for window in Windows
		if (window.hWnd == explorerHwnd)
			sFolder := window.Document
			
	;sFolder.ShellView := 1
	sFolder.CurrentViewMode := 4 ; Details
	;tooltip % sFolder.CurrentViewMode
	;sFolder.SORTCOLUMNS := PKEY_ItemNameDisplay, SORT_DESCENDING, bsssssss
}

;;;must look through that thread to find the direct "sort by name, sort by date" thingies.

ExplorerViewChange_List(explorerHwnd)
{
	if (!explorerHwnd)
		return
	;msgbox,,, % explorerHwnd, 0.5
	Windows := ComObjCreate("Shell.Application").Windows
	for window in Windows
		if (window.hWnd == explorerHwnd)
			sFolder := window.Document
	if (sFolder.CurrentViewMode == 8)
		sFolder.CurrentViewMode := 6 ; Tiles
	else if (sFolder.CurrentViewMode == 6)
		sFolder.CurrentViewMode := 4 ; Details
	else if (sFolder.CurrentViewMode == 4)
		sFolder.CurrentViewMode := 3 ; List
	else if (sFolder.CurrentViewMode == 3) {
		sFolder.CurrentViewMode := 2 ; Small icons
		sFolder.IconSize := 16 ; Actually make the icons small...
	} else if (sFolder.CurrentViewMode == 2) {
		sFolder.CurrentViewMode := 1 ; Icons
		sFolder.IconSize := 48 ; Medium icon size
	} else if (sFolder.CurrentViewMode == 1) {
		if (sFolder.IconSize == 256)
			sFolder.CurrentViewMode := 8 ; Go back to content view
		else if (sFolder.IconSize == 48)
			sFolder.IconSize := 96 ; Large icons
		else
			sFolder.IconSize := 256 ; Extra large icons
	}
	ObjRelease(Windows)
	tooltip % sFolder.CurrentViewMode
}



ExplorerViewChange_ICONS(explorerHwnd)
{

	if (!explorerHwnd)
	{
		tooltip, exiting.
		sleep 100
		return
	}
	;msgbox,,, % explorerHwnd, 0.5
	Windows := ComObjCreate("Shell.Application").Windows
	for window in Windows
		if (window.hWnd == explorerHwnd)
			sFolder := window.Document
	if (sFolder.CurrentViewMode >= 2) {
		sFolder.CurrentViewMode := 1 ; icons
		sFolder.IconSize := 256 ; make the icons big...
		;tooltip, large 1
	} else if (sFolder.CurrentViewMode == 1) {
		if (sFolder.IconSize == 48){
			sFolder.IconSize := 256
			;tooltip, large
			}
		else if (sFolder.IconSize == 256){
			sFolder.IconSize := 96
			;tooltip, you are now at medium icons
			}
		else if (sFolder.IconSize == 96) {
			sFolder.IconSize := 48 ; smallish icons
			;tooltip, you are now at smallish icons
			}
		else {
			sFolder.CurrentViewMode := 1
			sFolder.IconSize := 256
			;tooltip, reset
		}
	}
	;tooltip % sFolder.IconSize
	;tooltip, %explorerHwnd%
	;sleep 100
	;tooltip, % sFolder.CurrentViewMode
}


; ExplorerViewChange_ICONS(explorerHwnd)
; {

	; if (!explorerHwnd)
	; {
		; tooltip, exiting.
		; sleep 100
		; return
	; }
	; ;msgbox,,, % explorerHwnd, 0.5
	; Windows := ComObjCreate("Shell.Application").Windows
	; for window in Windows
		; if (window.hWnd == explorerHwnd)
			; sFolder := window.Document
	; if (sFolder.CurrentViewMode >= 2) {
		; sFolder.CurrentViewMode := 1 ; Small icons
		; sFolder.IconSize := 48 ; Actually make the icons small...
	; } else if (sFolder.CurrentViewMode == 1) {
		; if (sFolder.IconSize == 256){
			; sFolder.CurrentViewMode := 2 ; Go back to small icons
			; sFolder.IconSize := 48
			; }
		; else if (sFolder.IconSize == 48)
			; sFolder.IconSize := 96 ; Large icons
		; else
			; sFolder.IconSize := 256 ; Extra large icons
	; }
	; ;tooltip % sFolder.IconSize
	; ;tooltip, %explorerHwnd%
	; ;sleep 100
	; ;tooltip, % sFolder.CurrentViewMode
; }





;;;;;;;scripts from this guy;;;;;;;;;;;;;;;;
;https://github.com/asvas/AsVas_AutoHotkey_Scripts/blob/master/ahk_Scripts.ahk
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;not CURRENTLY used anywhere...;;;;


; x::F_Switch("firefox.exe","ahk_class MozillaWindowClass","firefoxgroup","C:\Program Files (x86)\Mozilla Firefox\firefox.exe")
; +x::F_Run("firefox.exe","C:\Program Files (x86)\Mozilla Firefox\firefox.exe")
; c::F_Switch("chrome.exe","ahk_class Chrome_WidgetWin_1","chromegroup")
; +c::F_Run("chrome.exe")
;
; w::F_Switch("WINWORD.EXE","ahk_class OpusApp","wordgroup") ;,"C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Word 2016.lnk")
; +w::F_Run("WINWORD.EXE") ;,"C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Word 2016.lnk")


;Function for hiding/Showing the intercept.exe window

;---------------------------------------------------------------------------------
;Run Function - Running specific executable
F_Run(Target,TPath = 0)
{
if TPath = 0 
	Run, %Target%
else
	Run, %TPath% ;Command for running target if conditions are satisfied
}

;---------------------------------------------------------------------------------
;Switch Function - Switching between different instances of the same executable or running it if missing
F_Switch(Target,TClass,TGroup,TPath = 0)
{
IfWinExist, ahk_exe %Target% ;Checking state of existence
	{
	GroupAdd, %TGroup%, %TClass% ;Definition of the group (grouping all instance of this class) (Not the perfect spot as make fo unnecessary reapeats of the command with every cycle, however the only easy option to keep the group up to date with the introduction of new instances)
	ifWinActive %TClass% ;Status check for active window if belong to the same instance of the "Target"
		{
		GroupActivate, %TGroup%, r ;If the condition is met cycle between targets belonging to the group
		}
	else
		WinActivate %TClass% ;you have to use WinActivatebottom if you didn't create a window group.
	}
else
	{
	if TPath = 0 
		Run, %Target%
	else
		Run, %TPath% ;Command for running target if conditions are satisfied
	}
Return
}

disableFile(){
	if WinActive("ahk_exe explorer.exe"){
		MouseClick, R
		Send {Up}
		Send {Enter}
		Sleep 150
		Send {Right}
		Send {Space}
		Sleep 20
		Send {Enter}
	}
}
;;;;;;scripts from another guy END;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;END OF FUNCTIONS;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


; insert::

; return

;;; https://autohotkey.com/board/topic/34696-explorer-post-message-sort-by-modified-size-name-etc/
; pgup::
; tooltip, sort by name?
; PostMessage, 0x111, 30210,,, ahk_class CabinetWClass ; Name
; return

; pgdn::
; PostMessage, 0x111, 28715,,, ahk_class CabinetWClass ; List
; ;PostMessage, 0x111, 30213,,, ahk_class CabinetWClass ; Date modified
; return