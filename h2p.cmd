::  By JaCk  |  Release 01/30/2018  |  https://github.com/1ijack/BatchMajeek/blob/master/h2p.cmd  |  h2p.cmd  --- uses wkhtmltopdf.exe to download and create local pdfs
:::
::: The zlib/libpng License -- https://opensource.org/licenses/Zlib
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
@echo off & setlocal EnableExtensions & goto :func_h2p_mein

:::  User Hardcoded Settings
:conf_user_settings
    set "h2p_url="
    set "h2p_output="
    set "_h2p_binary=%ProgramFiles%\wkhtmltopdf\bin\wkhtmltopdf.exe"
    set "_h2p_bin_opts=--quiet --print-media-type --background --header-font-name sitka --footer-font-name sitka --header-font-size 7 --footer-font-size 7 --header-line --footer-line --outline-depth 3 --header-left " [isodate] [time] ^| [Page:[page] - [subsection] ] ^|" --header-right " [section]" --footer-left "[ [sitepage] / [sitepages] ] ^| " --footer-right "[webpage]""
goto :eof

:::  Script behavorial boolSwitch.
:::    varName=[ true(defined) / false(undefined) ]
:conf_script_settings
    set "_h2p_auto_output=i like turtles"  rem  Does not prompt the user for filename, just generates one automaticly
    set "_h2p_auto_session=ah yeeeeeeh"    rem  Only prompt once, until I changed env/session. When prompted, use either, a, auto

    rem  the following debug switches change the behavor of the debug function 'func_h2p_dump_debug_msg'
    set "debug_h2p_grab_lnum=yarrr aye"    rem  Dump line number of msg in script. 
    set "debug_h2p_terse_msgs=jesPlease"   rem  undef is Very Verbose, you would get var dumps per each debug msg call and debug debug dumps.  
goto :eof
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::


::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

::: Bunctions
goto :eof rem   -- When you think you've seen it all... Fatch out for Bunctions. [x] EzCheese
          rem   -- Bunc'in Fatches Since DOS.  Where you werent set/pack= with a prompt all the time, you had choice  [x] Yeah-I-Went-There
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

::  Usage  ::  func_h2p_ahelp_me
rem  Dumps loads and loads of halpsmes.
:func_h2p_ahelp_me
    echo/
    echo/                          --  %~nx0  -- 
    echo/  --  feature-rich wrapper around the feature-rich "wkhtmltopdf" binary  --  
    echo/                              -- - -- 
    echo/%~nx0 Usage Help
    echo/         %~nx0   -u "httplink1"  -o "filename1"  --url "httplink2"  --add-opts:-n  -u "httplink3"  -u "httplink4"  --output "path\filename4"
    echo/
REM echo/   Autofilename:  for script generated output filename, use "auto"
REM echo/         %~nx0  "httplink"    "auto"
REM echo/
REM echo/   Explicit Args:  for more details use: %~nx0 --help:params
REM echo/         %~nx0 --url:"url"  --output:auto
REM echo/         %~nx0 -u:"url&funk?chrs" -o:"file name.pdf"
REM echo/
REM echo/   Multiple Links/files:  
REM echo/         %~nx0  url1;file1;go;  url2  file2  go  ; [etc]
REM echo/         %~nx0 ["http://url/1"];["1.pdf"^|auto];[done^|run^|go];  ["ftp://url/2"]  ["2url.pdf"^|auto]  [done^|run^|go] ; [etc]
REM echo/
REM echo/       Note:  parameters\args "go,run,done" are used to tell the script to process the args submitted and reset for more args
REM echo/
    echo/   More help options: 
    echo/         %~nx0 --help:[ params^| vars^| variables^| full]
    echo/
    echo/
goto :eof

::  Usage  ::  func_h2p_ahelp_params
rem  Dumps loads and loads of halps.
rem  Like, everywhere
:func_h2p_ahelp_params
    echo/
    echo/%~nx0 Help: Params 
    echo/
    echo/  Howto: Argument additional values; --parameter:"string"  OR   --parameter "string"
REM echo/  - Quotes:
    echo/      Use "double-quotes" around values that include: special characters, white-spaces, groups
REM echo/        Hint: always add quotes unless you know that you dont need them. Some examples under "Accepted Parameters"
REM echo/      Do not double-quote parameter with the string
    echo/         OK: -u:"http://a.url"  ^|^|  Not OK: "-u:http://a.url"
    echo/
REM echo/  - Key\Value Pairs (argument definitions): 
REM echo/      Use colon for argument definitions, DO NOT USE white-spaces, they are argument sperators
REM echo/         Fail:  --key value  ^|^|  Fail: "--key:value"   [notice the misplaced quotes]
REM echo/         OK:    --key:value   
REM echo/  
    echo/  Accepted Parameters:
    echo/               /?, -h, --help   Displays the help info, Additional options:
    echo/                --help:params     params - dump argument\parameter usage
    echo/                  --help:full     full - dump all help info
    echo/                               
    echo/                   --auto, -a   Script generated filename. Do not use with --output:file
    echo/                      auto, a     auto = urlpath.tld.dtime.pdf
    echo/                               
    echo/          --run, --go, --done   Tells script to run the current argument which are passed.
    echo/             -run, -go, -done     Used when creating multiple links/pdfs
    echo/                run, go, done     Will prompt user for missing info before moving to next argument set
    echo/                               
    echo/                --url:"<url>"   url to page that needs to be captured as a pdf
    echo/                   -u:"<url>"     please, please, encase with double-quotes
    echo/                      "<url>"     As a 1st argument: No definition required
    echo/                               
    echo/       --output:file, -o:file   Output to a local file. When filename is "auto", script generates a filename.
    echo/      -o:"dir path\fname.pdf"     OK: absolute/relative paths
    echo/               file.pdf, auto     No definition required when passed as the 2nd argument
    echo/               --output:path\     When only path is provided, guesses filename when "--auto" is also enabled
    echo/                      -o:auto     
    echo/                               
    echo/                      --norun  prints final command to console instead of running;
    echo/ 
    echo/    --binary:"<path\bin.exe>"  Use the defined binary instead of Current: 
    echo/          -b:"<path\bin.exe>"    [wkhtmltopdf.exe] "%_h2p_binary%"
    echo/ 
    echo/      --add-opts:"<add opts>"  Prepends additional binary parameters 
    echo/              -n:"<add opts>"  Current: 

    rem  Limit to only 30 characters
    if "%_h2p_bin_opts:~0,30%" equ "%_h2p_bin_opts%" ( echo/                                  %_h2p_add_opts% %_h2p_bin_opts%
                                                ) else echo/                                  %_h2p_add_opts% %_h2p_bin_opts:~0,30%...
    echo/

goto :eof

