::  by JaCk  |  Release 01/20/2018  |  https://github.com/1ijack/BatchMajeek/blob/master/elevate/elevate.cmd   |  elevate.cmd  --  checks current env to see if we're already elevated, when not we relaunch elevated.
:: 
::::  The zlib/libpng License -- https://opensource.org/licenses/Zlib
::  Copyright (c) 2018 JaCk
::  
::  This software is provided 'as-is', without any express or implied warranty. In no event will the authors be held liable for any damages arising from the use of this software.
::  
::  Permission is granted to anyone to use this software for any purpose, including commercial applications, and to alter it and redistribute it freely, subject to the following restrictions:
::  
::  1. The origin of this software must not be misrepresented; you must not claim that you wrote the original software. If you use this software in a product, an acknowledgment in the product documentation would be appreciated but is not required.
::  
::  2. Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.
::  
::  3. This notice may not be removed or altered from any source distribution.
@echo off & setlocal DisableDelayedExpansion EnableExtensions


::: asking jackOfMostTrades to work his OneLiner majeek
REM call :func_jack_me_sudo_via_net_session || endlocal & goto :eof

::: Pushing the elevator button to see if need to go up
call :func_can_i_has_admin  i_has_admin
if not defined i_has_admin endlocal & goto :eof

::: The following commands will execute only with administrator privledges
cmd     rem this just opens up a new command prompt console

:::  Leave script 
endlocal
goto :eof



::::::::::  Bunctions  ::::::::::
                        goto :eof

::::::::::::::::::::::::::::::::::::::::::::::::

:::::  Bureaucratic Method 
:::    -- Delegate the task(s) down a organized hierarchy of indiviual worker bunctions

    ::  Usage  ::  func_can_i_has_admin   returnVar   "path\file.name.vbs"
    rem  Elevates this script with administrator privledges -- param1: returnVar with true/undefined; -- param2: scriptname
    :func_can_i_has_admin
        if "%~1" equ ""    ( call %~0  i_has_admin  &goto :eof ) else if defined %~1 echo Info: %~nx0 has elevated privledges &goto :eof
        if "%~2" equ ""      call %~0  %1  "%cd%\sudo_make_me_a_sandwich.vbs"  &goto :eof
        if "%~x2" neq ".vbs" call %~0  %1  "%~2.vbs"  &goto :eof
        
        call :func_elv_adminCheck_net_session  %1
        if defined %~1 echo Info: %~nx0 has elevated privledges &goto :eof

        ( call :func_elv_create_elevator  %2 ) 1>nul
        "%SYSTEMROOT%\system32\cscript.exe" //nologo //b %2 "%~f0"
        ( ping %computername% -n 2 -w 1000 ) 2>nul 1>nul & ( del /q %2 )
    goto :eof

    ::  Usage  ::  func_elv_create_elevator   path\file.name.vbs
    rem  Creates a vbs script to param1, or "%temp%\getadmin.vbs". Note: extension needs to be .vbs
    :func_elv_create_elevator
        if "%~1" equ "" ( call %~0  "%temp%\getadmin.vbs" &goto :eof ) else if "%~x1" neq ".vbs" ( call %~0  "%~1.vbs" &goto :eof )
        ( echo/&echo/Set Admin = CreateObject^("Shell.Application"^)
          echo/Admin.ShellExecute WScript.Arguments^(0^), "", "", "runas", 1) > "%~1"
        if not exist "%~1" ( echo Error: Ascension procurement has either errored or been denied.  try to elevate the unascended at another time. &echo Error: Internal: Unable to locate elevator: "%~1" &goto :eof ) 1>&2
    goto :eof

    ::  Usage  ::  func_elv_adminCheck_net_session  returnVar
    rem  Returns (Err0) param1 set to true when elevated, otherwise undefines param1 (Err2)
    :func_elv_adminCheck_cacls
        if "%~1" equ "" ( call %~0  "i_has_admin" &goto :eof ) else set "%~1=true"
        setlocal EnableDelayedExpansion EnableExtensions
        call "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system" 2>nul 1>nul || set "%~1="
        endlocal
        if not defined %~1 exit /b 2
        exit /b 0
    goto :eof

    ::  Usage  ::  func_elv_adminCheck_net_session  returnVar
    rem  Returns (Err0) param1 set to true when elevated, otherwise undefines param1 (Err2)
    :func_elv_adminCheck_net_session
        if "%~1" equ "" ( call %~0  "i_has_admin" &goto :eof ) else set "%~1=true"
        for /f "tokens=3" %%A in ('net session 2^>^&1') do if /i "%%~A" equ "denied." set "%~1="
    goto :eof
::::::::::::::::::::::::::::::::::::::::::::::::





::::::::::  Bunctions  ::::::::::
                        goto :eof

:::::  Oneliner Methods
:::    -- use errorlevel to determine the status: 0 - elevated;  10 - Unelevated, relaunching as elevated;  2 - No Permissions

::::::::::::::::::::::::::::::::::::::::::::::::
    ::  Usage  ::  func_jack_me_sudo_via_cacls
    rem  Checks elevate status by cacls
    rem  OneLiner/jackOfMostTrades -- (491chars) -- EZ:1,2,3: 1: When no elevated permissions (Err2), 2: elevate-self (Err10), 3: exit after self-relaunch (Err0)
    :func_jack_me_sudo_via_cacls
        setlocal EnableDelayedExpansion EnableExtensions & ( call "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system" 2>nul 1>nul && echo/Info: %~nx0 has elevated privledges ) || ( echo/> "%temp%\getadmin.vbs" && ( echo/Set Admin = CreateObject^("Shell.Application"^) &echo/Admin.ShellExecute WScript.Arguments^(0^), "", "", "runas", 1 &echo/) >> "%temp%\getadmin.vbs" && (( call cscript //B //NOLOGO "%temp%\getadmin.vbs" "%~s0") & endlocal & exit /b 10 ) & endlocal & exit /b )
    goto :eof

::::::::::::::::::::::::::::::::::::::::::::::::

    ::  Usage  ::  func_jack_me_sudo_via_net_session
    rem  Checks elevate status by net session 
    rem  OneLiner/jackOfMostTrades -- (437chars) -- EZ:1,2,3: 1: When no elevated permissions (Err2), 2: elevate-self (Err10), 3: exit after self-relaunch (Err0)
    :func_jack_me_sudo_via_net_session
        setlocal EnableDelayedExpansion EnableExtensions & ( call "%SYSTEMROOT%\system32\net" session 2>nul 1>nul && echo Info: %~nx0 has elevated privledges) || ( echo/> "%temp%\getadmin.vbs" && ( echo/Set Admin = CreateObject^("Shell.Application"^) &echo/Admin.ShellExecute WScript.Arguments^(0^), "", "", "runas", 1 &echo/) >> "%temp%\getadmin.vbs" && (( call cscript //T:30 //B //NOLOGO "%temp%\getadmin.vbs" "%~s0") & endlocal & exit /b 10 ) & endlocal & exit /b )
    goto :eof
::::::::::::::::::::::::::::::::::::::::::::::::

