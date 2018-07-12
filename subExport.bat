::  By JaCk  |  Release 05/18/2018  |  https://github.com/1ijack/BatchMajeek/blob/master/subExport.bat  |  subExport.bat  --  Export all text subtitles and font attachments from mkv containers depending on subtitle language id
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
@echo off & setlocal DisableDelayedExpansion EnableExtensions & ( for /f "tokens=1 delims==" %%A in ('set sxp') do if /i "%%~A" neq "sxp_popd_me_back" set "%%~A=") 2>nul & goto :func_sxp_mah_mains

:::::::::::::::::::::::::::::::::::::::
::                                   ::
::           User Settings           ::
::                                   ::
:::::::::::::::::::::::::::::::::::::::
:func_sxp_user_conf
    rem  ffmpeg binary path and options, note, -v/-loglevel args are used manually
    set "sxp_ffmpeg_bin=%ProgramData%\chocolatey\bin\ffmpeg.exe"
    set "sxp_ffmpeg_opt=-n -vn -an -hide_banner"

    rem  ffmpeg subtype filter, mainly used for filtering out image based subs
    set "sxp_sub_filter=dvd_subtitle"

    rem  Media file extensions, you can separate with whitespace, semicolon or comma
    set "sxp_extensions=.avi .bik .flv .mk3d .mkv .mks .mov .mp4 .mpg .mpeg .ogm .ogv .webm .wmv"

    rem  Stop the auto/annoying help dump 
    rem set "sxp_skip_helps=true"
    set "sxp_skip_helps="
goto :eof


:::::::::::::::::::::::::::::::::::::::
::                                   ::
::      --       Helps       --      ::
::                                   ::
:::::::::::::::::::::::::::::::::::::::
:func_sxp_ahh_helps
    echo/ _______________________________________
    echo/
    echo/  %~nx0 - wrapper around ffmpeg to recursively export 
    echo/          text subtitles and attachments from media containers
    echo/
    echo/  Usage:
    echo/         %~nx0  -f ["list"] -e ["extensionList"] -b ["path\binary.ext"]
    echo/           ["Path"] -i ["Path"] --input ["Path"]
    echo/
    echo/  Parameters:
    echo/    -h, --help         Shows this help
    echo/
    echo/    -i, --input        Relative/Absolute directory to export from
    echo/    -d, --directory
    echo/
    echo/    -b, --binary       ffmpeg binary path
    echo/
    echo/    -e, --extensions   media file inclusion extension list
    echo/                         separate by comma, space and or semicolon
    echo/
    echo/    -f, --filter       ffmpeg subtitle format ignore filter list, separate by space
    echo/                         used mainly to filter out imagetype subtitle formats
    echo/
    echo/
    echo/  Other Information:
    echo/      Parameters are take effect/processed one at a time 
    echo/        in the order they are entered/recieved
    echo/
    echo/      When no parameters are passed into the script:
    echo/        Uses [current or script directory]: "%cd%" or "%~dp0"
    echo/
    echo/      To filter out specific sub formats, see 'sxp_sub_filter' or parameter -f
    echo/        sxp_sub_filter: '%sxp_sub_filter%'
    echo/
    echo/
    echo/  Hardcoded behavior:
    echo/     Creates the following subtitle files for each text stream:
    echo/       .srt, .ass, .vtt
    echo/
    echo/     Relative subdirectories:
    echo/       Subtitle  files go to "mediafile\..\subs\"
    echo/       ffmpegLog files go to "mediafile\..\meta\"
    echo/
    echo/     Output filename scheme:
    echo/       .\[srcName.ext] -^> .\subs\[srcName.ext].[langID].[streamID].[subExt]
    echo/ _______________________________________
    echo/
goto :eof

