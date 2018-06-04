::  Encoded - UTF-8  |  By JaCk  |  Release 06/03/2018  |  https://github.com/1ijack/BatchMajeek/blob/master/compactor.cmd  |  compactor.cmd  --  uses windows compact.exe to: compact/uncompact specific file extensions, uncompact redundant/zeroRatio files [files which have 0 compression]
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
@echo off &setlocal DisableDelayedExpansion EnableExtensions &goto :compact_main

:::::::::::::::::::::::::::::::::::::::
::
::: User Settings
::
:::::::::::::::::::::::::::::::::::::::

::  Usage  ::  userSettings
rem user/pre-defined script behavior settings
rem variables/settings overwritten by properly passed in parameter(s)
:userSettings
    rem hardcoded path - list -- [list separators: "white space"  comma, "semi-colon"; list]
    rem add double quotes when white-spaces and/or special characters
    set "path{compact}="

    rem file compact/uncompact file extensions - list -- [list separators: "white space"  comma, "semi-colon"; list]
    set "ext{compact}="

    rem all extensions - true/false - file compact/uncompact
    set "ext{compact}all="


    rem log path - path\file -  prints all msgs to this file, --silent agnostic
    set "path{log}out="


    rem run booleans - true/false - when the following are true, runs these specific jobs/script-functions
    set "run{run_compressor}="
    set "run{run_redundants}="
    set "run{run_decompress}="


    rem recurse flag - true/false - when true walks down a directory tree
    rem true effect - dir /s
    set "bool{recurseDirs}="

    rem force compact - true/false - when true forces compact.exe to compact/uncompact matched files
    rem use sparingly as it is possible to drastically increase processing time
    rem true effect - compact.exe /f
    set "bool{forceCompact}="

    rem silent console output - true/false - when true suppresses all console output
    set "bool{silent}console="


    rem location of compact.exe - path\bin - %SystemRoot%\System32\compact.exe
    set "bin{compact}=%SystemRoot%\System32\compact.exe"


    rem redundant ratio - must greater than 1.0 -- uncompress all files at or below this ratio
    set "redun{ratio}min="


    rem total of blanks needed to stop arg parser - must greater than 1
    set "arg{blank}max=3"

goto :eof


:::::::::::::::::::::::::::::::::::::::
::
::: Functions
::
:::::::::::::::::::::::::::::::::::::::
                              goto :eof

