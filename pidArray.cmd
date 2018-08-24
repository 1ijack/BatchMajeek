::  By JaCk  |  Release 08/15/2018  |  Source https://github.com/1ijack/BatchMajeek/pidArray.cmd  |  pidArray.cmd -- prints processList as -- "pid" : "processName.ext"
::: 
::: Pre Process
@echo off &setlocal EnableExtensions
set "#s{A}=%~1"
set "#er{b}="
set "#p{h}="
set "#EtS="
call :arJuan "%~1" %*
((set "#Out=%%#EtS%%") &set "#EtS=2>&1")

::: Process - Main
if not defined #p{h} if not defined #s{A} call :pidArrayAll
if not defined #p{h} if defined #s{A} call :pidArrayString %*
if defined #p{h} call :infoDump %#p{h}%

::: Post Process
( for %%A in (#EtS;#Out;#p{h};#s{A}) do set "%%A="
  endlocal &exit /b %ErrorLevel%
)

:::::::::::::::::::::::::::::::::::::::
::                                   ::
:::            Functions            :::
::                                   ::
:::::::::::::::::::::::::::::::::::::::
goto :eof

:: Help me, help you... er, um, just this once...
rem  HelpMeHelpYou Args parser 
rem  + only looks for help/version keys >> ?, h, help, v, version
rem  + accepted Prfexes >> [none], --, -, /, \
:arJuan
    set "#p{A}=%~1"
    if not defined #p{A} goto :eof
         for %%P in (%#p{A}:?=h%
    ) do for %%S in (-;/;--;\;""
    ) do for %%K in (h;help;v;version
    ) do if /i "%%~S%%K" equ "%%P" set "#p{h}=%%K"
    shift /1
    goto :eof

::  Prints variable array to console -- "pid" : "processName.ext"
:pidArrayAll
    for /f "tokens=1,2 delims=," %%T in ('%#Out% tasklist /NH /FO csv') do echo/%%U : %%T
    goto :eof

::  Prints a matching variable array to console -- "pid" : "processName.ext"
::    processName argument(s) are optional
::    when using "*" - must be next to string
::    StdErr is not suppressed
:pidArrayString
    set "#p{A}=%~1"
    if not defined #p{A} (((if not defined #er{b} goto :eof) &set "#er{b}=") &exit /b 1)
    for /f "tokens=1,2 delims=," %%T in ('
        %#Out% tasklist /NH /FO csv /FI "IMAGENAME eq %1"
    ') do if "%%~U" equ "" ((set "#er{b}=1") &echo/%%T
    ) 1>&2 else echo/%%U : %%T
    shift /1
    goto %~0

::  Usage  ::  infoDump
rem  Prints Release message to standard out
rem  Print only Version when %1 is "v"
rem  parses first line found, ignores the rest
:infoDump
    set "#p{l}="
    for /f "tokens=1,2,3,4 delims=|" %%L in ('%#Out% findstr /rc:"^::  [A-Z].*  |" "%~f0"') do if not defined #p{l} (
        set "#p{l}=true"
        if /i "%~1" equ "v" (
            for /f "tokens=*" %%V in ("%%M") do echo/%%V&       rem Version Short 
        ) else (
            for /f "tokens=*" %%V in ("%%O") do echo/%%V&       rem Description
            for /f "tokens=*" %%V in ("%%N") do echo/%%V&       rem Link
            for /f "tokens=*" %%V in ("%%M") do echo/%%V&       rem Version
            for /f "tokens=2,*" %%V in ("%%L") do echo/%%V %%W& rem Author
        )
    )
    set "#p{l}="
    goto :eof
