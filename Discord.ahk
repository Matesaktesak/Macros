; This script makes Spotify pause playback when PTT in Discord is activated...
; ... and if its not playing, it won't start it out of the blue.

; If your using this script on its own, uncomment the next line
; I use Break/Pause as the PTT key in Discord

;~$Pause:: PTT() ; The $ is there just as a percaution from previous versions of the script which were triggering themselfs


PTT(){                              ; Pust-To-Talk function
    SetTitleMatchMode 2             ; Mach by RegEx anywhere
    detecthiddenwindows, on
    WinGet, id, list, ahk_exe Spotify.exe ; Find all hidden Spotify windows
    Loop, %id% {                            ; List trough them untill we find the one we need
        this_ID := id%A_Index%
        WinGetTitle, title, ahk_id %this_ID%
        If !(title = "" || title = "Default IME" || title = "MSCTFIME UI" || title = "GDI+ Window (Spotify.exe)")
            break
    }
    if(title != "Spotify Premium"){         ; The title is "Spotify Premium" when nothing is playing
        Send {Media_Stop}                   ; Stop the song
        KeyWait, Pause                      ; Wait until the user releases the hotkey (CHANGE this to your hotkey)
        Sleep 250                           ; Prevent Spotify from "debouncing" the Media_Play_Pause key 😂
        Send {Media_Play_Pause}             ; Let Spotify play again
    }
    return 
}