::  Usage  ::  func_h2p_ahelp_pebug
rem  Dumps brickloads of halps to stdout
:func_h2p_ahelp_pars
    echo/      
    echo/%~nx0 Help: Script Variables 
    echo/      
    echo/  Note: edit %~nx0, look within the first  20 lines for "conf_user_settings" and/or "conf_script_settings"
    echo/        - var names are BEFORE the "=", values are AFTER the "=", example: "varName=varValue"
    echo/        - Please DO NOT CHANGE the variable names, this WILL break %~nx0
    echo/      
    echo/  User Hardcoded Settings:
    echo/                    "h2p_url"  Hardcoded Url -- will not prompt user
    echo/                               - Recommended for this to be always unset.
    echo/                               - unsets after any args\parameters "go,run,done"
    echo/                               - Can ONLY be overwritten by using a named arg-prefix: -u:"", --url:""
    echo/      
    echo/                 "h2p_output"  Hardcoded Output File -- will not prompt user
    echo/                               - Recommended for this to be always unset.
    echo/                               - can be set to "auto" for script auto generated file name
    echo/                               - unsets after any args\parameters "go,run,done"
    echo/                               - Can ONLY be overwritten by using a named arg-prefix: -o:"", --output:"", -a, --auto
    echo/      
    echo/                "_h2p_binary"  Hardcoded Binary Path\Name:
    echo/                               - Recommended for this to be always set.
    echo/                               - Set to the path of the local "wkhtmltopdf" binary
    echo/                               - Can ONLY be overwritten by using a named arg-prefix: -b:"", --binary:""
    echo/      
    echo/              "_h2p_bin_opts"  Hardcoded Binary options -- parameters\args which are to be passed onto the "wkhtmltopdf" binary
    echo/                               - Recommended for this to be set 
    echo/                               - Overwrites predefined params by using a named arg-prefix: -no:"", --add-opts-overwrite:""
    echo/                               - Prepends additional bin args by using a named arg-prefix: -n:"", --add-opts:""
    echo/
    echo/  Script Behavorial boolSwitch:
    echo/    Note: definition of "boolSwitch" in the eyes of %~nx0 are:
    echo/       true  - when defined; set to ANY value(s)/character(s).
    echo/       false - when undefined; not set to any value(s)
    echo/
    echo/           "_h2p_auto_output"  Suppresses PROMPTING for output file, but instead generates one automaticly.
    echo/                               - ignored when using arg-prefix: -o:"", --output:"", -a, --auto
    echo/                               - ignored when using arg-param2 as output filename 
    echo/                               - ignored when h2p_output is defined
    echo/
goto :eof


:func_h2p_mein
    call :func_h2p_a_whole_new_world
    call :conf_user_settings
    call :conf_script_settings
    goto :func_h2p_Shifty_Argument
goto :eof

    
:func_h2p_post_args
    rem  Runs script -- Only when unresolved run-counters exist -- OR -- When counters are not set 
    rem    only when defined counters; and arg counter is positive
    rem    Need to make counter when url is def, then compare with total runs; only run when values dont match
    if "%_h2p_arg_checked_count%" gtr "1" (
        if defined _h2p_runAcnt (
            if defined _h2p_runTcnt (
                if "%_h2p_runAcnt%" neq "%_h2p_runTcnt%" call :func_h2p_aprocess_varset
            ) else rem call :func_h2p_aprocess_varset
        ) else call :func_h2p_aprocess_varset
    ) else call :func_h2p_pargs_help

    rem  End of script
    call :func_h2p_a_whole_new_world
    endlocal

goto :eof


::: Args parse
::  "Shifty Argument" -- by Alex Vronskiy -- Release 01/30/2018 -- You may use this and distribute it freely
rem
rem  Legend (or usage examples) of accepted/optional prefixes for switches(s) and key-value(k:v) pairs definitions
rem      s,   -s,   +s,   --s,   /+-s,   /s,    ------------------s
rem      k:v, -k:v, +k:v, --k:v, /+-k:v, /k:v,  ----------------k:v
rem      k=v, -k=v, +k=v, --k=v, /+-k=v, /k=v,  ----------------k=v
rem 
rem    Optional/Loose Arg-prefix acceptance:
rem      "Optional" -- meaning does not even need to be prefixed with the accepted prefix but can be an agnostic arg
rem         "Loose" -- meaning all prefixed instances of the accepted prefixes are stripped no matter the quantity 
rem     
rem  shift-loop inf until 10 consecutive empty arguments
rem     
rem  ForF loop variable mapping/explanation -- understanding this is not required
rem      Prefix Parsed Value     :  %%X
rem      Single Switch Parsing   :  %%U  and/or  %%X
rem      Key-Value Pair Parsing  :  key:%%U , value:%%V
rem   
rem  Key-Value pair limitations: Value CANNOT BE DEFINED via white-space (although this is now resolvable, yet it is beyond the scope of this checkin)
rem       k v, -k v, --k v, /-k v, /k v    -- Examples of what NOT to do
rem     
:func_h2p_Shifty_Argument
    set /a "_h2p_arg_checked_count+=1 , _h2p_blank_counter+=1"

    rem  Adjust blank counter
    if "%~1" neq "" set "_h2p_blank_counter=0"

    if %_h2p_blank_counter% gtr 0 (
        rem  Under threshold, reloop back around checking the next arg
        shift /1 
        if %_h2p_blank_counter% lss 9 goto :func_h2p_Shifty_Argument

        rem  Over threshold, adjust argCount and leave function/label
        set /a "_h2p_arg_checked_count-=%_h2p_blank_counter%"
        set "_h2p_blank_counter="
        goto :func_h2p_post_args
    )

    set "h2p_currArg{One}=%~1"
    set "h2p_currArg{Two}=%~2"
    set /a "_h2p_arg_shift+=1"

    rem  when arg is not empty strip arg prefix and expose/parse keyPairs/switches
    if "%~1" neq "" if .%1. equ ./?. (
        rem  W/A for a bug in interpreter; 
        call :func_h2p_match_key_check_value "help" "%~2"
    ) else for /f "usebackq tokens=* delims=+/-" %%X in (
        `echo/-%1`
    ) do for /f "usebackq tokens=1,* delims==:;," %%U in (
        `echo/%%X`
    ) do if "%~1" equ "%%~X" (
        rem  UnNamed argument
        set "h2p_currArg{One}=%%~X"
        set "h2p_currArg{Two}="
        call :func_h2p_match_key_check_value "%%~X"
    ) else if "%%~V" equ "" if "%h2p_currArg{One}:~-1,1%" equ ":" (
        rem  Named Argument separated by a colon AND an unquoted white-space separator
        set "h2p_currArg{One}=%%~U"
        set "h2p_currArg{Two}=%~2"
        call :func_h2p_match_key_check_value "%%~U" "%~2"
        set /a "_h2p_arg_shift-=1"
    ) else if "%%~V" equ "" (
        rem  Named Argument separated by a white-space
        set "h2p_currArg{One}=%%~X"
        set "h2p_currArg{Two}=%~2"
        call :func_h2p_match_key_check_value "%%~X"  "%~2"
    ) else (
        rem  Named Argument separated by a colon,semi-colon,comma;  rem  pre-remove a shift value
        set "h2p_currArg{One}=%%~U"
        set "h2p_currArg{Two}=%%~V"
        call :func_h2p_match_key_check_value "%%~U" "%%~V"
        set /a "_h2p_arg_shift-=1"
    )

    rem  shift arguments -- as much as needed,  Number NEEDS to be positive;  rem  reset shift; loop back
    if %_h2p_arg_shift% lss 1 set "_h2p_arg_shift=1"
    for /l %%S in (1,1,%_h2p_arg_shift%) do shift /1
    set "_h2p_arg_shift="
    goto :func_h2p_Shifty_Argument

