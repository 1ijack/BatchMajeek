::  By JaCk  |  Release 06/24/2018  |   https://github.com/1ijack/BatchMajeek/blob/master/uptime.cmd  |  uptime.cmd -- calculate uptime from wmic boot/local time
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
@echo off & setlocal EnableExtensions DisableDelayedExpansion

:::::::::::::::::::::::::::::::::::::::
::                                   ::
:::           User Config           :::
::                                   ::
:::::::::::::::::::::::::::::::::::::::

set "bool{simple}output=true"           rem simplified output
set "bool{days}output="                 rem output days
set "bool{hour}output="                 rem output hours
set "bool{mins}output="                 rem output mins
set "bool{secs}output="                 rem output secs


:::::::::::::::::::::::::::::::::::::::
::                                   ::
:::         ErrorCheck/Init         :::
::                                   ::
:::::::::::::::::::::::::::::::::::::::

rem pre-clear all env vars
for %%A in (LastBootUpTime;LocalDateTime;m01;m02;m03;m04;m05;m06;m07;m08;m09;m10;m11;m12;uptime{seconds};uptime{minutes};uptime{hours};uptime{days};curr{days};boot{days}) do set "%%A="

rem check booleans
call :validateBoolBi bool{simple}output bool{days}output bool{hour}output bool{mins}output bool{secs}output

rem making sure that we have access to the wmic bin
if not exist "%SystemRoot%\System32\wbem\wmic.exe" (
    echo %~nx0: Error: Fatal: Unable to access: "%SystemRoot%\System32\wbem\wmic.exe"
    for %%A in (bool{simple}output;bool{days}output;bool{hour}output;bool{mins}output;bool{secs}output) do set "%%A="
    endlocal
    goto :eof
)

rem making sure that an output type is specified
if not defined bool{days}output if not defined bool{hour}output if not defined bool{mins}output if not defined bool{secs}output if defined bool{simple}output (
    set "bool{secs}output=true"
    set "bool{mins}output=true"
    set "bool{hour}output=true"
) else (
    set "bool{secs}output=true"
    set "bool{mins}output=true"
    set "bool{hour}output=true"
    set "bool{days}output=true"
)

:::::::::::::::::::::::::::::::::::::::
::                                   ::
:::              Main               :::
::                                   ::
:::::::::::::::::::::::::::::::::::::::

for /f "tokens=2 delims==-." %%B in ('"%SystemRoot%\System32\wbem\wmic.exe OS get LastBootUpTime /format:list"') do if not defined LastBootUpTime set "LastBootUpTime=%%B"
for /f "tokens=2 delims==-." %%B in ('"%SystemRoot%\System32\wbem\wmic.exe OS get LocalDateTime  /format:list"') do if not defined LocalDateTime  set "LocalDateTime=%%B"

rem accumulated days by month
set /a "m01=31,m02=m01+28,m03=m02+31,m04=m03+30,m05=m04+31,m06=m05+30,m07=m06+31,m08=m07+31,m09=m08+30,m10=m09+31,m11=m10+30,m12=m11+31"
call set /a "curr{days}=m%LocalDateTime:~4,2%+%LocalDateTime:~6,2%,boot{days}=m%LastBootUpTime:~4,2%+%LastBootUpTime:~6,2%"

rem leapyear check
if 1%LocalDateTime:~4,2%  gtr 102 set /a "curr{days}+=!( %LocalDateTime:~0,4% %% 4 &  %LocalDateTime:~0,4% %% 100 &  %LocalDateTime:~0,4% %% 400)"
if 1%LastBootUpTime:~4,2% gtr 102 set /a "boot{days}+=!(%LastBootUpTime:~0,4% %% 4 & %LastBootUpTime:~0,4% %% 100 & %LastBootUpTime:~0,4% %% 400)"

rem accumulated totals - convert everything to seconds first, then convert back while adjusting seconds counter
set /a "uptime{seconds}=((curr{days}-boot{days})*86400)+((1%LocalDateTime:~8,2%-1%LastBootUpTime:~8,2%)*3600)+((1%LocalDateTime:~10,2%-1%LastBootUpTime:~10,2%)*60)+(1%LocalDateTime:~12,2%-1%LastBootUpTime:~12,2%)"
if defined bool{days}output set /a "uptime{days}+=uptime{seconds}/86400,uptime{seconds}-=uptime{days}*86400"
if defined bool{hour}output set /a "uptime{hours}+=uptime{seconds}/3600,uptime{seconds}-=uptime{hours}*3600"
if defined bool{mins}output set /a "uptime{minutes}+=uptime{seconds}/60,uptime{seconds}-=uptime{minutes}*60"
if not defined bool{secs}output set "uptime{seconds}="

:::::::::::::::::::::::::::::::::::::::
::                                   ::
:::             Report              :::
::                                   ::
:::::::::::::::::::::::::::::::::::::::

rem making sure that all values are populated with at least a 0
set /a "uptime{days}+=0,uptime{hours}+=0,uptime{minutes}+=0,uptime{seconds}+=0"


rem when simple report, make sure that needed zeros are prefixed
if defined bool{simple}output (
    if %uptime{days}%    lss 10 set "uptime{days}=0%uptime{days}%"
    if %uptime{hours}%   lss 10 set "uptime{hours}=0%uptime{hours}%"
    if %uptime{minutes}% lss 10 set "uptime{minutes}=0%uptime{minutes}%"
    if %uptime{seconds}% lss 10 set "uptime{seconds}=0%uptime{seconds}%"
)

rem report uptime and clear
if defined bool{simple}output (
    if defined bool{days}output echo/|set /p "enon=%uptime{days}%:"
    echo/%uptime{hours}%:%uptime{minutes}%:%uptime{seconds}%
) else (
    if defined bool{days}output echo/|set /p "enon=%uptime{days}% days "
    if defined bool{hour}output echo/|set /p "enon=%uptime{hours}% hours "
    if defined bool{mins}output echo/|set /p "enon=%uptime{minutes}% minutes "
    if defined bool{secs}output echo/|set /p "enon=%uptime{seconds}% seconds"
    echo/
)

:::::::::::::::::::::::::::::::::::::::
::                                   ::
:::             De-init             :::
::                                   ::
:::::::::::::::::::::::::::::::::::::::

rem post-clear all env vars
for %%A in (bool{simple}output;bool{days}output;bool{hour}output;bool{mins}output;bool{secs}output;LastBootUpTime;LocalDateTime;m01;m02;m03;m04;m05;m06;m07;m08;m09;m10;m11;m12;uptime{seconds};uptime{minutes};uptime{hours};uptime{days};curr{days};boot{days}) do set "%%A="
endlocal


:::::::::::::::::::::::::::::::::::::::
::                                   ::
:::            Functions            :::
::                                   ::
:::::::::::::::::::::::::::::::::::::::
                              goto :eof

::  Usage  ::  validateBoolBi   varName1   varName2   varName3   etc
rem Checks variable value for these states
rem [only checks the first character of the variables value]
rem  true  - 1, p, t, y -- [1, pass, true, yes]
rem  undefined  - notPass, undefined -- [no value, any value not matching pass]
:validateBoolBi
    if "%~1" equ "" goto :eof
    if not defined %~1 ((shift /1) &goto %~0)
    call set "bool{check}=%%%~1%% "
    set "bool{check}=%bool{check}:~0,1%"
    set "%~1="
    for %%B in (1;p;t;y) do if /i "%bool{check}%" equ "%%B" set "%~1=true"
    set "bool{check}="
    shift /1
    goto %~0
