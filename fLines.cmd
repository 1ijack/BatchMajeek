::  by JaCk  |  Release 05/24/2018  |  https://github.com/1ijack/BatchMajeek/blob/master/fLines.cmd  |  fLines.cmd  --  uses find.exe to get total number of lines in a file
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
@echo off &setlocal DisableDelayedExpansion EnableExtensions
:::::::::::::::::::::::::::::::::::::::
::
::: User Settings
::
:::::::::::::::::::::::::::::::::::::::

rem boolean -- demo - when no args use log and ini files from SystemRoot
set "lc{demo}=true"

:::::::::::::::::::::::::::::::::::::::
::
::: Main
::
:::::::::::::::::::::::::::::::::::::::

rem lazy args parse
if "%~1" neq "" for %%A in (%*
) do if "%%~A" neq "" if exist "%%~A" call :func_FindLineCount "" %%A

rem method - true cleaver of cleared falseness
set "lc{demo}=%lc{demo}%false"
if /i "%lc{demo}:~0,1%" equ "t" (set "lc{demo}=true") else set "lc{demo}="

rem example/demo dump when no args
if defined lc{demo} if "%~1" equ "" for %%A in ("%SystemRoot%\*.log"; "%SystemRoot%\*.ini") do (
    call :func_FindLineCount line{count} "%%A"
    if defined line{count} call echo/%%line{count}%% : %%A
    set "line{count}="
)

rem leave script
set "line{count}="
set "lc{demo}="
set "t{aB}="
set "t{A}="
endlocal
goto :eof

:::::::::::::::::::::::::::::::::::::::
::
::: Functions
::
:::::::::::::::::::::::::::::::::::::::
                              goto :eof

::  Usage  ::  func_FindLineCount   optional-returnVar  "dir\targetFile.extension"
rem  Returns returnVar defined with the targetFile line count
rem  optional param1 - returnVar - when missing, prints line count and file to standard out
rem  requires param2 - "dir\targetFile.extension"
:func_FindLineCount
    if "%~2" equ "" goto :eof
    if "%~1" equ "" (
        call %~0 t{A} %2
        goto :eof
    )
    set "%~1=0"

    rem when dir reloop with file list
    set "t{aB}=%~a2 "
    if /i "%t{aB}:~0,1%" equ "d" (
        for %%A in ("%~2\*") do call %~0 "t{A}" "%%A"
        set "%~1="
        goto :eof
    )
    set "t{aB}="

    rem ensure file exist and grab lines
    if exist %2 for /f "delims=" %%A in ('
        %SystemRoot%\System32\find.exe /c /off /v /i "" %2
    ') do for %%B in (%%~A) do if "%%~xB%%~nB" gtr "----------1.a" ( set "%~1=%%B" ) 2>nul

    rem when internal reloop print and clear
    if "%~1" equ "t{A}" if defined %~1 (
        call echo/%%%~1%% : %2
        set "t{A}="
    )

goto :eof