::  Usage  ::  ahh_helps  optional-int{counter}
rem Dumps help info only when dumping for the first time unless param1 is equal/less-than 0
rem param1 -- optional -- force specific counter value
rem   -1   -- bypasses silent and log-output checks
rem    0   -- run with silent and log-output checks
:ahh_helps
    rem unsolicited overprint prevention
    if "%~1" neq "" ( if %~1. lss a  set /a "help{msg}c=%~1" ) 2>nul
    set /a "help{msg}c+=1"
    if %help{msg}c% gtr 1 goto :eof
    if %help{msg}c% equ 1 (
        call :lumberLuahg call %~0 -1
        set "help{msg}c=1"
        goto :eof
    )
    rem help me... pretty please
    echo/
    echo/  %~nx0:
    echo/       A robust wrapper around compact.exe which compresses/uncompresses files via the filesystem
    echo/
    echo/  Usage:
    echo/      %~nx0 [-h] ["path\"] [-b "path\bin.exe"] [-c] [-d "A:\bsol\Path" -i "rel\path" ^| -p "Dir\withFile.ext"] [-e [^*.^*^|.ext1 .ext2]] [-f^|-nf] [-l "path\file.log"] [[-m^|-t] int.int] [-q^|-s] [-r^|-nr] [-u] [-z]
    echo/
    echo/  Parameters:
    echo/
    echo/      -?, -h, --help         Shows this help information
    echo/
    echo/      -b, --binary           Custom path location for compact.exe
    echo/
    echo/      -c, --compact,         Compress all files and file matches with
    echo/      --compress               compact.exe /c
    echo/
    echo/      -i {path}, --input,    Files to process OR directories to search in
    echo/      -d, --directory,         can be called multiple times
    echo/      -p, --path               example: -i file.log -i "path\file 2" -i D:\path
    echo/
    echo/      -e {.ext}, --ext,      List of extensions to for file matching
    echo/      -e all, -e *.*           extension wildcards: *.*, *, all
    echo/      --extensions             can be called multiple times
    echo/                               example: -e .txt .log *.* -e .sql
    echo/
    echo/      -f, --force,           Run with force - compact.exe /f
    echo/      -nf, --no-force        Run w/o  force - compact.exe
    echo/
    echo/      -l {file}, --log       Print to this logpath, agnostic to --silent
    echo/
    echo/      --ratio {x.x},         Optional ratio qualifier for: '--redundant'
    echo/      -t, --threshhold,        Example: -m 1.3
    echo/      -m, --min-ratio,
    echo/
    echo/      -q, --quiet,           Do not print anything to console
    echo/      -s, --silent
    echo/
    echo/      -r, --recurse,         Recurse down directory tree path - dir /s
    echo/      -nr, --no-recurse      Do not recurse directory tree path - dir
    echo/
    echo/      -u, --uncompact,       Uncompress all files and file matches with
    echo/      --uncompress             compact.exe /u
    echo/
    echo/      -z,  --redundant,      Search for matching files with a compression
    echo/      --zero, --badratio,      ratio of 1.0, then uncompress matched files.
    echo/      --zerocompression        See '--threshhold' when custom ratio needed
    echo/
    echo/  Notes:
    echo/
    echo/      * Unnamed Keys and/or keyless values are used as paths
    echo/      * Key order is NOT enforced as all parameters are parsed before any workload is done.  These parameters [-e, --ext, --extensions] and [-d, -i, -p, --directory, --input, --path] both append, therefore they can be submitted multiple times when needed.
    echo/      * min-ratio of 1.0 is used for '--redundant'. When needing a custom ratio, it can be passed in as '--threshhold X.X'.  Example: --redundant --threshhold 2.0
    echo/
    echo/  Usage Examples:
    echo/
    echo/      Compacts all uncompacted .log, .txt, .sql, .md files, then rewalk path to uncompact files which ratios are at/less-than 1.5.
    echo/      %~0 --recurse --force --compact -extensions .log .txt .sql .md --redundant --threshhold 1.5 "%homeDrive%\myWorkspace\logs" --path "%homeDrive%\myWorkspace\ACME_101" --path "%homeDrive%\myWorkspace\database_archive"
    echo/
    echo/      Recursively uncompact all files with extensions .7z, .zip, .rar, .cab, .cbr, .cbz
    echo/      %~0 --recurse --uncompact -extensions .7z .zip .rar .cab .cbr .cbz
    echo/
    echo/      Compact all files in a directory
    echo/      %~0 --no-recurse --compact -extensions all --path %homeDrive%\backup\database\
    echo/
    goto :eof


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

    if not defined arg{One}key if exist "%~1" if "%~a1" neq "" call set "path{compact}=%%path{compact}%%; %1"

    rem  \\\\\\\\\\\\\\\ ///////////////
    rem       ArgParser - Key reuse
    rem  /////////////// \\\\\\\\\\\\\\\
    if not defined arg{One}key goto :argShwift

    if /i "%arg{One}key%" equ "?"                set "arg{One}key=help"
    if /i "%arg{One}key%" equ "b"                set "arg{One}key=binary"
    if /i "%arg{One}key%" equ "badratio"         set "arg{One}key=zerocompression"
    if /i "%arg{One}key%" equ "c"                set "arg{One}key=compress"
    if /i "%arg{One}key%" equ "compact"          set "arg{One}key=compress"
    if /i "%arg{One}key%" equ "d"                set "arg{One}key=input"
    if /i "%arg{One}key%" equ "directories"      set "arg{One}key=input"
    if /i "%arg{One}key%" equ "directory"        set "arg{One}key=input"
    if /i "%arg{One}key%" equ "e"                set "arg{One}key=extensions"
    if /i "%arg{One}key%" equ "ext"              set "arg{One}key=extensions"
    if /i "%arg{One}key%" equ "extension"        set "arg{One}key=extensions"
    if /i "%arg{One}key%" equ "f"                set "arg{One}key=force"
    if /i "%arg{One}key%" equ "file-extension"   set "arg{One}key=extensions"
    if /i "%arg{One}key%" equ "file-extensions"  set "arg{One}key=extensions"
    if /i "%arg{One}key%" equ "file-type"        set "arg{One}key=extensions"
    if /i "%arg{One}key%" equ "file-types"       set "arg{One}key=extensions"
    if /i "%arg{One}key%" equ "h"                set "arg{One}key=help"
    if /i "%arg{One}key%" equ "i"                set "arg{One}key=input"
    if /i "%arg{One}key%" equ "inputs"           set "arg{One}key=input"
    if /i "%arg{One}key%" equ "l"                set "arg{One}key=log"
    if /i "%arg{One}key%" equ "m"                set "arg{One}key=min-ratio"
    if /i "%arg{One}key%" equ "nf"               set "arg{One}key=no-force"
    if /i "%arg{One}key%" equ "nr"               set "arg{One}key=no-recurse"
    if /i "%arg{One}key%" equ "p"                set "arg{One}key=input"
    if /i "%arg{One}key%" equ "path"             set "arg{One}key=input"
    if /i "%arg{One}key%" equ "paths"            set "arg{One}key=input"
    if /i "%arg{One}key%" equ "q"                set "arg{One}key=silent"
    if /i "%arg{One}key%" equ "quiet"            set "arg{One}key=silent"
    if /i "%arg{One}key%" equ "r"                set "arg{One}key=recurse"
    if /i "%arg{One}key%" equ "ratio"            set "arg{One}key=min-ratio"
    if /i "%arg{One}key%" equ "redundant"        set "arg{One}key=zerocompression"
    if /i "%arg{One}key%" equ "s"                set "arg{One}key=silent"
    if /i "%arg{One}key%" equ "t"                set "arg{One}key=min-ratio"
    if /i "%arg{One}key%" equ "threshhold"       set "arg{One}key=min-ratio"
    if /i "%arg{One}key%" equ "type"             set "arg{One}key=extensions"
    if /i "%arg{One}key%" equ "types"            set "arg{One}key=extensions"
    if /i "%arg{One}key%" equ "u"                set "arg{One}key=uncompress"
    if /i "%arg{One}key%" equ "uncompact"        set "arg{One}key=uncompress"
    if /i "%arg{One}key%" equ "z"                set "arg{One}key=zerocompression"
    if /i "%arg{One}key%" equ "zero"             set "arg{One}key=zerocompression"

    rem  \\\\\\\\\\\\\\\ ///////////////
    rem       ArgParser - Key ONLY
    rem  /////////////// \\\\\\\\\\\\\\\

    if /i "%arg{One}key%" equ "compress"         set "run{run_compressor}=true"
    if /i "%arg{One}key%" equ "help"             call :ahh_helps
    if /i "%arg{One}key%" equ "force"            set "bool{forceCompact}=true"
    if /i "%arg{One}key%" equ "no-force"         set "bool{forceCompact}="
    if /i "%arg{One}key%" equ "no-recurse"       set "bool{recurseDirs}="
    if /i "%arg{One}key%" equ "recurse"          set "bool{recurseDirs}=true"
    if /i "%arg{One}key%" equ "silent"           set "bool{silent}console=true"
    if /i "%arg{One}key%" equ "uncompress"       set "run{run_decompress}=true"
    if /i "%arg{One}key%" equ "zerocompression"  set "run{run_redundants}=true"

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

    if /i "%arg{One}key%" equ "binary"      set /a "arg{shift}c+=1"
    if /i "%arg{One}key%" equ "binary"      set "bin{compact}=%~1"

    if /i "%arg{One}key%" equ "input"       set /a "arg{shift}c+=1"
    if /i "%arg{One}key%" equ "input"       call set "path{compact}=%%path{compact}%%; %1"

    if /i "%arg{One}key%" equ "log"         set /a "arg{shift}c+=1"
    if /i "%arg{One}key%" equ "log"         set "path{log}out=%~1"

    if /i "%arg{One}key%" equ "min-ratio"   set /a "arg{shift}c+=1"
    if /i "%arg{One}key%" equ "min-ratio"   set "redun{ratio}min=%~1"

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
        if /i "%~1" equ "all" ((shift /1) &set "ext{compact}all=*.*")
        if    "%~1" equ "*."  ((shift /1) &set "ext{compact}all=*.*")
        if    "%~1" equ  ".*" ((shift /1) &set "ext{compact}all=*.*")
        if    "%~1" equ  "*"  ((shift /1) &set "ext{compact}all=*.*")
        if    "%~1" equ "*.*" ((shift /1) &set "ext{compact}all=*.*")
        if    "%~1" equ "%~x1" (
            call set "ext{compact}=%%ext{compact}%% %1;"
            shift /1
        ) else goto :argShwift
    )
    goto :argExtensionParser
    goto :eof


