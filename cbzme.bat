:: By JaCk | Release 06/11/2018  |  https://github.com/1ijack/BatchMajeek/blob/master/cbzme.bat  |  https://pastebin.com/6vEQscEX  |  cbzme.bat  - Creates cbz files using the 7-zip binary
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
@echo off & setlocal EnableExtensions EnableDelayedExpansion

:: This script is based on http://alanhorkan.livejournal.com/58404.html
::  - which was based on http://aarmstrong.org/tutorials/mass-zip-rar-to-7zip-recompression-batch-file
::  -- "Mass Zip, RAR to 7Zip Recompression Batch File by Andrew Armstrong"
::
::
:: Recurses through a directory and creates cbz [Comic Book Zip] files using 7z
::
:: Directory Structure for the input
:: - C:\cbme_plox\source\Comic 123\000.jpg
:: ---- [C:\cbme_plox\source] is the base directory for [cbzme_var_source_directory]
:: ---- Note: [Comic 123] is the title of name of the Book.  This name will be used for the new cbz file like: [Comic 123.cbz]
:: ---- Note: [000.jpg] is one of the images in [Comic 123]


:::::::::::::::::::::::::::::::::::::::
::
:: User Variables (Settings)
::
:::::::::::::::::::::::::::::::::::::::
set "cbzme_var_7z_bin_full_path=.\7-Zip\7z.exe"       rem Default: [Binary Location] - This is the full path to the 7-zip binary.  http://www.7-zip.org
set "cbzme_var_source_directory=.\source"             rem Default: [NotSet]          - This is the full path to the source directory contains the sub-directories that you would like processed.  If not set, script will ask user for input.
set "cbzme_var_output_directory=.\output"             rem Default: [NotSet]          - This is the full path to the output directory with future cbz output files (if all the stars align).  If not set, script will ask user for input.


:::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::
:::: Unless you know what you're doing ::::
:::: DO NOT CHANGE BELOW               ::::
:::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::

:: Push it, push it real good
set /a "cbzme_push+=0,cbzme__dtcount=0,cbzme__dpcount=0,cbzme__fatal_flag=0,cbzme__error_count=0"
if /i "%cd%" neq "%~dp0" if exist "%~dp0" (
	pushd "%~dp0"
	set /a "cbzme_push+=1"
)

:: internal debug msgs - very few
set "cbzme__debug_flag="

:::::::::::::::::::::::::::::::::::::::
::
:: Prompts
::
:::::::::::::::::::::::::::::::::::::::
:: Checking veracity of the variable definitions
for %%A in (cbzme_var_7z_bin_full_path;cbzme_var_source_directory;cbzme_var_output_directory) do if defined %%A if not exist "!%%A!" set "%%A="

:: Querying user when required variables undefined

rem Try to locate the bin in the PATH system variable and set it as the default
rem If multiple are located, script will always choose the last one on the list

rem Ask user for input
set "cbzme__input="
if not defined cbzme_var_7z_bin_full_path for /f "delims=" %%S in ('%SystemRoot%\System32\where.exe 7z.exe') do if not defined cbzme__input set "cbzme__input=%%S"
if not defined cbzme_var_7z_bin_full_path (
    echo/
    echo/%~nx0: Input: 7z.exe binary path:
    echo/%~nx0: Input: 7z: Default: ["%cbzme__input%"]
    set /p "cbzme__input=: "
    echo/
)
if not defined cbzme_var_7z_bin_full_path set "cbzme_var_7z_bin_full_path=%cbzme__input%"


set "cbzme__input=%~dp0"
if not defined cbzme_var_source_directory (
    echo/
    echo/%~nx0: Input: Source: Please Enter the full INPUT directory path containing the sub-directories to be processed.
    echo/%~nx0: Input: Source: Default: ["%cbzme__input%"]
    set /p "cbzme__input=: "
    echo/
)
if not defined cbzme_var_source_directory set "cbzme_var_source_directory=%cbzme__input%"


if not defined cbzme_var_source_directory (
    set "cbzme__input=%~dp0\output"
) else (
    set "cbzme__input=%cbzme_var_source_directory%\output"
)
if not defined cbzme_var_output_directory (
    echo/
    echo/%~nx0: Input: Output Path: Please Enter the full directory OUTPUT path for the new cbz files
    echo/%~nx0: Input: Output Path: Default: [%cbzme__input%]
    set /p "cbzme__input=: "
    echo/
)
if not defined cbzme_var_output_directory set "cbzme_var_output_directory=%cbzme__input%"


:: I need cleansing
:: - forgive me father for I have been used, multiple times on multiple occasions and as a temporary placeholder...
set "cbzme__input="


:::::::::::::::::::::::::::::::::::::::
::
:: Basic Error Checking
::
:::::::::::::::::::::::::::::::::::::::

if not exist "%cbzme_var_7z_bin_full_path%" (
    echo/
    echo/%~nx0: Error: Fatal: Unable to access 7z.exe: "%cbzme_var_7z_bin_full_path%"
    echo/
    set /a "cbzme__fatal_flag+=1"
)


if not exist "%cbzme_var_source_directory%" (
    echo/
    echo/%~nx0: Error: Fatal: Unable to access source directory: "%cbzme_var_source_directory%"
    echo/
    set /a "cbzme__fatal_flag+=1"
)


