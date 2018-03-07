::  by JaCk  |  Release 03/07/2018  |  https://github.com/1ijack/BatchMajeek/blob/master/elevate/elevate.cmd   |  elevate.cmd  --  checks current env to see if we're already elevated, when not, we relaunch elevated and launch the piggybacked arguments
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


::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::

:::  Example of how to use/incorporate into your script
:::    opens 'cmd.exe' elevated, then leaves
:::    This commented-out one-liner depends on label 'func_jack_me_sudo_via_cacls'
:::    OneLiner: asking jackOfMostTrades to work his majeek
REM  ((( call :func_jack_me_sudo_via_cacls ) && cmd.exe /k ) || echo/) & goto :eof

:::  Example of how to use/incorporate into your script
:::    opens elevated 'myscript.bat arg1 arg2 arg3 etc', then leaves
:::    This commented-out one-liner depends on label 'func_jack_me_sudo_via_net_session'
:::    OneLiner: asking jackOfMostTrades to work his majeek
REM  (( call :func_jack_me_sudo_via_net_session ) && myscript.bat arg1 arg2 arg3 etc ) & goto :eof

::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::


::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::

::: Saving all arguments to temp file
::  Note: elevator-script does not pass args; only used when script is elevated
if "%~1%~2%~3" neq "" (
    echo/%*
) > "%temp%\%~nx0.args"

::: Pushing the elevator button to see if need to go up
call :func_can_i_has_admin  can_i_has_admin
if not defined can_i_has_admin (
    endlocal
    goto :eof 
)

::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::

::: The following commands will execute only with administrator privileges

rem   when no arguments, open up a new command prompt console session
if not exist "%temp%\%~nx0.args" (
    endlocal
    cmd.exe
    goto :eof
)

rem   Launches/removes whatever arguments that were given to %0
for /f "usebackq tokens=* delims=" %%A in (
    "%temp%\%~nx0.args"
) do ( 
    ( del /q "%temp%\%~nx0.args"
    ) 2>nul 1>nul
    endlocal
    %%A
    goto :eof
)

rem  Just to make sure....
( del /q "%temp%\%~nx0.args"
) 2>nul 1>nul
goto :eof


::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::             :::              :::             ::::::::::
::::::::::  Functions  :::   Functions  :::  Functions  ::::::::::
::::::::::             :::              :::             ::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
                                                         goto :eof

::::::::::::::::::::::::::::::::::::::::::::::::
:::::  Bureaucratic Method 
:::    -- Delegate the task(s) down an organized hierarchy of individual functions
::
::::::::::::::::::::::::::::::::::::::::::::::::

    ::  Usage  ::  func_can_i_has_admin   returnVar   "path\file.name.vbs"
    rem  Elevates this script with administrator privledges -- param1: returnVar with true/undefined; -- param2: scriptname
    :func_can_i_has_admin
        if "%~1" equ ""      ( ( call %~0  can_i_has_admin           %2                         ) & goto :eof )
        if "%~2" equ ""      ( ( call %~0       %1         "%temp%\sudo_make_me_a_sandwich.vbs" ) & goto :eof )
        if "%~x2" neq ".vbs" ( ( call %~0       %1                 "%~2.vbs"                    ) & goto :eof )
        if defined %~1       ( ( echo %date:~-10% %time:~0,-3% %~nx0%~0: Info: elevated)          & goto :eof )

        call :func_elv_adminCheck_net_session  %1
        if defined %~1       ( ( echo %date:~-10% %time:~0,-3% %~nx0%~0: Info: elevated)          & goto :eof )

        ( call :func_elv_create_elevator  "%~2"
        ) 1>nul
        if not exist "%~f2" goto :eof

        ( "%SystemRoot%\system32\cscript.exe" //nologo //b "%~f2" "%~f0"
          timeout /t 2
          rem  ping %computername% -n 2 -w 1000
          del /q %2
        ) 2>nul 1>nul 
    goto :eof

    ::  Usage  ::  func_elv_create_elevator   path\file.name.vbs
    rem  Creates a vbs script to param1, or "%temp%\getadmin.vbs". Note: extension needs to be .vbs
    :func_elv_create_elevator
        if  "%~1" equ   ""   exit /b 101
        if "%~x1" neq ".vbs" exit /b 101

        ( echo/&echo/Set Admin = CreateObject^("Shell.Application"^)
          echo/Admin.ShellExecute WScript.Arguments^(0^), "", "", "runas", 1
        ) > "%~1"

        if not exist "%~1" ( 
            echo %date:~-10% %time:~0,-3% %~nx0%~0: Error: Ascension procurement has either errored or been denied.  try to elevate the unascended "%~nx0" at another time. 
            echo %date:~-10% %time:~0,-3% %~nx0%~0: Error: Internal: Unable to locate elevator: "%~1"
        ) 1>&2
    goto :eof

    ::  Usage  ::  func_elv_adminCheck_net_session  returnVar
    rem  Returns (Err0) param1 set to true when elevated, otherwise undefines param1 (Err2)
    :func_elv_adminCheck_cacls
        if "%~1" equ "" exit /b 101
        set "%~1=true"

        setlocal EnableDelayedExpansion EnableExtensions
        call "%SystemRoot%\system32\cacls.exe" "%SystemRoot%\system32\config\system" 2>nul 1>nul || set "%~1="
        endlocal

        if not defined %~1 ( exit /b 2 ) else exit /b 0
    goto :eof

    ::  Usage  ::  func_elv_adminCheck_net_session  returnVar
    rem  Returns (Err0) param1 set to true when elevated, otherwise undefines param1 (Err2)
    :func_elv_adminCheck_net_session
        if "%~1" equ "" exit /b 101

        for /f "tokens=2,3" %%A in ('net session 2^>^&1') do if /i "%%~A" neq "error" if /i "%%~B" neq "denied." ( ( set "%~1=true" ) & exit /b 0 )

        set "%~1="
        exit /b 2
    goto :eof
