::  by JaCk  |  Release 08/023/2018  |  https://github.com/1ijack/BatchMajeek/md5.cmd  |  md5.cmd - compute/[verify(manually)] MD5 hash of a file using PowerShell (or almost any other tool).  (Verify, is not working atm, although I just coded it in another similar script)
:::
:: References/Sources/Links -- Thank you very much
::  Original PowerShell Command Author Atif Aziz - Script Name: md5.cmd -- Description: Windows batch script to compute MD5 hash of a file using PowerShell -- srcURL: https://gist.github.com/atifaziz/4368545
:::
::  WARNING! DO NOT USE if you do not understand what this script's commands do
::  No Support, No Warrenties, No Guarentees -- USE WITH YOUR OWN RISK!!!
::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
@echo off & setlocal DisableDelayedExpansion EnableExtensions & ( for /f "tokens=1 delims==" %%V in ('set emde5_') do set "%%~V=" ) 2>nul 1>nul
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::
::  Notes and Changes:
::  * 08/03/2018 - Arg Parser Fix for absolute paths
::  + 07/26/2018 - added preliminary hash verification lines
::  * 07/26/2018 - help dump error fixes
::  * 07/26/2018 - function rewrite/optimization: console-waitcheck, 4chcp-codepage
::  + 01/17/2018 - Added recursion control via params/vars.  When recursion is disabled and input is directory, only hashes files in that directory.  Otherwise, when enabled, walks down directory tree.
::  + 01/17/2018 - Refactored args-parser to be [self]-recallible and moved label into bunctions.  Moved main objects outside of args-parser.  Added "off","on","enable" and standardised the flags.
::  * 01/17/2018 - Changed behavior of user prompts.  Only prompts when there's nothing to hash via parameters.
::  + 01/03/2018 - Rewrote Args parse, added --output:file and --pause:[auto/on/enable/disable/no]
::  * 01/03/2018 - Changed the behavior when passing directories with and without an ending backslash ('\')
::  * 01/03/2018 - Rewrote chcp blocks to make them more defined
::  $ 12/06/2017 - Found limitation, when filename contains '%' [script drops 1 '%' per 'call' statement].  To [start] fixing the issue, need to rewrite args parse to use "shift" and set to var.  WIP...
::  * 12/06/2017 - Rewrote some functions to use errorlevel statements instead of DblAmp\DblPipe to be DelayedExpansion indenpendant.
::  - 12/06/2017 - Removed all debug code blocks and unused\broken\debug functions (~650 lines deleted). [original content is still in md5dev.cmd].  Prep for public\per\outside readability
::
::::::::::::::::::::::::::::::::::::::::
::
::         User settings
::
::::::::::::::::::::::::::::::::::::::::

::: Default: undef   --- Type: Boolean, Hardcoded preset --- Required: Optional :: Description: unicode/65001 console encoding; should restore to previous encoding before leaving script
::  Note: toggling params will over-write this setting
::  - Disable -- Var:       -- Params: --utf8-disable  --unicode-disable  -ud
::  - Enable  -- Var: true  -- Params: --utf8          --unicode          -u
set "emde5_unicode=true"

::: Default: true    --- Type: Boolean, Hardcoded preset --- Required: Optional :: Description: Default directory recursian.  When defined, recurses down directories looking for files to hash.  When undef, ignores sub-directories.
::  - Disable -- Var:       -- Params: --recurse:disable  -rd
::  - Enable  -- Var: true  -- Params: --recurse:enable   --recurse  -r
set "emde5_recurse_dirs=true"

::: Default: true    --- Type: Boolean, Hardcoded preset --- Required: Optional :: Description: when called from a non console env, wait for user input for 60secs before exiting. IE: when called from Shell/DWM by double clicking
::  - Disable -- Var:       -- Params: --pause:no
::  - Enable  -- Var: true  -- Params: --pause:auto
set "emde5_non_console_60pause=true"

::::::::::::::::::::::::::::::::::::::::
::
::       Script Settings
::
::::::::::::::::::::::::::::::::::::::::
rem none -- this is not a internal/debug release



::::::::::::::::::::::::::::::::::::::::
::
::       Mah-Mein
::
::::::::::::::::::::::::::::::::::::::::
call :func_md5_args_and_input %*

if defined emde5_non_console_60pause call :func_md5_wait_check  "%~nx0"
if defined emde5_unicode call :func_md5_encoding_unset

call :func_md5_xit
goto :eof


::::::::::::::::::::::::::::::::::::::::
::
::          Bunctions
::
::::::::::::::::::::::::::::::::::::::::
:: When I close my eyes, they can not see me. tee-hee
:: [script should not, ever, get here].
                               goto :eof

::  Usage  ::  func_md5_a_help   Extended-Optional
rem  Dumps Help
rem    When Param1 is supplied (any 437 value) shows extended help
:func_md5_a_help
    echo/  Usage:
    echo/    %~nx0 [options] [file1] [file2] [options] [file3] ...
    echo/
    echo/  Params:
    echo/     Parameters are processed in serial order.  Therefore, debug/unicode/output
    echo/    behavior can be toggled inbetween other file\directory parameters.
    echo/
    echo/    -h, --help           Print this help text.
    echo/                           ~ Prints Help when all inputs undefined
    echo/                           ~ Full List: [-h, /h, -?, /?, --help, /help, [undef]]
    echo/
    echo/    -o, --output:file,   Write also to a file. Can be toggled as well.
    echo/     --output, o:file      - Disables, when passed without an output file
    echo/
    echo/    -r, --recurse:flag   Toggle, Recurse/Walk down the directory tree: hashing all files
  if not defined emde5_recurse_dirs (
    echo/                           - Default Recursion: disable
  ) else (
    echo/                           - Default Recursion: %emde5_recurse_dirs%
  )
    echo/      enable, true, on     - Enable flags. Not required, as default action is "enable"
    echo/          disable, d,      - Disable flags. Required when needing to disable behavior
    echo/          false, off,
    echo/                 -rd       - Additional disable arg
    echo/
    echo/    -u, --unicode,       Change console encoding to unicode [chcp 65001]
    echo/        --utf8             - disables only when "%~nx0" previously it enabled and env wasn't cleared
    echo/                           + Only changes to 65001 for the current window, restores to original encoding before leaving script
    echo/                           + Can be toggled with with ":disable" and ":enable"
    echo/                           * examples: -u:disable, --unicode:enable, --utf8
    echo/    --ud, --utf8-disable,  - Additional disable args
    echo/    --unicode-disable      - Additional disable args

    rem  Extended help when asked for help only
    if "%~1" equ "" goto :eof

    echo/
    echo/  ----------------------------------------
    echo/  Examples: Input cmds and their outputs
    echo/
    echo/  - Multiple files
    echo/     "%~nx0" "%windir%\system.ini" "%windir%\Boot\BootDebuggerFiles.ini"
    echo/         286a9edb379dc3423a528b0864a0f123 ^*%windir%\system.ini
    echo/         783613ff39c559737bf0dfe08d82f8ec ^*%windir%\Boot\BootDebuggerFiles.ini
    echo/
    echo/  - output to console and to hash file while disabling directory recursion
    echo/      "%~nx0" --output ".\files.md5" ".\file.ext" --recurse:disable ".\folder"
    echo/         BAC3BAC1548E7883FCD4762769677EDA ^*.\file.ext
    echo/         27A7C651139F14EE12B4B02EC4D84953 ^*.\folder\file
    echo/         C0F1BCFF0605055F0AABAB5D197D0CAB ^*.\folder\phyle
    echo/
    echo/  - run with unicode env; but, only for two of the four objects
    echo/      "%~nx0" --unicode ".\фаел.кнц" ".\папка" -ud ".\file.ext" ".\folder"
    echo/         81371319530c48a997b0f9fc9a3736fe ^*.\фаел.кнц
    echo/         d69e8c6bca4c5669bee2aa23171620dc ^*.\папка\фу.бар
    echo/         caa18391007c4c8724dd3a44c44831e8 ^*.\file.ext
    echo/         3a7ecf3433c1e9dd0cc8d834682a5bb7 ^*.\folder\foo.bar
    echo/
    echo/  ----------------------------------------
    echo/  Features:
    echo/    ^* Prompts user to input an object/file to hash when called without parameters
    echo/    ^* on-the-fly unicode console encoding toggle
    echo/    ^* Dump to console and a local file
    echo/
    echo/  ----------------------------------------
    echo/  Complaints:
    echo/    ^* Why not use [Insert "better" Language Here] instead^?
    echo/        1. Jelly Jerk, don't tell me how to waste my time
    echo/        2. Windows batch script, is teh fawnist kodes ever
    echo/
    echo/  ----------------------------------------
    echo/
    goto :eof


::  Usage  ::  func_md5_args_and_input  ArgsNeededParsing
rem  Oh Sanity, My Sanity, where arst thou be?  To wherest thou hast gone?
rem    When no params, ask user for input
rem    dump help: lazy-parse params for help flags [--help, /help, -h, /h, -?, /?]
rem    when not called from console, pauses before exiting
rem    Em-Dee-Five dis beach and bounce
:func_md5_args_and_input
    if defined emde5_unicode call :func_md5_encoding_set 65001

    rem help/debug params parsing  --  Question Marks do not work well inside "normal for loops"
    if "%~1" equ "-?" call :func_md5_a_help   extended
    if "%~1" equ "/?" call :func_md5_a_help   extended

    rem parsing just a "few" params
    for %%Z in (
        %*
    ) do for /f "tokens=* delims=+-/" %%X in (
        " -%%Z "
    ) do for /f "tokens=1,* delims=:" %%U in (
        " %%X "
    ) do if /i "-%%~X" equ "-_interal_reloop_"        ( rem do nothing -- take bullet out of the chamber
    ) else if /i "-%%~U" equ "-h"                     ( call :func_md5_a_help   extended
    ) else if /i "-%%~U" equ "-help"                  ( call :func_md5_a_help   extended
    ) else if /i "-%%~U" equ "-unicode"               (
                           if "-%%~V" equ "-disable"    call :func_md5_encoding_unset
                           if "-%%~V" equ "-false"      call :func_md5_encoding_unset
                           if "-%%~V" equ "-off"        call :func_md5_encoding_unset
                           if "-%%~V" equ "-d"          call :func_md5_encoding_unset
                           if "-%%~V" equ "-enable"     call :func_md5_encoding_set 65001
                           if "-%%~V" equ "-true"       call :func_md5_encoding_set 65001
                           if "-%%~V" equ "-on"         call :func_md5_encoding_set 65001
                           if "-%%~V" equ "-"           call :func_md5_encoding_set 65001
    ) else if /i "-%%~U" equ "-recurse"               (
                           if "-%%~V" equ "-disable"    set "emde5_recurse_dirs="
                           if "-%%~V" equ "-false"      set "emde5_recurse_dirs="
                           if "-%%~V" equ "-off"        set "emde5_recurse_dirs="
                           if "-%%~V" equ "-d"          set "emde5_recurse_dirs="
                           if "-%%~V" equ "-enable"     set "emde5_recurse_dirs=true"
                           if "-%%~V" equ "-true"       set "emde5_recurse_dirs=true"
                           if "-%%~V" equ "-on"         set "emde5_recurse_dirs=true"
                           if "-%%~V" equ "-"           set "emde5_recurse_dirs=true"
    ) else if /i "-%%~U" equ "-check"                 ( set "emde5_match_file=%%~V"
    ) else if /i "-%%~U" equ "-input"                 ( set "emde5_input_file=%%~V"
    ) else if /i "-%%~U" equ "-pause"                 (
                           if /i "-%%~V" equ "-disable" set "emde5_non_console_60pause="
                           if /i "-%%~V" equ "-off"     set "emde5_non_console_60pause="
                           if /i "-%%~V" equ "-no"      set "emde5_non_console_60pause="
                           if /i "-%%~V" equ "-enable"  set "emde5_non_console_60pause=true"
                           if /i "-%%~V" equ "-auto"    set "emde5_non_console_60pause=true"
                           if /i "-%%~V" equ "-on"      set "emde5_non_console_60pause=true"
    ) else if /i "-%%~U" equ "-o"                     ( set "emd5_output_file=%%~V"
    ) else if /i "-%%~U" equ "-output"                ( set "emd5_output_file=%%~V"
    ) else if /i "-%%~X" equ "-rd"                    ( set "emde5_recurse_dirs="
    ) else if /i "-%%~X" equ "-ud"                    ( call :func_md5_encoding_unset
    ) else if /i "-%%~X" equ "-utf8-disable"          ( call :func_md5_encoding_unset
    ) else if /i "-%%~X" equ "-unicode-disable"       ( call :func_md5_encoding_unset
    ) else if /i "-%%~U" equ "-c"                     ( call %~0 _interal_reloop_   --check:"%%~V"
    ) else if /i "-%%~U" equ "-i"                     ( call %~0 _interal_reloop_   --input:"%%~V"
    ) else if /i "-%%~U" equ "-r"                     ( call %~0 _interal_reloop_ --recurse:"%%~V"
    ) else if /i "-%%~U" equ "-u"                     ( call %~0 _interal_reloop_ --unicode:"%%~V"
    ) else if /i "-%%~U" equ "-utf8"                  ( call %~0 _interal_reloop_ --unicode:"%%~V"
    ) else call :func_md5_a_object_proccess "%%~Z"

    if defined emde5_input_object goto :eof

    rem  user prompt control
    if "%~1" neq "_interal_reloop_" if not defined _emd5_hash_counter if not defined check_input_counter (
        if "%~1" equ "" call :func_md5_a_help
        call :func_md5_ask_input_check
        goto :eof
    )

    goto :eof



::  Usage  ::  func_md5_a_object_proccess  "file"
rem  sub-Main: All "per object" functions go here:
rem    Basic Error Checking
rem    md5 file check and compare
rem    prints results when no issues found
:func_md5_a_object_proccess
    if "%~1" equ "" goto :eof

    rem  recursion control
    set "emd5_dircmd_attrib_options=a:-d"
    if defined emde5_recurse_dirs set "emd5_dircmd_attrib_options=a"

    rem  when directory, process and submit nested objects
    set "_emd5_ac_=%~a1"
    set "_emd5_p_=%~1"
    if "%_emd5_ac_:~0,1%" equ "d" for /f "tokens=* delims=" %%D in (
            'dir /b /%emd5_dircmd_attrib_options% "%~1"'
        ) do if "%%~D" neq "" if "%_emd5_p_:~-1,1%" neq "\" (
               call %~0 "%~1\%%~D"
        ) else call %~0  "%~1%%~D"
    ) 2>nul
    set "_emd5_ac_="
    set "_emd5_p_="

    call :func_md5_basic_errorcheck "%~1"
    if %errorlevel% neq 0 goto :eof

    rem  hash'em and output to std/file
    call :func_md5_filehash        "emde5_result_hash"   "%~1"
    call :func_md5_prnt_result    "%emde5_result_hash%"  "%~1"  "%emd5_match_report%"

    if defined emd5_output_file for %%A in ("%emd5_output_file%") do if "%%~zA" neq "%~z1" (
        if "%%~nxA" neq "%~nx1" call :func_md5_prnt_result    "%emde5_result_hash%"  "%~1"  "%emd5_match_report%"
    ) >> "%emd5_output_file%"

    if not defined emde5_result_hash ( echo/Error: Unable to hash "%~1") 1>&2
    set "emde5_result_hash="
    set /a "_emd5_hash_counter+=1"

    goto :eof