goto :eof
       rem call :func_h2p_match_key_check_value "%%~X" "%~2"
       rem   above is support for spaced arguments, but there are still some unresolved nuances for live-in-h2p



:func_h2p_match_key_check_value

    rem  Help args
    if   "-%~1" equ "-?"     goto :func_h2p_pargs_help
    if /i "%~1" equ "h"      goto :func_h2p_pargs_help
    if /i "%~1" equ "help"   goto :func_h2p_pargs_help

    
    rem  ghetto WA for known uris 
    if /i "%~1" equ "ftp"    ( 
        call %~0 "%~1:%h2p_currArg{Two}%"
        goto :eof 
    )

    if /i "%~1" equ "file"   ( 
        call %~0 "%~1:%h2p_currArg{Two}%"
        goto :eof 
    )

    if /i "%~1" equ "http"   ( 
        call %~0 "%~1:%h2p_currArg{Two}%"
        goto :eof 
    )

    if /i "%~1" equ "https"  ( 
        call %~0 "%~1:%h2p_currArg{Two}%"
        goto :eof 
    )

    if /i "%~1" equ "stream" ( 
        call %~0 "%~1:%h2p_currArg{Two}%"
        goto :eof 
    )

    if /i "%~1" equ "done" (
        call :func_h2p_aprocess_varset
        call :func_h2p_a_whole_new_world  "h2p_"
        goto :eof
    ) 

    if /i "%~1" equ "run"  (
        call :func_h2p_aprocess_varset
        call :func_h2p_a_whole_new_world  "h2p_"
        goto :eof
    ) 

    if /i "%~1" equ "go"   (
        call :func_h2p_aprocess_varset
        call :func_h2p_a_whole_new_world  "h2p_"
        goto :eof
    ) 

    

    rem  url args
    if /i "%~1" equ "u"    (
        if defined h2p_url (
            call :func_h2p_aprocess_varset
            call :func_h2p_a_whole_new_world  "h2p_"
        )

        if "%~2" equ "" echo/-u:"expecting url"
        
        set "h2p_url=%h2p_currArg{Two}%"
        set /a "_h2p_arg_shift+=1"
        goto :eof
    ) 

    if /i "%~1" equ "url" (
        if defined h2p_url (
            call :func_h2p_aprocess_varset
            call :func_h2p_a_whole_new_world  "h2p_"
        )

        if "%~2" equ "" echo/--url:"expecting url"

        set "h2p_url=%h2p_currArg{Two}%"
        set /a "_h2p_arg_shift+=1"
        goto :eof
    ) 



    REM rem  silent output args
    REM if /i "%~1" equ "silent" ( 
    REM     if "-%~2" equ  "-"    ( set "_h2p_silent=true"  
    REM     ) else if "-%~2" equ "-on"   ( set "_h2p_silent=true"  
    REM     ) else if "-%~2" equ "-off"    set "_h2p_silent="  
    REM goto :eof )



    rem  output filename args
    if /i "%~1" equ "o" (
        if "%~2" equ "" (
            echo/-o:"expecting path\filename.pdf"
        ) else if "-%~2" equ "-auto" (
            call :func_h2p_guess_auto h2p_output
        ) else set "h2p_output=%~2"
        set /a "_h2p_arg_shift+=1"
        goto :eof
    ) 

    if /i "%~1" equ "output" (
        if "%~2" equ "" (
            echo/-output:"expecting path\filename.pdf"
        ) else if "-%~2" equ "-auto" (
            call :func_h2p_guess_auto h2p_output
        ) else set "h2p_output=%~2"
        set /a "_h2p_arg_shift+=1"
        goto :eof
    ) 

    if /i "%~1" equ "a" ( 
        call :func_h2p_guess_auto h2p_output
        goto :eof
    ) 

    if /i "%~1" equ "auto" ( 
        call :func_h2p_guess_auto h2p_output
        goto :eof
    ) 

    
    
    rem  additional binargs args
    if /i "%~1" equ "n" (
        if "%~2" equ "" (
            echo/--add-opts:"additional options"
            echo/   Or   -n:"additional options"
        ) 

        set "_h2p_add_opts=%~2"
        set /a "_h2p_arg_shift+=1"
        goto :eof
    ) 

    if /i "%~1" equ "add-opts" (
        if "%~2" equ ""  echo/--add-opts:"additional options"
        
        set "_h2p_add_opts=%~2"
        set /a "_h2p_arg_shift+=1"
        goto :eof
    ) 

    
    
    rem  additional binargs-overwrite args
    if /i "%~1" equ "no" (
        set "_h2p_bin_opts=%~2"
        set /a "_h2p_arg_shift+=1"
        goto :eof
    ) 

    if /i "%~1" equ "add-opts-overwrite" (
        set "_h2p_bin_opts=%~2"
        set /a "_h2p_arg_shift+=1"
        goto :eof
    ) 

    
    
    rem  pdfbin args
    if /i "%~1" equ "b" (
        if "%~2" equ "" (
            echo/-b:"expecting path\BinName"
        ) else set "_h2p_binary=%~2"
        set /a "_h2p_arg_shift+=1"
        goto :eof
    ) 

    if /i "%~1" equ "binary" ( 
        if "%~2" equ "" (
            echo/--binary:"expecting path\BinName"
        ) else set "_h2p_binary=%~2"
        set /a "_h2p_arg_shift+=1"
        goto :eof
    ) 

    
        
    rem  norun args
    if /i "%~1" equ "norun" (
        set "_h2p_norun=true"
        if "%~2" equ "" goto :eof
        for %%g in ( true  yes on  aye enable  "+" hecka-ya accepted surething IAlsoLikeTurtles  ) do if /i "-%~2" equ "-%%~g"  ( ( ( set /a "_h2p_arg_shift+=1" ) & set "_h2p_norun=true" ) & goto :eof )
        for %%g in ( false no  off nay disable "-" hecka-no denied IDontThinkSo under9000 NoMilk ) do if /i "-%~2" equ "-%%~g"  ( ( ( set /a "_h2p_arg_shift+=1" ) & set "_h2p_norun="     ) & goto :eof )
        goto :eof
    ) 
    

    
    rem  unresolved unnamed args
    if /i  "%~1" neq "" (
        rem unless defined, 1st param: url, 2nd param: output file
        if not defined h2p_url ( 
            set "h2p_url=%h2p_currArg{One}%"
        ) else if not defined h2p_output set "h2p_output=%~1"
        set /a "_h2p_arg_shift+=1"
        goto :eof
    ) 
    
    rem  .pdf extension args 
    if /i  "%~x1" equ ".pdf" (
        if not defined h2p_output set "h2p_output=%~1"
        goto :eof
    ) 

    rem  End of Args Parse  