::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::


::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::             :::              :::             ::::::::::
::::::::::  Functions  :::   Functions  :::  Functions  ::::::::::
::::::::::             :::              :::             ::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
                                                         goto :eof

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:::::  Oneliner Methods
:::    -- use errorlevel to determine the status:  
::        0 = elevated
::        2 = denied/no permissions
::       10 = successfully called elevated relaunch. (still not elevated)

::::::::::::::::::::::::::::::::::::::::::::::::
    ::  Usage  ::  func_jack_me_sudo_via_cacls
    rem  Checks elevate status by cacls
    rem  OneLiner/jackOfMostTrades -- (561chars) -- EZ:1,2,3: 1: When no elevated permissions (Err2), 2: elevate-self (Err10), 3: exit after self-relaunch (Err0)
    :func_jack_me_sudo_via_cacls
        setlocal EnableDelayedExpansion EnableExtensions & ( call "%SystemRoot%\system32\cacls.exe" "%SystemRoot%\system32\config\system" 2>nul 1>nul && echo/%date:~-10% %time:~0,-3% %~nx0: Info: elevated) || ( echo/> "%temp%\getadmin.vbs" && ( echo/Set Admin = CreateObject^("Shell.Application"^) &echo/Admin.ShellExecute WScript.Arguments^(0^), "", "", "runas", 1 &echo/) >> "%temp%\getadmin.vbs" && (( call cscript //B //NOLOGO "%temp%\getadmin.vbs" "%~s0") & (echo/%date:~-10% %time:~0,-3% %~nx0: Info: not elevated) & endlocal & exit /b 10 ) & endlocal & exit /b )
    goto :eof

::::::::::::::::::::::::::::::::::::::::::::::::

    ::  Usage  ::  func_jack_me_sudo_via_net_session
    rem  Checks elevate status by net session 
    rem  OneLiner/jackOfMostTrades -- (532chars) -- EZ:1,2,3: 1: When no elevated permissions (Err2), 2: elevate-self (Err10), 3: exit after self-relaunch (Err0)
    :func_jack_me_sudo_via_net_session
        setlocal EnableDelayedExpansion EnableExtensions & ( call "%SystemRoot%\system32\net" session 2>nul 1>nul && echo %date:~-10% %time:~0,-3% %~nx0: Info: elevated) || ( echo/> "%temp%\getadmin.vbs" && ( echo/Set Admin = CreateObject^("Shell.Application"^) &echo/Admin.ShellExecute WScript.Arguments^(0^), "", "", "runas", 1 &echo/) >> "%temp%\getadmin.vbs" && (( call cscript //T:30 //B //NOLOGO "%temp%\getadmin.vbs" "%~s0") & (echo/%date:~-10% %time:~0,-3% %~nx0: Info: not elevated) & endlocal & exit /b 10 ) & endlocal & exit /b )
    goto :eof
::::::::::::::::::::::::::::::::::::::::::::::::

