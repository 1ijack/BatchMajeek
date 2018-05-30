::  By JaCk  |  Release 05/30/2018  |  https://github.com/1ijack/BatchMajeek/blob/master/slength.cmd  |  slength.cmd  -- uses findstr to calculate and return string length
:::
:: General concept credit/inspiration/source for length calc
:: by Frank Westlake - RandomizeKey.cmd - lines 24-26
:: :: From the desk of Frank P. Westlake, 2013-01-03
:: :: Package not marked for individual sale.
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
@echo off & setlocal DisableDelayedExpansion EnableExtensions & goto :getLen

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
    set "json{results}="
    set "json{escaped}=true"

    rem  print to console, only the returning string length
    set "text{results}=true"

goto :eof


:::::::::::::::::::::::::::::::::::::::
::                                   ::
::             Functions             ::
::                                   ::
:::::::::::::::::::::::::::::::::::::::
                              goto :eof

::  Usage  ::  getLen
:getLen
    if "%~1" equ "" goto :func_sln_nein
    rem pull user settings once
    if not defined sln_flag_init call :func_sln_user_settings
    set "sln_flag_init=true"
    rem variable or string
    set "{len}="
    set "{str}=%~1"
    ( if defined %{str}% call set "{str}=%%{str}%%" ) 2>nul
    rem measuring tape
    if defined {str} call :func_sln_lenString
    rem reporter
    call :func_sln_conWriter  {len}   {str}
    rem reloop
    shift /1
goto :getLen


::  Usage  ::  func_sln_nein
rem  script cleanup, env uninit while leaving gracefully
:func_sln_nein
    set "{str}="
    set "{len}="
    set "sln_flag_init="
    set "json{results}="
    set "json{escaped}="
    set "text{results}="
    ((endlocal) &goto :eof)
goto :eof


::  Usage  ::  func_sln_conWriter   varNameLength   varNameString
rem  [fails to] report results.  based on user variables
:func_sln_conWriter
    if    ""  equ "%~2" goto :eof
    if    ""  equ "%~1" goto :eof
    if not defined %~2  goto :eof
    if not defined %~1  goto :eof
    rem  report simple results
    if defined text{results} call echo/%%%~1%%
    rem  fiends... ye no friends of json...
    if not defined json{results} goto :eof
    rem  you cant escape me...
    if not defined json{escaped} (
        call echo/{"length" : "%%%~1%%", "string" : "%%%~2%%" }
        goto :eof
    )
    rem  escapeJson, report and tidy-up
    call set "sln_jzon=%%%~2%%"
    set "sln_jzon=%sln_jzon:\=\\%"
    call echo/{ "%~1" : "%%%~1%%", "string" : "%sln_jzon:"=\"%" }
    set "sln_jzon="

goto :eof


::  Usage  ::  func_sln_lenString
rem  returns string length
rem  sources String from variable '{str}'
rem  returns Length  in  variable '{len}'
:func_sln_lenString
    if not defined {str} goto :eof
    rem General concept credit/inspiration/source for length calc
    rem by Frank Westlake - RandomizeKey.cmd - lines 24-26
    rem :: From the desk of Frank P. Westlake, 2013-01-03
    rem :: Package not marked for individual sale.
    for /f "skip=1 tokens=1 delims=:" %%O in ('
        "(echo/{str}&echo/{str})|findstr /boc:{str}"
    ') do for /f "tokens=1 delims=:" %%L in ('
        "(set {str}&echo/{str})|findstr /boc:{str}"
    ') do set /a "{len}=%%~L-%%~O"
    rem  bad results are better than no results... seriously...
    set /a "{len}+=0"

goto :eof


::  Usage  ::  func_getLength   returnVar   "varName{value{String}}"
rem  returns string length set to value of param1.  Uses the value of param2 as the varName to retrieve String
:func_getLength
    if "%~2" equ "" goto :eof
    if "%~1" equ "" goto :eof
    set "%~1=0"
    rem  is parameter a variable or a string
    set "{str}=%~2"
    if defined %~2 call set "{str}=%%%~2%%"
    rem General concept credit/inspiration/source for length calc
    rem by Frank Westlake - RandomizeKey.cmd - lines 24-26
    rem :: From the desk of Frank P. Westlake, 2013-01-03
    rem :: Package not marked for individual sale.
    for /f "skip=1 tokens=1 delims=:" %%O in ('
        "(echo/{str}&echo/{str})|findstr /boc:{str}"
    ') do for /f "tokens=1 delims=:" %%L in ('
        "(set {str}&echo/{str})|findstr /boc:{str}"
    ') do set /a "%~1=%%~L-%%~O"
    set "{str}="
    rem  bad results are better than no results... seriously...
    set /a "%~1+=0"

goto :eof
