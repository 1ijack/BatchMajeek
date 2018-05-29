::  By JaCk  |  Release 05/28/2018  |  https://github.com/1ijack/BatchMajeek/blob/master/compactor.cmd  |  compactor.cmd  --  uses windows compact.exe to: compact/uncompact specific file extensions, uncompact redundant/zeroRatio files [files which have 0 compression]
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


    rem run booleans - true/false - when the following are true, runs these specific jobs/script-functions
    set "run{CompressExtensions}="
    set "run{unCompressRedundant}="
    set "run{unCompressExtensions}="


    rem recurse flag - true/false - when true walks down a directory tree
    rem true effect - dir /s
    set "bool{recurseDirs}="

    rem force compact - true/false - when true forces compact.exe to compact/uncompact matched files
    rem true effect - compact.exe /f
    set "bool{forceCompact}="


    rem location of compact.exe - path\bin - %SystemRoot%\System32\compact.exe
    set "bin{compact}=%SystemRoot%\System32\compact.exe"


    rem total of blanks needed to stop arg parser - must greater than 1
    set "arg{blank}max=3"

goto :eof


:::::::::::::::::::::::::::::::::::::::
::
::: Functions
::
:::::::::::::::::::::::::::::::::::::::
                              goto :eof

:ahh_helps
    if "%~1" neq "" if %~1. gtr 0. goto :eof
    set /a "help{msg}c+=1"
    REM call echo/%~nx0%~0: %%da^te:~-10,6%%%%da^te:~-2%% %%ti^me:~-12,8%%: Dumping usage information
    REM echo/
    echo/  %~nx0:
    echo/       A robust wrapper around compact.exe which compresses/uncompresses files via the filesystem
    echo/
    echo/  Usage:
    echo/      %~nx0 [-h] [-c] [-u] [-z] [-e [^*.^*^|.ext1 .ext2]] [-f^|-nf] [-r^|-nr] [-b "path\bin.exe"] [-d "A:\bsol\Path" -i "rel\path" ^| -p "Dir\withFile.ext"]
    echo/
    echo/  Parameters:
    echo/
    echo/      -?, -h, --help         Shows this help information
    echo/
    echo/      -c, --compact,         Compress all files and file matches with
    echo/      --compress               compact.exe /c
    echo/
    echo/      -e, --ext,             List of extensions to for file matching
    echo/      --extensions             can be called multiple times
    echo/                               example: -e .txt .log *.* -e .sql
    echo/
    echo/      -u, --uncompact,       Uncompress all files and file matches with
    echo/      --uncompress             compact.exe /u
    echo/
    echo/      -z,  --redundant,      Search for matching files with a compression
    echo/      --zero, --badratio,      ratio of 1.0, then uncompress matched files
    echo/      --zerocompression
    echo/
    echo/      -f, --force,           Run with force - compact.exe /f
    echo/      -nf, --no-force        Run w/o  force - compact.exe
    echo/
    echo/      -r, --recurse,         Recurse down directory tree path - dir /s
    echo/      -nr, --no-recurse      Do not recurse directory tree path - dir
    echo/
    echo/      -b, --binary           Custom path location for compact.exe
    echo/
    echo/      -d, --directory,       Directories to search in or files to search for
    echo/      -i, --input,             can be called multiple times
    echo/      -p, --path               example: -i file.log -i "path\file 2" -i D:\path
    echo/
    echo/  Notes:
    echo/
    echo/      All parameters are parsed before anything workload is processed.  These parameters [-e, --ext, --extensions] and [-d, -i, -p, --directory, --input, --path] both append, therefore they can be submitted multiple times when needed.
    echo/
    goto :eof


