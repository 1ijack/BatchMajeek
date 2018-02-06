:::  By JaCk | Release 12/03/2017 | raw2res.bat  --  Uses ffmpeg to create predetermined sets of resized images from a list of source directories.  Works best when raws are larger than the images to be created.  Does not check image size atm.
@echo off & setlocal DisableDelayedExpansion

pushd "%~dp0"
::: User Settings
set "list_source_dirs=".\raw\";"
set "list_height_pixels=240 ; 320 ; 360 ; 480 ; 560 ; 720 ; 1080 ; 1440"
set "ffmpeg_bin=ffmpeg.exe"


::: Loop-de-loop-fun
for %%S in (%list_source_dirs%) do if "%%~S" neq "" if not exist "%%~S" (
    echo/Warning: Unable to locate source directory "%%~S"
) else for %%D in (%list_height_pixels%) do (
    if not exist ".\%%~Dp" (
        echo/
        echo/Info: Creating Directory: ".\%%~Dp"
        mkdir ".\%%~Dp" 1>nul
    ) else echo/&echo/Info: Checking Directory: ".\%%~Dp"

    for /f "tokens=* delims=" %%A in ('dir /b /a:-d "%%~S"') do if exist ".\%%~Dp\%%~nA_%%~Dp%%~xA" (
        rem don't do a dam thing or say 
        REM echo Info: File Already exists, skipping ".\%%~Dp\%%~nA_%%~Dp%%~xA"
    ) else ( 
        echo Info: New file: ".\%%~Dp\%%~nA_%%~Dp%%~xA" 
        "%ffmpeg_bin%" -v error -i "%%~S\%%~A" -vf "scale=-1:%%~D" ".\%%~Dp\%%~nA_%%~Dp%%~xA"
    )
)

::: dddddddddone
popd