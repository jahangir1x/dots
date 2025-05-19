#Requires AutoHotkey v2.0.2
#SingleInstance Force
Persistent  ; Prevent the script from exiting automatically.

TraySetIcon("C:\Users\rocky\.config\AutoHotkey\masir_launcher.ico")

RunWait('taskkill /IM masir.exe /F', , 'Hide')
Sleep 1000
Run('C:\Users\rocky\.cargo\bin\masir.exe', , 'Hide')

OnExit ExitObject.Exiting

class ExitObject {
    static Exiting(*) {
        RunWait('taskkill /IM masir.exe /F')
    }
}