goto :eof

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

::  Usage  ::  func_h2p_a_whole_new_world  "varPrefix-optional"
rem  Resets the h2p world back to square zero (or .5)
rem    Note: YOU CAN BREAK YOUR SYSTEM!! 
rem          Clean inputs make clean outputs. [x] EzCheese
:func_h2p_a_whole_new_world
    if "%~1" neq "" ( for /f "usebackq tokens=1 delims==" %%V in ( `set %1` ) do set "%%~V=" 
    ) 2>nul else    ( for %%K in ( h2p_ ; _h2p_ ; debug_h2p_ ) do if "%%~K" neq "" for /f "usebackq tokens=1 delims==" %%V in (` set %%K `) do set "%%~V="
    ) 2>nul

goto :eof



::  Usage  :: func_h2p_aprocess_varset  
rem  Runs command line with current env state.
rem  Note: This is to enable mutliple runs in one session.
rem    First, Evaluates current variable set for errors. attempts to fix any issues or Prompts user as needed.
rem    Next,  runs Main -- http to pdf
rem    Last,  clear subprocess vars
:func_h2p_aprocess_varset
    rem  to disable other execution methods
    if /i "%~1" equ "run" set /a "_h2p_runAcnt+=1"
    set /a "_h2p_runTcnt+=1"

    rem  check n fix dependencies; error when unresolved
    call :func_h2p_check_deps   h2p_errcnt
    if not "%h2p_errcnt%" equ "0" ( ( echo/ Error: %h2p_errcnt% checks failed, cannot continue) & exit /b %h2p_errcnt% ) 1>&2
    
    rem  run bin to generate pdf from url
    call :func_h2p_gen_pdf
    
    rem  reset/unset session run vars
    call :func_h2p_a_whole_new_world  "h2p_" 2>nul 1>nul 

goto :eof


::  Usage  ::  func_h2p_check_deps  returnVar
rem  checks dependencies.  
rem    Errlvl   0  =  No failures
rem    Errlvl 1##  =  Failed 1## of checks
rem    Errlvl 456  =  Function took a crap
:func_h2p_check_deps
    if "%~1" equ "" ( ( call %~0  "h2p_errcnt" ) & goto :eof ) else set "%~1=0"

    rem  resolve when unset
    REM call :func_h2p_fix_url
    if not defined h2p_url          call :func_h2p_get_user_input        "h2p_url"     "&echo/  Input: User: Enter url or html location"   ""
    if not defined _h2p_binary      call :func_h2p_whereForFile       "_h2p_binary"    "wkhtmltopdf.exe"       true 
    if not exist "%_h2p_binary%"    call :func_h2p_whereForFile       "_h2p_binary"    "wkhtmltopdf.exe"       true 

    rem  resolve output filename when unset; auto var check
    if not defined h2p_output if defined _h2p_auto_output (
           call :func_h2p_guess_auto       h2p_output
    ) else call :func_h2p_guess_n_ask     "h2p_output"    "%h2p_url%"

    
    rem  resolve output filename when unset; auto name check
    rem    'auto' session when you want 'auto' to be permenant in the ; otherwise leave commented below (after ~100 chars), "set _h2p_auto_output" command  
    for %%A in ( a auto ) do if /i "-%%~A" equ "-%h2p_output%" call :func_h2p_guess_auto h2p_output

    rem  prefix affix
    if "%h2p_output:~-1,1%" equ "\" call :func_h2p_outdir_prefix_auto  h2p_output  "%h2p_output%"
    if "%h2p_output:~-1,1%" equ "/" call :func_h2p_outdir_prefix_auto  h2p_output  "%h2p_output%"
    
    rem  AUTO resolve output filename when still unset; "this should never happen..." said NoOne, ever
    if not defined h2p_output       call :func_h2p_guess_auto          h2p_output

    rem  error when unset
    if not defined h2p_url       set /a "%~1+=1"
    if not defined h2p_output    set /a "%~1+=1"
    if not defined _h2p_binary ( set /a "%~1+=1" ) else if not exist "%_h2p_binary%" set /a "%~1+=1"

    if not defined %~1 exit /b 456

    for /f "tokens=1,* delims==" %%U in ('set %~1') do exit /b %%~V
    exit /b
    
goto :eof



::  Usage  ::  func_h2p_outdir_prefix_auto   "returnVar"   "prefix\Path\And\Or\Name"
rem  Auto generates filename and prepends string before it.  Does this only once (unless var h2p_preVar is cleared)
:func_h2p_outdir_prefix_auto
    if defined h2p_preVar ( goto :eof ) else if "%~1" equ "" ( goto :eof ) else if "%~2" equ "" (
        for /f "tokens=1,* delims=" %%A in ('set %1') do call %~0 "%%~B"
        goto :eof
    ) 2>nul

    set "h2p_preVar=%~2"
    set "%~1="

    call :func_h2p_guess_auto  %1
    if not defined %~1 ( ( set "%~1=%h2p_preVar%" ) & goto :eof )
    
    for /f "tokens=1,* delims==" %%A in ('set %~1') do set "%%~A=%h2p_preVar%%%~B"
    
goto :eof


::  Usage  ::  func_h2p_gen_pdf  boolSwitch(optional("norun"))
rem  "Runs" "Bin" with optional params
rem    Note: ONLY When all dependencies met and set: _h2p_binary _h2p_bin_opts, h2p_url, h2p_output
rem    Note: "Runs" -- Console does eval, cannot use "call" due url substitution errors in the sub-process. 
rem          Why - a percentage symbol gets removed per occurance
rem          Remedies - could pre-pad the symbols.  expensive, djanky bunctions: 
rem             func_h2p_fix_url_25x -- pads upto 25 instances -- 
rem             func_h2p_fix_url_51x -- pads upto 51 instances -- VERY expensive load 
rem    Note: When "norun" is passed in as param1, leaves bunction before command "runs"
:func_h2p_gen_pdf
    if defined _h2p_silent ( call %~0 %*
        goto :eof
    ) 2>nul 1>nul
    
    for %%V in ( _h2p_binary ; h2p_output ; h2p_url ) do if not defined %%~V goto :eof
    if /i "%~1" equ "norun" set "_h2p_norun=true" 
    
    if defined _h2p_norun echo/ Info: NoRun[%_h2p_norun%]: & echo "%_h2p_binary%" %_h2p_add_opts% %_h2p_bin_opts% "%h2p_url%" "%h2p_output%"
    if defined _h2p_norun goto :eof

    "%_h2p_binary%" %_h2p_add_opts% %_h2p_bin_opts% "%h2p_url%" "%h2p_output%"
    if %errorlevel%. neq 0. echo/ Warning: exitcode: [%errorlevel%] from %_h2p_binary% 

    if exist "%h2p_output%" ( for %%A in ("%h2p_output%") do if not "%%~zA" gtr "0" (
        echo/ Warning: New File: [%%~zA B]:
    ) else  echo/ Info: New File: [%%~zA B]:
    ) else echo/ Error: New File: [Missing]:
    echo "%h2p_output%"
    