::  goto Usage  ::  argShwift
::  call Usage  ::  argShwift   arg1   arg2   arg3   etc
rem super basic arg parser
rem although both work, intended use as goto instead of call
:argShwift
    rem  only shift when var is greater than one
    set "arg{One}key="
    REM set "arg{Two}key="
    set /a "arg{shift}c+=0,arg{blank}c+=1"
    for /l %%L in (1,1,%arg{shift}c%) do shift /1
    set /a "arg{shift}c=1"
    rem  reloop/leave on empty
    if %arg{blank}c% gtr %arg{blank}max%  goto :eof
    if     "%~1"     equ       ""         goto :argShwift
    rem pre-define counters
    set /a "arg{blank}c=0,arg{total}c+=1"

    rem  define key
    for /f "tokens=* delims=/-\" %%A in ("-%~1") do if "%~1" neq "%%~A" set "arg{One}key=%%~A"
    REM for /f "tokens=* delims=/-\" %%A in ("-%~2") do if "%~2" neq "%%~A" set "arg{Two}key=%%~A"

    rem  \\\\\\\\\\\\\\\ ///////////////
    rem       ArgParser - KeyLess
    rem  /////////////// \\\\\\\\\\\\\\\

    rem  keyless matching
    if not defined arg{One}key if exist "%~1" if defined path{compact} call set "path{compact}=%%path{compact}%%; %1"

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
    if /i "%arg{One}key%" equ "directory"        set "arg{One}key=input"
    if /i "%arg{One}key%" equ "e"                set "arg{One}key=extensions"
    if /i "%arg{One}key%" equ "ext"              set "arg{One}key=extensions"
    if /i "%arg{One}key%" equ "f"                set "arg{One}key=force"
    if /i "%arg{One}key%" equ "h"                set "arg{One}key=help"
    if /i "%arg{One}key%" equ "i"                set "arg{One}key=input"
    if /i "%arg{One}key%" equ "nf"               set "arg{One}key=no-force"
    if /i "%arg{One}key%" equ "nr"               set "arg{One}key=no-recurse"
    if /i "%arg{One}key%" equ "p"                set "arg{One}key=input"
    if /i "%arg{One}key%" equ "path"             set "arg{One}key=input"
    if /i "%arg{One}key%" equ "r"                set "arg{One}key=recurse"
    if /i "%arg{One}key%" equ "redundant"        set "arg{One}key=zerocompression"
    if /i "%arg{One}key%" equ "u"                set "arg{One}key=uncompress"
    if /i "%arg{One}key%" equ "uncompact"        set "arg{One}key=uncompress"
    if /i "%arg{One}key%" equ "z"                set "arg{One}key=zerocompression"
    if /i "%arg{One}key%" equ "zero"             set "arg{One}key=zerocompression"

    rem  \\\\\\\\\\\\\\\ ///////////////
    rem       ArgParser - Key ONLY
    rem  /////////////// \\\\\\\\\\\\\\\

    if /i "%arg{One}key%" equ "compress"         set "run{CompressExtensions}=true"
    if /i "%arg{One}key%" equ "help"             call :ahh_helps
    if /i "%arg{One}key%" equ "force"            set "bool{forceCompact}=true"
    if /i "%arg{One}key%" equ "no-force"         set "bool{forceCompact}="
    if /i "%arg{One}key%" equ "no-recurse"       set "bool{recurseDirs}="
    if /i "%arg{One}key%" equ "recurse"          set "bool{recurseDirs}=true"
    if /i "%arg{One}key%" equ "uncompress"       set "run{unCompressExtensions}=true"
    if /i "%arg{One}key%" equ "zerocompression"  set "run{unCompressRedundant}=true"

    rem  \\\\\\\\\\\\\\\ ///////////////
    rem       ArgParser - Key w/Value(s)
    rem  /////////////// \\\\\\\\\\\\\\\

    rem leave early when no values found
    if "%~2" equ "" goto :argShwift

    rem trim the shift counter again
    for /l %%L in (1,1,%arg{shift}c%) do shift /1
    set /a "arg{shift}c=0"

    rem  note, when using parameter positions from 1 and higher, adjust shift accordingly
    rem  easy formula -- set /a "arg{shift}c+=ArgPosition"

    if /i "%arg{One}key%" equ "binary"      set /a "arg{shift}c+=1"
    if /i "%arg{One}key%" equ "binary"      set "bin{compact}=%~1"

    if /i "%arg{One}key%" equ "input"       set /a "arg{shift}c+=1"
    if /i "%arg{One}key%" equ "input"       call set "path{compact}=%%path{compact}%%; %1"

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
        if "%~1" equ "%~x1" (
            if "%~1" equ "%%~A" (
                call set "ext{compact}=%%ext{compact}%% %1;"
                shift /1
            ) else goto :argShwift
        ) else goto :argShwift
    )

    goto :argExtensionParser
    goto :eof


::  Usage  ::  clearVariables   optional-varName1   optional-varName2   optional-varName3   etc
rem un-defines script variables
:clearVariables
    if "%~1" neq "" ( set "%~1="
    ) else for %%V in (path{compact};bool{recurseDirs};bool{forceCompact};bin{compact};d{s}a;c{f}a;arg{total}c;arg{blank}c;arg{shift}c;arg{One}key;ext{compact}all;ext{compact};help{msg}c
    ) do set "%%V="
    if "%~2" neq "" ((shift /1) &goto %~0)
    goto :eof


