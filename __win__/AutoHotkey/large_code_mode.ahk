#Requires AutoHotkey v2.0.2
#SingleInstance Force

; MoveWindowUnderMouseCursor(Except:="Progman WorkerW Shell_TrayWnd") {  ;    By SKAN on D38S/D38S
; Local                                            ; @ autohotkey.com/boards/viewtopic.php?t=80416
;   MouseGetPos,,, hWnd
;   WinGetClass, Class, % "ahk_id" . WinExist("ahk_id" . hWnd)
;   If ( DllCall("IsZoomed", "Ptr",hWnd)  ||  InStr(" " . Except . " ", " " . Class . " ", True) )
;     Return
;   WinActivate
;   WinWaitActive,,, 0
;   PostMessage, 0x112, 0xF010                                       ;      WM_SYSCOMMAND, SC_MOVE
;   SendEvent ^{Down}
; }
; ^#RButton:: MoveWindowUnderMouseCursor()

#r:: Reload