goto :eof



::  Usage  ::  func_h2p_get_time_string   returnVar
rem  Returns string with YYYY.MM.DD.TimeInSecs
:func_h2p_get_time_string
    if "%~1" equ "" goto :eof

    call :func_h2p_calc_timestamp h2p_dtsecs_ "%time%"
    if not defined h2p_dtsecs_ ( set "%~1=%date:~-4,4%.%date:~4,2%.%date:~7,2%"
	) else set "%~1=%date:~-4,4%.%date:~4,2%.%date:~7,2%.%h2p_dtsecs_%"
    
    set "h2p_dtsecs_="

    if not defined %~1 exit /b 1
    exit /b 0
    
goto :eof


::  Usage  ::   func_h2p_calc_timestamp   returnVar  time-optional
rem  Returns elapsed time in secs 
rem  Note: When using time-optional, MUST be in format "HH:MM:SS.MS"
rem     Tip: if you dont have the whole string, you can just use 00 for the missing parts. Example, missing ms: "HH:MM:SS.00"
:func_h2p_calc_timestamp
    rem  Choose the bunction calc below and use goto to point to it
    goto func_h2p_calc_timestamp_ezrnd_ms
    
rem ~~~~~~~~~~~~ sec calc below ~~~~~~~~~~~~

    rem calc secs in today -- rounds 51ms+ to 1 sec and w/a for octals by ((1xx + 1xx) / 300)
    :func_h2p_calc_timestamp_ezrnd_ms
        if "%~1" equ "" goto :eof
        if "%~2" neq "" ( set "_scest=%~2" ) else set "_scest=%time%"
        
        set /a "%~1=((1%_scest:~-2% + 1%_scest:~-2%) / 300) + (1%_scest:~-5,2% - 100) + ((1%_scest:~3,2% - 100) * 60 ) + ((%_scest:~0,2% * 60) * 60)"
        set "_scest="
    goto :eof
    
    rem calc secs in today -- rounds 51ms+ to 1 sec and w/a for octals -- extra steps to round 51ms+ to secs
    :func_h2p_calc_time_nezrnd_ms
        if "%~1" equ "" goto :eof
        if "%~2" neq "" ( set "_scest=%~2" ) else set "_scest=%time%"

        set /a "%~1=(1%_scest:~-5,2% - 100) + ((1%_scest:~3,2% - 100) * 60 ) + ((%_scest:~0,2% * 60) * 60)"
        if defined %~1 if %_scest:~-2,2% gtr 50 set /a "%~1+=1"
        set "_scest="
    goto :eof

    rem calc secs in today -- archived 01/11/2018
    rem   works, has a issue when trying to work with non-octal numbers like: 07,08,09
    rem   no support for supplied time
    :func_h2p_01112018_calc_time_secs
        if "%~1" neq "" set /a "%~1=%time:~-5,2% + (%time:~3,2% * 60 ) + ((%time:~0,2% * 60) * 60)"
    goto :eof
    
rem ~~~~~~~~~~~~ mss calc below ~~~~~~~~~~~~
    
    rem calc ms in today -- no support for supplied time
    :func_h2p_time_calc_today_ms
        if "%~1" equ "" goto :eof
        set /a "%~1=( 1%time:~-2% - 100 ) + (( 1%time:~-5,2% - 100 ) * 1000) + (( 1%time:~3,2% - 100 ) * 60000 ) + (( %time:~0,2% + 2 - 2) * 3600000)"
        set /a "%~1+=0"
    goto :eof

    rem calc ms in today OR a suppyled HH:MM:SS.MS time
    :func_h2p_time_calc_ms
        if "%~1" equ "" goto :eof
        if "%~2" neq "" ( set "_smst=%~2" ) else set "_smst=%time%"

        set /a "%~1=( 1%_smst:~-2% - 100 ) + (( 1%_smst:~-5,2% - 100 ) * 1000) + (( 1%_smst:~3,2% - 100 ) * 60000 ) + (( %_smst:~0,2% + 2 - 2) * 3600000)"
        set "_smst="
    goto :eof

rem ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
goto :eof


::  Usage  :: func_h2p_get_user_input  returnVar   msgText-Optional   defaultResponse-Optional
rem  Prompts User for input
rem    Quoted parameters optional, double-quotes will be dropped regardless, White-spaces ignored between params
rem    Example:   func_h2p_get_user_input   varUserFeedback   "Input: User: Did you like %~nx0"   "N/A"
:func_h2p_get_user_input
    if "%~1" equ "" goto :eof

    if "%~2" neq "" echo/%~2
    if "%~3" neq "" set "%~1=%~3"
    if "%~3" neq "" echo/   [Default: %3]

    set /p "%~1= ~> "

goto :eof



::  Usage  :: func_h2p_guess_auto   returnVar   "url"
rem  Generate descriptive output names. Respective of 
rem    1 - Generates a name based on the url.timestamp
rem    2 - Generates a name based on the tld.timestamp
rem    3 - Generates a name with a timestamp
:func_h2p_guess_auto
    if "%~1" equ "" exit /b 456
    if "%~2" equ "" if defined h2p_url (
        call %~0   %1   "%h2p_url%"
        goto :eof
    )
    
    call :func_h2p_get_time_string h2p_YyyyMmDdSecs
    set "%~1="
    
    rem timestamp -- leave early
    set "%~1=%h2p_YyyyMmDdSecs%.pdf"
    if "%~2" equ "" goto :eof
    
    rem url -- leave early
    REM call :func_h2p_guess_outname   "%~1"  "%~2"
    call :func_h2p_guess_outname   "%~1"  h2p_url
    if defined %~1 (
        for /f "tokens=1,* delims==" %%A in ('set "%~1"') do set "%~1=%%~B.%h2p_YyyyMmDdSecs%.pdf"
        goto :eof
    )
    
    rem tld
    for /f "tokens=2 delims==/?!&,;@#" %%B in ("%~2") do set "%~1=%%~B.%h2p_YyyyMmDdSecs%.pdf"

    set "h2p_YyyyMmDdSecs="
goto :eof



::  Usage  :: func_h2p_guess_n_ask   returnVar   "url"
rem  Generates three names, then prompts user (once) if they want to change it
rem    1 - Generates a file name based on the url.timestamp, then prompts user if they want to change it
rem    2 - Generates a file name based on the tld.timestamp, then prompts user if they want to change it
rem    3 - Generates a file name with a timestamp, then prompts user if they want to change it
:func_h2p_guess_n_ask

    call :func_h2p_get_time_string h2p_YyyyMmDdSecs

    REM call :func_h2p_guess_outname   "%~1"  "%~2"
    call :func_h2p_guess_outname   "%~1"  h2p_url

    if defined %~1     for /f "tokens=1,* delims==" %%A in ('set "%~1"') do call :func_h2p_get_user_input  "%~1"  "&echo/  Input: User: Enter output path\filename"   "%%~B.%h2p_YyyyMmDdSecs%.pdf"
    if not defined %~1 for /f "tokens=2 delims==/?!&,;@#" %%B in ("%~2") do call :func_h2p_get_user_input  "%~1"  "&echo/  Input: User: Enter output path\filename"   "%%~B.%h2p_YyyyMmDdSecs%.pdf"
    if not defined %~1 call :func_h2p_get_user_input  "%~1"  "&echo/  Input: User: Enter output path\filename"   "%h2p_YyyyMmDdSecs%" 

    set "h2p_YyyyMmDdSecs="

