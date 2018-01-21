::  by JaCk  |  Release 01/21/2018  |  https://github.com/1ijack/BatchMajeek/blob/master/elevate/elvc.cmd  |  elvc.cmd  --  checks current env to see if we're already elevated, when not we relaunch elevated. Minized method.
:::
::  The zlib/libpng License -- https://opensource.org/licenses/Zlib
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



::: Elevating env when needed by asking jackOfMostTrades to work his OneLiner majeek
call :func_jack_me_sudo_via_cacls || ( endlocal & goto :eof )

:: any commands below will run only as elevated  --  "cmd" will launch an interactive cmd console
cmd

:: Leaving script
endlocal
goto :eof



::::::::::  Bunctions  ::::::::::
                        goto :eof

::  Usage  ::  func_jack_me_sudo_via_cacls
rem  Checks elevate status by cacls
rem  OneLiner/jackOfMostTrades -- (491chars) -- EZ:1,2,3: 1: When no elevated permissions (Err2), 2: elevate-self (Err10), 3: exit after self-relaunch (Err0)
:func_jack_me_sudo_via_cacls
    setlocal EnableDelayedExpansion EnableExtensions & ( call "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system" 2>nul 1>nul && echo/Info: %~nx0 has elevated privledges ) || ( echo/> "%temp%\getadmin.vbs" && ( echo/Set Admin = CreateObject^("Shell.Application"^) &echo/Admin.ShellExecute WScript.Arguments^(0^), "", "", "runas", 1 &echo/) >> "%temp%\getadmin.vbs" && (( call cscript //B //NOLOGO "%temp%\getadmin.vbs" "%~s0") & endlocal & exit /b 10 ) & endlocal & exit /b )
goto :eof
