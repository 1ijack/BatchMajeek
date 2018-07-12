::  by JaCk  |  Dev 05/08/2018  |   https://github.com/1ijack/BatchMajeek/blob/master/uhash.cmd  |  uhash.cmd  --  returns current time in unixtime  --  total elapsed seconds since January 1st, 1970
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
@echo off & setlocal DisableDelayedExpansion EnableExtensions & for %%A in (arg{One}key;arg{Two}key) do set "%%A="

:::::::::::::::::::::::::::::::::::::::
::                                   ::
:::             Config              :::
::                                   ::
:::::::::::::::::::::::::::::::::::::::

set "ext{arg}=.avi;.mkv;.mka;.mpg;.mpeg;.mov;.webm;.mp4;.cbr;.cbz;.zip;.7z;.ogm"
set "_rHashBin=M:\Media\[Resources]\Tools\RHash-1.3.5\rhash-1.3.6-win64\rhash.exe"
set "_rHashNewOptions=-a  -p "    \"file{hashes}\" : {\n        \"size\" : \"%%s\",\n        \"modd\" : \"%%{mtime}\",\n        \"name\" : \"%%f\",\n        \"urln\" : \"%%u\",\n        \"ed2klink\" : \"%%l\",\n        \"hash\" : {\n            \"aich\"           : \"%%a\",\n            \"btih\"           : \"%%{btih}\",\n            \"crc32\"          : \"%%c\",\n            \"ed2k\"           : \"%%e\",\n            \"edon-r256\"      : \"%%{edon-r256}\",\n            \"edon-r512\"      : \"%%{edon-r512}\",\n            \"gost\"           : \"%%g\",\n            \"gost-cryptopro\" : \"%%{gost-cryptopro}\",\n            \"has160\"         : \"%%{has160}\",\n            \"md4\"            : \"%%{md4}\",\n            \"md5\"            : \"%%m\",\n            \"ripemd-160\"     : \"%%r\",\n            \"sha-224\"        : \"%%{sha-224}\",\n            \"sha-256\"        : \"%%{sha-256}\",\n            \"sha-384\"        : \"%%{sha-384}\",\n            \"sha-512\"        : \"%%{sha-512}\",\n            \"sha1\"           : \"%%h\",\n            \"sha3-224\"       : \"%%{sha3-224}\",\n            \"sha3-256\"       : \"%%{sha3-256}\",\n            \"sha3-384\"       : \"%%{sha3-384}\",\n            \"sha3-512\"       : \"%%{sha3-512}\",\n            \"snefru128\"      : \"%%{snefru128}\",\n            \"snefru256\"      : \"%%{snefru256}\",\n            \"tiger\"          : \"%%{tiger}\",\n            \"tth\"            : \"%%t\",\n            \"whirlpool\"      : \"%%w\"\n        }\n    }\n""
REM set "_rHashNewOptions=-a  -p "    \"file{hashes}\" : {\n        \"size\" : \"%%s\",\n        \"modd\" : \"%%{mtime}\",\n        \"path\" : \"%%p\",\n        \"name\" : \"%%f\",\n        \"urln\" : \"%%u\",\n        \"ed2klink\" : \"%%l\",\n        \"hash\" : {\n            \"aich\"           : \"%%a\",\n            \"btih\"           : \"%%{btih}\",\n            \"crc32\"          : \"%%c\",\n            \"ed2k\"           : \"%%e\",\n            \"edon-r256\"      : \"%%{edon-r256}\",\n            \"edon-r512\"      : \"%%{edon-r512}\",\n            \"gost\"           : \"%%g\",\n            \"gost-cryptopro\" : \"%%{gost-cryptopro}\",\n            \"has160\"         : \"%%{has160}\",\n            \"md4\"            : \"%%{md4}\",\n            \"md5\"            : \"%%m\",\n            \"ripemd-160\"     : \"%%r\",\n            \"sha-224\"        : \"%%{sha-224}\",\n            \"sha-256\"        : \"%%{sha-256}\",\n            \"sha-384\"        : \"%%{sha-384}\",\n            \"sha-512\"        : \"%%{sha-512}\",\n            \"sha1\"           : \"%%h\",\n            \"sha3-224\"       : \"%%{sha3-224}\",\n            \"sha3-256\"       : \"%%{sha3-256}\",\n            \"sha3-384\"       : \"%%{sha3-384}\",\n            \"sha3-512\"       : \"%%{sha3-512}\",\n            \"snefru128\"      : \"%%{snefru128}\",\n            \"snefru256\"      : \"%%{snefru256}\",\n            \"tiger\"          : \"%%{tiger}\",\n            \"tth\"            : \"%%t\",\n            \"whirlpool\"      : \"%%w\"\n        }\n    }\n""

