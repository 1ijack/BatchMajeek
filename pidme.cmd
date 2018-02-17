::  By JaCk  |  Release 02/15/2018  |  https://github.com/1ijack/BatchMajeek/blob/master/pidme.cmd  |  pidme.cmd -- using powershell, starts the command and returns the pid
::  sourced from comments of URL :  http://techibee.com/uncategorized/pstip-start-a-process-and-get-its-pid-using-powershell/1939
:::  
:::  The zlib/libpng License -- https://opensource.org/licenses/Zlib
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
:::
@echo off & setlocal DisableDelayedExpansion EnableExtensions 

::  Usage  ::  func_pdm_user_settings
rem  Contains user variable settings
:func_pdm_user_settings
    rem  location of powershell binary
    set "pdm_ps_bin=powershell.exe"
REM goto :eof


::::::::::::::::::::::::::::::::::::::::
::                                    ::
::             Bunctions              ::
::                                    ::
::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::
:::                                  :::
::   "func" labels have the closing   ::
::  commands rem'd out so it runs as  ::
::    a classic batchfile in this     ::
::     script but still be easily     ::
::   transferrable to other scripts   ::
:::                                  :::
::::::::::::::::::::::::::::::::::::::::


::  Usage  ::  func_pdm_check_args  Args
rem  Checks for known args
:func_pdm_check_args
                     if    "%~1" equ ""       ( echo/&echo/Usage Help: %~n0 Starts a process and returns PID&echo/  %~nx0 [ /?^| -h^| --help^| {command} {args} ]
    goto :eof ) else if    "%~1" equ "/?"     ( echo/&echo/Usage Help: %~n0 Starts a process and returns PID&echo/  %~nx0 [ /?^| -h^| --help^| {command} {args} ]
    goto :eof ) else if /i "%~1" equ "/h"     ( echo/&echo/Usage Help: %~n0 Starts a process and returns PID&echo/  %~nx0 [ /?^| -h^| --help^| {command} {args} ]
    goto :eof ) else if /i "%~1" equ "-h"     ( echo/&echo/Usage Help: %~n0 Starts a process and returns PID&echo/  %~nx0 [ /?^| -h^| --help^| {command} {args} ]
    goto :eof ) else if /i "%~1" equ "/help"  ( echo/&echo/Usage Help: %~n0 Starts a process and returns PID&echo/  %~nx0 [ /?^| -h^| --help^| {command} {args} ]
    goto :eof ) else if /i "%~1" equ "--help" ( echo/&echo/Usage Help: %~n0 Starts a process and returns PID&echo/  %~nx0 [ /?^| -h^| --help^| {command} {args} ]
    goto :eof ) 
REM goto :eof


::  Usage  ::  func_pdm_check_ps_path  
rem  when bin-path is defined, but not with a path, pure-batch search path var
rem  when bin-path is not defined, pure-batch search path var
:func_pdm_check_ps_path
    rem  compare strings; when relative/absolute path is missing, search path var
    if defined pdm_ps_bin for %%P in ("%pdm_ps_bin%") do  if "%%~nxP" equ "%pdm_ps_bin%" ( for %%P in ("%pdm_ps_bin%") do for %%e in (;%PATHEXT%) do for %%i in (%%~nP%%e) do if not "%%~$PATH:i" equ "" set "pdm_ps_bin=%%~$PATH:i"
                                                    ) else if "%%~nP" equ "%pdm_ps_bin%"   for %%P in ("%pdm_ps_bin%") do for %%e in (;%PATHEXT%) do for %%i in (%%~nP%%e) do if not "%%~$PATH:i" equ "" set "pdm_ps_bin=%%~$PATH:i"

    rem  path\bin definition missing, search path var
    if not defined pdm_ps_bin for %%P in ("powershell.exe") do for %%e in (;%PATHEXT%) do for %%i in (%%~nP%%e) do if not "%%~$PATH:i" equ "" set "pdm_ps_bin=%%~$PATH:i"
REM goto :eof


::  Usage  ::  func_pdm_startProcess_returnPid  binOrCommand "with Args"
rem  eval args and print process id to console
:func_pdm_startProcess_returnPid
    "%pdm_ps_bin%" -C (Start-Process -PassThru -FilePath "%*").Id
REM goto :eof


::  Usage  ::  func_pdm_gtfo
rem  cleanup env changes
:func_pdm_gtfo
    set "pdm_ps_bin="
    endlocal
REM goto :eof
