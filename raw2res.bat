::  By JaCk  |  Release 02/05/2017  |  https://github.com/1ijack/BatchMajeek/blob/master/raw2res.bat  |  raw2res.bat  --  Uses ffmpeg to create predetermined sets of resized images from a list of source directories.  Works best when raws are larger than the images to be created.  Does not check image size atm.  I use this to pre-create MPC-HC backgrounds in all Height varities.
@echo off & setlocal DisableDelayedExpansion EnableExtensions

:::  User Settings                   ::
set "r2r_list_source_dirs=".\raw\";"
set "r2r_list_height_pixels=240 ; 320 ; 360 ; 480 ; 560 ; 720 ; 1080 ; 1440"
set "r2r_ffmpeg_bin=ffmpeg.exe"

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:::  Dae - Script - Hae              ::

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:::  Perror-Checqing                 ::
call :func_r2r_perror_errorp  r2r_2r2_r2r
if "1%r2r_2r2_r2r%" gtr "10" goto :eof

::: Make'n paint-kin -- Resizing Images
call :func_r2r_looped_deloop_ded

:::  dddddddddone  ::  sssssssssonn  ::
for %%V in ( r2r_list_source_dirs r2r_list_height_pixels r2r_ffmpeg_bin  r2r_8O08 ) do set "%%~V="
endlocal
goto :eof
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::               ::::::::::::::::::::::::::
:::       Bunctions                  
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

::  Usage  ::  func_r2r_dir_me  "path\"
:func_r2r_dir_me
    if "%~1" equ "" goto :eof
    set "r2r_ata=%~a1"
    if "%r2r_ata:~1,1%" equ "d" if exist "%~1" set "r2r_ata=" & goto :eof
    
    echo/| set /p "radoofoobar=Info: Creating Directory: ".\%~1" "
    mkdir ".\%~1"
goto :eof


::  Usage  ::  func_r2r_efefem_me  "path\inputFile.ext"   "baseheight"  "path\outputFile.ext"
:func_r2r_efefem_me 
    if "%~3" equ "" goto :eof
    if "%~2" equ "" goto :eof
    if "%~1" equ "" goto :eof
    echo/| set /p "radoofoobar=Info: Creating: "%~3" "
    "%r2r_ffmpeg_bin%" -v error -i "%~1" -vf "scale=-1:%~2" "%~3"
    echo/Done.

goto :eof
    REM echo Info: New file: ".\%%~Dp\%%~nA_%%~Dp%%~xA" 
    REM "%r2r_ffmpeg_bin%" -v error -i "%%~S\%%~A" -vf "scale=-1:%%~D" ".\%%~Dp\%%~nA_%%~Dp%%~xA"

    
::  Usage  ::  func_r2r_looped_deloop_ded   
:func_r2r_looped_deloop_ded
    
    for %%S in (
        %r2r_list_source_dirs%
    ) do if "%%~S" neq "" if not exist "%%~S" ( echo/Warning: Unable to locate source directory "%%~S" ) else for %%D in (%r2r_list_height_pixels%) do ( 
        rem  Checks/Makes Dirs
        echo/&echo/Info: Checking Directory: ".\%%~Dp"
        if not exist ".\%%~Dp" call :func_r2r_dir_me ".\%%~Dp"

        rem  walking down 1 path
        for /f "tokens=* delims=" %%A in ('dir /b /a:-d "%%~S"') do if not exist ".\%%~Dp\%%~nA_%%~Dp%%~xA" ( 
            if not defined r2r_ffmpeg_bin ( echo/Error: Hidden: Well this awkard... not sure what yo sae
            ) else call :func_r2r_efefem_me   "%%~S\%%~A"   "%%~D"   ".\%%~Dp\%%~nA_%%~Dp%%~xA"
        ) else rem don't say or do a dam thing  ... echo Info: File Already exists, skipping ".\%%~Dp\%%~nA_%%~Dp%%~xA"
    )
    
goto :eof


::  Usage  ::  func_r2r_perror_errorp   returnVar
:func_r2r_perror_errorp
    if "%~1" equ "" call %~0 r2r_air_roar &goto :eof
    set "%~1="

    if not defined r2r_list_source_dirs set "r2r_list_source_dirs="%cd%"; "
    if not defined r2r_list_height_pixels set "r2r_list_height_pixels= 320 ; 360 ; 480 ; 720 "
    call :func_r2r_whereForFile  "r2r_ffmpeg_bin" "%r2r_ffmpeg_bin%"
    
    for %%V in (r2r_list_source_dirs r2r_list_height_pixels r2r_ffmpeg_bin) do if not defined %%~V (
        echo/Error: Fatal: Setting Undefined: %%~V 
        set /a "%~1+=1"
    ) 1>&2
   
goto :eof

::  Usage  ::  func_r2r_whereForFile  returnVar   "FileOrBinaryName" 
rem  returns param1 set to found path. Uses pure batch method to locate the binary in param2
:func_r2r_whereForFile
    if "%~2" equ "" goto :eof
    if "%~1" equ "" goto :eof
    
    if "%~2" neq "" set "r2r_8O08=%~dp2;%cd%;%PATH%"
    set "%~1="
    
    rem  Search PATH/CD using the extensionlist ( and fileExt when provided ) for the desired file
    for %%P in ( "%~2" ) do for %%e in ( %~x2 ; %PATHEXT% ) do for %%i in ( "%%~nP%%e" ) do if not "%%~$r2r_8O08:i" equ "" set "%~1=%%~$r2r_8O08:i"
    set "r2r_8O08="

goto :eof

