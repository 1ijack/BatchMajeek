::  By JaCk  |  Release 03/31/2018  |  https://github.com/1ijack/BatchMajeek/blob/master/RemoveEmpties.bat   |  RemoveEmpties.bat --  Remove all empty directories in the temp or specified directory
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
@echo off & setlocal DisableDelayedExpansion EnableExtensions & ( for %%A in ( zk_ #func_zk_ ) do ( for /f "tokens=1 delims==" %%C in ('set %%~A') do set "%%~C=" ) 2>nul 1>nul ) & goto :func_mein

:::::::::::::::::::::::::::::::::::::::
::                                   ::
::        User/Script Settings       ::
::                                   ::
:::::::::::::::::::::::::::::::::::::::
:func_zk_user_script_settings
    rem  default path list when called without args; separate with white-spaces, double-quote paths as needed
    set "zk_default_path_list="%temp%""

    rem  set to 'true' if you want script to print: which directory is being checked, which file/subdir is being removed, and post removal summary counts
    rem  when NOT 'true', script is silent; except help dump
    set "zk_print_script_msgs=true"

goto :eof

:::::::::::::::::::::::::::::::::::::::
::                                   ::
::                Main               ::
::                                   ::
:::::::::::::::::::::::::::::::::::::::
:func_mein
    call :func_zk_user_script_settings

    set "zk_print_script_msgs=%zk_print_script_msgs%false"
    if /i "%zk_print_script_msgs:~0,1%" neq "t" set "zk_print_script_msgs="

    rem  if path is passed into the arglist use that  ::  defaults to %temp% when no args
    if "%~1%~2%~3" neq "" (
           goto :func_zk_arg_shifter
    ) else call :func_zk_arg_shifter   %zk_default_path_list%

    rem  leave script
    goto :func_zk_zend

goto :eof

:::::::::::::::::::::::::::::::::::::::
::                                   ::
::             Functions             ::
::                                   ::
:::::::::::::::::::::::::::::::::::::::
                              goto :eof

::  Usage  ::  func_zk_arg_shifter
rem  shift through all the args
:func_zk_arg_shifter
    set "#func_zk_arg_shifter{One}=%~1"
    if not defined #func_zk_arg_shifter{One} goto :func_zk_zend
    set /a "zk_param_count+=1"

    rem  cannot be empty; sets to white-space when empty
    set "#func_zk_arg_shifter{One{a}}=%~a1 "
    if /i "%#func_zk_arg_shifter{One{a}}:~0,1%" neq "d" set "#func_zk_arg_shifter{One{a}}="
    
    rem  checks accessible/existing directories only;  rem shift early since param is still set to var;  rem  when last args was a path, loop back early
    if defined #func_zk_arg_shifter{One{a}} call :func_zk_remove_empties   %1
    shift /1
    if defined #func_zk_arg_shifter{One{a}} goto :func_zk_arg_shifter

    rem  non-path arg parser; WA to keep '?' out of the forf loop below
    if    "%#func_zk_arg_shifter{One}:~1%"   equ "?" set "#func_zk_arg_shifter{One}=-h"
    if    "%#func_zk_arg_shifter{One}:~2%"   equ "?" set "#func_zk_arg_shifter{One}=--help"

    for /f "tokens=* delims=+-/" %%X in ("-%#func_zk_arg_shifter{One}%") do (
        rem  Help arg parsing
        if /i "%%~X"  equ  "help"  call :func_zk_dump_help
        if /i "%%~X"  equ   "h"    call :func_zk_dump_help

        rem  Silent arg parsing, when silent is passed in and it's the ONLY arg, use default path list
        if /i "%%~X"  equ "silent" call :func_zk_daFifth    zk_print_script_msgs  %1
        if /i "%%~X"  equ   "s"    call :func_zk_daFifth    zk_print_script_msgs  %1
    )

goto :func_zk_arg_shifter


::  Usage  ::  func_zk_dump_help
rem  Prints Help message to standard out
:func_zk_dump_help
    echo/ %~nx0: remove empty files/subdirectories (non-recursive) from specified path(s)
    echo/
    echo/ Usage: %~nx0 [ -h^| --help^| /?^| --silent^| -s^| "[path1]"]  "[path2]"  "[path3]"  [etc]
    echo/
    echo/ Argless Usage, defaults to:
    echo/   %~nx0  %zk_default_path_list%
    goto :eof


::  Usage  ::  func_zk_daFifth   returnVar  nextArg
rem  Helper function of func_zk_arg_shifter to process 'silent' argument switches
:func_zk_daFifth
    if "%~1" equ "" goto :eof
    set "%~1="
    if "%~2" neq "" goto :eof

    rem  when param counter is '1', use default path list
    if %zk_param_count%. equ 1. call :func_zk_arg_shifter %zk_default_path_list%
    goto :eof


::  Usage  ::  func_zk_remove_empties  directoryPath
rem  Remove Empty files/directories
:func_zk_remove_empties
    if "%~a1" equ "" goto :eof

    set /a "zk_empty_file_count=0,zk_empty_dir_count=0"

    pushd "%~1"
    if defined zk_print_script_msgs echo/Info: Checking: "%~1"
    2>nul call :func_zk_remove_empty_directories   "%~1"
    2>nul call :func_zk_remove_empty_files         "%~1"
    popd

    if not defined zk_print_script_msgs goto :eof

    echo/Info: Remove Count Summary:
    echo/   %zk_empty_dir_count% Dir(s)
    echo/   %zk_empty_file_count% File(s)

    goto :eof


::  Usage  ::  func_zk_remove_empty_directories  directoryPath
rem  Recurse through a directory and remove all empty subdirectories
:func_zk_remove_empty_directories
    if "%~a1" equ "" goto :eof

    for /f "tokens=* delims=" %%g in ('dir /b /a:d "%~1\"') do for /f "tokens=1-4 delims= " %%A in ('dir /a "%~1\%%~g"') do if "%%~D" equ "bytes" if "%%~B" equ "File(s)" if %%~A. equ 0. for /f "tokens=1-4 delims= " %%E in ('dir /a "%~1\%%~g"') do if "%%~H" equ "bytes" if "%%~F" equ "Dir(s)" if %%~E. equ 2. (
        set /a "zk_empty_dir_count+=1"
        if defined zk_print_script_msgs echo/Removing Empty Directory: "%%~g"
        2>nul 1>nul rmdir /q "%~1\%%~g"
    )
    goto :eof


::  Usage  ::  func_zk_remove_empty_files  directoryPath
rem  Recurse through a directory and remove all empty subdirectories
:func_zk_remove_empty_files
    if "%~a1" equ "" goto :eof

    for /f "tokens=* delims=" %%g in ('dir /b /a:-d "%~1\"') do if %%~zg. equ 0. (
        set /a "zk_empty_file_count+=1"
        if defined zk_print_script_msgs echo/Removing Empty File: "%%~g"
        2>nul 1>nul del /q "%~1\%%~g"
    )
    goto :eof


::  Usage  ::  func_zk_zend
rem  Cleanup env, to be used as a 'goto' label
:func_zk_zend
    for %%A in ( zk_ #func_zk_ ) do (
        for /f "tokens=1 delims==" %%C in ('set %%~A') do set "%%~C="
    ) 2>nul 1>nul
    endlocal
    goto :eof