goto :eof


::  Usage  :: func_h2p_guess_outname  returnVar  "urlVarNameOrString"
rem  Creates a recommendation for an output file name
:func_h2p_guess_outname
    if "%~2" equ "" exit /b 456
    if "%~1" equ "" exit /b 456
    
    if not defined %2 ( 
        set "url_outGuess{Two}=%~2"
    ) else call set "url_outGuess{Two}=%%%~2%%"

    call :func_h2p_url_decode  "url_outGuess{Two}"  %2

    set "h2p_clncntr="
    set "%~1="
    
    rem  Supa-Lazy name
    for /f "tokens=* delims=" %%A in ( "%url_outGuess{Two}%"
    ) do if "%%~nxA" neq "" set "%~1=%%~nxA.%computername%"

    rem  Guesstimate amount of crap to clean up; ( 2(A+B) + Num-Url-Parts )
    for /f "tokens=1-26 delims==/?!&,;@\" %%A in ( "%url_outGuess{Two}%"
    ) do if "%%~A" neq "" (
        if "%%~A" neq "file:" set "%~1=%%~C %%~D %%~E %%~F %%~G %%~H %%~I %%~J %%~K %%~L %%~M %%~N %%~O %%~P %%~Q %%~R %%~S %%~T %%~U %%~V %%~W %%~X %%~Y %%~Z.%%~B"

        for %%g in ( %%A %%B %%C %%D %%E %%F %%G %%H %%I %%J %%K %%L %%M %%N %%O %%P %%Q %%R %%S %%T %%U %%V %%W %%X %%Y %%Z 
        ) do if "%%~g" neq "" set /a "h2p_clncntr+=1"
    )
    
    if not defined %~1 exit /b 1
    if not defined h2p_clncntr set "h2p_clncntr=20"
    
    for /l %%A in (1,1,%h2p_clncntr%) do call :sub_chqNstrp__h2p_guess_outname "%~1"  "%%~A"

    exit /b 0
    
goto :eof


    ::  Usage  ::  guess_outname_chqNstrp   "keyVar"  "optional-loopDebugCount"
    rem  Janitor of "_.-?"
    :sub_chqNstrp__h2p_guess_outname
        rem insanity check
        if "%~1" equ "" exit /b 456
        
        rem  define, strip and clean -- characers/spaces can be weird and messy
        REM for /f "tokens=1,* delims==" %%U in ('set "%~1"') do call set "h2p_go_sA_=%%~V"
        call set "h2p_go_sA_=%%%~1%%"
        
        rem  scrub-de-dub-do-dat~dampt. *looks around*
        rem    starts sing'n:  "scrub-de-dub-do-dat~damt-dum-ding-clang-clash, popt-dupt-phromt-dead-deddeddeddendt. done-pun-bang-poptposhphrosh"
        set "h2p_go_sA_=%h2p_go_sA_:?= %"
        set "h2p_go_sA_=%h2p_go_sA_:.www.=.%"
        set "h2p_go_sA_=%h2p_go_sA_:..=.%"
        set "h2p_go_sA_=%h2p_go_sA_:__=_%"
        set "h2p_go_sA_=%h2p_go_sA_:--=-%"
        set "h2p_go_sA_=%h2p_go_sA_:    = %"
        set "h2p_go_sA_=%h2p_go_sA_:  = %"
        set "h2p_go_sA_=%h2p_go_sA_:_ =_%"
        set "h2p_go_sA_=%h2p_go_sA_:- =-%"
        set "h2p_go_sA_=%h2p_go_sA_:. =.%"
        set "h2p_go_sA_=%h2p_go_sA_:  = %"
        set "h2p_go_sA_=%h2p_go_sA_: _=_%"
        set "h2p_go_sA_=%h2p_go_sA_: -=-%"
        set "h2p_go_sA_=%h2p_go_sA_: .=.%"
        
        rem  wash string in the front, then the back
        for %%E in ( "-";" ";" ";"_";".";"+") do if "%h2p_go_sA_:~0,1%"  equ "%%~E" call set "h2p_go_sA_=%h2p_go_sA_:~1%"
        for %%E in ( "-";" ";" ";"_";".";"+") do if "%h2p_go_sA_:~-1,1%" equ "%%~E" call set "h2p_go_sA_=%h2p_go_sA_:~0,-1%"
        
        rem  rinse, toss var back on and done
        set "%~1=%h2p_go_sA_%"
        set "h2p_go_sA_="
    
    goto :eof


