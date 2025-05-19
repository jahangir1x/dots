#Requires AutoHotkey v2.0.2
#SingleInstance Force
Persistent  ; Prevent the script from exiting automatically.

TraySetIcon("C:\Users\rocky\.config\AutoHotkey\komorebi_launcher.ico")

Run('komorebic start', , 'Hide')

OnExit ExitObject.Exiting

class ExitObject {
    static Exiting(*) {
        RunWait('komorebic stop')
    }
}