::  Usage  ::  clearVariables   optional-varName1   optional-varName2   optional-varName3   etc
rem un-defines script variables
:clearVariables
    if "%~1" neq "" ( set "%~1="
    ) else for %%V in (path{compact};bool{recurseDirs};bool{forceCompact};bin{compact};d{s}a;c{f}a;arg{total}c;arg{blank}c;arg{shift}c;arg{One}key;ext{compact}all;ext{compact};help{msg}c;f{cb}b;redun{ratio}min;strm{one}out;bool{silent}console;path{log}out
    ) do set "%%V="
    if "%~2" neq "" (
        shift /1
        goto %~0
    )
    goto :eof


:compact_main
    call :initEnv
    call :argShwift %*
    call :runSelector
    goto :deInitEnv
    goto :eof


::  Usage  ::  deInitEnv
rem de-initializes the script environment by clearing script variables and restoring pre-script configuration
:deInitEnv
    call :clearVariables
    ((endlocal) &goto :eof)
    goto :eof


::  Usage  ::  initEnv
rem initializes the script environment by defining default states and performing basic errorchecks
:initEnv
    call :clearVariables
    call :userSettings
    call :whereBinPath bin{compact}
    call :validateBoolBi bool{recurseDirs} bool{forceCompact} ext{compact}all bool{silent}console
    if %arg{blank}max%. lss 1. set "arg{blank}max=2"
    if defined ext{compact}all set "ext{compact}all=*.*"
    if defined bool{silent}console set "strm{one}out=2>nul 1>nul"
    goto :eof