::  Usage  ::  func_h2p_url_decode   returnVar   varNameOrString
rem  Converts URL from encoded (alt hex codes) characters to their ASCII/UTF equivalent 
rem  Note:  This method is NOT PERFECT and has issues (as in multiple percentage signs next to each other are treated as 1 percentage sign): example, function sees: 100%%%%%001  => 100%001
rem  Note, partial legend below:
rem       :::: Reserved characters after percent-encoding
rem       ::   !	#	$	&	'	(	)	*	+	,	/	:	;	=	?	@	[	]
rem       ::  %21	%23	%24	%26	%27	%28	%29	%2A	%2B	%2C	%2F	%3A	%3B	%3D	%3F	%40	%5B	%5D
rem       ::
rem       :::: Common characters after percent-encoding (ASCII or UTF-8 based) 
rem       ::  wsp = whitespace
rem       ::   CR	LF	wsp	"	%	-	.	<	>	\	^	_	`	{	|	}	~
rem       ::  %0D	%0A	%20	%22	%25	%2D	%2E	%3C	%3E	%5C	%5E	%5F	%60	%7B	%7C	%7D	%7E
:func_h2p_url_decode
    if "%~2" equ "" goto :eof
    if "%~1" equ "" goto :eof

    rem  Get the string (when string IS A VARIABLE, value as the string supersedes the varName)
    set "url_decode{Two}=%~2"
    if defined %2 call set "url_decode{Two}=%%%~2%%"

    rem  prep/run subroutine
    set "url_decode{A}="
    set "url_decode{B}=%url_decode{Two}%"
    call :subr_h2p_acsii_alt2chr_loop
    
    rem  return converted string 
    set "%~1=%url_decode{A}%"
    set "url_decode{A}="
    set "url_decode{B}="
    
    goto :eof

    rem  ________________________________________________________
    rem  --------------------------------------------------------
    rem  below loop consists of 255 ASCII characters for decoding
    rem     ---  Character Code Information/Description  ---  
    rem  ________________________________________________________
    rem  --------------------------------------------------------
    rem  
    rem  - ASCII control character codes 00-1F [Decimal 0-31] 
    rem  --- unprintable control codes used to control devices
    rem  
    rem  - ASCII printable character codes 20-7F [Decimal 32-127] 
    rem  --- 'printable characters' - typical keyboard characters
    rem  
    rem  - extended ASCII character codes 80-FF [decimal 128-255] 
    rem  --- ISO 8859-1, aka ISO Latin-1
    rem  --- Microsoft® Windows Latin-1 extended character codes:
    rem  ----- 81-9F [decimal 129-159]
    rem  ________________________________________________________
    rem  --------------------------------------------------------
    :subr_h2p_acsii_alt2chr_loop
        if not defined url_decode{B} goto :eof

        if "%url_decode{B}:~0,1%" equ "%%" (
            for /f "tokens=* delims=%%" %%A in (
                "%url_decode{B}%"
            ) do (
                set "url_decode{B}=%%%%~A"
                if "%%~A" equ "" goto :eof
            ) 
        ) else for /f "tokens=1* delims=%%" %%A in (
            "%url_decode{B}%"
        ) do (
            set "url_decode{B}=%%%%~B"
            set "url_decode{A}=%url_decode{A}%%%~A"
            if "%%~B" equ "" goto :eof
        ) 

        rem  Manual replacement for these problematic characters:
        rem  --  "22|""; "2A|*"; "3F|?"; "7C||"; 
        if    "%url_decode{B}:~1,2%" equ "22" set "url_decode{A}=%url_decode{A}%""
        if /i "%url_decode{B}:~1,2%" equ "2A" set "url_decode{A}=%url_decode{A}%*"
        if /i "%url_decode{B}:~1,2%" equ "3F" set "url_decode{A}=%url_decode{A}%?"
        if /i "%url_decode{B}:~1,2%" equ "7C" set "url_decode{A}=%url_decode{A}%|"

        rem  replacing 'lineFeed' (0A) with a 'whitespace' and 'carriageReturn' (0D) with nothing 
        @for %%A in (
            "00|";  "01|";  "02|";  "03|";  "04|";  "05|";  "06|";  "07|";  "08|";  "09|";  "0A| "; "0B|";  "0C|";  "0D|";  "0E|";  "0F|";  
            "10|";  "11|";  "12|";  "13|";  "14|";  "15|";  "16|";  "17|";  "18|";  "19|";  "1A|";  "1B|";  "1C|";  "1D|";  "1E|";  "1F|";  
            "20| "; "21|!"; "22|";  "23|#"; "24|$"; "25|%"; "26|&"; "27|'"; "28|("; "29|4"; "2A|";  "2B|+"; "2C|,"; "2D|-"; "2E|."; "2F|/";
            "30|0"; "31|1"; "32|2"; "33|3"; "34|4"; "35|5"; "36|6"; "37|7"; "38|8"; "39|9"; "3A|:"; "3B|;"; "3C|<"; "3D|="; "3E|>"; "3F|";
            "40|@"; "41|A"; "42|B"; "43|C"; "44|D"; "45|E"; "46|F"; "47|G"; "48|H"; "49|I"; "4A|J"; "4B|K"; "4C|L"; "4D|M"; "4E|N"; "4F|O";
            "50|P"; "51|Q"; "52|R"; "53|S"; "54|T"; "55|U"; "56|V"; "57|W"; "58|X"; "59|Y"; "5A|Z"; "5B|["; "5C|\"; "5D|9"; "5E|^"; "5F|_";
            "60|`"; "61|a"; "62|b"; "63|c"; "64|d"; "65|e"; "66|f"; "67|g"; "68|h"; "69|i"; "6A|j"; "6B|k"; "6C|l"; "6D|m"; "6E|n"; "6F|o";
            "70|p"; "71|q"; "72|r"; "73|s"; "74|t"; "75|u"; "76|v"; "77|w"; "78|x"; "79|y"; "7A|z"; "7B|{"; "7C|";  "7D|}"; "7E|~"; "7F|";
            "E0|à"; "E1|á"; "E2|â"; "E3|ã"; "E4|ä"; "E5|å"; "E6|æ"; "E7|ç"; "E8|è"; "E9|é"; "EA|ê"; "EB|ë"; "EC|ì"; "ED|í"; "EE|î"; "EF|ï";
            "80|€"; "81|";  "82|‚"; "83|ƒ"; "84|„"; "85|…"; "86|†"; "87|‡"; "88|ˆ"; "89|‰"; "8A|Š"; "8B|‹"; "8C|Œ"; "8D|";  "8E|Ž"; "8F|"; 
            "90|";  "91|‘"; "92|’"; "93|“"; "94|”"; "95|•"; "96|–"; "97|—"; "98|˜"; "99|™"; "9A|š"; "9B|›"; "9C|œ"; "9D|";  "9E|ž"; "9F|Ÿ";
            "A0| "; "A1|¡"; "A2|¢"; "A3|£"; "A4|¤"; "A5|¥"; "A6|¦"; "A7|§"; "A8|¨"; "A9|©"; "AA|ª"; "AB|«"; "AC|¬"; "AD|­"; "AE|®"; "AF|¯";
            "B0|°"; "B1|±"; "B2|²"; "B3|³"; "B4|´"; "B5|µ"; "B6|¶"; "B7|·"; "B8|¸"; "B9|¹"; "BA|º"; "BB|»"; "BC|¼"; "BD|½"; "BE|¾"; "BF|¿";
            "C0|À"; "C1|Á"; "C2|Â"; "C3|Ã"; "C4|Ä"; "C5|Å"; "C6|Æ"; "C7|Ç"; "C8|È"; "C9|É"; "CA|Ê"; "CB|Ë"; "CC|Ì"; "CD|Í"; "CE|Î"; "CF|Ï";
            "D0|Ð"; "D1|Ñ"; "D2|Ò"; "D3|Ó"; "D4|Ô"; "D5|Õ"; "D6|Ö"; "D7|×"; "D8|Ø"; "D9|Ù"; "DA|Ú"; "DB|Û"; "DC|Ü"; "DD|Ý"; "DE|Þ"; "DF|ß";
            "F0|ð"; "F1|ñ"; "F2|ò"; "F3|ó"; "F4|ô"; "F5|õ"; "F6|ö"; "F7|÷"; "F8|ø"; "F9|ù"; "FA|ú"; "FB|û"; "FC|ü"; "FD|ý"; "FE|þ"; "FF|ÿ";
        ) do for /f "tokens=1,2 delims=|" %%B in ( 
            "%%~A"
        ) do if /i "%url_decode{B}:~1,2%" equ "%%~B" (
            rem  when the value matches, replace character and remove the alt hex code
            set "url_decode{A}=%url_decode{A}%%%~C"
            set "url_decode{B}=%url_decode{B}:~3%"
            goto %~0
        )

        rem  when the value does NOT match, move string to base-string and remove from check-string
        set "url_decode{A}=%url_decode{A}%%url_decode{B}:~0,3%"
        set "url_decode{B}=%url_decode{B}:~3%"

    goto %~0

goto :eof