::  Usage  ::  func_md5_basic_errorcheck  "fileOrDirectory"
rem  Checks the access/existance/state-of-object.  When error, exit function (script in memory)
rem  Note: Must be files ONLY
rem    Example usage:
rem      func_md5_basic_errorcheck   "%UserProfile%\Documents\MyDoc.doc"
:func_md5_basic_errorcheck
    if "%~1" equ "" exit /b 1
    rem  check first attribute -- directory - d
    set "_emd5_err_ac_=%~a1 "
    if "%_emd5_err_ac_:~0,1%" equ "d" ((set "_emd5_err_ac_=") &exit /b 10)
    set "_emd5_err_ac_="
    rem  Make sure "user" neq "troll"
    if not exist "%~1" (for /f "delims=" %%A in ('dir /b /a "%~1"') do exit /b 0) 2>nul 1>nul else exit /b 0
    exit /b 1
    goto :eof



::  Usage  ::  func_md5_get_user_input  returnVar   msgText-Optional   defaultResponse-Optional
rem  Prompts User for input
rem    Quoted parameters optional, double-quotes will be dropped regardless, White-spaces ignored between params
rem    Example usage:
rem      func_md5_get_user_input   varUserFeedback   "Input: User: Did you like %~nx0"   "N/A"
:func_md5_get_user_input
    if "%~1" equ "" goto :eof
    if "%~2" neq "" echo/%~2
    if "%~3" neq "" echo/   [Default: %3]
    if "%~3" neq "" set "%~1=%3"
    set /p "%~1= ~> "
    goto :eof



