::  by JaCk  |  Release 04/24/2018  |   https://github.com/1ijack/BatchMajeek/blob/master/unixTime.bat  |  unixTime.bat  --  returns current time in unix time  --  total elapsed seconds since January 1st, 1970
@echo off & setlocal DisableDelayedExpansion EnableExtensions & ( for /f "tokens=1 delims==" %%A in ('set utx_') do set "%%~A=" ) 2>nul 1>nul & goto :func_utx_main

::::::::::::::::::::::::::::::::::::::::
::
::  What is teh Unix Time?
::    The number of seconds that have passed since the beginning of 00:00:00 UTC Thursday, 1 January 1970. The second layer encodes that number as a sequence of bits or decimal digits.
::  [ source: https://en.wikipedia.org/wiki/Unix_time ]  --  accessed on 04/24/2018 
::
::::::::::::::::::::::::::::::::::::::::


::::::::::::::::::::::::::::::::::::::::
::                                    ::
::           User Settings            ::
::                                    ::
::::::::::::::::::::::::::::::::::::::::
:func_utx_user_settings
    rem  Boolean settings below, use the following values to enable/disable behavior: 
    rem    to Enable,  set to: true
    rem    to Disable, set to: false [or undefined]

    rem  Note:  When below setting is undefined/false, output is seconds;  otherwise, when value is 'true', output is in milliseconds
    set "utx_output_milliseconds="      rem  Default:      ;  Description: utx_output_milliseconds --- will display with ms upto 1000 ms

goto :eof


::::::::::::::::::::::::::::::::::::::::
::                                    ::
::                Main                ::
::                                    ::
::::::::::::::::::::::::::::::::::::::::
:func_utx_main
    call :func_utx_user_settings
    call :func_utx_calc_date_secs   "utx_time{unix}"
    
    echo/%utx_time{unix}%

::  Env Cleanup 
( for /f "tokens=1 delims==" %%A in ('set utx_') do set "%%~A=" ) 2>nul 1>nul & ( endlocal & goto :eof )

goto :eof


::::::::::::::::::::::::::::::::::::::::
::                                    ::
::             Functions              ::
::                                    ::
::::::::::::::::::::::::::::::::::::::::
2>nul (  goto :eof  ||  exit /b  ) 1>nul


::  Usage  ::  func_utx_calc_time_secs_rounded   returnVarSecs   returnVarMS   "optional-HH:MM:SS.MS"
rem  calc time elapsed seconds and ms (today OR param2)  --  w/a for octals by (except ms)
rem  Note:  DOES NOT overwrite returnVarSecs value.  Function ADDs to returnVarSecs
rem  Note:  DOES overwrite returnVarMS value.
:func_utx_calc_time_secs_ms
    if "%~2" equ "" goto :eof
    if "%~1" equ "" goto :eof

    rem  choose between system-clock vs provided-time
    set "_scest=%time%"
    if "%~3" neq "" set "_scest=%~3"
    
    rem  calculate total seconds and round milliseconds
    rem    returnVar  ghetto ms -- purposefully not checking/fixing octal numbers to ensure three digit MS number
    set "%~2=%_scest:~-2%0"

    rem    returnVar  seconds -> seconds          minutes -> seconds              hours -> seconds
    set /a "%~1+=(1%_scest:~-5,2% - 100) + ((1%_scest:~3,2% - 100) * 60 ) + (( %_scest:~0,2%  * 60 ) * 60 )"
    set "_scest="
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
               if /i "%%A" equ "Bias" ( for /f "tokens=1 delims=abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ" %%g in ("%%~B") do set /a "%~1+=%%g"
        ) else if /i "%%B" equ "Bias" ( for /f "tokens=1 delims=abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ" %%g in ("%%~C") do set /a "%~1+=%%g"
        ) else if /i "%%C" equ "Bias" ( for /f "tokens=1 delims=abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ" %%g in ("%%~D") do set /a "%~1+=%%g"
        ) else if /i "%%D" equ "Bias" ( for /f "tokens=1 delims=abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ" %%g in ("%%~E") do set /a "%~1+=%%g"
        ) else if /i "%%E" equ "Bias" ( for /f "tokens=1 delims=abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ" %%g in ("%%~F") do set /a "%~1+=%%g"
        ) else if /i "%%F" equ "Bias" ( for /f "tokens=1 delims=abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ" %%g in ("%%~G") do set /a "%~1+=%%g"
        ) else if /i "%%G" equ "Bias"   for /f "tokens=1 delims=abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ" %%g in ("%%~H") do set /a "%~1+=%%g"
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
:func_utx_calc_date_secs
    if "%~1" equ "" goto :eof
    if "%~2" equ "" ( ( call %~0   %1   "%date:* =%"   %3 ) & goto :eof )
    if "%~3" equ "" ( ( call %~0   %1   %2   "01/01/1970" ) & goto :eof )

    set "utx_p{two}=%~2"
    set "utx_p{tri}=%~3"
    
    rem  when param2 is greater than param3, swap variables;  compares YYYYMMDD
    if %utx_p{two}:~-4%%utx_p{two}:~-10,2%%utx_p{two}:~-7,2% lss %utx_p{tri}:~-4%%utx_p{tri}:~-10,2%%utx_p{tri}:~-7,2% (
        set utx_p{two}=%utx_p{tri}%
        set utx_p{tri}=%utx_p{two}%
    )

    REM set /a "utx_leap{two}=((( %utx_p{two}:~-4% / 4 ) * 4 ) - %utx_p{two}:~-4% ) & ((( %utx_p{two}:~-4% / 100 ) * 100 ) - %utx_p{two}:~-4% ) & ((( %utx_p{two}:~-4% / 400 ) * 400 ) - %utx_p{two}:~-4% ), ! utx_leap{two}"
    REM set /a "utx_leap{tri}=((( %utx_p{tri}:~-4% / 4 ) * 4 ) - %utx_p{tri}:~-4% ) & ((( %utx_p{tri}:~-4% / 100 ) * 100 ) - %utx_p{tri}:~-4% ) & ((( %utx_p{tri}:~-4% / 400 ) * 400 ) - %utx_p{tri}:~-4% ), ! utx_leap{tri}"

    rem  using modulus,  returns 1 when leap-year, 0 when not --  highly modified from source: "http://www.robvanderwoude.com/datetiment.php#LeapYear"
    REM set /a "utx_leap{two}=%utx_p{two}:~-4% % 4 & %utx_p{two}:~-4% % 100 & %utx_p{two}:~-4% % 400, ! %utx_leap{two}%"
    REM set /a "utx_leap{tri}=%utx_p{tri}:~-4% % 4 & %utx_p{tri}:~-4% % 100 & %utx_p{tri}:~-4% % 400, ! %utx_leap{tri}%"
    
    REM call :func_utx_calc_time_secs_rounded   "utx_elapsed{secs}"  "%time%"
    call :func_utx_calc_time_secs_ms        "utx_elapsed{secs}"   "utx_elapsed{ms}"   "%time%"
    call :func_utx_get_utc_timeShift         "utx_utc{shift}"    "seconds"

    rem  not sure where my math is messed up, but the time is ahead 24 hours, hence making adjustment here
    set "utx_leap{total}=-1"

    rem  calculate all the leapyears between the two year ranges  --  using modulus,  adds '1' when leap-year --  highly modified from source: "http://www.robvanderwoude.com/datetiment.php#LeapYear"
    for /l %%A in (%utx_p{tri}:~-4%,1,%utx_p{two}:~-4%) do set /a "utx_leap{total}+=( utx_leap{diff}=%%A %% 4 & %%A %% 100 & %%A %% 400, ! utx_leap{diff} )"
    
    rem   Dates need to be defined as "MM/DD/YYYY" (strip DOW)
    for /f "tokens=1-3,4-6 delims=-/" %%A in ("%utx_p{two}%/%utx_p{tri}%") do set /a "%~1=((((((( 1%%~A - 100 ) - ( 1%%~D - 100 )) * 304 ) + ((( 1%%~B - 100 ) - ( 1%%~E - 100 )) * 10  ) + (((  %%~C * 365 ) - (  %%~F * 365 )) * 10 )) / 10 ) + %utx_leap{total}% ) * 86400 ) + %utx_utc{shift}% + %utx_elapsed{secs}%"
    if /i "%utx_output_milliseconds:~0,1%" equ "t" call set "%~1=%%%~1%%%utx_elapsed{ms}%"

    rem  Debug print statements: 
    rem     if defined utx_elapsed{secs} echo utx_elapsed{secs} - %utx_elapsed{secs}%
    rem     if defined utx_elapsed{ms}   echo utx_elapsed{ms}   - %utx_elapsed{ms}%
    rem     if defined utx_utc{shift}    echo utx_utc{shift}    - %utx_utc{shift}%
    rem     if defined utx_leap{total}   echo utx_leap{total}   - %utx_leap{total}%
    rem     for /f "tokens=1-3,4-6 delims=-/" %%A in ("%utx_p{two}%/%utx_p{tri}%") do echo/A/B/C ^| D/E/F: %%A/%%B/%%C ^| %%D/%%E/%%F

    ( for %%A in (  "utx_leap{total}";  "utx_leap{diff}";  "utx_leap{tri}";  "utx_leap{two}";  "utx_p{tri}";  "utx_p{two}"  ) do set "%%~A=" ) 2>nul 1>nul

goto :eof


                  ::::::::
               ::::      ::::
             :::            :::
           :::                :::
          ::: ::: :::::::: ::: :::
          :::                  :::
          :::    Here lays     :::
          ::: Unused Functions :::
          :::    2018-2018     :::
          :::                  :::
          ::: ::: :::::::: ::: :::
          ::     Gone, but      ::
          ::   Not forgotten    ::
          ::                    ::
          ::    Did what had    ::
          ::     to be done.    ::
          ::                    ::
          ::   Loving worker,   ::
          ::   Parent, Child,   ::
          ::  Nested Operator.  ::
          ::                    ::
          ::  Survived by Main, ::
          :: Not leaving behind ::
          ::   any dependents   ::
          ::                    ::
        ::::::::::::::::::::::::::::
    ::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::


::  Usage  ::  func_utx_calc_time_secs_rounded   returnVar   "optional-HH:MM:SS.MS"
rem  calc time elapsed seconds (today OR param2) -- rounds 51ms+ to 1 sec and w/a for octals by ((1xx + 1xx) / 300)
rem  Note:  DOES NOT overwrite returnVar value.  Function ADDs to returnVar
:func_utx_calc_time_secs_rounded
    if "%~1" equ "" goto :eof

    rem  choose between system-clock vs provided-time
    set "_scest=%time%"
    if "%~2" neq "" set "_scest=%~2" 
    
    rem  calculate total seconds and round milliseconds
    rem    returnVar  rounded ms -> seconds                   seconds -> seconds          minutes -> seconds              hours -> seconds
    set /a "%~1+=((1%_scest:~-2% + 1%_scest:~-2%) / 300) + (1%_scest:~-5,2% - 100) + ((1%_scest:~3,2% - 100) * 60 ) + (( %_scest:~0,2%  * 60 ) * 60 )"
    set "_scest="
goto :eof


::  Usage  ::  func_utx_calc_time_secs_rounded   returnVar   "optional-HH:MM:SS.MS"
rem  calc time elapsed seconds (today OR param2) -- rounds 51ms+ to 1 sec and w/a for octals by ((1xx + 1xx) / 300)
rem  Note:  DOES NOT overwrite returnVar value.  Function ADDs to returnVar
:func_utx_calc_time_ms
    if "%~1" equ "" goto :eof

    rem  choose between system-clock vs provided-time
    set "_scest=%time%"
    if "%~2" neq "" set "_scest=%~2" 
    
    rem  calculate total seconds and round milliseconds
    rem    returnVar      ms                          seconds -> ms                      minutes -> ms                     hours -> ms
    set /a "%~1+=( 1%_scest:~-2% - 100 ) + (( 1%_scest:~-5,2% - 100 ) * 100 ) + ( ( 1%_scest:~3,2% - 100 ) * 6000 ) + ( %_scest:~0,2%  * 360000 )"
    set "_scest="
goto :eof

    
::  Usage ::  func_utx_calc_leap_year_normal  returnVar   "YYYY"
rem  straight math,  returns 1 when leap-year, 0 when not  --  modified from source: "http://www.robvanderwoude.com/datetiment.php#LeapYear"
rem  Note:  MM/DD/YYYY syntax is OK for param2
:func_utx_calc_leap_year_normal
    if "%~2" equ "" goto :eof
    if "%~1" equ "" goto :eof

    set "utx_lyr{two}=%~2"
    set /a "%~1=((( %utx_lyr{two}:~-4% / 4 ) * 4 ) - %utx_lyr{two}:~-4% ) & ((( %utx_lyr{two}:~-4% / 100 ) * 100 ) - %utx_lyr{two}:~-4% ) & ((( %utx_lyr{two}:~-4% / 400 ) * 400 ) - %utx_lyr{two}:~-4% ), ! %~1"
    set "utx_lyr{two}="
    
goto :eof


::  Usage ::  func_utx_calc_leap_year_modulus  returnVar   "YYYY"
rem  using modulus,  returns 1 when leap-year, 0 when not  --  modified from source: "http://www.robvanderwoude.com/datetiment.php#LeapYear"
rem  Note:  MM/DD/YYYY syntax is OK for param2
:func_utx_calc_leap_year_modulus
    if "%~2" equ "" goto :eof
    if "%~1" equ "" goto :eof

    set "utx_lyr{two}=%~2"
    set /a "%~1=%utx_lyr{two}:~-4% % 4 & %utx_lyr{two}:~-4% % 100 & %utx_lyr{two}:~-4% % 400, ! %~1"
    set "utx_lyr{two}="
    
goto :eof