::  Usage  ::  func_h2p_whereForFile  returnVar   "FileOrBinaryName" 
rem  returns param1 set to found path. Uses pure batch method to locate the binary in param2
:func_h2p_whereForFile
    if "%~2" equ "" ( exit /b 456 ) else if "%~1" equ "" ( exit /b 456 ) else set "%~1="

    rem  Add to search path: script dir, current directory, pathVar
    set "h2p_8O08=%~dp2;%cd%;%PATH%"

    rem  Search PATH/CD/scriptDir using environment extension-list ( and fileExt ) for the desired file
    for %%P in (
        "%~2"
    ) do for %%e in (
        %~x2 ; %PATHEXT%
    ) do for %%i in (
        "%%~nP%%e" 
    ) do if not "%%~$h2p_8O08:i" equ "" set "%~1=%%~$h2p_8O08:i"

    rem  Cleanup func vars
    set "h2p_8O08="

    rem  When undefined, leave with errorLevel 1
    if not defined %~1 exit /b 1

goto :eof

    
::  Usage  ::  func_h2p_where_bin  returnVar   "path\BinaryName.ext"   "onlyOne-trueBool-optional"
rem  returns param1 set to found path. Uses where.exe to locate the binary in param2
rem    Note:  Param3 is an optional Bool, Returns only first path when multiple are found
:func_h2p_where_bin
    if "%~2" equ "" ( exit /b 456 ) else if "%~1" equ "" ( exit /b 456 ) else set "%~1="
    
    for /f "delims=" %%W in ('"%SystemRoot%\system32\where.exe" /f "%~2"') do if "%%~W" neq "" if "%~3" neq "" ( if not defined %~1 set "%~1=%%~W"
        exit /b 0
    ) else call :func_h2p_concatList  "%~1" "%%~W"

    if defined %~1 exit /b 0
    exit /b 1

goto :eof
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::



::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::: Internal Debug Bunctions (and dependencies)
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

::  Usage  ::  func_h2p_concatList  keyVar  valueListItem   valueListItem2   valueListItem3   valueListItemEtc
rem  Concats items into a list, similar to an array -- define/addto keyParam1: params2, and above as values
rem  Note:  Double-Quotes stick to list values
rem    Example: func  "myList" "Kelly and Megan" "Sam and Stan"     Joe Sarah Mike
rem    Returns:        myList="Kelly and Megan" ; "Sam and Stan" ; Joe ; Sarah ; Mike
:func_h2p_concatList
    if "%~2" equ "" goto :eof
    if "%~1" equ "" goto :eof
    
    if "%~3" neq "" for %%A in ( 
        %*
    ) do if "%%~A" neq "%~1" call %~0 "%~1" %%A
    if "%~3" neq "" goto :eof
    
    if defined %~1 for /f "tokens=1,* delims==" %%U in ('set %~1') do if "%%~V" neq "" set "%~1=%%V ; %2"
    if not defined %~1 set "%~1=%2"
goto :eof



::  Usage  ::  func_h2p_time_calc_today_ms  ReturnVar
rem calc ms in today -- no support for supplied time
:func_h2p_calc_time_ms
    if "%~1" equ "" goto :eof
    set /a "%~1=( 1%time:~-2% - 100 ) + (( 1%time:~-5,2% - 100 ) * 1000) + (( 1%time:~3,2% - 100 ) * 60000 ) + (( %time:~0,2% + 2 - 2) * 3600000)"
    set "%~1+=0"
goto :eof
    
    

:: Usage :: func_h2p_dump_debug_msg  MsgTextORHeaderText-Optional   MsgText-Optional   doNotDumpVarsFlag-Optional
rem Prints messages from params 1 and 2 and dumps all script vars if param 3 is undef
rem   Examples  ---  To dump all vars and not print other messages       ---  func     ""            ""  
rem             ---  To print MsgHeader and MsgText without dumping Vars ---  func   "INIT: " "Errorlevel is !errorlevel!"  0
rem   Note:  Originally this was split into 3 bunctions to better display/understand the inner mechz, but, this script needs to be as lean as possible.
:func_h2p_dump_debug_msg
    if "%~1" equ "" if "%~3" neq "" goto :eof
    
    set "_h2p__ddbgln_A="
    
    if "%~1" neq "" if defined debug_h2p_grab_lnum for /f "eol=- tokens=1 delims=[]" %%A in (
        'find /N "%~1" "%~dpnx0"'
    ) do if "/%%~A" neq "/" call :func_h2p_concatList  _h2p__ddbgln_A  %%A
    
    if defined _h2p__ddbgln_A set "_h2p__ddbgln_A=Line: [ %_h2p__ddbgln_A% ]:"
    call :func_h2p_calc_time_ms  "_h2p__ddbgsnd_A"
    if defined _h2p__ddbgsnd_A set "_h2p__ddbgsnd_A=.%_h2p__ddbgsnd_A%"
    
    if "/%~1" neq "/" echo/    Debug: %date:~-2%%date:~4,2%%date:~7,2%%_h2p__ddbgsnd_A%: %_h2p__ddbgln_A% "%~1%~2"
    if "/%~3" neq "/" goto :eof
    
    for /f "tokens=1,* delims==" %%V in ('set h2p_') do if "%%~V" neq "" echo/    Debug: %date:~-2%%date:~4,2%%date:~7,2%%_h2p__ddbgsnd_A%: %_h2p__ddbgln_A% Variable: "%%~V": "%%~W"  
    echo/
    set "_h2p__ddbgsnd_A="
    set "_h2p__ddbgln_A="
goto :eof
    rem  calc ms with octal issue
    REM set /a "_h2p__ddbgsnd_A=(%time:~-2% + 2 - 2) + ((%time:~-5,2% + 2 - 2) * 1000) + ((%time:~3,2% + 2 - 2 ) * 60000 ) + (( %time:~0,2% + 2 - 2) * 3600000)"
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::


::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::: Args Parse -- Extended
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

::  Usage  ::  func_h2p_pargs_help  optional-NamedArg
rem  help arg parser, accepts args:
rem    %1 all
rem    %1 full
rem    %1 params
rem    %1 vars
rem    %1 variables
:func_h2p_pargs_help
    rem  No args, dump generic help
    if    "%~1" equ "?"    shift /1
    if /i "%~1" equ "h"    shift /1
    if /i "%~1" equ "help" shift /1
    if    "%~1" equ   ""   goto :func_h2p_ahelp_me

    rem  Adjust shift for named args
    for %%g in ( all full params vars variables ) do if /i "%~1" equ "%%~g" set /a "_h2p_arg_shift+=1"
    
    rem  named args
    if /i "%~1" equ "params"    goto :func_h2p_ahelp_params
    if /i "%~1" equ "vars"      goto :func_h2p_ahelp_pars
    if /i "%~1" equ "variables" goto :func_h2p_ahelp_pars

    if /i "%~1" equ "full"   (
        call :func_h2p_ahelp_me
        call :func_h2p_ahelp_params
        call :func_h2p_ahelp_pars
        goto :func_h2p_ahelp_pebug
    )

    if /i "%~1" equ "all" (
        call :func_h2p_ahelp_me
        call :func_h2p_ahelp_params
        call :func_h2p_ahelp_pars
        goto :func_h2p_ahelp_pebug
    )

goto :eof

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
