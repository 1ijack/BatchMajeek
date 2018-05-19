::  By JaCk  |  Release 05/18/2018  |  url  |  subExport.bat  --  Export all text subtitles and font attachments from mkv containers depending on subtitle language id
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
@echo off & setlocal DisableDelayedExpansion EnableExtensions & (for %%A in (sxp_ffmpeg_bin;sxp_ffmpeg_opt) do set "%%A=") & goto :func_sxp_main

:::::::::::::::::::::::::::::::::::::::
::                                   ::
::           User Settings           ::
::                                   ::
:::::::::::::::::::::::::::::::::::::::
:func_sxp_user_settings
    ::  ffmpeg binary path and options
    set "sxp_ffmpeg_bin=%ProgramData%\chocolatey\bin\ffmpeg.exe"
    set "sxp_ffmpeg_opt=-n -hide_banner -v info -vn -an"

    REM set "sxp_skip_helps=true"
    set "sxp_skip_helps="
goto :eof


:::::::::::::::::::::::::::::::::::::::
::                                   ::
::      --       Helps       --      ::
::                                   ::
:::::::::::::::::::::::::::::::::::::::
:func_sxp_a_helps
    echo/ _______________________________________
    echo/
    echo/  Usage:  %~nx0  ["Path to process"]
    echo/  
    echo/  Accepts One parameter: path containing files
    echo/  
    echo/  When no parameters are passed into the script:
    echo/    Uses the [current directory]: "%cd%"
    echo/    Or when in ["%SystemRoot%\System32%"],
    echo/      Uses [script directory]: "%~dp0"
    echo/  
    echo/  Please note, for now, this script loosely checks whether the subs 
    echo/    are text or image.  Therefore, script always assumes text unless:
    echo/    stream label: 'dvd_subtitle'
    echo/
    echo/  Please note, for now, when the media container contains multiple subs 
    echo/    of the same langauge, script ONLY pulls the first sub text stream 
    echo/    for that language and ignores the rest.
    echo/
    echo/  Directories:
    echo/    Subtitle files always go to the relative subdirectory ".\subs\" 
    echo/    ffmpeg log files always go to the relative subdirectory ".\meta\" 
    echo/  
    echo/  Creates the following subtitle files for each unique text stream:
    echo/    .srt, .ass, .vtt
    echo/  
    echo/  Output filename scheme: 
    echo/    w/  lang: [media file name].[extension].[lang].[sub extension]
    echo/    w/o lang: [media file name].[extension].und.[streamID].[sub extension]
    echo/ _______________________________________
    echo/
goto :eof

:::::::::::::::::::::::::::::::::::::::
::                                   ::
::               Main                ::
::                                   ::
:::::::::::::::::::::::::::::::::::::::
:func_sxp_main
    ::  clear any pop flags before starting export
    call :func_sxp_user_settings
    call :func_sxp_error_check
    call :func_sxp_outdir

    ::  use params as input path OR use the current directory path
    if  "%~1" equ "" (
        if not defined sxp_skip_helps call :func_sxp_a_helps
        if "%cd%" equ "%SystemRoot%\System32" (
            call :func_sxp_subExport "%~dp0"
        ) else (
            call :func_sxp_subExport "%cd%"
        )
    ) else if "%~x1" equ "" ( if exist "%~1" call :func_sxp_subExport "%~1"
    ) else for /f "delims=" %%X in ('dir /b /s /a:-d "%~1"') do if exist "%%~dpX" call :func_sxp_subExport "%%~dpX"
    
    :: out like trout
    goto :func_sxp_gtfo
    
goto :eof


:::::::::::::::::::::::::::::::::::::::
::                                   ::
::             Functions             ::
::                                   ::
:::::::::::::::::::::::::::::::::::::::
                              goto :eof

::  Usage  ::  func_sxp_create_dir   "path"
:func_sxp_create_dir
    if "%~1" equ "" goto :eof
    if exist "%~1"  goto :eof

    echo/|set /p "dummy=Info: CreateDir: Creating Dir: %~1 "
    md "%~1"

    if "%errorlevel%" neq "0" if not exist "%~1" echo Error: CreateDir: Unable to Create: "%~1"
