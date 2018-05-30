::  by JaCk  |  Release 05/29/2018  |   https://github.com/1ijack/BatchMajeek/blob/master/duration.bat  |  duration.bat  --  displays/calculates execution duration by acting as a wrapper which launches all args in a separate window/memory-space
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
@echo off &(set /a "dur{cmdCounter}+=1") &setlocal DisableDelayedExpansion EnableExtensions

:::::::::::::::::::::::::::::::::::::::
::
::: User/Script/Report Settings
::
:::::::::::::::::::::::::::::::::::::::

rem start subprocess cmdline options
REM set "dur{startOpts}=start /d "%cd%" /i /min /separate /wait"
set "dur{startOpts}=echo/&call"

rem wait # of seconds before leaving script
rem hardpause   -1
rem nowait       0
rem nowait  [undefined]
set "dur{waitExit}="

rem hardcoded utc time shift in seconds -- bypass OS query
set "dux{offset}="


::: Boolean[on/off] switches
rem true  state = "true"
rem true  state = [defined]
rem false state = [undefined]

    rem OS utc time query bin 
    set "dux{wmic}tz=true"
    set "dux{w32tm}tz="

    rem bool -- print duration time
    set "dur{printDur}=true"

    rem bool -- print timestamp
    set "dur{printTimes}=true"

    rem bool -- print results under the unique counter obj -- command counter
    set "dur{printIdObj}="

    rem bool -- print unique command key -- command counter
    set "dur{printCmdId}=true"

    rem bool -- print start/end times
    set "dur{printTimes}=true"

    rem bool -- print cmdline
    set "dur{printEval}="

    rem bool -- print json escaped
    set "dur{printEscaped}=true"

    rem bool -- print wait status when waiting
    set "dur{printWait}="

:::::::::::::::::::::::::::::::::::::::
::
::: start script
::
:::::::::::::::::::::::::::::::::::::::

rem inf-loop/crash detection
( echo/"%~nx1" | findstr /c:"%~nx0"
) 2>nul 1>nul && (
    echo/%~nx0: Error: %date:~-10,6%%date:~-2% %time:~-12,8%: *** infinite loop ***:  "%~n0" attempted to evaluate "%~n1". Unable to continue.
    goto :func_dur{gtfo}
)
rem pre-clear/set all important vars
for %%A in (dur{tsec};dur{tms};dur{sts};dur{ets};dux{stamp}) do set "%%A="
set /a "dux{offset}+=0,dux{shift}=dux{offset},dux{leap}+=0,dur{waitExit}+=0"

rem grab start date/time
set "dur{st}=%time%"
set "dur{sd}=%date%"

rem run command
%dur{startOpts}% cmd.exe /c %*

rem grab end date/time
set "dur{et}=%time%"
set "dur{ed}=%date%"

rem do duration calc, reset utc-offset and leapyear calc when dates differ
call :func_dux{Time} dur{sts} "%dur{st}%" "%dur{sd}%" true
if "%dur{ed}%" neq "%dur{sd}%" set /a "dux{shift}=dux{offset},dux{leap}=0"
call :func_dux{Time} dur{ets} "%dur{et}%" "%dur{ed}%" true

rem additional calc OR fallback calc time only when no unixtime
if not defined dur{ets} (
    set /a "dur{tms}=1%dur{et}:~-2%-1%dur{st}:~-2%,dur{tms}+=(1%dur{et}:~-5,2%-1%dur{st}:~-5,2%)*100,dur{tms}+=(1%dur{et}:~3,2%-1%dur{st}:~3,2%)*6000,dur{tms}+=(%dur{et}:~0,2%-%dur{st}:~0,2%)*360000"
) else set /a "dur{tms}=1%dur{ets}:~-3%-1%dur{sts}:~-3%,dur{tsec}=%dur{ets}:~0,-3%-%dur{sts}:~0,-3%"
set /a "dur{tms}+=0,dur{tsec}+=0"

rem allows for negative time which is a systemclock error
if %dur{tsec}%. neq 0. if %dur{tms}%. lss 0. set /a "dur{tsec}-=1,dur{tms}+=1000"
if %dur{tsec}%. equ 0. set "dur{tsec}="

rem allow negative milliseconds when secs are undefined
if  %dur{tms}%. lss 0. if not defined dur{tsec} set "dur{tms}n=%dur{tms}%"

rem pad/trim zeros
set "dur{tms}=000%dur{tms}:-=%
set "dur{tms}=%dur{tms}:~-3%

rem readjust negative milliseconds
if defined dur{tms}n set "dur{tms}=-%dur{tms}%"
set "dur{tms}n="

rem prepare/print results
if defined dur{printEval} set dur{cmdline}=%*
REM if defined dur{printEval} for /f "delims=" %%A in ("%*") do set "dur{cmdline}=%%A"