if %cbzme__fatal_flag% gtr 0 (
    echo/
    echo/%~nx0: Info: Encountered Fatals - [%cbzme__fatal_flag%]
    echo/%~nx0: Info: Exiting...
    echo/
    goto :gtfo
)

:: only attempt to create directory when no errors found

if not exist "%cbzme_var_output_directory%" (
    echo/
    echo/%~nx0: Info: Output Dir: directory does not exist, Creating...
    mkdir "%cbzme_var_output_directory%"
)
if not exist "%cbzme_var_output_directory%" (
    echo/
    echo/%~nx0: Error: Output directory: Failed to create: "%cbzme_var_output_directory%"
    echo/%~nx0: Info: Continuing...
    echo/
)


:::::::::::::::::::::::::::::::::::::::
::
:: Main
::
:::::::::::::::::::::::::::::::::::::::

rem Setting default string before all the magic
((set "cbzme__d=%date:* =%") &set "cbzme__t=%time:~0,-3%")
set "cbzme__time_string=%cbzme__d:/=.%-%cbzme__t::=.%"
set "cbzme__time_string=%cbzme__time_string: =%"

:: Grab a quick total count
( for /f "tokens=1* delims=" %%D in ('
        dir /b /o:-n /a:d "%cbzme_var_source_directory%"
') do set /a "cbzme__dtcount+=1" ) 2>nul


:: Give a pretty message or exit script
if %cbzme__dtcount%. lss 1. (
    set /a "cbzme__fatal_flag+=1"
    echo/%~nx0: Error: Fatal: Cbz process failed: no subdirectories in: "%cbzme_var_source_directory%"
    goto :gtfo
)
echo/%~nx0: Info: Cbz: Total Directories to Process [%cbzme__dtcount%]
echo/


:: Recurse through source directory and create cbz files in the output directory
:: files named [z*.*] and [Thumbs.db] will automaticlly be ignored and NOT added into the new cbz file
for /f "tokens=1* delims=" %%D in ('
        dir /b /o:-n /a:d "%cbzme_var_source_directory%"
') do (
    rem Assign me to my var plx
        set /a "cbzme__dpcount+=1"

    rem set the title and print message to console
        title %~0: Processing [!cbzme__dpcount!/%cbzme__dtcount%] - "%%D.cbz"
        echo/
        echo/ ========================================
        echo/
        echo/%~nx0: Info: Cbz: Processing [!cbzme__dpcount!/%cbzme__dtcount%] - "%%D.cbz"

    rem call the binary with all the parameters
        if defined cbzme__debug_flag echo call "%cbzme_var_7z_bin_full_path%" a -tzip "%cbzme_var_output_directory%\%%D.cbz" -mx=0 '-x^^!Thumbs.db*' "%cbzme_var_source_directory%\%%D"

        rem call "%cbzme_var_7z_bin_full_path%" a -tzip "%cbzme_var_output_directory%\%%D.cbz" -mx=0 '-x^^!Thumbs.db*' '-x^^!z*.*' "%cbzme_var_source_directory%\%%D"
        ( 2>> "%cbzme_var_output_directory%\cbz_7z_errors.%cbzme__time_string%.log" call "%cbzme_var_7z_bin_full_path%" a -tzip "%cbzme_var_output_directory%\%%D.cbz" -mx=0 '-x^^!Thumbs.db*' "%cbzme_var_source_directory%\%%D"
        ) || (
            rem check if bin exited cleanly
            echo/%~nx0: Error: Cbz: 7z: Encountered unknown errors or warnings while creating ["%cbzme_var_output_directory%\%%D.cbz"]
            echo/%~nx0: Error: Cbz: 7z: Encountered unknown errors or warnings while creating ["%cbzme_var_output_directory%\%%D.cbz"] 1>&2>> "%cbzme_var_output_directory%\cbz_7z_errors.%cbzme__time_string%.log"
            echo/
            set /a "cbzme__error_count+=1"
            if defined cbzme__debug_flag timeout /t 3
        )
        echo/
        echo/ ========================================
        echo/
    rem if defined cbzme__debug_flag goto :gtfo
)
echo/

:: Checking if the error log contains anything, if not, then we delete it
for %%A in ("%cbzme_var_output_directory%\cbz_7z_errors.%cbzme__time_string%.log") do if %%~zA. gtr 0. del /q "%cbzme_var_output_directory%\cbz_7z_errors.%cbzme__time_string%.log"


:::::::::::::::::::::::::::::::::::::::
::
:: Fin-laund
::       git-it... FIN... LAUND... HAHA
::        not funny, alt-f4 yourself...
::
:::::::::::::::::::::::::::::::::::::::

if %cbzme__error_count% gtr 0 (
    echo/%~nx0: Error: Warning: Cbz: 7z encountered [%cbzme__error_count%] errors or warnings
    echo/%~nx0: Error: Warning: Cbz: Please Check "%cbzme_var_output_directory%\cbz_7z_errors.%cbzme__time_string%.log" for details
    echo/
)


:gtfo
rem Gotta clean after me-self and the kitchen-sync [-.*]
for /l %%P in (1,1,%cbzme_push%) do popd
set "cbzme_push="
set /a "erlvl=!!(cbzme__error_count)"
for /f "tokens=1 delims==" %%V in ('set cbzme_') do set "%%V="
timeout /t 30 & (((endlocal) & set "erlvl=") &exit /b %erlvl%)
