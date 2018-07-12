::  by JaCk  |  Release 05/29/2018  |   https://github.com/1ijack/BatchMajeek/blob/master/unixTime.bat  |  unixTime.bat  --  returns current time in unixtime  --  total elapsed seconds since January 1st, 1970
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
@echo off & setlocal DisableDelayedExpansion EnableExtensions & for %%A in (utx_leap{total};utx_utc{shift};utx_time{unix};utx_out{bool}) do set "%%A="

rem  Output seconds OR milliseconds.
if not defined utx_out_ms set "utx_out_ms="
  rem  set "utx_out_ms="            rem  output seconds
  rem  set "utx_out_ms=false"       rem  output seconds
  rem  set "utx_out_ms=true"        rem  output milliseconds

rem  timezone source binary - wmic.exe/w32tm.exe
if not defined utx_tz_wmic  set "utx_tz_wmic=true"
if not defined utx_tz_w32tm set "utx_tz_w32tm="
  rem  both  true - defaults wmic.exe
  rem  both false - uses neither

rem  Bypass timezone check by forcing a manual offset
if not defined utx_utc_offset set "utx_utc_offset="
  rem  set "utx_utc_offset=25200"      rem  UTC+7  hours, (is  [420] min, is  [25200] seconds)
  rem  set "utx_utc_offset=0"          rem  UTC+0  hours, (is    [0] min, is      [0] seconds)
  rem  set "utx_utc_offset=-36000"     rem  UTC-10 hours, (is [-600] min, is [-36000] seconds)

rem  main Calculation
set /a "utx_utc{shift}=utx_utc_offset,utx_leap{total}=0"
if defined utx_tz_wmic set "utx_tz_w32tm="
if not defined utx_utc_offset (
    if defined utx_tz_wmic for /f %%g in ('"%SystemRoot%\System32\wbem\WMIC.exe computersystem get currenttimezone"') do if %%g1 lss 1 set /a "utx_utc{shift}+=%%g*60"
    if defined utx_tz_w32tm for /f "tokens=1-8 delims=: " %%A in ('"%SystemRoot%\System32\w32tm.exe" /tz') do for %%e in ( "%%~A|%%~B"; "%%~B|%%~C"; "%%~C|%%~D"; "%%~D|%%~E"; "%%~E|%%~F"; "%%~F|%%~G"; "%%~G|%%~H" ) do for /f "tokens=1,2 delims=|" %%f in (%%e) do if /i "%%~f" equ "Bias" for /f "tokens=1 delims=min" %%m in ("%%~g") do if "%%~m" neq "0" set /a "utx_utc{shift}+=%%~m*60"
) 2>nul 1>nul
for /l %%A in (1970,1,%date:~-4%) do set /a "utx_leap{total}+=!(%%A %% 4 & %%A %% 100 & %%A %% 400)"
for /f "tokens=1-3,4-6 delims=-/" %%A in ("%date:* =%/01/01/1970") do set /a "utx_time{unix}=(((((1%%~A-1%%~D)*305)/10)+%utx_leap{total}%+(1%%~B-1%%~E)+(%%~C-%%~F)*365)*86400)-172800+%utx_utc{shift}%+((1%time:~-5,2%-100)+((1%time:~3,2%-100)*60)+(%time:~0,2%*3600))"
set "utx_out{bool}=%utx_out_ms%false"
if /i "%utx_out{bool}:~0,1%" equ "t" set "utx_time{unix}=%utx_time{unix}%%time:~-2%0"
if "%~1" equ "" (
    echo/%utx_time{unix}%
    for %%A in (utx_leap{total};utx_utc{shift};utx_time{unix};utx_out{bool}) do set "%%A="
    endlocal
) else ((set "%~1=%utx_time{unix}%") &(for %%A in (utx_leap{total};utx_utc{shift};utx_time{unix};utx_out{bool}) do set "%%A=") &endlocal)