call :func_dur{result}  "dur{output}"

rem print/leave script
if not defined dur{output} goto :func_dur{gtfo}
if defined dur{printIdObj} for /f "tokens=1,*delims==" %%A in ('set dur{output}') do echo/{ "%dur{cmdCounter}%": { %%B }}
if not defined dur{printIdObj} for /f "tokens=1,*delims==" %%A in ('set dur{output}') do echo/{ %%B }

goto :func_dur{gtfo}

:::::::::::::::::::::::::::::::::::::::
::
::: Functions
::
:::::::::::::::::::::::::::::::::::::::
                              goto :eof

::  Usage  ::  func_dur{gtfo}
:func_dur{gtfo}
    if %dur{waitExit}% lss 0 (
        if defined dur{printWait} echo/%date:~-10,6%%date:~-2% %time:~-12,8%: %~nx0: Info: dur{waitExit}: %dur{waitExit}% [secs]: [HardPause]: Press any key to continue
        ( pause
        ) 1>nul
    )
    if %dur{waitExit}% gtr 0 (
        if defined dur{printWait} echo/%date:~-10,6%%date:~-2% %time:~-12,8%: %~nx0: Info: dur{waitExit}: %dur{waitExit}% [secs]: Press any key to abort exit wait
        ( timeout /t %dur{waitExit}%
        ) 1>nul
    )

    rem gracefully leave after un-setting vars
    for %%A in (dux{wmic}tz;dux{w32tm}tz;dur{tsec};dur{tms};dur{sts};dur{ets};dur{ed};dur{et};dur{sd};dur{st};dux{ms};dux{shift};dux{leap};dux{stamp};dur{startOpts};dur{printWait};dur{waitExit};dur{output};dur{cmdline}) do set "%%A="
    endlocal
goto :eof