::  Usage  ::  func_md5_ask_input_check
rem  Prompts user for input and calls args parser
rem  Note: this should only be run once per session
:func_md5_ask_input_check
    if 1%check_input_counter% gtr 10 goto :eof
    set /a "check_input_counter+=1"
    call :func_md5_get_user_input   emde5_input_object   "&echo/&echo/&echo/ Input: User: Enter a relative/absolute path(s) to object(s) and any other options needing parsing:&echo/&echo/ Info: &echo/   Hint: Add double-quotes around file/path when file/path name contains spaces/special characters &echo/   Hint: for help type in: /help&echo/" "%cd%"
    if defined emde5_input_object   call :func_md5_args_and_input    %emde5_input_object%
    goto :eof



::  Usage  ::  func_md5_filehash   "returnVar"   "FileToHash"   "returnCompareVar-Optional"   "expectedHash-Optional"
rem  Hashes object, optionally checks result and returns status
rem    Note: No 2G file limitation (lazy ~2000000000 bytes)
rem    Note: Single-quote needs to be escaped for the powershell command(s) (by another single-quote)
rem    Note: Yes, I understand this isn't superclean, my other solution took too long
:func_md5_filehash
    if "%~2" equ "" exit /b 101
    if "%~1" equ "" exit /b 101
    set "%~1="
    set "emd5_pTwo="

    for /f "tokens=1,2 delims='" %%Q in ("%~fnx2") do if not "%%~R" equ "" set "emd5_pTwo=%~2"
    if defined emd5_pTwo     call :func_md5_ps_getfilehash   "%~1"   "%emd5_pTwo:'=''%"
    if not defined emd5_pTwo call :func_md5_ps_getfilehash   "%~1"       "%~fnx2"
    set "emd5_pTwo="

    goto :eof