:::::::::::::::::::::::::::::::::::::::
::                                   ::
::               Main                ::
::                                   ::
:::::::::::::::::::::::::::::::::::::::
:func_sxp_mah_mains
    rem  clear any previous states/runs
    call :func_sxp_out_ofDir "si man"
    ( for /f "tokens=1 delims==" %%A in ('set sxp') do call set "%%~A="
    ) 2>nul

    rem  init environment
    call :func_sxp_user_conf
    call :func_sxp_errChecks    || goto :func_sxp_gtfo_plox

    rem  to shwift or not to shwift...
    if  "%~1" equ "" (
        if not defined sxp_skip_helps call :func_sxp_ahh_helps
        if "%cd%" equ "%SystemRoot%\System32" (
            call :func_sxp_subExport "%~dp0"
        ) else (
            call :func_sxp_subExport "%cd%"
        )
    ) else goto :func_sxp_ArgShwift

    rem  out like trout
    goto :func_sxp_gtfo_plox

goto :eof


:::::::::::::::::::::::::::::::::::::::
::                                   ::
::             Functions             ::
::                                   ::
:::::::::::::::::::::::::::::::::::::::
                              goto :eof

::  Usage  ::  func_sxp_ArgShwift   arg1   arg2   arg3   etc
rem  super basic arg parser
:func_sxp_ArgShwift
    rem  only shift when var is greater than one
    set "sxp_Key="
    set /a "sxpArg+=0"
    for /l %%L in (1,1,%sxpArg%) do shift /1
    set /a "sxpArg-=sxpArg"
    rem  out like trout
    if "%~1" equ "" ( goto :func_sxp_gtfo_plox )
    rem  define key 
    for /f "tokens=* delims=/-\" %%A in ("-%~1") do if "%~1" neq "%%~A" set "sxp_Key=%%~A"

    rem  check argParse values
    set /a "sxpArg+=1"

    rem  \\\\\\\\\\\\\\\ ///////////////
    rem       ArgParser - KeyLess
    rem  /////////////// \\\\\\\\\\\\\\\

    rem  keyless matching
    if not defined sxp_Key if "%~x1" equ "" (
        if exist "%~1" call :func_sxp_subExport "%~1"
    ) else for /f "delims=" %%X in ('dir /b /s /a:-d "%~1"') do if exist "%%~dpX" call :func_sxp_subExport "%%~dpX"

    rem  \\\\\\\\\\\\\\\ ///////////////
    rem       ArgParser - Key ONLY
    rem  /////////////// \\\\\\\\\\\\\\\

    rem  key matching
    if    "%sxp_Key%" equ "?"     call :func_sxp_ahh_helps
    if /i "%sxp_Key%" equ "h"     call :func_sxp_ahh_helps
    if /i "%sxp_Key%" equ "help"  call :func_sxp_ahh_helps

    rem  \\\\\\\\\\\\\\\ ///////////////
    rem   ArgParser - Key with Value(s)
    rem  /////////////// \\\\\\\\\\\\\\\
    if "%sxp_Key%" equ "" goto :func_sxp_ArgShwift
    if    "%~2"    equ "" goto :func_sxp_ArgShwift

    rem  note, when using parameter position 2 or higher, adjust shift accordingly
    rem  easy formula below
    rem    set /a "sxpArg+=ArgPosition - 1"

    if /i "%sxp_Key%" equ "b" (
        set /a "sxpArg+=2 - 1"
        set "sxp_ffmpeg_bin=%~2"
        call :func_sxp_errChecks    || goto :func_sxp_gtfo_plox
    )

    if /i "%sxp_Key%" equ "binary" (
        set /a "sxpArg+=2 - 1"
        set "sxp_ffmpeg_bin=%~2"
        call :func_sxp_errChecks    || goto :func_sxp_gtfo_plox
    )

    if /i "%sxp_Key%" equ "e" (
        set /a "sxpArg+=2 - 1"
        set "sxp_extensions=%~2"
        call :func_sxp_errChecks    || goto :func_sxp_gtfo_plox
    )

    if /i "%sxp_Key%" equ "extensions" (
        set /a "sxpArg+=2 - 1"
        set "sxp_extensions=%~2"
        call :func_sxp_errChecks    || goto :func_sxp_gtfo_plox
    )

    if /i "%sxp_Key%" equ "f" (
        set /a "sxpArg+=2 - 1"
        set "sxp_sub_filter=%~2"
    )

    if /i "%sxp_Key%" equ "filter" (
        set /a "sxpArg+=2 - 1"
        set "sxp_sub_filter=%~2"
    )

    if /i "%sxp_Key%" equ "d" (
        set /a "sxpArg+=2 - 1"
        call :func_sxp_subExport "%~2"
    )

    if /i "%sxp_Key%" equ "directory" (
        set /a "sxpArg+=2 - 1"
        call :func_sxp_subExport "%~2"
    )

    if /i "%sxp_Key%" equ "i" (
        set /a "sxpArg+=2 - 1"
        call :func_sxp_subExport "%~2"
    )

    if /i "%sxp_Key%" equ "input" (
        set /a "sxpArg+=2 - 1"
        call :func_sxp_subExport "%~2"
    )

    if /i "%sxp_Key%" equ "path" (
        set /a "sxpArg+=2 - 1"
        call :func_sxp_subExport "%~2"
    )

    rem  \\\\\\\\\\\\\\\ ///////////////
    rem         ArgParser - End
    rem  /////////////// \\\\\\\\\\\\\\\