rem  Output seconds OR milliseconds.
rem ignored as unixtime is not being calculated
REM if not defined avd_out_ms set "avd_out_ms=false"
    rem  set "avd_out_ms="            rem  output seconds
    rem  set "avd_out_ms=false"       rem  output seconds
    rem  set "avd_out_ms=true"        rem  output milliseconds

rem  Bypass timezone check by forcing a manual offset
rem ignored as unixtime is not being calculated
REM if not defined avd_utc_offset set "avd_utc_offset="
    rem  set "avd_utc_offset=25200"      rem  UTC+7  hours, (is  [420] min, is  [25200] seconds)
    rem  set "avd_utc_offset=0"          rem  UTC+0  hours, (is    [0] min, is      [0] seconds)
    rem  set "avd_utc_offset=-36000"     rem  UTC-10 hours, (is [-600] min, is [-36000] seconds)

:::::::::::::::::::::::::::::::::::::::
::                                   ::
:::            ErrorCheck           :::
::                                   ::
:::::::::::::::::::::::::::::::::::::::
set /a "arg{shift}c=0,arg{blank}c=0,arg{total}c=0,arg{blank}max=2"
call :argShwift %*
if not defined avd_system_drives call :func_ListSetDriveChars_wmic    avd_system_drives   ":\ "
call :validateBoolBi bool{recurseDirs}
if defined bool{recurseDirs} set "d{s}a=/s"

:::::::::::::::::::::::::::::::::::::::
::                                   ::
:::              Main               :::
::                                   ::
:::::::::::::::::::::::::::::::::::::::

call :runSelector
REM for /f "tokens=* delims=" %%J in ('dir /a:-d /b %d{s}a% "*.mkv"') do call :func_rhash_info "%%~J"

goto :eof


