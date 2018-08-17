::  By JaCk  |  Debug 08/14/2018  |  Source  https://github.com/1ijack/BatchMajeek/blob/master/lazyJson.bat  |  lazyJson.bat  --- lazy json string parser.
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
@echo off &goto :lazyMain

:::::::::::::::::::::::::::::::::::::::
::                                   ::
:::            Functions            :::
::                                   ::
:::::::::::::::::::::::::::::::::::::::
                              goto :eof

rem some lazy crap to tell you how to use this crappy script [copy-pasta from keyVal_json *teehee*]
:lazyMain
    if "%~1%~2" equ "" goto :lazyHelp
    call :lazyArgs %*
    goto :eof

:lazyHelp
    (   echo/Usage: %~nx0 Summer\atLake\Jason.json   "SomeFile OuttaSpace.json"   fail3.json
        echo/
        echo/  Prints all key/value pairs to console
        echo/  TL;DR -- NEEDS to have a whitespace on AT LEAST ONE side of the colon.  Each key/value pair needs to be on a separate line
        echo/    Note:
        echo/      a space before/after a colon, and brackets -- { "key" : "value" }
        echo/      \n and \r\n are considered end-of-key-value
        echo/      makes no distinction between an [array] and {key:value} and considers \r\n[array]\r\n as a valueless key
        echo/      commas outside double-quotes are ignored
    )
    goto :eof

rem not my #1 laziest argsParser, but a good third place
:lazyArgs
    rem leave when empty or notFile
    set "t{aB}="
    if "%~1" equ "" goto :eof
    set "t{aB}=%~a1 "
    if "%t{aB}:~0,1%" neq " " (
        if "%t{aB}:~0,1%" equ "-" call :keyVal_jsonFile "%~1"
        shift /1
        goto %~0
    ) else call :keyVal_jsonObject %*
    set "t{aB}="
    goto :eof


::  Usage  ::  keyVal_jsonFile  "path\to\json\file.json"   "file2.json"
rem  Prints all key/value pairs to console
rem  TL;DR -- NEEDS to have a whitespace on AT LEAST ONE side of the colon.  Each key/value pair needs to be on a separate line
rem    Notes: 
rem      a space before/after a colon, and brackets -- { "key" : "value" }
rem      \n and \r\n are considered end-of-key-value
rem      makes no distinction between an [array] and {key:value} and considers \r\n[array]\r\n as a valueless key
rem      commas outside double-quotes are ignored
:keyVal_jsonFile
    if "%~1" equ "" goto :eof
    for /f "usebackq tokens=1,* delims=:{}[]" %%A in ("%~1") do for /f "tokens=*" %%C in ("%%A") do if "%%~C" neq " " if "%%~C" neq "" for /f %%S in ('"(for /f %%T in (%%B) do @echo//) 2>&1"
    ') do if "%%S" equ "The" (
        for %%E in (%%B) do echo/"%%~C=%%~E"
    ) else for /f "tokens=*" %%E in (%%B) do echo/"%%~C=%%~E"
    shift /1
    goto %~0

::  Usage  ::  keyVal_jsonObject  "key" : "Value"
::  Usage  ::  keyVal_jsonObject  { "key" : "Value", }
rem  This function is still super buggy, do not use for live env
:keyVal_jsonObject
    if not defined %~n0Debug ((echo/%~nx0%~0: Unstable Fucntion: leaving) &goto :eof)
    if "%~1" equ "" goto :eof
    for /f "tokens=1,* delims=:{}[]" %%A in ("%*") do for /f "tokens=1*" %%C in ("%%A") do if "%%~C" neq " " if "%%~C" neq "" for /f %%S in ('"(for /f %%T in (%%B) do @echo//) 2>&1"
    ') do if "%%S" equ "The" (
        for %%E in (%%B) do if not defined #fVA (
            set/a#fVA+=1
            echo/"%%~C=%%~E"
        )
        set "#fVA="
    ) else for /f "tokens=*" %%E in (%%B) do echo/"%%~C=%%~E"
    goto :eof