goto :func_sxp_ArgShwift


::  Usage  ::  func_sxp_cleanLogs  "path\to\log\files\"
rem  removing all of the empty log files
:func_sxp_cleanLogs
    if "%~1" equ "" goto :eof
    if exist "%~1\subs.*.log" for /f "delims=" %%Z in ('
        dir /s /b /a:-d "%~1\subs.*.log"
    ') do if "%%~zZ" equ "0" (
        echo/%~nx0%~0: Info: "%%~nxZ"
        del /q "%%~Z"
    )
goto :eof


::  Usage  ::  func_sxp_cleanSubs  "path\to\sub\files\"
rem  removing all empty subtitle files
:func_sxp_cleanSubs
    if "%~1" equ "" goto :eof
    for %%X in (.srt;.ass;.vtt) do (
        for /f "delims=" %%Z in ('
            dir /s /b /a:-d "%~1\*%%X"
        ') do if "%%~zZ" equ "0" (
            echo/%~nx0%~0: Info: "%%~nxZ"
            del /q "%%~Z"
        )
    ) 2>nul
goto :eof


::  Usage  ::  func_sxp_createSubDir   "path"
:func_sxp_createSubDir
    if exist "%~1" goto :eof

    echo/|set /p "dummy=%~nx0%~0: Info: "%~1" "
    md "%~1"

    if not exist "%~1" (
        echo/Error.
        echo/
    ) else echo/Success.
    if "%~2" neq "" ( ( shift /1 ) & goto %~0 )
goto :eof


::  Usage  ::  func_sxp_createDir   "path"
:func_sxp_createDir
    if "%~1" equ "" goto :eof
    if exist "%~1"  goto :eof

    echo/|set /p "dummy=%~nx0%~0: Info: %~1 "
    md %1

    if not exist "%~1" (
        echo/Error.
        echo/
    ) else echo/Success.
    if "%~2" neq "" ( ( shift /1 ) & goto %~0 )
goto :eof