:::::::::::::::::::::::::::::::::::::::
::                                   ::
:::            Functions            :::
::                                   ::
:::::::::::::::::::::::::::::::::::::::
::  goto Usage  ::  argShwift
::  call Usage  ::  argShwift   arg1   arg2   arg3   etc
rem super basic arg parser
rem although both work, intended use as goto instead of call
:argShwift
    rem  only shift when var is greater than one
    set "arg{One}key=%arg{Two}key%"
    set "arg{Two}key="
    set /a "arg{shift}c+=0,arg{blank}c+=1"
    for /l %%L in (1,1,%arg{shift}c%) do shift /1
    set /a "arg{shift}c=1"
    rem  reloop/leave on empty
    if %arg{blank}c% gtr %arg{blank}max%  goto :eof
    if     "%~1"     equ       ""         goto :argShwift
    rem pre-define counters
    set /a "arg{blank}c=0,arg{total}c+=1"
    rem  define key
    if not defined arg{One}key for /f "tokens=* delims=/-\" %%A in ("-%~1") do if "%~1" neq "%%~A" set "arg{One}key=%%~A"
    for /f "tokens=* delims=/-\" %%A in ("-%~2") do if "%~2" neq "%%~A" set "arg{Two}key=%%~A"

    rem  \\\\\\\\\\\\\\\ ///////////////
    rem       ArgParser - KeyLess
    rem  /////////////// \\\\\\\\\\\\\\\
    rem  keyless matching

    if not defined arg{One}key if exist "%~1" if "%~a1" neq "" call set "path{arg}=%%path{arg}%%; %1"

    rem  \\\\\\\\\\\\\\\ ///////////////
    rem       ArgParser - Key reuse
    rem  /////////////// \\\\\\\\\\\\\\\
    if not defined arg{One}key goto :argShwift

    if /i "%arg{One}key%" equ "?"                set "arg{One}key=help"
    if /i "%arg{One}key%" equ "d"                set "arg{One}key=input"
    if /i "%arg{One}key%" equ "directories"      set "arg{One}key=input"
    if /i "%arg{One}key%" equ "directory"        set "arg{One}key=input"
    if /i "%arg{One}key%" equ "e"                set "arg{One}key=extensions"
    if /i "%arg{One}key%" equ "ext"              set "arg{One}key=extensions"
    if /i "%arg{One}key%" equ "extension"        set "arg{One}key=extensions"
    if /i "%arg{One}key%" equ "file-extension"   set "arg{One}key=extensions"
    if /i "%arg{One}key%" equ "file-extensions"  set "arg{One}key=extensions"
    if /i "%arg{One}key%" equ "file-type"        set "arg{One}key=extensions"
    if /i "%arg{One}key%" equ "file-types"       set "arg{One}key=extensions"
    if /i "%arg{One}key%" equ "h"                set "arg{One}key=help"
    if /i "%arg{One}key%" equ "i"                set "arg{One}key=input"
    if /i "%arg{One}key%" equ "inputs"           set "arg{One}key=input"
    if /i "%arg{One}key%" equ "nr"               set "arg{One}key=no-recurse"
    if /i "%arg{One}key%" equ "p"                set "arg{One}key=input"
    if /i "%arg{One}key%" equ "path"             set "arg{One}key=input"
    if /i "%arg{One}key%" equ "paths"            set "arg{One}key=input"
    if /i "%arg{One}key%" equ "r"                set "arg{One}key=recurse"
    if /i "%arg{One}key%" equ "type"             set "arg{One}key=extensions"
    if /i "%arg{One}key%" equ "types"            set "arg{One}key=extensions"

    rem  \\\\\\\\\\\\\\\ ///////////////
    rem       ArgParser - Key ONLY
    rem  /////////////// \\\\\\\\\\\\\\\

    if /i "%arg{One}key%" equ "help"             echo/No on can halp you
    if /i "%arg{One}key%" equ "no-recurse"       set "bool{recurseDirs}="
    if /i "%arg{One}key%" equ "recurse"          set "bool{recurseDirs}=true"

    rem leave early -- param2 unexpected key value
    if defined arg{Two}key goto :argShwift
    rem leave early -- param2 no value
    if "%~2" equ "" goto :argShwift

    rem  \\\\\\\\\\\\\\\ ///////////////
    rem       ArgParser - Key w/Value(s)
    rem  /////////////// \\\\\\\\\\\\\\\


    rem trim the shift counter again
    for /l %%L in (1,1,%arg{shift}c%) do shift /1
    set /a "arg{shift}c=0"

    rem  note, when using parameter positions from 1 and higher, adjust shift accordingly
    rem  easy formula -- set /a "arg{shift}c+=ArgPosition"

    if /i "%arg{One}key%" equ "input"       set /a "arg{shift}c+=1"
    if /i "%arg{One}key%" equ "input"       call set "path{arg}=%%path{arg}%%; %1"

    rem  \\\\\\\\\\\\\\\ ///////////////
    rem       ArgParser - subArgParse
    rem  /////////////// \\\\\\\\\\\\\\\

    rem continue parsing values in another label
    if /i "%arg{One}key%" equ "extensions" goto :argExtensionParser

    rem  \\\\\\\\\\\\\\\ ///////////////
    rem       ArgParser - End
    rem  /////////////// \\\\\\\\\\\\\\\

    goto :argShwift
    goto :eof


:argExtensionParser
    if "%~1" equ "" goto :argShwift
    set /a "arg{total}c+=1"
    for /f "tokens=* delims=/-\" %%A in ("-%~1") do (
        if /i "%~1" equ "all" ((shift /1) &set "ext{arg}all=*.*")
        if    "%~1" equ "*."  ((shift /1) &set "ext{arg}all=*.*")
        if    "%~1" equ  ".*" ((shift /1) &set "ext{arg}all=*.*")
        if    "%~1" equ  "*"  ((shift /1) &set "ext{arg}all=*.*")
        if    "%~1" equ "*.*" ((shift /1) &set "ext{arg}all=*.*")
        if    "%~1" equ "%~x1" (
            call set "ext{arg}=%%ext{arg}%% %1;"
            shift /1
        ) else goto :argShwift
    )
    goto :argExtensionParser
    goto :eof



::  Usage  ::  runSelector
rem runs job/function based on boolean variables OR prints help
rem checks whether the path is a file or a directory
rem checks for extension list variable
rem checks for wildcard extension boolean
:runSelector
    rem run extension lists only on directory paths
    for %%P in (%path{arg}%) do if f%%~aP gtr fd (
        if defined ext{arg} for %%E in (%ext{arg}%) do call :run_hashwalker "%%~P\*%%~xE"
        if defined ext{arg}all call :run_hashwalker "%%~P\%ext{arg}all%"
    ) else call :run_hashwalker %%P
    goto :eof


