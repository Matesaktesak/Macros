SetWorkingDir, %A_ScriptDir%
Menu, Tray, Icon, shell32.dll, 283 ;tray icon is now a little keyboard, or piece of paper or something
;when you get to #include, it means the END of the autoexecute section.
;gui must be #included first, or it does not work, for some reason...
;YOU probably do NOT need the GUI at all. Delete the line below:

global savedCLASS = "ahk_class Notepad++"
global savedEXE = "notepad++.exe" ;BEFORE the #include is apparently the only place these can go.

#include Windows_functions.ahk
#include Premiere_functions.ahk
#include AfterFX_functions.ahk
#include Discord.ahk

SetKeyDelay, 0 ;warning ---this was absent for some reason. i just added it back in. IDK if I removed it for a reason or not...

#NoEnv
SendMode Input
#InstallKeybdHook
#InstallMouseHook
#UseHook On

#SingleInstance force ;only one instance may run at a time!
#MaxHotkeysPerInterval 2000
#WinActivateForce ;https://autohotkey.com/docs/commands/_WinActivateForce.htm ;this may prevent taskbar flashing.
#HotkeyModifierTimeout 60 ; https://autohotkey.com/docs/commands/_HotkeyModifierTimeout.htm

detecthiddenwindows, on

SetNumLockState, AlwaysOn ;i think this only works if launched as admin.

;Avoid using stupid CTRL when alt is released https://autohotkey.com/boards/viewtopic.php?f=76&t=57683
#MenuMaskKey vk07  ; vk07 is unassigned.

; ----------------- Other Windows ----------------------
^+!F11:: search()
^+!F12:: back()

; --------------- idiotic mouse macros -------------
+^!F8:: prPreset("Morph Cut_3") ; Morph cut
^!+T:: selectForward()

~$Pause:: PTT()

#if (getKeyState("F23", "P"))  ; F23 Modifier (Second Keyboard)
F23:: return				; Has to be allowed to return because it WAS pressed

; ----------------- Windows ----------------------------
^+F1:: switchToExplorer()
^+F2:: switchToDiscord()
^+F3:: switchToOutlook()
^+F4:: switchToPremiere()
^+F5:: switchToSpotify()
^+F6:: switchToChrome()


^+!F1:: instantExplorer("\\srvsl02\video")
^+!F2:: instantExplorer("D:\Pictures")
^+!F3:: instantExplorer("D:\install\")
^+!F4:: instantExplorer("R:\Youtube\Parkour")
^+!L:: instantExplorer("R:")
^+!M:: instantExplorer("D:\Music")
^+!F5:: switchToFusion360()
^+!F6:: switchToVSCode()
^+!F7:: switchToAE()
^+!F8:: switchToWord()
^+!F9:: switchToPowerpoint()
^+!F10:: switchToBlender()
^+!F12:: switchToPS()

^+!F11:: disableFile()

^+!S:: saveLocation2()
^+!O:: openSavedDir()


#if getKeyState("F23", "P") && WinActive("ahk_exe Adobe Premiere Pro.exe") ; F23 Modifier (Second Keyboard) and only if Premiere is active
F23:: return
; ----------------- General Premiere -------------------
Numpad0::					; Select Master-Clip 
	masterClipSelect()
Return
Numpad1::					; Full Resolution
	prFocus("program")
	Send ^!{F11}
Return

Numpad2::					; 1/2 Resolution
	prFocus("program")
	Send !+{F11}
Return

Numpad3::					; 1/3 Resolution
	prFocus("program")
	Send +{F11}
Return

Left::
	toggleMercury(5) 		; Toggle mercury transmit on one of the monitors (the fifth one)
Return

; ----------------- Transform ; - Backspace ------------
Backspace:: reverse()
ý:: Speed(50)
á:: Speed(75)
í:: Speed(100)
é:: Speed(115)
^P:: Speed(150)
´:: Speed(200)


; ----------------- Clipboardy G1 - G6 -----------------
^!A:: recallClipboard("a")
+A:: saveClipboard("a")
^B:: recallClipboard("b")
+B:: saveClipboard("b")
^C:: recallClipboard("c")
+C:: saveClipboard("c")

; ----------------- Presety QWERTYUIOP{} ---------------

^+W:: prPreset("Median1px")		; Median

Q:: prPreset("Flip Horizontally")	; Horizontal Flip
W:: prPreset("Flip Vertically")		; Vertical Flip
A:: prPreset("75%")					; 75% scale
E:: prPreset("180° Rotace")			; 180° Rotace

R:: prPreset("Photo - slow")		; Photo taken effects - No Sound
T:: prPreset("Photo - faster")
Y:: prPreset("Pan Left")
U:: prPreset("Pan Up")
I:: prPreset("Pan Right")
^!+I:: prPreset("Tele - Extreme Motion")
^!+U:: prPreset("Wide - Extreme Motion")

^+Q:: prPreset("warp general")		; Normal warp stabilizer
Z:: prPreset("ultra key exec")		; Normal Ultra key

O:: prPreset("Soft Black And White")
P:: prPreset("Contrast Black And White")
^A:: prPreset("Gentle Natural Grade")	; Natureal Grade
+^A:: prPreset("Hard Contrast Natural Grade") ; Hard Contrast Natural Grade

; --------------- Video --------------------------------
End:: showVideoKeyframes() ; Show video keyframes in timeline (sends +!K)
^+!P:: removeNextGap()
; --------------- Audio F1 - 12 ------------------------

F1:: audioMonoMaker("left")			; Make audio mno by left track
F2:: audioMonoMaker("right")		; -------||------- right track


F3:: addGain(-200)					; Disable sound
F4:: addGain(200)					; Reset Sound
F5:: addGain(-8)					; Lower selected audio gain by 8db
F6:: addGain(-4)					; -------------||------------- 4db
F7:: addGain(4)						; Rise -----------||---------- 4db
F8:: addGain(8)						; Rise -----------||---------- 8db						

Insert:: showAudioKeyframes() ; Show audio keyframes in timeline (sends ^+!K)

#if getKeyState("F23", "P") && WinActive("ahk_exe AfterFX.exe")  ; F23 Modifier (Second Keyboard) and only if AE is active
F23:: return				; Has to be allowed to return because it WAS pressed


; --------------- General After Effects ----------------

Q:: aePreset("flop") 			; horizontal flip
W:: aePreset("flip")			; vertical flip

Z:: aePreset("GSKey - combo 1") ; Green Screen Matte and Cleanup
X:: aePreset("GSKey - combo 2") ; Spill reduction and Color corection

F5:: aeGain("-8")
F6:: aeGain("-4")
F7:: aeGain("+4")
F8:: aeGain("+8")

M:: aeBlendingMode("normal")
N:: aeBlendingMode("screen")

Numpad1:: aeResolution("Full") 	; Full Resolution
Numpad2:: aeResolution("Half") 	; 1/2 Resolution
Numpad3:: aeResolution("1/4")	; 1/4 Resolution