::  Usage  ::  func_md5_prnt_result   "HashOfFile"   "FileWhichWasHashed"   ";comment"
rem  Prints to stdout the hash results
rem    Note: (param3) is optional as they are notes
:func_md5_prnt_result
    if "%~2" equ "" goto :eof
    if "%~1" equ "" goto :eof

    set "emd5_pTwo=%~2"
    for /f "tokens=1,2 delims=&" %%Q in (
        "%~2"
    ) do if "%%~R" equ "" set "emd5_pTwo="

    if not defined emd5_pTwo echo/%~1 ^*%~2%~3
    if not defined emd5_pTwo exit /b 0

    set "emd5_pTwo=%emd5_pTwo:&=^&%"
    echo/%~1 ^*%emd5_pTwo%%~3

    set "emd5_pTwo="
    goto :eof


::  Usage  ::  func_md5_ps_getfilehash   "returnVar"   "FileToHash"   "returnCompareVar-Optional"   "expectedHash-Optional"
rem  Hashes object, optionally checks result and returns status
rem    Note: No 2G file limitation (lazy ~2000000000 bytes)
rem    Note: Single-quote needs to be escaped (by another single-quote) for the powershell command(s)
:func_md5_ps_getfilehash
    if "%~2" equ "" exit /b 101
    if "%~1" equ "" exit /b 101
    set "%~1="

    ( for /f "eol=- usebackq tokens=1,2 delims= " %%R in (
            `PowerShell -C "Get-FileHash -Algorithm MD5 -LiteralPath '%~fnx2'"`
        ) do if /i "%%~R" equ "MD5" set "%~1=%%~S"
    ) 2>nul

    if not defined %~1 exit /b 1
    goto :eof


