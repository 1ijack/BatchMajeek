::  By JaCk  |  Release 08/11/2018  |  Source  https://github.com/1ijack/BatchMajeek/blob/master/RemoveEmpties.bat   |  RemoveEmpties.bat --  Remove all empty directories in the temp or specified directory
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

    rem boolean settings - Console message
    rem   ~ set to 'true' if you want script to print
    rem   ~ when 'false'/undefined, script is silent -  except help dump
    set "zk_print_del_msgs=true"       rem which file/dir is being removed
    set "zk_print_info_msgs=true"      rem which directory is being checked
    set "zk_print_summary_msgs=true"   rem post file/directory removal summary counts

    rem boolean settings - Directory Recurstion
    rem   ~ set to 'true' when you want to recurse/walk down directory path(s)
    rem   ~ when 'false'/undefined, script does not recurse
    set "zk_recurse_tree="

goto :eof

:::::::::::::::::::::::::::::::::::::::
::                                   ::
::                Main               ::
::                                   ::
:::::::::::::::::::::::::::::::::::::::
:func_mein
    call :func_zk_user_script_settings

    rem boolean processing
    set "zk_print_summary_msgs=%zk_print_summary_msgs%false"
    set "zk_print_info_msgs=%zk_print_info_msgs%false"
    set "zk_print_del_msgs=%zk_print_del_msgs%false"
    set "zk_recurse_tree=%zk_recurse_tree%false"

    if /i "%zk_print_summary_msgs:~0,5%" neq "false" set "zk_print_summary_msgs=true"
    if /i   "%zk_print_info_msgs:~0,5%"  neq "false" set "zk_print_info_msgs=true"
    if /i    "%zk_print_del_msgs:~0,5%"  neq "false" set "zk_print_del_msgs=true"
    if /i     "%zk_recurse_tree:~0,5%"   neq "false" set "zk_recurse_tree=true"

    rem clear/pre-define counters
    set /a "zk_empty_file_count=0,zk_empty_dir_count=0"
    set "zk_walk_dir_count="

    rem  if path is passed into the arglist use that  ::  defaults to %temp% when no args
    call :func_zk_arg_shifter %*
    if not defined zk_walk_dir_count call :func_zk_arg_shifter %zk_default_path_list%

    rem  leave early
	if not defined zk_print_summary_msgs goto :func_zk_zend
	if "%zk_walk_dir_count%" equ "0"     goto :func_zk_zend

    rem  print counters
	echo/Info: Remove Count Summary:
	echo/   %zk_empty_dir_count% Dir(s)
	echo/   %zk_empty_file_count% File(s)

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
    if not defined #func_zk_arg_shifter{One} goto :eof

    rem  cannot be empty; sets to white-space when empty
    set "#func_zk_arg_shifter{One{a}}=%~a1 "
    if /i "%#func_zk_arg_shifter{One{a}}:~0,1%" neq "d" set "#func_zk_arg_shifter{One{a}}="

    rem  checks accessible/existing directories only;  rem shift early since param is still set to var;  rem  when last args was a path, loop back early
    if defined #func_zk_arg_shifter{One{a}} if defined zk_recurse_tree for /f "delims=" %%R in (' 2^>nul dir /b /s /a:d %1 ^| sort /r') do call :func_zk_remove_empties   "%%R"
    if defined #func_zk_arg_shifter{One{a}} call :func_zk_remove_empties   %1
    shift /1
    if defined #func_zk_arg_shifter{One{a}} goto :func_zk_arg_shifter

    rem  non-path arg parser; WA to keep '?' out of the forf loop below
    if    "%#func_zk_arg_shifter{One}:~1,1%"   equ "?" set "#func_zk_arg_shifter{One}=-h"
    if    "%#func_zk_arg_shifter{One}:~2,1%"   equ "?" set "#func_zk_arg_shifter{One}=--help"

    for /f "tokens=* delims=+-/" %%X in ("-%#func_zk_arg_shifter{One}%") do (
        rem  Help arg parsing
        if /i "%%~X"  equ   "version"      call :func_zk_info
        if /i "%%~X"  equ      "v"         call :func_zk_info       %%~X

        rem  Help arg parsing
        if /i "%%~X"  equ     "help"       call :func_zk_dump_help
        if /i "%%~X"  equ      "h"         call :func_zk_dump_help

        rem  Silent args parsing
        if /i "%%~X"  equ  "no-info-msgs"  call :func_zk_daFifth    zk_print_info_msgs
        if /i "%%~X"  equ      "ni"        call :func_zk_daFifth    zk_print_info_msgs

        if /i "%%~X"  equ  "no-del-msgs"   call :func_zk_daFifth    zk_print_del_msgs
        if /i "%%~X"  equ      "nd"        call :func_zk_daFifth    zk_print_del_msgs

        if /i "%%~X"  equ "no-totals-msgs" call :func_zk_daFifth    zk_print_summary_msgs
        if /i "%%~X"  equ "no-total-msgs"  call :func_zk_daFifth    zk_print_summary_msgs
        if /i "%%~X"  equ      "nt"        call :func_zk_daFifth    zk_print_summary_msgs

        if /i "%%~X"  equ    "no-msgs"     call :func_zk_daFifth    zk_print_info_msgs zk_print_del_msgs zk_print_summary_msgs
        if /i "%%~X"  equ     "silent"     call :func_zk_daFifth    zk_print_info_msgs zk_print_del_msgs zk_print_summary_msgs
        if /i "%%~X"  equ       "s"        call :func_zk_daFifth    zk_print_info_msgs zk_print_del_msgs zk_print_summary_msgs

        rem  recurse dir tree
        if /i "%%~X"  equ    "recurse"     set "zk_recurse_tree=true"
        if /i "%%~X"  equ       "r"        set "zk_recurse_tree=true"
        if /i "%%~X"  equ    "no-recurse"  set "zk_recurse_tree="
        if /i "%%~X"  equ       "nr"       set "zk_recurse_tree="
    )

    goto :func_zk_arg_shifter


