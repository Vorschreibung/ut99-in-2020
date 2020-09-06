@ECHO OFF
REM .umod Install Script v1.2 (2020-09-06) (e3644839fc48e2e)
REM https://vorschreibung.github.io/ut99-in-2020/
REM - - - - - - - - - - - - - - - - - - - - - - - 
REM this script can be used to install .umod files
REM copy this script to the root directory of your UT99 installation
REM
REM usage: drag and drop .umod files in windows-explorer onto this script


REM parent path of the current .bat
SET ut99dir=%~dp0

:NextArg
IF "%1"=="" GOTO EOF
ECHO installing "%~nx1"
"%ut99dir%\System\Setup.exe" install "%1"
SHIFT
GOTO NextArg
:EOF

PAUSE
