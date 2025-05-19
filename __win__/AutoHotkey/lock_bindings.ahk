#Requires AutoHotkey v2.0
#SingleInstance Force

TraySetIcon("C:\Users\rocky\.config\AutoHotkey\lock_bindings.ico")

EnableLock() {
    RegWrite "0", "REG_DWORD", "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\System",
        "DisableLockWorkstation"
}

DisableLock() {
    RegWrite "1", "REG_DWORD", "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\System",
        "DisableLockWorkstation"
}

DisableLock()

; Register pause key
Pause::
{
    EnableLock()
    Sleep 500
    DllCall("LockWorkStation")
    Sleep 3000
    DisableLock()
}
