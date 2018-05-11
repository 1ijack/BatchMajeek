::  by JaCk  |  Release 05/11/2018  |   https://github.com/1ijack/BatchMajeek/blob/master/unixTimeFull.bat  |  unixTimeFull.bat  --  returns current time in unix time  --  total elapsed seconds since January 1st, 1970
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
::::::::::::::::::::::::::::::::::::::::
::
::  What is teh Unix Time?
::    The number of seconds that have passed since the beginning of 00:00:00 UTC Thursday, 1 January 1970. The second layer encodes that number as a sequence of bits or decimal digits.
::  [ source: https://en.wikipedia.org/wiki/Unix_time ]  --  accessed on 04/24/2018 
::
::::::::::::::::::::::::::::::::::::::::
@echo off & setlocal DisableDelayedExpansion EnableExtensions & ( for /f "tokens=1 delims==" %%A in ('set utx_') do set "%%~A=" ) 2>nul 1>nul & goto :func_utx_main


::::::::::::::::::::::::::::::::::::::::
::                                    ::
::           User Settings            ::
::                                    ::
::::::::::::::::::::::::::::::::::::::::
:func_utx_user_settings
    rem ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    rem  -----------------------------------------
    rem  Boolean settings below, use the following values to enable/disable behavior: 
    rem    to Enable,  set to: true
    rem    to Disable, set to: false [or undefined]
    rem  -----------------------------------------

    rem  Note:  When below setting is undefined/false, output is seconds;  otherwise, when value is 'true', output is in milliseconds
    set "utx_out_ms=false"      rem  Default:      ;  Description: utx_out_ms --- will display with ms upto 1000 ms
    rem  -----------------------------------------
    rem ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    
    rem ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    rem -----------------------------------------
    rem  String settings below, use expected strings
    rem    to Enable,  set to: <string>
    rem    to Disable, set to: [undefined]
    rem -----------------------------------------

    rem  The following is to bypass asking the w32tm.exe for the timezone settings.  Value should be in seconds (integer).  When value is undefined, script will ask the OS for timezone configuration.
    rem  -- Example: UTC+7 hours  (aka 420 min), value would be: 25200
    rem  -- Example: UTC+0 hours  (aka   0 min), value would be: 0
    rem  -- Example: UTC-10 hours (aka 600 min), value would be: -36000
    set "utx_utc_offset="
    rem -----------------------------------------
    rem ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
goto :eof

::::::::::::::::::::::::::::::::::::::::
::                                    ::
::                Main                ::
::                                    ::
::::::::::::::::::::::::::::::::::::::::
:func_utx_main
    call :func_utx_user_settings
    call :func_utx_error_checks
    call :func_utx_calc_date_secs   "utx_time{unix}"   "%date:* =%"   "01/01/1970"

    echo/%utx_time{unix}%

    rem Env Cleanup 
    (   for /f "tokens=1 delims==" %%A in ('set utx_') do set "%%~A=" 
        endlocal & goto :eof
    ) 2>nul 1>nul 

goto :eof


::::::::::::::::::::::::::::::::::::::::
::                                    ::
::             Functions              ::
::                                    ::
::::::::::::::::::::::::::::::::::::::::
2>nul (  goto :eof  ||  exit /b  ) 1>nul

::  Usage  ::   func_utx_error_checks
rem  ensure that dependencies are resolved
:func_utx_error_checks
    rem  boolean NEEDS to be defined as something
    if not defined utx_out_ms set "utx_out_ms=false"

    rem  Making sure binary exists, hard-coded value takes priority
    if defined utx_utc_offset (
        set /a "utx_utc{shift}=%utx_utc_offset% * 1"
    ) else if not exist "%SystemRoot%\System32\w32tm.exe" set "utx_utc{shift}=0"
    
goto :eof


::  Usage  ::  func_utx_calc_time_secs_rounded   returnVarSecs   returnVarMS   "optional-HH:MM:SS.MS"
rem  calc time elapsed seconds and ms (today OR param2)  --  w/a for octals by (except ms)
rem  Note:  DOES NOT overwrite returnVarSecs value.  Function ADDs to returnVarSecs
rem  Note:  DOES overwrite returnVarMS value.
:func_utx_calc_time_secs_ms
    if "%~2" equ "" goto :eof
    if "%~1" equ "" goto :eof

    rem  choose between system-clock vs provided-time
    set "utx_scest=%time%"
    if "%~3" neq "" set "utx_scest=%~3"
    
    rem  calculate total seconds and round milliseconds
    rem    returnVar  ghetto ms -- purposefully not checking/fixing octal numbers to ensure three digit MS number
    set "%~2=%utx_scest:~-2%0"

    rem    returnVar  seconds -> seconds          minutes -> seconds              hours -> seconds
    set /a "%~1+=( 1%utx_scest:~-5,2% - 100 ) + (( 1%utx_scest:~3,2% - 100 ) * 60 ) + ( %utx_scest:~0,2% * 3600 )"
    set "utx_scest="
goto :eof


::  Usage  ::  func_utx_get_utc_timeShift   returnVar  optional-[ "hours" | "minutes" | "seconds" | "milliseconds" ]
rem  Returns the (seconds) time difference from the system's timezone and UTC0 (daylight saving and other adjustments also factored)
rem  Note:  Number of seconds can be positive OR negative
rem  Note:  Param2 is optional units of time returned:  'hours', 'minutes', 'seconds', 'milliseconds'
rem  Note:  Param2 default is 'minutes'
:func_utx_get_utc_timeShift
    if "%~1" equ "" goto :eof

    rem  Get current time adjustments
    for /f "tokens=1-8 delims=: " %%A in ('"%SystemRoot%\System32\w32tm.exe" /tz') do (
        if /i "%%~A" equ "Bias" for /f "tokens=1 delims=min" %%g in ("%%~B") do set /a "%~1+=%%g"
        if /i "%%~B" equ "Bias" for /f "tokens=1 delims=min" %%g in ("%%~C") do set /a "%~1+=%%g"
        if /i "%%~C" equ "Bias" for /f "tokens=1 delims=min" %%g in ("%%~D") do set /a "%~1+=%%g"
        if /i "%%~D" equ "Bias" for /f "tokens=1 delims=min" %%g in ("%%~E") do set /a "%~1+=%%g"
        if /i "%%~E" equ "Bias" for /f "tokens=1 delims=min" %%g in ("%%~F") do set /a "%~1+=%%g"
        if /i "%%~F" equ "Bias" for /f "tokens=1 delims=min" %%g in ("%%~G") do set /a "%~1+=%%g"
        if /i "%%~G" equ "Bias" for /f "tokens=1 delims=min" %%g in ("%%~H") do set /a "%~1+=%%g"
    )

    if    "%~2" equ      ""        goto :eof
    if /i "%~2" equ   "minutes"    goto :eof
    
    rem  convert min ->  ( seconds OR milliseconds )
    if /i "%~2" equ    "hours"     set /a "%~1/=60"
    if /i "%~2" equ   "seconds"    set /a "%~1*=60"
    if /i "%~2" equ    "secs"      set /a "%~1*=60"
    if /i "%~2" equ "milliseconds" set /a "%~1*=6000"
    if /i "%~2" equ     "ms"       set /a "%~1*=6000"
    
goto :eof


::  Usage  ::  func_utx_calc_time_secs_rounded   returnVar   "optional-DD/MM/YYYY"   "optional-DD/MM/YYYY"
rem  calc days+months+years elapsed seconds (today/010111970 OR today/param3 OR param2/param3)
rem  Note:  DOES NOT overwrite returnVar value.  Function ADDs to returnVar
rem  Function Notes:
rem    when param2 is greater than param3, swap variables;  compares YYYYMMDD
rem    current time, timezone, DST and other adjustments
rem    calculate all the leapyears between the two year ranges  --  using modulus,  adds '1' when leap-year --  highly modified from source: "http://www.robvanderwoude.com/datetiment.php#LeapYear"
rem    Dates need to be defined as "MM/DD/YYYY" (strip DOW)
rem    ghetto milliseconds ftw
:func_utx_calc_date_secs
    if "%~1" equ "" goto :eof
    if "%~2" equ "" ( ( call %~0   %1   "%date:* =%"   %3 ) & goto :eof )
    if "%~3" equ "" ( ( call %~0   %1   %2   "01/01/1970" ) & goto :eof )

    set "utx_p{two}=%~2"
    set "utx_p{tri}=%~3"
    
    if %utx_p{two}:~-4%%utx_p{two}:~-10,2%%utx_p{two}:~-7,2% lss %utx_p{tri}:~-4%%utx_p{tri}:~-10,2%%utx_p{tri}:~-7,2% (
        set "utx_p{two}=%utx_p{tri}%"
        set "utx_p{tri}=%utx_p{two}%"
    )

    if not defined utx_utc{shift} call :func_utx_get_utc_timeShift   "utx_utc{shift}"    "seconds"
    call :func_utx_calc_time_secs_ms   "utx_elapsed{secs}"   "utx_elapsed{ms}"   "%time%"

    for /l %%A in (%utx_p{tri}:~-4%,1,%utx_p{two}:~-4%) do set /a "utx_leap{total}+=!(%%A %% 4 & %%A %% 100 & %%A %% 400)"

    for /f "tokens=1-3,4-6 delims=-/" %%A in ("%utx_p{two}%/%utx_p{tri}%") do set /a "%~1=((((( 1%%~A - 1%%~D ) * 305 ) / 10 ) + ( 1%%~B - 1%%~E + %utx_leap{total}% ) + ( ( %%~C - %%~F ) * 365 ) ) * 86400 ) - 172800 + %utx_utc{shift}% + %utx_elapsed{secs}%"

    if /i "%utx_out_ms:~0,1%" neq "t" goto :eof
    if defined utx_elapsed{ms} call set "%~1=%%%~1%%%utx_elapsed{ms}%"

goto :eof