::  Usage  ::  func_md5_ps_fsopen   "returnVar"   "FileToHash"
rem  Hashes object, optionally checks result and returns status
rem    Note: Suffers from a 2G file limitation (lazy ~2000000000 bytes)
rem    func   returnVar   objectToHash   returnCompareVar-Optional   expectedHash-Optional
:func_md5_ps_fsopen
    if "%~2" equ "" goto :eof
    if "%~1" equ "" goto :eof
    set "%~1="

    ( for /f "usebackq tokens=1* delims= " %%R in (
            `PowerShell -C "[System.BitConverter]::ToString([System.Security.Cryptography.MD5]::Create().ComputeHash([System.IO.File]::ReadAllBytes('%~2'))).ToLowerInvariant().Replace('-', '')"`
        ) do set "%~1=%%~R"
    ) 2>nul

    if not defined %~1 exit /b 1
    goto :eof


::  Usage  ::  func_md5_encoding_set   optional-ChcpCodePage
rem  Gets the current console encoding value and attempts to change it to 65001 (unicode) OR value of param1
rem    All params are ignored and unused, returns errorlevel 1 when issues are encountered, 0 when no issues encountered
:func_md5_encoding_set
    if "%~1" equ "" ((call %~0 65001) &goto :eof)

    rem get chcp binary path - get current code page - get new code page - leave when no errors
    if not defined emde5_chbin (for /f "delims=" %%C in ('"%SystemRoot%\System32\where.exe" "%SystemRoot%\System32:chcp.com" "%path%:chcp.com"') do set "emde5_chbin=%%~C") 2>nul 1>nul || set "emde5_chbin=chcp"
    if not defined emde5_chcp_orig for /f "tokens=4" %%C in ('"%emde5_chbin%"') do set "emde5_chcp_orig=%%C"
    if not defined emde5_chcp_new  if 1%emde5_chcp_orig% equ 1%~1 ( set "emde5_chcp_new=%emde5_chcp_orig%" ) else for /f "tokens=4" %%C in ('"%emde5_chbin%" %~1') do set "emde5_chcp_new=%%C"
    if defined emde5_chcp_new exit /b 0

    rem oh-noes dere-be-dem damned errors now
    if defined emde5_chbin if not defined emde5_chcp_orig (
        echo/ Error: chcp: Unable to change console encoding. Unexpected or missing query output
        echo/ Info: chcp: If a console encoding change is necessary: before running "%~nx0", run this command: "%emde5_chbin%" %~1
    ) 1>&2 else if not defined emde5_chcp_new   ( echo/ Error: chcp: code page "%~1" unavailible
    ) 1>&2 else if "%~1" neq "%emde5_chcp_new%" ( echo/ Error: chcp: code page "%~1" unavailible
    ) 1>&2

    rem since there were errors, revert the code page change and cleanup vars
    if defined emde5_chcp_orig "%emde5_chbin%" %emde5_chcp_orig%
    for %%V in (emde5_chcp_orig; emde5_chbin; emde5_chcp_new) do set "%%V="

    exit /b 1
    goto :eof