goto :eof


::  Usage  ::  func_sxp_error_check
rem  returns errlvl 0 when no issues, otherwise returns errlvl 1
rem  Mainly checks for ffmpeg binary 
:func_sxp_error_check
    ::  stupid proof binary check, makes sure that the user defined binary can be executed.  Clears on error
    if defined sxp_ffmpeg_bin ((( "%sxp_ffmpeg_bin%" -version ) 2>nul | "%SystemRoot%\System32\findstr" /i /c:"ffmpeg version" ) 1>nul || set "sxp_ffmpeg_bin=" )

    ::  check path for ffmpeg.exe binary, selects the first working one when multiple are found
    if not defined sxp_ffmpeg_bin for %%e in (
        .exe;%PathExt%
    ) do for %%W in ( 
        "ffmpeg%%e"
    ) do if "%%~$sxp_path:W" neq "" if not defined sxp_ffmpeg_bin (
        ((( "%%~$sxp_path:W" -version ) 2>nul | "%SystemRoot%\System32\findstr" /i /c:"ffmpeg version" ) 1>nul && set "sxp_ffmpeg_bin=%%~$sxp_path:W")
    )

    ::  well, last try, check path for ffmpeg.exe binary, selects the first one
    if not defined sxp_ffmpeg_bin for /f "delims=" %%W in ('""%SystemRoot%\System32\where.exe" "ffmpeg""') do if not defined sxp_ffmpeg_bin set "sxp_ffmpeg_bin=%%~W"

    :: good-bye moon-men
    if defined sxp_ffmpeg_bin exit /b 0

    echo/%~nx0: Error: Init: Unable to proceed, ffmpeg binary cannot be located and variable ^(sxp_ffmpeg_bin^) is undefined/misdefined
    exit /b 1

goto :eof


::  Usage  ::  func_sxp_gtfo
:func_sxp_gtfo
    :: cleanup
    call :func_sxp_outdir "%cd%"
    set "sxp_ffmpeg_bin="
    set "sxp_ffmpeg_opt="

goto :eof


:: uses PUSHD to change the current directory
:: If param is a file, should change directory to the file's directory
:func_sxp_indir
    if "%~1" equ "" goto :eof
    pushd "%~1"
    if "%errorlevel%" neq "0" (
        echo %~nx0 %~0: Warning: Pushd: Dirty errorcode [%errorlevel%]
    ) else (
        set /a "sxp_popd_me_back+=1"
        echo/%~nx0: Info: %~0: pushd: "%~1"
    )
goto :eof


::  Usage  ::  func_sxp_outdir   popdBack-All-Bool
rem  When param1, pops back all tracked pushes
:func_sxp_outdir
    if not defined sxp_popd_me_back ( ( set "sxp_popd_me_back=0" ) & goto :eof )
    if not %sxp_popd_me_back% gtr 0 goto :eof
    if "%~1" equ "" (
        echo/%~nx0: Info: %~0: popd
        set /a "sxp_popd_me_back-=1"
        popd
    ) else for /l %%P in (%sxp_popd_me_back%,-1,1) do (
        echo/%~nx0: Info: %~0: popd
        set /a "sxp_popd_me_back-=1"
        popd
    )
    if "%sxp_popd_me_back%" equ "0" set "xp_popd_me_back="
goto :eof