::  Usage  ::   run_hashwalker  dirPath1\*.*   "dir Path 2\*.extension2"   dirPath3\file3   etc
rem Recursively walks dir tree calling rhash info label
:run_hashwalker
    if "%~1" equ "" goto :eof
    (   for /f "tokens=* delims=" %%J in ('
            dir /a:-d /b %d{s}a% %1
        ') do call :func_rhash_info "%%~J"
    ) 2>nul
    shift /1
    goto %~0
    goto :eof


::  Usage  ::  func_rhash_info   "path\to\file.extension"
rem Creates a jxon extension file with target file information.
rem
rem  --  O month
rem  --  P day
rem  --  Q year
rem  --  R hours
rem  --  S mins
rem  --  T secs
rem  --  U am/pm
rem  --  V size
rem  --  W fname
:func_rhash_info
    set "h{aA}=%~a1"
    if not defined h{aA} goto :eof
    if /i "%h{aA}:~0,1%" neq "-" goto :eof

    rem in this loop - T is am/pm
    for /f "tokens=1-7 delims=.:/ " %%O in ("%~t1") do (
        set "dTag=%%Q%%O%%P"
        set /a "PM=12,AM=0,dhour=1%%R-100+%%T"
        set "dmint=%%S"
    )
    if %dhour% lss 10 set "dhour=0%dhour%"

    set "h{dp}=%~dp1meta\"
    if not exist "%~dp1meta\" set "h{dp}=%~dp1"

    rem escape backslashes in paths
    set "jxon{directory}=%~dp1"
    set "jxon{path}=%~dpnx1"
    set "jxon{directory}=%jxon{directory}:\=\\%
    set "jxon{path}=%jxon{path}:\=\\%

    rem check hardlinks
    call :func_get_file_hardlinks_fsutil  "avd_fileLinks"   "%~dpnx1"  "true"

    rem
    @for /f "tokens=1-8,* delims=:/ " %%O in ('
        forfiles /p "%~dp1." /m "%~nx1" /c "cmd /c echo @fdate @ftime @fsize @fname"
    ') do if not exist "%h{dp}%%dTag%.%dhour%%dmint%%%T.%%V.jxon" (
        echo/Processing: [%dTag%.%dhour%%dmint%%%T.%%V]: "%~nx1"
        (
        REM set    "avd_file{path}=%~dpnx1"
        REM set    "avd_file{name}=%%W"
        REM set    "avd_file{size}=%%V"
        REM set    "avd_file{extension}=%~x1"
        REM set    "avd_dir{path}=%~dp1"
        REM set    "avd_mtime{hhmmPA}=%~t1"
        REM set    "avd_mtime{hhmmssPA}=%%R:%%S:%%T %%U"

        REM call :func_dux{Time}                  "avd_mtime{unix}"
        REM call :func_calc_unixTime              "" ""   "%%O/%%P/%%Q" "%%R:%%S:%%T %%U"

        rem  timstamp concat hhmmss
        REM set /a "PM=43200,AM=0,mtime{hhmmss}=(%%R+(%%U/3600))"
        REM call set "mtime{hhmmss}=%%mtime{hhmmss}%%%%S%%T"

        REM for /f "tokens=* delims=" %%Y in ('call echo/%dTag%.%dhour%%dmint%%%mtime{hhmmss}:~-5,2%%') do if not exist "%%V.%%Y.jxon" (
            echo/{
            echo/    "file{info}"      : {
            echo/       "attributes"   : "%~a1",
            echo/       "directory"    : "%jxon{directory}%",
            echo/       "extension"    : "%~x1",
            echo/       "file"         : "%~xn1",
            echo/       "modified"     : [
            echo/           "%%O/%%P/%%Q %%R:%%S:%%T %%U",
            echo/           "%~t1",
            echo/           "%dTag:~4,2%/%dTag:~6,2%/%dTag:~0,4% %dhour%:%dmint%:%%T",
            echo/           "%dTag%%dhour%%dmint%%%T"
            echo/       ],
            echo/       "name"         : %%W,
            echo/       "path"         : "%jxon{path}%",
            echo/       "size"         : "%%V"
   REM call echo/       "mtime{unixtime}" : "%%avd_mtime{unixtime}%%"
            echo/   },

            echo/    "file{hardlinks}" : {[ %avd_fileLinks:\=\\% ]},

            "%_rHashBin%" "%~1" %_rHashNewOptions%

            echo/}
        ) 1> "%h{dp}%%dTag%.%dhour%%dmint%%%T.%%V.jxon"
    )
    goto :eof



:: Usage :: func_get_file_hardlinks_fsutil  returnVar  "Path\File"
rem  Retrieves all file hardlinks
rem  when ANYTHING is passed into param3, function will print to console
:func_get_file_hardlinks_fsutil
    if "%~2" equ "" goto :eof
    if "%~1" equ "" goto :eof

    rem  just incase there are hardlinks in cross mountpoint junctions
    if not defined avd_system_drives call :func_ListSetDriveChars_wmic avd_system_drives ":\ "

    set "%~1=%2"

    rem  get/process hardlink files
    for /F "delims=" %%L in ('
        call "%SystemRoot%\System32\fsutil.exe" hardlink list "%~2"
    ') do if "%~f2" neq "%~d2%%~L" if exist "%~d2%%~L" (
        call set "%~1=%%%~1%%, "%~d2%%~L""
    ) else for %%A in (%avd_system_drives%) do if exist "%%~dA%%~L" (
        call set "%~1=%%%~1%%, "%%~dA%%~L""
    )

    goto :eof


::  Usage  ::   func_ListSetDriveChars_wmic   optional-returnVar   optional-separatorCharacters   optional-BoolPrintSingleLine   optional-BoolPrintSeparateLine
rem  List var with all driveletters using wmic on a single-line and delimit by a customer characters -- default delimiter is a whitespace
rem  Param3 and/or Param4 only trigger on string "true",
rem    Output example when as:   func_ListSetDriveChars_wmic   "driveLetters"   ":\ "  ""  "true"
rem    setVar example:  driveLetters=C:\ M:\
rem    Output example:
rem       C:\
rem       M:\
:func_ListSetDriveChars_wmic
    set "p{a}=%~3"
    set "p{e}=%~4"
    rem  get list of driveLetters; print/set per param instructions; suppress all errors
    for /f "tokens=2 delims==:" %%L in ('"wmic logicaldisk get name /value /format:list 2>nul"') do (
        if /i "%~4" equ "true" echo/%%L%~2
        call set "v{A}=%%v{A}%%%%L%~2"
    )
    set "%~1=%v{A}%"
    if defined p{a} if defined v{A} echo/%v{A}%
    for %%A in (p{a};p{c};v{A}) do set "%%A="
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


rem  rhash dump json object
REM "M:\Media\[Resources]\Tools\RHash-1.3.5\rhash-1.3.6-win64\rhash.exe" -a "../[2017] - TV Series - Reikenzan - Eichi e no Shikaku/01 - Reikenzan Eichi e no Shikaku - Episode 1 - [2017][Wien-Subs] - (3F14BAB8).mkv" -p="\n\r{\n\r\t\"size\" : \"%s\",\n\r\t\"modd\" : \"%{mtime}\",\n\r\t\"path\" : \"%p\",\n\r\t\"name\" : \"%f\",\n\r\t\"urln\" : \"%u\",\n\r\t\"ed2klink\" : \"%l\",\n\r\t\"hash\" : {\n\r\t\t\"aich\" : \"%a\",\n\r\t\t\"btih\" : \"%{btih}\",\n\r\t\t\"crc32\" : \"%c\",\n\r\t\t\"ed2k\" : \"%e\",\n\r\t\t\"edon-r256\" : \"%{edon-r256}\",\n\r\t\t\"edon-r512\" : \"%{edon-r512}\",\n\r\t\t\"gost\" : \"%g\",\n\r\t\t\"gost-cryptopro\" : \"%{gost-cryptopro}\",\n\r\t\t\"has160\" : \"%{has160}\",\n\r\t\t\"md4\" : \"%{md4}\",\n\r\t\t\"md5\" : \"%m\",\n\r\t\t\"ripemd-160\" : \"%r\",\n\r\t\t\"sha-224\" : \"%{sha-224}\",\n\r\t\t\"sha-256\" : \"%{sha-256}\",\n\r\t\t\"sha-384\" : \"%{sha-384}\",\n\r\t\t\"sha-512\" : \"%{sha-512}\",\n\r\t\t\"sha1\" : \"%h\",\n\r\t\t\"sha3-224\" : \"%{sha3-224}\",\n\r\t\t\"sha3-256\" : \"%{sha3-256}\",\n\r\t\t\"sha3-384\" : \"%{sha3-384}\",\n\r\t\t\"sha3-512\" : \"%{sha3-512}\",\n\r\t\t\"snefru128\" : \"%{snefru128}\",\n\r\t\t\"snefru256\" : \"%{snefru256}\",\n\r\t\t\"tiger\" : \"%{tiger}\",\n\r\t\t\"tth\" : \"%t\",\n\r\t\t\"whirlpool\" : \"%w\"\n\r\t}\n\r}\n\r"
REM "M:\Media\[Resources]\Tools\RHash-1.3.5\rhash-1.3.6-win64\rhash.exe" -a "../[2017] - TV Series - Reikenzan - Eichi e no Shikaku/01 - Reikenzan Eichi e no Shikaku - Episode 1 - [2017][Wien-Subs] - (3F14BAB8).mkv" -p="\n\r{\n\r\t\"size\" : \"%s\",\n\r\t\"modd\" : \"%{mtime}\",\n\r\t\"path\" : \"%p\",\n\r\t\"name\" : \"%f\",\n\r\t\"urln\" : \"%u\",\n\r\t\"ed2klink\" : \"%l\",\n\r\t\"hash\" : {\n\r\t\t\"aich\" : \"%a\",\n\r\t\t\"btih\" : \"%{btih}\",\n\r\t\t\"crc32\" : \"%c\",\n\r\t\t\"ed2k\" : \"%e\",\n\r\t\t\"edon-r256\" : \"%{edon-r256}\",\n\r\t\t\"edon-r512\" : \"%{edon-r512}\",\n\r\t\t\"gost\" : \"%g\",\n\r\t\t\"gost-cryptopro\" : \"%{gost-cryptopro}\",\n\r\t\t\"has160\" : \"%{has160}\",\n\r\t\t\"md4\" : \"%{md4}\",\n\r\t\t\"md5\" : \"%m\",\n\r\t\t\"ripemd-160\" : \"%r\",\n\r\t\t\"sha-224\" : \"%{sha-224}\",\n\r\t\t\"sha-256\" : \"%{sha-256}\",\n\r\t\t\"sha-384\" : \"%{sha-384}\",\n\r\t\t\"sha-512\" : \"%{sha-512}\",\n\r\t\t\"sha1\" : \"%h\",\n\r\t\t\"sha3-224\" : \"%{sha3-224}\",\n\r\t\t\"sha3-256\" : \"%{sha3-256}\",\n\r\t\t\"sha3-384\" : \"%{sha3-384}\",\n\r\t\t\"sha3-512\" : \"%{sha3-512}\",\n\r\t\t\"snefru128\" : \"%{snefru128}\",\n\r\t\t\"snefru256\" : \"%{snefru256}\",\n\r\t\t\"tiger\" : \"%{tiger}\",\n\r\t\t\"tth\" : \"%t\",\n\r\t\t\"whirlpool\" : \"%w\"\n\r\t}\n\r}\n\r"
REM for %%A in (fhs_utc_offset;fhs_out_ms;fhs_leap{total};fhs_utc{shift};fhs_leap{diff};fhs_time{unix}) do set "%%A="

:::::::::::::::::::::::::::::::::::::::
::                                   ::
:::              Unused             :::
:::            Functions            :::
::                                   ::
:::::::::::::::::::::::::::::::::::::::

::  Usage  ::  func_dux{Time}  "optional-returnVar"  "optional-HH:MM:SS.MS"  "optional-Dow MM/DD/YYYY"  "optional-calcMS-bool{true}"
rem  returns returnVar defined with the current time in unixtime: total elapsed seconds since January 1st, 1970
:func_dux{Time}
    if "%~1" neq "" set "%~1="
    set "dux{t}=%~2"
    set "dux{d}=%~3"
    set "dux{ms}=%~4 "
    set "dux{stamp}="
    if defined dux{wmic}tz if not exist "%SystemRoot%\System32\wbem\WMIC.exe" set "dux{w32tm}tz="
    if not defined dux{t} set "dux{t}=%time%"
    if not defined dux{d} set "dux{d}=%date%"
    if /i "%dux{ms}:~0,1%" neq "t" set "dux{ms}="
    rem calc offset
    if %dux{shift}%. equ 0. (
        if defined dux{wmic}tz for /f %%g in ('"%SystemRoot%\System32\wbem\WMIC.exe computersystem get currenttimezone 2>&1"') do if %%g1 lss 1 set /a "dux{shift}+=%%g*60"
        if defined dux{w32tm}tz for /f "tokens=1-8 delims=: " %%A in ('"%SystemRoot%\System32\w32tm.exe" /tz') do for %%e in ("%%~A#%%~B";"%%~B#%%~C";"%%~C#%%~D";"%%~D#%%~E";"%%~E#%%~F";"%%~F#%%~G";"%%~G#%%~H") do for /f "tokens=1,2 delims=#" %%f in (%%e) do if /i "%%~f" equ "Bias" for /f "tokens=1 delims=min" %%m in ("%%~g") do if "%%~m" neq "0" set /a "dux{shift}+=%%~m*60"
    ) 2>nul 1>nul
    rem calc leap-year
    if "%dux{leap}%"  equ "0" for /l %%A in (1970,1,%dux{d}:~-4%) do set /a "dux{leap}+=!(%%A %% 4 & %%A %% 100 & %%A %% 400)"
    rem calc time-stamp
    for /f "tokens=1-3,4-6 delims=-/" %%A in ("%dux{d}:* =%/01/01/1970") do set /a "dux{stamp}=(((((1%%~A-1%%~D)*305)/10)+%dux{leap}%+(1%%~B-1%%~E)+(%%~C-%%~F)*365)*86400)-172800+%dux{shift}%+((1%dux{t}:~-5,2%-100)+((1%dux{t}:~3,2%-100)*60)+(%dux{t}:~0,2%*3600))"
    rem add ms as needed
    if defined dux{ms} set "dux{stamp}=%dux{stamp}%%dux{t}:~-2%0"
    rem return result
    if "%~1" neq "" (set "%~1=%dux{stamp}%") else echo/%dux{stamp}%
    rem unset temp vars
    for %%A in (dux{stamp};dux{t};dux{d};dux{ms}) do set "%%A="
    goto :eof


::  Usage  ::   func_calc_unixTime   date1{mm/dd/yyyy}   time1{hh:mm:ss.ms}   date2{01/01/1970}   time2{00:00:00.00}
rem  main Calculation
:func_calc_unixTime
    set /a "avd_utc{shift}=%avd_utc_offset%,avd_leap{total}=0,PM=43200,AM=0"
    if not defined avd_utc_offset for /f %%g in ('"%SystemRoot%\System32\wbem\WMIC.exe computersystem get currenttimezone 2>&1"') do if %%g1 lss 1 set /a "avd_utc{shift}+=%%g*60"
    for /f "tokens=1-8,* delims=:/ " %%O in ("%~3 %~4") do (
        for /l %%L in (1970,1,%%Q) do set /a "avd_leap{total}+=!(%%A %% 4 & %%A %% 100 & %%A %% 400)"
        for /f "tokens=1-3,4-6 delims=-/" %%A in ("%%O/%%P/%%Q/01/01/1970") do set /a "avd_mtime{unix}=(((((%%~A+100-1%%~D)*305)/10)+avd_leap{total}+(1%%~B-1%%~E)+(%%~C-%%~F)*365)*86400)-172800+avd_utc{shift}+((1%%T-100)+((1%%S-100)*60)+(%%R*3600))+%%U"
    )
    goto :eof
    REM if defined avd_out_ms set "avd_time{unix}=%avd_time{unix}%%time:~-2%0"
    REM if not defined avd_utc_offset ( for /f "tokens=1-8 delims=: " %%A in ('"%SystemRoot%\System32\w32tm.exe" /tz') do for %%e in ( "%%~A|%%~B"; "%%~B|%%~C"; "%%~C|%%~D"; "%%~D|%%~E"; "%%~E|%%~F"; "%%~F|%%~G"; "%%~G|%%~H" ) do for /f "tokens=1,2 delims=|" %%f in (%%e) do if /i "%%~f" equ "Bias" for /f "tokens=1 delims=min" %%m in ("%%~g") do if "%%~m" neq "0" set /a "avd_utc{shift}+=%%~m*60") 2>nul 1>nul

