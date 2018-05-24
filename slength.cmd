::  By JaCk  |  Release 05/16/2018  |  https://github.com/1ijack/BatchMajeek/blob/master/slength.cmd  |  slength.cmd  -- uses findstr to calculate and return string length
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
@echo off & setlocal DisableDelayedExpansion EnableExtensions & goto :func_sln_mein

 :::::::::::::::::::::::::::::::::::::::
::                                   ::
::           User Settings           ::
::                                   ::
:::::::::::::::::::::::::::::::::::::::

:func_sln_user_settings
    rem  to enable, use "true"
    rem  to disable, use "" -- [undefined]/blank

    rem  when defined, dumps results to console as an [un]escaped json object
    rem  note - all objects are strings, even integers
    set "sln_report_json="
    set "sln_escape_json=true"

    rem  print to console, only the returning string length
    set "sln_report_simple=true"

goto :eof


:::::::::::::::::::::::::::::::::::::::
::                                   ::
::             Functions             ::
::                                   ::
:::::::::::::::::::::::::::::::::::::::
                              goto :eof

::  Usage  ::  func_sln_mein
rem  Used mainly as a label although bearing the function prefix
:func_sln_mein
    rem  Arg/Blank count. quick re-loop on empty OR leave when 2 blanks in a row
    if "%~1" neq "" ( set /a "sln_arcnt+=1, sln_blcnt=0" ) else set /a "sln_blcnt+=1"
    if %sln_blcnt% geq 2 goto :func_sln_nein
    if %sln_blcnt% gtr 0 ( ( shift /1 ) & goto :func_sln_mein )

    rem  pull user settings and use sln_String ONLY on the first run OR reset scriptVars
    if defined sln_flag_init (
        set "sln_String="
        set "sln_Length="
    ) else call :func_sln_user_settings
    set "sln_flag_init=true"

    rem  is parameter a variable or a string
    (( set %~1
    ) 2>nul 1>nul && call set "sln_String=%%%~1%%"
    ) 2>nul 1>nul ||      set "sln_String=%~1"

    rem  *Zip*zap*zip*... measuring tape
    if defined sln_String call :func_sln_lenString
    if 1%sln_Length%1 gtr 11 if 1%sln_Length%1 gtr 101 call :func_sln_conWriter  sln_Length   sln_String

    shift /1

goto :func_sln_mein


::  Usage  ::  func_sln_nein
rem  script cleanup, env uninit while leaving gracefully
:func_sln_nein
    set "sln_jzon="
    set "sln_String="
    set "sln_Length="
    set "sln_flag_init="
    set "sln_report_json="
    set "sln_escape_json="
    set "sln_report_simple="
    ( ( endlocal ) & goto :eof )
goto :eof



::  Usage  ::  func_sln_conWriter   varNameLength   varNameString
rem  [fails to] report results.  based on user variables
:func_sln_conWriter
    if    ""  equ "%~2" goto :eof
    if not defined %~2  goto :eof
    if    ""  equ "%~1" goto :eof
    if not defined %~1  goto :eof

    rem  report simple results
    if defined sln_report_simple call echo/%%%~1%%

    rem  fiends... you are no friends of json...
    if not defined sln_report_json goto :eof

    rem  you cant escape me...
    if not defined sln_escape_json call echo/{"length" : "%%%~1%%", "string" : "%%%~2%%" }
    if not defined sln_escape_json goto :eof

    rem  escapeJson, report and tidy-up
    call set "sln_jzon=%%%~2%%"
    set "sln_jzon=%sln_jzon:\=\\%"
    call echo/{ "%~1" : "%%%~1%%", "string" : "%sln_jzon:"=\"%" }
    set "sln_jzon="

goto :eof


::  Usage  ::  func_sln_lenString
rem  returns string length
rem  sources String from variable 'sln_String'
rem  returns Length  in  variable 'sln_Length'
:func_sln_lenString
    set "sln_Length=0"
    if not defined sln_String goto :eof

    rem  measuring yardstick
    for /f "skip=1 tokens=1 delims=:" %%O in ('
        "(echo/sln_String&echo/sln_String)|findstr /boc:sln_String"
    ') do for /f "tokens=1 delims=:" %%L in ('
        "(set sln_String&echo/sln_String)|findstr /boc:sln_String"
    ') do set /a "sln_Length=%%~L-%%~O"

    rem  bad results are better than no results... seriously...
    if not defined sln_Length set "sln_Length=0"
    if   0   gtr %sln_Length% set "sln_Length=0"

goto :eof


::  Usage  ::  func_sln_varLength   returnVar   "varName{value{String}}"
rem  returns string length set to value of param1.  Uses the value of param2 as the varName to retrieve String
:func_sln_varLength
    if "%~1" equ "" ( goto :eof ) else set "%~1=0"
    if "%~2" equ ""   goto :eof

    rem  is parameter a variable or a string
    (( set %~2
    ) 2>nul 1>nul && call set "sln_vStr=%%%~2%%"
    ) 2>nul 1>nul ||      set "sln_vStr=%~2"

    rem  measuring the yardstick
    for /f "skip=1 tokens=1 delims=:" %%O in ('
        "(echo/sln_vStr&echo/sln_vStr)|findstr /boc:sln_vStr"
    ') do for /f "tokens=1 delims=:" %%L in ('
        "(set sln_vStr&echo/sln_vStr)|findstr /boc:sln_vStr"
    ') do set /a "%~1=%%~L-%%~O"

    set "sln_vStr="

    rem  bad results are better than no results... seriously...
    if not defined %~1 set "%~1=0"

goto :eof