::  Usage  ::  func_dur{result}  returnVar   optional-bool-print{force}
rem  defines returnVar with result AND/OR prints to stndOut
rem  param1 = returnVar
rem  param2 = bool - force print result
:func_dur{result}
    if "%~1" equ "" goto :eof
    set "%~1="
    set "t{rA}="
    set "t{rB}="

    rem bool-forcePrint
    set "dur{printForce}=%~2"

    rem prepare cmdID and quick exit
    if defined dur{printCmdId} set "t{rB}="id": "%dur{cmdCounter}%""
    if not defined t{rA} ( set "t{rA}=%t{rB}%"
    ) else set "t{rA}=%t{rA}%, %t{rB}%"
    set "t{rB}="
    set "dur{printCmdId}="

    rem cmdID quick exit
    if not defined dur{printDur} if not defined dur{printTimes} if not defined dur{printEval} (
        if defined dur{printForce} if defined t{rA} echo/{ %t{rA}% }
        set "%~1=%t{rA}%"
        set "t{rA}="
        goto :eof
    )

    rem prepare printDur and quick exit
    if defined dur{printDur} set "t{rB}="duration": "%dur{tsec}%%dur{tms}%""
    if not defined t{rA} ( set "t{rA}=%t{rB}%"
    ) else set "t{rA}=%t{rA}%, %t{rB}%"
    set "t{rB}="

    rem printDur quick exit
    if not defined dur{printTimes} if not defined dur{printEval} (
        if defined dur{printForce} if defined t{rA} echo/{ %t{rA}% }
        set "%~1=%t{rA}%"
        set "t{rA}="
        goto :eof
    )


    rem prepare printTimes
    if defined dur{printTimes} set "t{rB}="start": { "utime": "%dur{sts}%", "time": "%dur{sd}:~-10% %dur{st}%" }"
    if defined t{rB} set "t{rB}=%t{rB}%, "end": { "utime": "%dur{ets}%", "time": "%dur{ed}:~-10% %dur{et}%" }"
    if defined t{rB} if not defined t{rA} ( set "t{rA}=%t{rB}%"
    ) else set "t{rA}=%t{rA}%, %t{rB}%"
    set "t{rB}="

    rem printTimes quick exit
    if not defined dur{printEval} (
        if defined dur{printForce} if defined t{rA} echo/{ %t{rA}% }
        set "%~1=%t{rA}%"
        set "t{rA}="
        goto :eof
    )

    rem missing command line error quick exit
    if not defined dur{cmdline} (
        if defined dur{printForce} if defined t{rA} echo/{ %t{rA}%, "command": "" }
        set "%~1=%t{rA}%, "command": """
        set "t{rA}="
        goto :eof
    )


    rem prepare nonEscaped commandline and quick exit
    if not defined dur{printEscaped} if defined dur{printForce} ( for /f "tokens=1,*delims==" %%A in ('set dur{cmdline}') do (
        echo/{ %t{rA}%, "command": "%%B" }
        set "%~1=%t{rA}%, "command": "%%B""
        set "t{rA}="
        goto :eof
    ) 2>nul ) 2>nul

    rem prepare Escaped commandline
    ( for /f "tokens=1,*delims==" %%A in ('set dur{cmdline}') do set "t{rB}=%%B"
    ) 2>nul

    rem errored commandline parse quick exit
    if not defined t{rB} (
        echo/{ %t{rA}%, "command": "%~nx0%~0: [%dur{cmdCounter}%]: error parsing command line" }
        set "%~1=%t{rA}%, "command": "%~nx0%~0: [%dur{cmdCounter}%]: error parsing command line""
        set "t{rA}="
        goto :eof
    )

    rem prepare command line escape
    ( for /f "tokens=* delims=" %%A in ('cmd.exe /c echo/%t{rB}:\=\\%') do set "t{rB}=%%A"
    ) 2>nul
    if defined t{rA}     ( for /f "delims=" %%A in (""%t{rB}:"=\"%"") do set "t{rA}=%t{rA}%, "command": %%A"
    ) 2>nul
    if not defined t{rA} ( for /f "delims=" %%A in (""%t{rB}:"=\"%"") do set "t{rA}="command": %%A"
    ) 2>nul
    set "t{rB}="

    rem well... chasing our tail was... fun...
    if not defined t{rA} if not defined %~1 goto :eof

    rem print/defined return
    if defined dur{printForce} ( for /f "tokens=1,*delims==" %%A in ('set t{rA}') do (
        echo/{ %%B }
        set "%~1=%%B"
        set "t{rA}="
        goto :eof
    ) 2>nul )
    for /f "tokens=1,*delims==" %%A in ('set t{rA}') do set "%~1=%%B"
    set "t{rA}="
goto :eof


::  Usage  ::  func_dux{Time}  "optional-returnVar"  "optional-HH:MM:SS.MS"  "optional-Dow MM/DD/YYYY"  "optional-calcMS-bool{true}"
rem  returns returnVar defined with the current time in unixtime: total elapsed seconds since January 1st, 1970
:func_dux{Time}
    set "dux{stamp}="
    if "%~1" neq ""   set "%~1="
    if "%~2" neq "" ( set "dux{t}=%~2"  ) else set "dux{t}=%time%"
    if "%~3" neq "" ( set "dux{d}=%~3"  ) else set "dux{d}=%date%"
    if "%~4" neq "" ( set "dux{ms}=%~4" ) else set "dux{ms}=false"
    if defined dux{wmic}tz if exist "%SystemRoot%\System32\wbem\WMIC.exe" set "dux{w32tm}tz="
    rem calc offset
    if "%dux{shift}%" equ "0" ( 
        if defined dux{wmic}tz for /f %%g in ('"%SystemRoot%\System32\wbem\WMIC.exe computersystem get currenttimezone 2>&1"') do if %%g1 lss 1 set /a "dux{shift}+=%%g*60"
        if defined dux{w32tm}tz for /f "tokens=1-8 delims=: " %%A in ('"%SystemRoot%\System32\w32tm.exe" /tz') do for %%e in ( "%%~A|%%~B"; "%%~B|%%~C"; "%%~C|%%~D"; "%%~D|%%~E"; "%%~E|%%~F"; "%%~F|%%~G"; "%%~G|%%~H" ) do for /f "tokens=1,2 delims=|" %%f in (%%e) do if /i "%%~f" equ "Bias" for /f "tokens=1 delims=min" %%m in ("%%~g") do if "%%~m" neq "0" set /a "dux{shift}+=%%~m*60"
    ) 2>nul 1>nul
    rem calc leapyear
    if "%dux{leap}%"  equ "0" for /l %%A in (1970,1,%dux{d}:~-4%) do set /a "dux{leap}+=!(%%A %% 4 & %%A %% 100 & %%A %% 400)"
    rem calc timestamp
    for /f "tokens=1-3,4-6 delims=-/" %%A in ("%dux{d}:* =%/01/01/1970") do set /a "dux{stamp}=(((((1%%~A-1%%~D)*305)/10)+%dux{leap}%+(1%%~B-1%%~E)+(%%~C-%%~F)*365)*86400)-172800+%dux{shift}%+((1%dux{t}:~-5,2%-100)+((1%dux{t}:~3,2%-100)*60)+(%dux{t}:~0,2%*3600))"
    rem add ms as needed
    if /i "%dux{ms}:~0,1%" equ "t" set "dux{stamp}=%dux{stamp}%%dux{t}:~-2%0"
    rem return result
    if "%~1" neq "" (set "%~1=%dux{stamp}%") else echo/%dux{stamp}%
    rem unset temp vars
    for %%A in (dux{stamp};dux{t};dux{d};dux{ms}) do set "%%A="
goto :eof