::  Usage  ::   compressExtensions  dirPath1\*.*   "dir Path 2\*.extension2"   dirPath3\file3   etc
rem Recursively walks dir tree and tries to compress all the files matching the extension
rem When matching file is already compressed, does not recompress
:compressExtensions
    if "%~1" equ "" goto :eof

    ( for /f "delims=" %%A in ('
        dir /b /a:-d %d{s}a% %1
    ') do for /f "skip=6 delims=" %%U in ('
        %bin{compact}% %c{f}a% /I /Q /C "%%A"
    ') do call echo/%~nx0%~0: %%da^te:~-10,6%%%%da^te:~-2%% %%ti^me:~-12,8%%: %%A: %%U
    ) 2>nul
    shift /1
    goto %~0
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
    call :validateBoolBi bool{recurseDirs} bool{forceCompact} ext{compact}all
    if %arg{blank}max%. lss 1. set "arg{blank}max=2"
    if defined ext{compact}all set "ext{compact}all=*.*"
    goto :eof


::  Usage  ::  runSelector
rem runs job/function based on boolean variables OR prints help
rem checks for extension list variable
rem checks for wildcard extension boolean
rem checks whether the path is directly to a file, instead of a directory
:runSelector
    call :validateBoolBi bool{forceCompact} bool{recurseDirs} run{CompressExtensions} run{unCompressRedundant} run{unCompressExtensions}

    if not defined path{compact} ((call :ahh_helps %help{msg}c%) &goto :deInitEnv)
    if not defined run{CompressExtensions} if not defined run{unCompressRedundant} if not defined run{unCompressExtensions} if %help{print}%. lss 1. ((call :ahh_helps %help{msg}c%) &goto :deInitEnv)

    if defined bool{recurseDirs}  set "d{s}a=/s"
    if defined bool{forceCompact} set "c{f}a=/f"

    if defined run{CompressExtensions} for %%P in (%path{compact}%) do (
        if defined ext{compact} for %%E in (%ext{compact}%) do call :CompressExtensions "%%~P\*%%~xE"
        if defined ext{compact}all call :CompressExtensions "%%~P\%ext{compact}all%"
        if f%%~aP lss fd call :CompressExtensions %%P
    )

    if defined run{unCompressExtensions} for %%P in (%path{compact}%) do (
        if defined ext{compact} for %%E in (%ext{compact}%) do call :unCompressExtensions "%%~P\*%%~xE"
        if defined ext{compact}all call :unCompressExtensions "%%~P\%ext{compact}all%"
        if f%%~aP lss fd call :unCompressExtensions %%P
    )

    if defined run{unCompressRedundant} for %%P in (%path{compact}%) do (
        if defined ext{compact} for %%E in (%ext{compact}%) do call :unCompressRedundant "%%~P\*%%~xE"
        if defined ext{compact}all call :unCompressRedundant "%%~P\%ext{compact}all%"
        if f%%~aP lss fd call :unCompressRedundant %%P
    )
    goto :eof


::  Usage  ::   unCompressExtensions  dirPath1\*.*   "dir Path 2\*.extension2"   dirPath3\file3   etc
rem Recursively walks dir tree and tries to uncompress all the files matching the extension
rem When matching file is already compressed, does not re-uncompress
:unCompressExtensions
    if "%~1" equ "" goto :eof
    ( for /f "delims=" %%A in ('
        dir /b /a:-d %d{s}a% %1
    ') do for /f "skip=3 delims=" %%U in ('
        %bin{compact}% %c{f}a% /I /Q /U "%%A"
    ') do call echo/%~nx0%~0: %%da^te:~-10,6%%%%da^te:~-2%% %%ti^me:~-12,8%%: %%A: %%U
    ) 2>nul
    shift /1
    goto %~0
    goto :eof


::  Usage  ::   unCompressRedundant  dirPath1\*.*   "dir Path 2\*.extension2"   dirPath3\file3   etc
rem Recursively walks dir tree and tries to uncompress all the files redundant files
rem Redundant files are files which have a 1.0 ratio
:unCompressRedundant
    if "%~1" equ "" goto :eof
    ( for /f "delims=" %%A in ('
        dir /b /a:-d %d{s}a% %1
    ') do for /f "tokens=3,5" %%B in ('
        compact /q /a "%%A"
    ') do if "%%C%%B" equ "1.0ratio" for /f "skip=2 delims=" %%U in ('
        %bin{compact}% %c{f}a% /I /Q /U "%%A"
    ') do call echo/%~nx0%~0: %%da^te:~-10,6%%%%da^te:~-2%% %%ti^me:~-12,8%%: %%A: %%U
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


::  Usage  ::  whereBinPath  returnVar  path\bin1
rem  Returns Variable defined with the binary location when located in the path
rem  path is optional and NOT required
rem  when providing a path, use only absolutePaths; NO relativePaths. Function does not validate paths
:whereBinPath
    if "%~2" equ "" goto :eof
    if "%~1" equ "" goto :eof
    set "%~1="

    if "%~p2" equ "" for /f "delims=" %%B in ('
        %SystemRoot%\System32\where.exe %~2
    ') do if not defined %~1 set "%~1=%%B"

    if "%~p2" neq "" for /f "delims=" %%B in ('
        %SystemRoot%\System32\where.exe "%~dp2":"%~nx2"
    ') do if not defined %~1 set "%~1=%%B"

    goto :eof