::  Usage  ::  lumberLuahg  Msg
::  Usage  ::  lumberLuahg  echo/Msg
::  Usage  ::  lumberLuahg  call func_Kek  prophó  «Kêkistan»
rem Log to file and/or print to console
rem Adds echo statements when needed
rem can call functions to control output
:lumberLuahg
    if "%~1" equ "" goto :eof
    if not defined path{log}out if defined bool{silent}console goto :eof
    set "lAp=%~1"
    if "%lAp:call=%" equ "%lAp%" if "%lAp:echo=%" equ "%lAp%" (
        call %~0 echo/%*
        set "lAp="
        goto :eof
    )
    set "lAp="
    if defined path{log}out ( 
      %*
    ) %path{log}out%
    ( %*
    ) %strm{one}out%
    goto :eof


:runPrep
    rem runner dependency resolution cry for help
    call :validateBoolBi bool{forceCompact} bool{recurseDirs} run{run_compressor} run{run_redundants} run{run_decompress} bool{silent}console
    if not defined path{compact} (
        call :ahh_helps
        exit /b 1
    )
    if not defined run{run_compressor} if not defined run{run_redundants} if not defined run{run_decompress} (
        call :ahh_helps
        exit /b 1
    )
    rem force/recurse affixation
    if defined bool{recurseDirs}  set "d{s}a=/s"
    if defined bool{forceCompact} set "c{f}a=/f"
    rem ratio cannot be less than 1.0 -  but needs to be an int past the first decimal point
    if not defined redun{ratio}min (
        rem blank
        set "redun{ratio}min=1.0"
    ) else for /f "tokens=1,2,3 delims==. " %%N in ('"2>nul set redun{ratio}min"') do if "%%~Oa" gtr "a" (
        rem empty or not an int
        set "redun{ratio}min=1.0"
    ) else if "%%~O.%%~P" lss "1.0" (
        rem int but less than 1.0
        set "redun{ratio}min=1.0"
    ) else if "a%%~P" gtr "a" (
        rem int and all is well
        set "%%~N=%%~O.%%~P"
    ) else (
        rem first is well - second needs fixin
        set "%%~N=%%~O.0"
    )
    rem ensure workload
    if defined ext{compact}all (
        rem make sure we are not doing double the work
        set "ext{compact}="
    ) else if not defined ext{compact} (
        rem when directory -- make sure we are doing some type of work
        set "ext{compact}all=*.*"
    )
    rem lazy redirection checks -- apply redirection when missing
    if defined bool{silent}console set "strm{one}out=2>nul 1>nul"
    if not defined path{log}out exit /b 0
    ((set "path{log}out") | findstr "1< 1>" || call set "path{log}out=1>>%path{log}out%"   ) 2>nul 1>nul
    ((set "path{log}out") | findstr "2< 2>" || call set "path{log}out=2>nul %path{log}out%") 2>nul 1>nul
    rem touch the file`
    (echo/|set /p "noop=") %path{log}out%

    set "path{log}out"
    exit /b 0
    goto :eof


::  Usage  ::  runSelector
rem runs job/function based on boolean variables OR prints help
rem checks whether the path is a file or a directory
rem checks for extension list variable
rem checks for wildcard extension boolean
:runSelector
    call :runPrep || goto :deInitEnv
    rem run extension lists only on directory paths
    if defined run{run_compressor} for %%P in (%path{compact}%) do if f%%~aP gtr fd (
        if defined ext{compact} for %%E in (%ext{compact}%) do call :run_compressor "%%~P\*%%~xE"
        if defined ext{compact}all call :run_compressor "%%~P\%ext{compact}all%"
    ) else call :run_compressor %%P
    if defined run{run_decompress} for %%P in (%path{compact}%) do if f%%~aP gtr fd (
        if defined ext{compact} for %%E in (%ext{compact}%) do call :run_decompress "%%~P\*%%~xE"
        if defined ext{compact}all call :run_decompress "%%~P\%ext{compact}all%"
    ) else call :run_decompress %%P
    if defined run{run_redundants} for %%P in (%path{compact}%) do if f%%~aP gtr fd (
        if defined ext{compact} for %%E in (%ext{compact}%) do call :run_redundants "%%~P\*%%~xE"
        if defined ext{compact}all call :run_redundants "%%~P\%ext{compact}all%"
    ) else call :run_redundants %%P
    goto :eof


::  Usage  ::   run_compressor  dirPath1\*.*   "dir Path 2\*.extension2"   dirPath3\file3   etc
rem Recursively walks dir tree and tries to compress all the files matching the extension
rem When matching file is already compressed, does not recompress
:run_compressor
    if "%~1" equ "" goto :eof
    (   for /f "delims=" %%A in ('
            dir /b /a:-d %d{s}a% %1
        ') do for /f "skip=6 delims=" %%U in ('
            %bin{compact}% %c{f}a% /I /Q /C "%%A"
        ') do call :lumberLuahg echo/%~nx0%~0: %%da^te:~-10,6%%%%da^te:~-2%% %%ti^me:~-12,8%%: %%A: %%U
    ) 2>nul
    shift /1
    goto %~0
    goto :eof


::  Usage  ::   run_decompress  dirPath1\*.*   "dir Path 2\*.extension2"   dirPath3\file3   etc
rem Recursively walks dir tree and tries to uncompress all the files matching the extension
rem When matching file is already compressed, does not re-uncompress
:run_decompress
    if "%~1" equ "" goto :eof
    (   for /f "delims=" %%A in ('
            dir /b /a:-d %d{s}a% %1
        ') do for /f "skip=3 delims=" %%U in ('
            %bin{compact}% %c{f}a% /I /Q /U "%%A"
        ') do call :lumberLuahg echo/%~nx0%~0: %%da^te:~-10,6%%%%da^te:~-2%% %%ti^me:~-12,8%%: %%A: %%U
    ) 2>nul
    shift /1
    goto %~0
    goto :eof


::  Usage  ::   run_redundants  dirPath1\*.*   "dir Path 2\*.extension2"   dirPath3\file3   etc
rem Recursively walks dir tree and tries to uncompress all the files redundant files
rem Redundant files are files which have a 1.0 ratio
:run_redundants
    set "f{cb}b="
    if "%~1" equ "" goto :eof
    set "f{cb}b=true"
    (   for /f "delims=" %%A in ('
            dir /b /a:-d %d{s}a% %1
        ') do for /f "tokens=1-8" %%B in ('
            compact /q /a "%%A"
        ') do  if  "%%D"   equ   "added"                   ( rem action statement clause cannot be empty -- filtering action
        ) else if  "%%D"   equ   "files"                   ( rem action statement clause cannot be empty -- filtering action
        ) else if "%%B%%D" equ "0compressed"               ( rem action statement clause cannot be empty
            set "f{cb}b="                                    rem file is already not compressed - clear boolean flag
        ) else if  "%%D"   equ   "bytes"                   ( rem action statement clause cannot be empty -- filtering action
        ) else if  "%%D"   equ   "ratio" if defined f{cb}b ( rem clean boolean flag -now check/process ratio vs redun{ratio}min
            if %%F. geq %redun{ratio}min%. for /f "skip=2 delims=" %%U in ('
                %bin{compact}% %c{f}a% /I /Q /U "%%A"
            ') do call :lumberLuahg echo/%~nx0%~0: %%da^te:~-10,6%%%%da^te:~-2%% %%ti^me:~-12,8%%: %%A: %%U
        ) else call set "f{cb}b=true"                        rem looped through entire compaxt response - reset boolean flag
    ) 2>nul
    shift /1
    goto %~0
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
    set "%~1="
    if    "%bool{check}:~0,1%" equ "1" set "%~1=true"
    if /i "%bool{check}:~0,1%" equ "p" set "%~1=true"
    if /i "%bool{check}:~0,1%" equ "t" set "%~1=true"
    if /i "%bool{check}:~0,1%" equ "y" set "%~1=true"
    set "bool{check}="
    shift /1
    goto %~0


::  Usage  ::  validateBoolTri   varName1   varName2   varName3   etc
rem ensures that the variable value is one of the following states
rem [only checks the first character of the variables value]
rem  true       - 1, p, t, y -- [1, pass, true, yes]
rem  false      - 0, f, n    -- [0, fail, no]
rem  undefined  - notPass&notFalse, undefined -- [no value, any value not matching pass/fail]
:validateBoolTri
    if "%~1" equ "" goto :eof
    if not defined %~1 ((shift /1) &goto %~0)
    call set "bool{check}=%%%~1%% "
    set "%~1="
    if    "%bool{check}:~0,1%" equ "1" set "%~1=true"
    if /i "%bool{check}:~0,1%" equ "p" set "%~1=true"
    if /i "%bool{check}:~0,1%" equ "t" set "%~1=true"
    if /i "%bool{check}:~0,1%" equ "y" set "%~1=true"
    if    "%bool{check}:~0,1%" equ "0" set "%~1=false"
    if /i "%bool{check}:~0,1%" equ "f" set "%~1=false"
    if /i "%bool{check}:~0,1%" equ "n" set "%~1=false"
    set "bool{check}="
    shift /1
    goto %~0


::  Usage  ::  whereBinPath  returnVar   bin1.exe  bin1-x64.exe  bin1-x86.exe
rem  Returns Variable defined with the first binary location found
rem  Note: you can pass multiple binary name variations
rem  - leave early ignoring remainder of params, after finding the first location
rem  Note: path is optional and NOT required
rem  - when providing a path, use only absolutePaths; NO relativePaths. Function does not validate paths
:whereBinPath
    if "%~1" equ "" (exit /b 1) else if "%~2" equ "" (exit /b 1) else set "%~1="
    if "%~p2" neq "" for /f "delims=" %%B in ('
        %SystemRoot%\System32\where.exe "%~dp2":"%~nx2"
    ') do (
        set "%~1=%%B"
        exit /b 0
    )
    for /f "delims=" %%B in ('
        %SystemRoot%\System32\where.exe %~nx2
    ') do (
        set "%~1=%%B"
        exit /b 0
    )
    shift /2
    goto %~0
    goto :eof