::  Usage  ::  func_md5_encoding_unset
rem  Restores original console encoding when changed by func_md5_encoding_set
:func_md5_encoding_unset
    if not defined emde5_chcp_orig exit /b 1
    if not defined emde5_chbin set "emde5_chbin=chcp"
    rem revert code page and cleanup vars
    ( "%emde5_chbin%" %emde5_chcp_orig% ) 2>nul 1>nul
    for %%V in (emde5_chbin;emde5_chcp_new;emde5_chcp_orig) do set "%%V="
    goto :eof


::  Usage  ::  func_md5_wait_check   "%~nx0"
rem  Checks to see if the script was called from console or WM;
rem  when WM, wait 60secs
rem    Note: param1 is literal -- "%~nx0"
:func_md5_wait_check
    rem  check literacy\competency; talk to self when ritard
    if "%~1" equ "" ((call %~0 "%~nx0") &goto :eof)

    rem  proper launch -- check
    ( echo/"%CMDCMDLINE%"
    ) 2>nul 1>nul || goto :eof

    rem  check loosely -- script-name neq cmd-launch-name;  when true, trigger wait
    ((echo/"%CMDCMDLINE%"
    ) | findstr /i "%~nx1" 2>nul 1>nul
    ) && timeout /t 60
    goto :eof


::  Usage  ::  func_md5_xit   "errorlevel-Optional"
rem  Unsets script vars and exits batch file with an optional errorlevel/errorcode
rem  Note: If using this as call, this exits the temp-call-script in memory, NOT %0. You still need to exit (again)
rem  Note: If using this as goto, the param(s) are NOT passed in
rem    Example usage:
rem       call :func_md5_xit "255"
rem       call :func_md5_xit "%errorlevel%"
:func_md5_xit
    ( for /f "tokens=1 delims==" %%V in ('set emde5_') do set "%%~V="
    ) 2>nul 1>nul
    endlocal

    exit /b %~1
    goto :eof



::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
