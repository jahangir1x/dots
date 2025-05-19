#Persistent
#UseHook
#SingleInstance Force

; Variables to track Win key press time
global winPressed := false
global tapThreshold := 200  ; 200ms threshold for tap detection

; When Win key is pressed
LWin::
{
    winPressed := true
    SetTimer, CheckWinTap, %tapThreshold%
    KeyWait, LWin  ; Wait for release
    winPressed := false
    return
}

CheckWinTap:
{
    if (winPressed)  ; If still pressed after 200ms, don't send anything
        return
    Send, #{Space}  ; Send Win + Space
    return
}