::  Usage  ::  func_sxp_errChecks
rem  returns errlvl 0 when no issues, otherwise returns errlvl 1
rem  Mainly checks for ffmpeg binary
:func_sxp_errChecks
    rem  stupid proof binary check, makes sure that the user defined binary can be executed.  Clears on error
    if defined sxp_ffmpeg_bin ((( "%sxp_ffmpeg_bin%" -version ) 2>nul | "%SystemRoot%\System32\findstr.exe" /i /c:"ffmpeg version" ) 1>nul || set "sxp_ffmpeg_bin=" )

    rem  check path for ffmpeg.exe binary, selects the first working one when multiple are found
    set "sxp_path=%~dp2;%path%"
    if not defined sxp_ffmpeg_bin for %%e in (
        .exe;%PathExt%
    ) do for %%W in (
        "ffmpeg%%e"
    ) do if "%%~$sxp_path:W" neq "" if not defined sxp_ffmpeg_bin (
        ((( "%%~$sxp_path:W" -version ) 2>nul | "%SystemRoot%\System32\findstr.exe" /i /c:"ffmpeg version" ) 1>nul && set "sxp_ffmpeg_bin=%%~$sxp_path:W")
    )
    set "sxp_path="

    rem  well, last try, check path for ffmpeg.exe binary, selects the first one
    if not defined sxp_ffmpeg_bin for /f "delims=" %%W in ('""%SystemRoot%\System32\where.exe" "ffmpeg""') do if not defined sxp_ffmpeg_bin set "sxp_ffmpeg_bin=%%~W"

    rem  create extension list filter, prefix \ and postfix $ to look like \.ext$
    set "sxp_ext_filter="
    if defined sxp_extensions for %%A in ( %sxp_extensions% ) do call set "sxp_ext_filter=%%sxp_ext_filter%%%%%%~xA "
    if not defined sxp_extensions set "sxp_ext_filter=\.mkv$ \.mp4$"
    set "sxp_ext_filter=%sxp_ext_filter:.=\.%"
    set "sxp_ext_filter=%sxp_ext_filter: =$ %"

    rem goooooooooood-byeeeeeee moon-men
    if defined sxp_ffmpeg_bin exit /b 0

    echo/%~nx0%~0: Error: Unable to proceed, ffmpeg binary cannot be located and variable ^(sxp_ffmpeg_bin^) is undefined/misdefined
    exit /b 1

goto :eof


::  Usage  ::  func_sxp_gtfo_plox
:func_sxp_gtfo_plox
    rem cleanup
    call :func_sxp_out_ofDir true
    ( for /f "tokens=1 delims==" %%A in ('set sxp') do set "%%~A="
    ) 2>nul

goto :eof


:: uses PUSHD to change the current directory
:: If param is a file, should change directory to the file's directory
:func_sxp_in_to_dir
    REM if "%*" equ "" goto :eof
    echo/%*
    pushd %*
    if "%errorlevel%" neq "0" (
        echo %~nx0%~0: Warning: errorcode [%errorlevel%]
    ) else (
        set /a "sxp_popd_me_back+=1"
        echo/%~nx0%~0: Info: %*
    )
goto :eof


::  Usage  ::  func_sxp_out_ofDir   popdBack-All-Bool
rem  When param1, pops back all tracked pushes
:func_sxp_out_ofDir
    if not defined sxp_popd_me_back ( ( set /a "sxp_popd_me_back+=0" ) & goto :eof )
    if %sxp_popd_me_back% leq 0 goto :eof

    if "%~1" equ "" (
        echo/%~nx0%~0: Info: popd
        set /a "sxp_popd_me_back-=1"
        popd
        goto :eof
    )

    for /l %%P in (%sxp_popd_me_back%,-1,1) do (
        echo/%~nx0%~0: Info: popd
        popd
    )

    set /a "sxp_popd_me_back-=sxp_popd_me_back"
    if "%sxp_popd_me_back%" equ "0" set "sxp_popd_me_back="
goto :eof