::  Usage  ::  func_zk_info
rem  Prints Release message to standard out
rem  Print only Version when %1 is "v"
:func_zk_info
    for /f "tokens=1,2,3,4 delims=|" %%L in ('findstr /rc:"^::  [A-Z].*  |" "%~f0"') do if not defined #p{l} (
        set "#p{l}=true"
        if /i "%~1" equ "v" (
            for /f "tokens=1,2*" %%V in ("%%M") do echo/%%V %%W&   rem Version Short 
        ) else (
            for /f "tokens=*" %%V in ("%%O") do echo/%%V&          rem Description
            for /f "tokens=1,2*" %%V in ("%%N") do echo/%%V: %%W&  rem Link
            for /f "tokens=1,2*" %%V in ("%%M") do echo/%%V: %%W&  rem Version
            for /f "tokens=2,3*" %%V in ("%%L") do echo/%%V: %%W&  rem Author
        )
    )
    set "#p{l}="
    set "#p{A}="

    rem  preventing execution of zk_default_path_list
    set /a "zk_walk_dir_count+=0"
    goto :eof

::  Usage  ::  func_zk_dump_help
rem  Prints Help message to standard out
:func_zk_dump_help
    echo/ %~nx0: remove empty files/subdirectories from specified path(s)
    echo/
    echo/ Usage: %~nx0 [ -h^| -r^| -nr^| -s^| -nd^| -ni^| -nt^| "[path1]"]  "[path2]"  "[path3]"  [etc]
    echo/
    echo/ Paramaters:
    echo/     -h, -?, --help         Prints this help information
    echo/
    echo/     -nr, --no-recurse      Do not recurse down directory paths
    echo/
    echo/     -r, --recurse          Recurse down directory paths
    echo/
    echo/     -s, --silent,          Suppress ALL %~nx0 output
    echo/      --no-msgs
    echo/
    echo/     -ni, --no-info-msgs    Suppress information/checking output
    echo/
    echo/     -nd, --no-del-msgs     Suppress file/dir deletion output
    echo/
    echo/     -nt, --no-total-msgs,  Suppress Total Summary output
    echo/      --no-totals-msgs
    echo/
    echo/ Arguments are processed, applied, and executed in FIFO order.
    echo/   Hence, recommendation to use any behavioral arguments
    echo/   before any path(s) arguments
    echo/
    echo/ Argless Usage, defaults to:
    echo/   %~nx0  %zk_default_path_list%
    echo/

    rem  preventing execution of zk_default_path_list
    set /a "zk_walk_dir_count+=0"
    goto :eof


::  Usage  ::  func_zk_daFifth   varA   varB   varC   etc
rem  Helper function of func_zk_arg_shifter to process 'silent' argument switches
:func_zk_daFifth
    if "%~1" equ "" goto :eof
    set "%~1="
    shift /1
    goto %~0
    goto :eof


::  Usage  ::  func_zk_remove_empties  directoryPath
rem  Remove Empty files/directories
:func_zk_remove_empties
    if "%~a1" equ "" goto :eof
    pushd "%~1"
    set /a "zk_walk_dir_count+=1"
    if defined zk_print_info_msgs echo/Info: Checking: "%~1"
    2>nul call :func_zk_remove_empty_files         "%~1"
    2>nul call :func_zk_remove_empty_directories   "%~1"
    popd
    goto :eof


::  Usage  ::  func_zk_remove_empty_directories  directoryPath
rem  Recurse through a directory and remove all empty subdirectories
:func_zk_remove_empty_directories
    if "%~a1" equ "" goto :eof
    for /f "tokens=* delims=" %%g in ('dir /b /a:d "%~1\"') do for /f "tokens=1-4 delims= " %%A in ('dir /a "%~1\%%~g"') do if "%%~D" equ "bytes" if "%%~B" equ "File(s)" if %%~A. equ 0. for /f "tokens=1-4 delims= " %%E in ('dir /a "%~1\%%~g"') do if "%%~H" equ "bytes" if "%%~F" equ "Dir(s)" if %%~E. equ 2. (
        set /a "zk_empty_dir_count+=1"
        if defined zk_print_del_msgs echo/Del: Directory: "%~1\%%g"
        2>nul 1>nul rmdir /q "%~1\%%g"
    )
    goto :eof


::  Usage  ::  func_zk_remove_empty_files  directoryPath
rem  Recurse through a directory and remove all empty subdirectories
:func_zk_remove_empty_files
    if "%~a1" equ "" goto :eof
    for /f "tokens=* delims=" %%g in ('dir /b /a:-d "%~1\"') do if %%~zg. equ 0. (
        set /a "zk_empty_file_count+=1"
        if defined zk_print_del_msgs echo/Del:  0B  File: "%~1\%%g"
        2>nul 1>nul del /a /q "%~1\%%g"
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