:func_sxp_subExport
    if "%~1" equ "" goto :eof
    if not exist "%~1\*.mkv" goto :eof

    echo/%~nx0: Info: %~0: Checking: "%~1"

    if not exist "%~1\subs\" call :func_sxp_create_dir "%~1\subs\"

    call :func_sxp_indir "%~1\subs\"

    rem  reads the language tags and creates subs based for those languages
    rem  only dump attachments, fonts/etc, when there are no subs created for that specific file yet
    for /f "delims=" %%Z in ('dir /s /b /a:-d "%~1\*.mkv"') do for /f "usebackq tokens=1-7 delims=(#) " %%A in (`
        "("%sxp_ffmpeg_bin%" -hide_banner -vn -an -i "%%~Z" -) 2>&1"
    `) do if "%%~A" equ "Stream" if "%%~E" equ "Subtitle:" if "%%~C" neq "" if "%%~C" neq "Subtitle:" (
        if not exist "%%~nxZ.%%~C.ass" (
            if not exist "%%~nxZ.%%~C.srt" (
                if not exist "%%~nxZ.%%~C.vtt" ( 
                    echo/%~nx0: Info: %~0: Export %%~C .srt;.ass;.vtt: "%%~nxZ"
                    ( "%sxp_ffmpeg_bin%" %sxp_ffmpeg_opt% -dump_attachment:t "" -i "%%~Z"
                    ) 2>nul
                    ( "%sxp_ffmpeg_bin%" %sxp_ffmpeg_opt% -i "%%~Z" -map %%~B "%%~nxZ.%%~C.ass" -map %%~B "%%~nxZ.%%~C.srt" -map %%~B "%%~nxZ.%%~C.vtt"
                    ) 2>> "%~1\meta\subs.error.%%~nxZ.%%~C.log" 1>> "%~1\meta\subs.export.%%~nxZ.%%~C.log"
                )
            ) else if not exist "%%~nxZ.%%~C.vtt" ( 
                echo/%~nx0: Info: %~0: Export %%~C .vtt: "%%~nxZ"
                ( "%sxp_ffmpeg_bin%" %sxp_ffmpeg_opt% -i "%%~Z" -map %%~B "%%~nxZ.%%~C.vtt"
                ) 2>> "%~1\meta\subs.error.%%~nxZ.%%~C.log" 1>> "%~1\meta\subs.export.%%~nxZ.%%~C.log"
            )
        ) else (
            if not exist "%%~nxZ.%%~C.srt" ( 
                echo/%~nx0: Info: %~0: Export %%~C .srt: "%%~nxZ"
                ( "%sxp_ffmpeg_bin%" %sxp_ffmpeg_opt% -i "%%~Z" -map %%~B "%%~nxZ.%%~C.srt"
                ) 2>> "%~1\meta\subs.error.%%~nxZ.%%~C.log" 1>> "%~1\meta\subs.export.%%~nxZ.%%~C.log"
            )
            if not exist "%%~nxZ.%%~C.vtt" ( 
                echo/%~nx0: Info: %~0: Export %%~C .vtt: "%%~nxZ"
                ( "%sxp_ffmpeg_bin%" %sxp_ffmpeg_opt% -i "%%~Z" -map %%~B "%%~nxZ.%%~C.vtt"
                ) 2>> "%~1\meta\subs.error.%%~nxZ.%%~C.log" 1>> "%~1\meta\subs.export.%%~nxZ.%%~C.log"
            )
        )
    ) else for /f "tokens=1,2 delims=:" %%K in ("%%B") do (
        if not exist "%%~nxZ.und.%%~K%%~L.ass" (
            if not exist "%%~nxZ.und.%%~K%%~L.srt" (
                if not exist "%%~nxZ.und.%%~K%%~L.vtt" ( 
                    echo/%~nx0: Info: %~0: Export und.%%~K%%~L .srt;.ass;.vtt: "%%~nxZ"
                    ( "%sxp_ffmpeg_bin%" %sxp_ffmpeg_opt% -dump_attachment:t "" -i "%%~Z"
                    ) 2>nul
                    ( "%sxp_ffmpeg_bin%" %sxp_ffmpeg_opt% -i "%%~Z" -map %%~B "%%~nxZ.und.%%~K%%~L.ass" -map %%~B "%%~nxZ.und.%%~K%%~L.srt" -map %%~B "%%~nxZ.und.%%~K%%~L.vtt"
                    ) 2>> "%~1\meta\subs.error.%%~nxZ.und.%%~K%%~L.log" 1>> "%~1\meta\subs.export.%%~nxZ.und.%%~K%%~L.log"
                )
            ) else if not exist "%%~nxZ.und.%%~K%%~L.vtt" ( 
                echo/%~nx0: Info: %~0: Export und.%%~K%%~L .vtt: "%%~nxZ"
                ( "%sxp_ffmpeg_bin%" %sxp_ffmpeg_opt% -i "%%~Z" -map %%~B "%%~nxZ.und.%%~K%%~L.vtt"
                ) 2>> "%~1\meta\subs.error.%%~nxZ.und.%%~K%%~L.log" 1>> "%~1\meta\subs.export.%%~nxZ.und.%%~K%%~L.log"
            )
        ) else (
            if not exist "%%~nxZ.und.%%~K%%~L.srt" ( 
                echo/%~nx0: Info: %~0: Export und.%%~K%%~L .srt: "%%~nxZ"
                ( "%sxp_ffmpeg_bin%" %sxp_ffmpeg_opt% -i "%%~Z" -map %%~B "%%~nxZ.und.%%~K%%~L.srt"
                ) 2>> "%~1\meta\subs.error.%%~nxZ.und.%%~K%%~L.log" 1>> "%~1\meta\subs.export.%%~nxZ.und.%%~K%%~L.log"
            )
            if not exist "%%~nxZ.und.%%~K%%~L.vtt" ( 
                echo/%~nx0: Info: %~0: Export und.%%~K%%~L .vtt: "%%~nxZ"
                ( "%sxp_ffmpeg_bin%" %sxp_ffmpeg_opt% -i "%%~Z" -map %%~B "%%~nxZ.und.%%~K%%~L.vtt"
                ) 2>> "%~1\meta\subs.error.%%~nxZ.und.%%~K%%~L.log" 1>> "%~1\meta\subs.export.%%~nxZ.und.%%~K%%~L.log"
            )
        )
    )

    
    rem  removing all empty subtitle files
    ( 
        for /f "delims=" %%Z in ('
            dir /s /b /a:-d "%~1\subs\*.srt" "%~1\subs\*.ass" "%~1\subs\*.vtt" 
        ') do if "%%~zZ" equ "0" (
            echo/%~nx0: Info: %~0: Empty Cleanup: "%%~nxZ"
            del /q "%%~Z"
        )
    ) 2>nul

    rem  removing all of the empty log files
    if exist "%~1\meta\subs.*.log" for /f "delims=" %%Z in ('
        dir /s /b /a:-d "%~1\meta\subs.*.log"
    ') do if "%%~zZ" equ "0" (
        echo/%~nx0: Info: %~0: Empty Cleanup: "%%~nxZ"
        del /q "%%~Z"
    )

    call :func_sxp_outdir

goto :eof


:::::::::::::::::::::::::::::::::::::::
::                                   ::
::     disFunctional Graveyard       ::
::                                   ::
:::::::::::::::::::::::::::::::::::::::

::  Usage  ::  func_sxp_where_binary  returnVar  "binaryName.extension"   
:func_sxp_where_binary
    if "%~2" equ "" goto :eof
    if "%~1" equ "" goto :eof
    
    set sxp_path=%~dp2;%path%
    set "%~1="

    for %%e in (%~x2;%PathExt%) do for %%i in ("%~n2%%e") do if not "%%~$sxp_path:i" equ "" if not defined %~1 call :func_sxp_vercheck   "%~1"   "%%~$Path:i"  "ffmpeg version"
    set "sxp_path="
goto :eof


::  Usage  ::  func_sxp_vercheck  returnVar   "path\binary.ext"  "unique expected response"
:func_sxp_vercheck
    if "%~2" equ "" goto :eof
    if "%~1" equ "" goto :eof
    if not defined %~1 ((( "%~2" -version ) 2>nul | "%SystemRoot%\System32\findstr.exe" /i /c:"%~3" ) 1>nul || set "%~1=" )
    
goto :eof
