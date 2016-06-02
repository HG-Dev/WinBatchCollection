@echo off
TITLE Add entry to your Windows HOST file
COLOR F0

SET MYIP=127.0.0.1
SET MYURL=mylocalhost

ECHO Creating backup of HOSTS file...
COPY %WINDIR%\system32\drivers\etc\hosts %WINDIR%\system32\drivers\etc\hosts.bak || GOTO ERROR

SET Choice=
SET /P Choice="Add %MYURL% to HOSTS file? (Y/N) "

IF NOT '%Choice%'=='' SET Choice=%Choice:~0,1%

ECHO.
IF /I '%Choice%'=='Y' GOTO ACCEPTED
ECHO Operation was cancelled.
GOTO END

:ACCEPTED
SET NEWLINE=^& ECHO.
ECHO Checking for preexisting definition (%MYIP%   %MYURL%)
FIND /C /I "%MYURL%" %WINDIR%\system32\drivers\etc\hosts
IF %ERRORLEVEL% NEQ 0 GOTO INSERT
FIND /C /I "%MYIP%   %MYURL%" %WINDIR%\system32\drivers\etc\hosts
IF %ERRORLEVEL% EQU 0 GOTO NONEED

REM Delete outdated entry from HOSTS file.
FINDSTR /v %MYURL% %WINDIR%\system32\drivers\etc\hosts.bak > %WINDIR%\system32\drivers\etc\hosts

:INSERT
ECHO(%NEWLINE%>>%WINDIR%\system32\drivers\etc\hosts
ECHO %MYIP%   %MYURL%>>%WINDIR%\system32\drivers\etc\hosts
ECHO.
ECHO Finished.
ipconfig /flushdns
GOTO END

:ERROR
ECHO.
ECHO An error occurred. Be sure to run this batch file with administrator privileges.
GOTO END

:NONEED
ECHO.
ECHO %MYIP% has already been registered with the correct IP (see above).

:END
ECHO This window will close automatically.
ECHO.
REM DEL %WINDIR%\system32\drivers\etc\hosts.bak
ping -n 15 127.0.0.1 > nul
EXIT