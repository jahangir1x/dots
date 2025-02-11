@echo off

REM remove the old files for Code
del /f /q %APPDATA%\Code\User\settings.json
del /f /q %APPDATA%\Code\User\keybindings.json
del /f /s /q %APPDATA%\Code\User\snippets\*
rmdir /s /q %APPDATA%\Code\User\snippets

REM copy the new files for Code
copy home\.config\Code\User\settings.json %APPDATA%\Code\User\settings.json
copy home\.config\Code\User\keybindings.json %APPDATA%\Code\User\keybindings.json
mkdir %APPDATA%\Code\User\snippets
copy home\.config\Code\User\snippets\* %APPDATA%\Code\User\snippets\