::  Usage  ::  func_sxp_subExport  "path\to\files\"
rem  recursively walk down the directory tree searching for files to process
rem    reads the language tags and creates subs based for those languages
rem    when no language tag found, uses und aka undefined as the identifier
rem    only dump attachments, fonts/etc, when there are no subs created for that specific file yet
:func_sxp_subExport
    if "%~1" equ "" goto :eof
    if not exist "%~1\*" goto :eof

    echo/%~nx0%~0: Info: Checking: "%~1"
    set "sxp_fcntr=0"
    for /f "delims=" %%R in ("%~1") do for /f "delims=" %%Z in ('
        "( dir /s /b /a:-d "%%~R" | "%SystemRoot%\System32\findstr.exe" /ir "%sxp_ext_filter%" | "%SystemRoot%\System32\findstr.exe" /irv "\.ass$ \.srt$ \.vtt$" ) 2>nul"
    ') do set /a "sxp_fcntr+=1"

    if defined sxp_fcntr if "%sxp_fcntr%" neq "0" echo/%~nx0%~0: Info: matching files found: %sxp_fcntr%
    REM echo/%~nx0%~0: Info: findstr file filter: "%sxp_ext_filter%"

    for /f "delims=" %%R in ("%~1") do for /f "delims=" %%Z in ('
        "( dir /s /b /a:-d "%%~R" | "%SystemRoot%\System32\findstr.exe" /ir "%sxp_ext_filter%" | "%SystemRoot%\System32\findstr.exe" /irv "\.ass$ \.srt$ \.vtt$" ) 2>nul"
    ') do for /f "delims=" %%Q in ('cd') do if "%%~Q" neq "%%~dpZsubs" (
        call :func_sxp_cleanLogs  "%%~dpQmeta\"
        call :func_sxp_cleanSubs  "%%~dpQsubs\"
        call :func_sxp_createSubDir  "subs" "meta"
        call :func_sxp_out_ofDir
        call :func_sxp_in_to_dir  "%%~dpZsubs\"
        call :func_sxp_subDumper  "%%~Z"
    ) else call :func_sxp_subDumper  "%%~Z"

    call :func_sxp_out_ofDir true
goto :eof


::  Usage  ::  func_sxp_subDumper  "path\to\media\file.ext"
:func_sxp_subDumper
    if "%~1" equ "" goto :eof

    for /f "delims=" %%R in ("%~1") do for /f "usebackq tokens=1-7 delims=(#) " %%A in (`
        "("%sxp_ffmpeg_bin%" -v info -vn -an -hide_banner -i "%%~R" -) 2>&1 | "%SystemRoot%\System32\findstr.exe" /c:"Subtitle:" | "%SystemRoot%\System32\findstr.exe" /vi "%sxp_sub_filter%""
    `) do if "%%~A" equ "Stream" if "%%~C" neq "" for /f "tokens=1,2 delims=:" %%K in ("%%B") do if "%%~C" neq "Subtitle:" (
        if not exist "%~nx1*" (
            echo/%~nx0%~0: Info: "%~nx1" [attachments]
            "%sxp_ffmpeg_bin%" -v quiet %sxp_ffmpeg_opt% -dump_attachment:t "" -i "%~1"
        )
        if not exist "%~nx1.%%C.%%K%%L.ass" (
            echo/%~nx0%~0: Info: "%~nx1.%%C.%%K%%L.ass"
            echo/%~nx0%~0: Info: "%~nx1.%%C.%%K%%L.srt"
            echo/%~nx0%~0: Info: "%~nx1.%%C.%%K%%L.vtt"
            ( "%sxp_ffmpeg_bin%" -v error %sxp_ffmpeg_opt% -i "%~1" -map %%B "%~nx1.%%C.%%K%%L.ass" -map %%B "%~nx1.%%C.%%K%%L.srt" -map %%B "%~nx1.%%C.%%K%%L.vtt"
            ) 2>> "%~dp1meta\subs.error.%~nx1.%%C.%%K%%L.log" 1>> "%~dp1meta\subs.%~nx1.%%C.%%K%%L.log"
        )
    ) else if not exist "%~nx1.und.%%~K%%~L.ass" (
        if not exist "%~nx1*" (
            echo/%~nx0%~0: Info: "%~nx1" [attachments]
            "%sxp_ffmpeg_bin%" -v quiet %sxp_ffmpeg_opt% -dump_attachment:t "" -i "%~1"
        )
        echo/%~nx0%~0: Info: "%~nx1.und.%%~K%%~L.ass"
        echo/%~nx0%~0: Info: "%~nx1.und.%%~K%%~L.srt"
        echo/%~nx0%~0: Info: "%~nx1.und.%%~K%%~L.vtt"
        ( "%sxp_ffmpeg_bin%" -v error %sxp_ffmpeg_opt% -i "%~1" -map %%~B "%~nx1.und.%%K%%L.ass" -map %%~B "%~nx1.und.%%K%%L.srt" -map %%~B "%~nx1.und.%%K%%L.vtt"
        ) 2>> "%~dp1meta\subs.error.%~nx1.und.%%K%%L.log" 1>> "%~dp1meta\subs.info.%~nx1.und.%%K%%L.log"
    )

goto :eof
