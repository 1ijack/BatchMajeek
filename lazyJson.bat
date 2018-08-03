::  By JaCk  |  Release 08/03/2018  |   https://github.com/1ijack/BatchMajeek/blob/master/lazyJson.bat  |  lazyJson.bat  --- too lazy to write this right now.
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
@echo off &setlocal EnableExtensions

if "%~1" equ "" goto :lazyHelp
call :lazyArgs %*
goto :eof

:::::::::::::::::::::::::::::::::::::::
::                                   ::
:::            Functions            :::
::                                   ::
:::::::::::::::::::::::::::::::::::::::
                              goto :eof

rem some lazy crap to tell you how to use this crappy script [copy-pasta from keyVal_json *teehee*]
:lazyHelp
    (   echo/Usage: %~nx0 Summer\atLake\Jason.json  "SomeFile OuttaSpace.json"    fail3.json
        echo/
        echo/  defines all key/value pairs as envVars
        echo/  TL;DR -- NEEDS to have a whitespace on BOTH sides of the colon and each key/value pair needs to be on a separate line
        echo/    Note: when returnVar is supplied, returns an array of all the json keys from the files
        echo/    Note: clearing variables -- empty values for non-empty keys are not ignored
        echo/    lazy json parser -- works -- limitations
        echo/      spaces between colon and brackets -- { "key" : "value" }
        echo/      \n and \r\n are considered end-of-key-value
        echo/      makes no distinction between an [array] and {key:value} and considers \r\n[array]\r\n as a valueless key
        echo/      commas outside double-quotes are ignored
    )
    goto :eof

rem not my #1 laziest argsParser, but a good third place
:lazyArgs
    if "%~1" equ "" goto :eof

    rem Only Accept File/Dir Paths
    if "%~a1" equ "" (
        echo/%~nx0%~0: Not sure what you mean and too lazy to find out. Skipping %1
        shift /1
        goto %~0
    )

    rem when dir reloop with file list
    set "t{aB}=%~a1 "
    if /i "%t{aB}:~0,1%" equ "d" (
        for %%A in ("%~2\*") do call %~0 "%%A"
        goto :eof
    )
    set "t{aB}="

    rem set json key/value pairs to env
    call :keyVal_json lazyJsonKeys %1

    rem  debug -- prints all the key+value pairs from the json file; pause before continuing
    REM ((for %%A in (%lazyJsonKeys%) do set %%~A) &pause)
    for %%A in (%lazyJsonKeys%) do 2>nul set %%~A
    set "lazyJsonKeys="

    shift /1
    goto %~0


::  Usage  ::  keyVal_json  returnVar  "path\to\json\file.json"
::  Usage  ::  keyVal_json  "path\to\json\file.json"
rem  defines all key/value pairs as envVars
rem  TL;DR -- NEEDS to have a whitespace on BOTH sides of the colon and each key/value pair needs to be on a separate line
rem    Note: when returnVar is supplied, returns an array of all the json keys from the files
rem    Note: clearing variables -- empty values for non-empty keys are not ignored
rem    lazy json parser -- works -- limitations
rem      spaces between colon and brackets -- { "key" : "value" }
rem      \n and \r\n are considered end-of-key-value
rem      makes no distinction between an [array] and {key:value} and considers \r\n[array]\r\n as a valueless key
rem      commas outside double-quotes are ignored
:keyVal_json
    if "%~1" equ "" (
        if "%~2" neq "" call %~0 kv{A}js %2 %3 %4 %5 %6 %7 %8 %9
        shift /1
        goto %~0
    ) else if "%~x1" equ ".json" if not defined lp{A}lk (
        set "lp{A}lk=true"
        call %~0 "json{%~n1}" %*
        set "json{%~n1}="
        set "lp{A}lk="
        shift /1
        goto %~0
    )
    if "%~2" equ "" (goto :eof) else if "%~x2" neq ".json" if not exist "%~2" if exist "%~2.json" ((call %~0 %1 "%~2.json") &goto %~0)

    for /f "usebackq tokens=1,* delims=:{}[]" %%A in ("%~2") do for /f "tokens=*" %%C in (%%A) do for /f "tokens=*" %%E in (%%B) do if "%%~C" neq "" set "%%~C=%%~E"

    ( for /f "usebackq tokens=1,* delims=:{}[]" %%A in ("%~2") do for /f "tokens=*" %%C in (%%A) do call set "%~1=%%%~1%%;%%~C"
    ) 2>nul

    shift /2

    goto %~0