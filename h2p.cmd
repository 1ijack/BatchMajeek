::  By JaCk  |  Release 01/21/2018  |  https://github.com/1ijack/BatchMajeek/blob/master/h2p.cmd  |  h2p.cmd  --- uses wkhtmltopdf.exe to download and create local pdfs
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
@echo off &if "%~1" equ "--Gogogougo-Gougogo--" ( goto :func_h2p_aprocess_varset ) else setlocal EnableExtensions
goto :func_barg_parg

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
    set "debug_h2p_msgs="                  rem  Dump imbedded debug info during execution, each msg dump adds about 10 ms of additional work
    set "debug_h2p_grab_lnum=yarrr aye"    rem  Dump line number of msg in script. Depends on debug_h2p_msgs
    set "debug_h2p_terse_msgs=jesPlease"   rem  undef is Very Verbose, you would get var dumps per each debug msg call and debug debug dumps.  Depends on debug_h2p_msgs
goto :eof
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

::: Bunctions
goto :eof rem   -- When you think you've seen it all... Fatch out for Bunctions. [x] EzCheese
          rem   -- Bunc'in Fatches Since DOS.  Where you werent set/pack= with a prompt all the time, you had choice  [x] Yeah-I-Went-There

::  Usage  ::  func_h2p_ahelp_me
rem  Dumps loads and loads of halpsmes.
:func_h2p_ahelp_me
    if defined debug_h2p_msgs call :func_h2p_dump_debug_msg  "Halps meh pl0x"     "%~0 %~1"           "%debug_h2p_terse_msgs%" 
    echo/
    echo/                          --  %~nx0  -- 
    echo/  --  feature-rich wrapper around the feature-rich "wkhtmltopdf" binary  --  
    echo/                              -- - -- 
    echo/%~nx0 Help: Me
    echo/         %~nx0  "httplink"  "filename"
    echo/   
    echo/   Autofilename:  for script generated output filename, use "auto"
    echo/         %~nx0  "httplink"    "auto"
    echo/   
    echo/   Explicit Args:  for more details use: %~nx0 --help:params
    echo/         %~nx0 --url:"url"  --output:auto
    echo/         %~nx0 -u:"url&funk?chrs" -o:"file name.pdf"
    echo/   
    echo/       Note:  Semi-colons and white-spaces are parameter separators (unless double-quoted)
    echo/       Note:  When setting arg's value, do not use spaces\semi-colons. Use colon instead
    echo/         Good: --arg:value  ^|^|  Bad:  --arg value  ^|^|   Bad:  --arg;value
    echo/   
    echo/   Multiple Links/files:  
    echo/         %~nx0  url1;file1;go;  url2  file2  go  ; [etc]
    echo/         %~nx0 ["http://url/1"];["1.pdf"^|auto];[done^|run^|go];  ["ftp://url/2"]  ["2url.pdf"^|auto]  [done^|run^|go] ; [etc]
    echo/    
    echo/       Note:  parameters\args "go,run,done" are used to tell the script to process the args submitted and reset for more args
    echo/    
    echo/   More help options: 
    echo/         %~nx0 --help:[params^|vars^|variables^|debug^|full]
    echo/    
    echo/    
goto :eof

::  Usage  ::  func_h2p_ahelp_params
rem  Dumps loads and loads of halps.
rem  Like, everywhere
:func_h2p_ahelp_params
    if defined debug_h2p_msgs call :func_h2p_dump_debug_msg  "Halps params pl0x"     "%~0"           "%debug_h2p_terse_msgs%" 
    echo/
    echo/%~nx0 Help: Params 
    echo/
    echo/  Howto: Argument additional values
    echo/  - Quotes: 
    echo/      Use "double-quotes" around values that include: special characters, white-spaces, groups
    echo/        Hint: always add quotes unless you know that you dont need them. Some examples under "Accepted Parameters"
    echo/      Do not double-quote key with the value  
    echo/         Fail: "-u:http://a.url"  ^|^|  OK: -u:"http://a.url"
    echo/
    echo/  - Key\Value Pairs (argument definitions): 
    echo/      Use colon for argument definitions, DO NOT USE white-spaces, they are argument sperators
    echo/         Fail:  --key value  ^|^|  Fail: "--key:value"   [notice the misplaced quotes]
    echo/         OK:    --key:value   
    echo/  
    echo/  Accepted Parameters:
    echo/               /?, -h, --help   Displays the help info, Additional options:
    echo/                --help:params     params - dump argument\parameter usage
    echo/                 --help:debug     debug - dump debug\advanced usage
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
goto :eof

::  Usage  ::  func_h2p_ahelp_pebug
rem  Dumps brickloads of halps to stdout
:func_h2p_ahelp_pars
    if defined debug_h2p_msgs call :func_h2p_dump_debug_msg  "Halps vars pl0x"     "%~0"           "%debug_h2p_terse_msgs%" 
    echo/      
    echo/%~nx0 Help: Script Variables 
    echo/      
    echo/  Note: edit script, look within the first  20 lines
    echo/        - var names are BEFORE the "=", values are AFTER the "=", example: "varName=value"
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
    echo/    Note: definition of "boolSwitch" in the eyes of %~nx0
    echo/     - these settings are true when defined by ANY value(s)
    echo/     - these settings are false and ignored when undefined
    echo/
    echo/           "_h2p_auto_output"  Suppresses PROMPTING for output file, but instead generates one automaticly.
    echo/                               - ignored when using arg-prefix: -o:"", --output:"", -a, --auto
    echo/                               - ignored when using arg-param2 as output filename 
    echo/                               - ignored when h2p_output is defined
    echo/
    echo/             "debug_h2p_msgs"  Debug flag, when true, starts script with debug msgs
    echo/                               - change to "false" args: --debug:off, --debug:output:off, --debug:output:info:on
    echo/                               - change to "true"  agrs: --debug:on,  --debug:output:on,  --debug:output:info:off
    echo/
    echo/        "debug_h2p_grab_lnum"  Debug behavorial flag, when true, dumps line numbers for all internal debug msgs.
    echo/                               - dependant on "debug_h2p_msgs" setting\state
    echo/                               - some args to modify state: --debug:lines:off, --debug:lines:on
    echo/
    echo/       "debug_h2p_terse_msgs"  Debug behavorial flag, when true, does NOT dump all (non-debug) script vars to console.
    echo/                               - dependant on "debug_h2p_msgs" setting\state
    echo/                               - some args to modify state: --debug:terse:off, --debug:terse:on
    echo/
goto :eof


::  Usage  ::  func_h2p_ahelp_pebug
rem  Imagine a giant halps.  This same gaint halps, is now being dumped to stdout.
rem  Dumps hecka halps, like, too much. halps.
:func_h2p_ahelp_pebug
    if defined debug_h2p_msgs call :func_h2p_dump_debug_msg  "Halps pebug pl0x"     "%~0"           "%debug_h2p_terse_msgs%" 
    echo/
    echo/%~nx0 Help: Adv\Debug
    echo/                      --norun  prints final command to console instead of running;
    echo/ 
    echo/    --binary:"<path\bin.exe>"  Debug: Optional: Use the defined binary instead of Current: 
    echo/          -b:"<path\bin.exe>"    [wkhtmltopdf.exe] "%_h2p_binary%"
    echo/ 
    echo/      --add-opts:"<add opts>"  Debug: Optional: Prepends additional binary parameters 
    echo/              -n:"<add opts>"  Current: 
    echo/                                  %_h2p_add_opts% %_h2p_bin_opts%
    echo/
    echo/Debug Switches: rem ::  %~nx0 -debug:"[[enable|disable]:[trace|lines|output] | [output:[info|terse|verbose|trace]]"
    echo/  Note: Bool Switches 
    echo/    where you see  "on", ok to use instead: true,  +,  yes,  on,  aye, enable,  accepted, hecka-ya, surething,    IAlsoLikeTurtles
    echo/    where you see "off", ok to use instead: false, -,  no,   off, nay, disable, denied,   hecka-no, IDontThinkSo, under9000,  NoMilk
    echo/
    echo/          --debug, --debug:on  Turn on debug messages, Default verbosity: terse
    echo/                  --debug:off    off
    echo/
    echo/              --debug:off:all  Sets all debug options to off+verbose
    echo/              --debug:on:all     on+terse+trace
    echo/
    echo/              --debug:verbose  Toggle on/off [parameter dumps per debug message]
    echo/          --debug:verbose:off    off -- set verbosity to terse
    echo/          --debug:verbose:on     on  -- set verbosity to verbose
    echo/          --debug:off:verbose    off -- set verbosity to terse
    echo/          --debug:on:verbose     on  -- set verbosity to verbose
    echo/
    echo/          --debug:output       Turn on debug output, default verbosity: terse;  trace to off
    echo/          --debug:output:on      on, default verbosity: terse; sets trace to off
    echo/          --debug:output:off     off debug messages; sets trace to off
    echo/    --debug:output:lines:off     off - don't show lines with debug msgs
    echo/    --debug:output:lines:on      on  - do show lines with debug msgs
    echo/    --debug:output:trace:off     off - set echo off -- independent of debug\verbosity settings
    echo/    --debug:output:trace:on      on  - set echo on -- print every script line pre-eval AND post eval;
    echo/                                         independent of debug\verbosity settings
    echo/    --debug:output:info:off      off - turn on debug messages;  sets trace to off
    echo/    --debug:output:info:on       on  - turn off debug messages; sets trace to off
    echo/    --debug:output:terse:off     off - set verbosity to verbose; sets trace to off
    echo/    --debug:output:terse:on      on  - set verbosity to terse;   sets trace to off
    echo/  --debug:output:verbose:off     off - set verbosity to terse;   sets trace to off
    echo/  --debug:output:verbose:on      on  - set verbosity to verbose; sets trace to off
    echo/
    echo/            --debug:terse:off  Terse off -- set verbosity to verbose
    echo/            --debug:terse:on     on   -- set verbosity to terse
    echo/            --debug:off:terse    off  -- set verbosity to verbose
    echo/            --debug:on:terse     on   -- set verbosity to terse
    echo/
    echo/                --debug:trace  Toggle on/off [changes echo on/off] -- independent of debug\verbosity settings
    echo/            --debug:trace:off    off -- changes to echo off -- independent of debug\verbosity settings
    echo/            --debug:trace:on     on  -- changes to echo on  -- independent of debug\verbosity settings
    echo/            --debug:off:trace    off -- changes to echo off -- independent of debug\verbosity settings
    echo/            --debug:on:trace     on  -- changes to echo on  -- independent of debug\verbosity settings
    echo/
    echo/                --debug:lines  Toggle on/off [Dump line numbers in debug msgs]
    echo/            --debug:lines:off    off -- No, don't show line numbers for debug messages.
    echo/            --debug:lines:on     on  -- Yes, show line numbers for debug messages.
    echo/            --debug:off:lines    off -- No, don't show line numbers for debug messages.
    echo/            --debug:on:lines     on  -- Yes, show line numbers for debug messages.
goto :eof



::: Args parse
::  "Barg Parg" or "Farg Barser" -- by Alex Vronskiy
::    Release 10/19/2017 -- You may use this and distribute it freely
rem   Variable to loop mapping
rem   Note: Crappy explanation of for/forf loop's values:
rem        --["variable_X"]   is a raw form of   --["variable_U:variable_V"]   or    --["variable_U"]
rem        --[variable_U]:[variable_V]  or  --[variable_U]=[variable_V]  or just --[variable_U]
rem   
rem   Reminder: loose arg-prefix acceptance (stripped arg-prefix: X, UV): 
rem     These are accepted switches/key-value pairs, each line is evaulated the same
rem       s,   -s,   +s,   --s,   /-s,   /s
rem       k:v, -k:v, +k:v, --k:v, /-k:v, /k:v
rem     
rem     You would think this works, but it doesn't: (the key cannot be separated from the value).  
rem       k v, -k v, --k v, /-k v, /k v    -- it is highly probable that the vars may get "caught" correctly as this script uses ordered vars
rem     
rem     New limitation: cannot use "k=v" OR "?" in the first loop.... The latter is a HUGE problem as most links contain one.
:func_barg_parg
    call :func_h2p_a_whole_new_world
    call :conf_user_settings
    call :conf_script_settings

    rem  No params, send to help (will only args-parse when there are args to parse)
    if /i "%~1%~2%~3" equ  ""   call :func_h2p_ahelp_me
    if /i "%~1%~2%~3" equ "-?"  call :func_h2p_ahelp_me
    if /i "%~1%~2%~3" equ "/?"  call :func_h2p_ahelp_me
    if /i "%~1%~2%~3" equ "--?" call :func_h2p_ahelp_me

    for %%Z in (
        %*
    ) do for /f "tokens=* delims=+-/" %%X in (
        "-%%Z"
    ) do for /f "tokens=1,* delims=:" %%U in (
        "%%X"
    ) do (
        rem arg-prefix (character-chains) are stripped, loose arg-prefix acceptance: k:v, [----]k:v, [////]k:v, 
        rem I need halps ignoring the arg-prefix to minimize number of checks
               if /i "-%%~U" equ "-h"    (
                                            call :func_h2p_pargs_help "%%~V"
                                            goto :eof
        ) else if /i "-%%~U" equ "-help" (
                                            call :func_h2p_pargs_help "%%~V"
                                            goto :eof
        ) else if /i "-%%~U" equ "-done" (
                                            REM  Gogogo, through the Side-door -- relaunch script to run env set
                                            call "%~f0" "--Gogogougo-Gougogo--"
                                            call :func_h2p_a_whole_new_world  "h2p_"
        ) else if /i "-%%~U" equ "-run"  (
                                            rem  Fast-trak through the GoGoGo-door.  
                                            call "%~f0" "--Gogogougo-Gougogo--"
                                            call :func_h2p_a_whole_new_world  "h2p_"
        ) else if /i "-%%~U" equ "-go"   (
                                            rem  Gogogo Note: If that hairy GoGoGo remains uncaught, it "Gogogoes" a 1go, a 2go, and a 3go continues to next param
                                            call "%~f0" "--Gogogougo-Gougogo--"
                                            call :func_h2p_a_whole_new_world  "h2p_"

        ) else if /i "-%%~Z" equ "---Gogogougo-Gougogo--" (
                                            rem  Taking the "bullet" out of the chamber making sure that the env is eval'd once
                                            rem  Just like a locked gun, this block shouldn't trigger, but, weirder things have happened. 
                                            rem    Weeeeee, we're goofing offffff and getting PAID.  Thats what Im talking aboot
                                            rem    Heavy Indian Accent: Jus, a-take-it.  And-a GO.
                                            REM goto :func_h2p_aprocess_varset
                                            
        ) else if /i "-%%~U" equ "-u"    (
                                            if "-%%~V" equ "-" (
                                                echo/-u:"expecting url"
                                            ) else set "h2p_url=%%~V"
                                            
        ) else if /i "-%%~U" equ "-url" (
                                            if "-%%~V" equ "-" (
                                                echo/--url:"expecting url"
                                            ) else set "h2p_url=%%~V"

        REM ) else if /i "-%%~U" equ "-silent" ( 
                                                   REM if "-%%~V" equ  "-"    ( set "_h2p_silent=true"  
                                            REM ) else if "-%%~V" equ "-on"   ( set "_h2p_silent=true"  
                                            REM ) else if "-%%~V" equ "-off"    set "_h2p_silent="  
        
        ) else if /i "-%%~U" equ "-o" (
                                            if "-%%~V" equ "-" (
                                                echo/-o:"expecting path\filename.pdf"
                                            ) else if "-%%~V" equ "-auto" (
                                                call :func_h2p_guess_auto h2p_output
                                            ) else set "h2p_output=%%~V"

        ) else if /i "-%%~U" equ "-output" (
                                            if "-%%~V" equ "-" (
                                                echo/-output:"expecting path\filename.pdf"
                                            ) else if "-%%~V" equ "-auto" (
                                                call :func_h2p_guess_auto h2p_output
                                            ) else set "h2p_output=%%~V"

        ) else if /i "-%%~U" equ "-a" ( 
                                            call :func_h2p_guess_auto h2p_output
        ) else if /i "-%%~U" equ "-auto" ( 
                                            call :func_h2p_guess_auto h2p_output

        ) else if /i "-%%~U" equ "-n" (
                                            if "-%%~V" equ "-" (
                                                echo/--add-opts:"additional options"
                                                echo/   Or   -n:"additional options"
                                            ) else set "_h2p_add_opts=%%~V"

        ) else if /i "-%%~U" equ "-add-opts" (
                                            if "-%%~V" equ "-" (
                                                echo/--add-opts:"additional options"
                                            ) else set "_h2p_add_opts=%%~V"

        ) else if /i "-%%~U" equ "-no" (
                                            set "_h2p_bin_opts=%%~V"

        ) else if /i "-%%~U" equ "-add-opts-overwrite" (
                                            set "_h2p_bin_opts=%%~V"

        ) else if /i "-%%~U" equ "-b" (
                                            if "-%%~V" equ "-" (
                                                echo/-b:"expecting path\BinName"
                                            ) else set "_h2p_binary=%%~V"

        ) else if /i "-%%~U" equ "-binary" ( 
                                            if "-%%~V" equ "-" (
                                                echo/--binary:"expecting path\BinName"
                                            ) else set "_h2p_binary=%%~V"

        ) else if /i "-%%~U" equ "-norun" (
                                            set "_h2p_norun=true"
                                            
        ) else if /i "-%%~U" equ "-debug" (
            if "-%%~V" equ "-" (
               set "debug_h2p_msgs=true" 
            ) else for %%b in (
                %%V
            ) do for /f "tokens=1-3 delims=:-" %%g in (
                "-%%~b"
            ) do call :func_h2p_pargs_debug %%g %%h %%i

        ) else if /i  "%%~X" neq "" (
                                            rem unless defined, 1st param: url, 2nd param: output file
                                                   if not defined h2p_url    ( set "h2p_url=%%~X"
                                            ) else if not defined h2p_output ( set "h2p_output=%%~X"
                                            )

        ) else if /i  "%%~xU" equ ".pdf" (
                                            if not defined h2p_output set "h2p_output=%%~U"
        )

        if defined debug_h2p_msgs (
            call :func_h2p_dump_debug_msg  "ArgsPharseV parsed value " "%%~V"   "%debug_h2p_terse_msgs%" 
            call :func_h2p_dump_debug_msg  "ArgsPharseU parsed key "   "%%~U"   "%debug_h2p_terse_msgs%" 
            call :func_h2p_dump_debug_msg  "ArgsPharseX paircheck "    "%%~X"   "%debug_h2p_terse_msgs%" 
            call :func_h2p_dump_debug_msg  "ArgsPharseZ raw-param "    "%%~Z"   "%debug_h2p_terse_msgs%" 
        )
        
    )

    rem  End of Args Parse   -  Dump DebugSummary when needed

    if defined debug_h2p_msgs (
        call :func_h2p_dump_debug_msg  "Post ArgsPharse Vars Summary"     " %~nx0"         "%debug_h2p_terse_msgs%" 
        call :func_h2p_dump_debug_msg  "Vars Defined h2p_url: "         "%h2p_url%"        "%debug_h2p_terse_msgs%" 
        call :func_h2p_dump_debug_msg  "Vars Defined h2p_output: "      "%h2p_output%"     "%debug_h2p_terse_msgs%" 
        call :func_h2p_dump_debug_msg  "Vars Defined _h2p_binary "     "%_h2p_binary%"     "%debug_h2p_terse_msgs%" 
        echo/&echo/&echo/ Dumping Script Vars:
        echo/----------------------------------------
        call :func_h2p_dump_debug_msg  "" "%~0"
        echo/----------------------------------------
        echo/
    )


    rem  Runs script -- Only when unresolved run-counters exist.
    rem    only when defined counters
    rem    Need to make counter when url is def, then compare with total runs; only run when values dont match
    if defined _h2p_runAcnt ( 
        if defined _h2p_runTcnt (
            if "%_h2p_runAcnt%" neq "%_h2p_runTcnt%" call :func_h2p_aprocess_varset
        ) else call :func_h2p_aprocess_varset
    ) else call :func_h2p_aprocess_varset

    rem  End of script
    call :func_h2p_a_whole_new_world
    endlocal
goto :eof

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

::  Usage  ::  func_h2p_a_whole_new_world  "varPrefix-optional"
rem  Resets the h2p world back to square zero (or .5)
rem    Note: YOU CAN BREAK YOUR SYSTEM!! 
rem          Please scrub your inputs to get clean outputs. [x] EzCheese
:func_h2p_a_whole_new_world
    if "%~1" equ "" for %%K in ( h2p_ ; _h2p_ ; debug_h2p_ ) do call %~0 "%%~K" 2>nul 1>nul 

    if "%~1" neq "" for /f "usebackq tokens=1 delims==" %%V in (
        `set %1`
    ) do set "%%~V=" 
    
goto :eof



::  Usage  :: func_h2p_aprocess_varset  
rem  Runs command line with current env state.
rem  Note: This is to enable mutliple runs in one session.
rem    First, Evaluates current variable set for errors. attempts to fix any issues or Prompts user as needed.
rem    Next,  runs Main -- http to pdf
rem    Last,  clear subprocess vars
:func_h2p_aprocess_varset
    if defined debug_h2p_msgs call :func_h2p_dump_debug_msg  "subprocess url-out-set "     " %~0 "           "%debug_h2p_terse_msgs%" 
    
    rem  to disable other execution methods
    if /i "%~1" equ "run" set /a "_h2p_runAcnt+=1"
    set /a "_h2p_runTcnt+=1"

    rem  check n fix dependencies; error when unresolved
    call :func_h2p_check_deps   h2p_errcnt
    if not "1%h2p_errcnt%" equ "10" ( echo/ Error: %h2p_errcnt% checks failed, cannot continue &exit /b %h2p_errcnt% ) 1>&2
    
    rem  run bin to generate pdf from url
    call :func_h2p_gen_pdf
    
    rem  reset/unset session run vars
    call :func_h2p_a_whole_new_world  "h2p_" 2>nul 1>nul 

    if defined debug_h2p_msgs call :func_h2p_dump_debug_msg  "subprocess varcleared "     " %~0 - Current Setvars "           "Dumpit" 
goto :eof


::  Usage  ::  func_h2p_check_deps  returnVar
rem  checks dependencies.  
rem    Errlvl   0  =  No failures
rem    Errlvl 1##  =  Failed 1## of checks
rem    Errlvl 456  =  Function took a crap
:func_h2p_check_deps
    if defined debug_h2p_msgs call :func_h2p_dump_debug_msg  "check and verify"     " %~0 - %~1"           "%debug_h2p_terse_msgs%" 
    if "%~1" equ "" call %~0  "h2p_errcnt" &goto :eof
    set "%~1=0"

    rem  resolve when unset
    REM call :func_h2p_fix_url
    if not defined h2p_url          call :func_h2p_get_user_input  "h2p_url"       "&echo/  Input: User: Enter url or html location"   ""
    if not defined _h2p_binary      call :func_h2p_where_bin       "_h2p_binary"    "wkhtmltopdf.exe"       true 
    if not exist "%_h2p_binary%"    call :func_h2p_where_bin       "_h2p_binary"    "wkhtmltopdf.exe"       true 

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
    if not defined h2p_output     call :func_h2p_guess_auto       h2p_output
    
    
    rem  error when unset
    if not defined h2p_url       set /a "%~1+=1" 
    if not defined _h2p_binary   set /a "%~1+=1"
    if not exist "%_h2p_binary%" set /a "%~1+=1" 
    if not defined h2p_output    set /a "%~1+=1" 

    if not defined %~1 exit /b 456
    for /f "tokens=1,* delims==" %%U in ('set %~1') do exit /b %%~V
    exit /b
    
goto :eof



::  Usage  ::  func_h2p_outdir_prefix_auto   "returnVar"   "prefix\Path\And\Or\Name"
rem  Auto generates filename and prepends string before it.  Does this only once (unless var h2p_preVar is cleared)
:func_h2p_outdir_prefix_auto
    if defined h2p_preVar goto :eof
    if defined debug_h2p_msgs call :func_h2p_dump_debug_msg  "affix preffix "     " %~0 - %~1 %~2"           "%debug_h2p_terse_msgs%" 

    if "%~1" equ "" goto :eof
    if "%~2" equ "" if not defined %~1 (
        goto :eof
    ) else for /f "tokens=1,* delims=" %%A in ('set %1') do (
        call %~0 "%%~B"
        goto :eof
    )
    
    set "h2p_preVar=%~2"
    set "%~1="
    
    call :func_h2p_guess_auto  %1
    if not defined %~1 (
        set "%~1=%h2p_preVar%"
        goto :eof
    )
    
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
    if defined debug_h2p_msgs call :func_h2p_dump_debug_msg  "Runs external bin to gen pdf"     " %~0 %~1"           "%debug_h2p_terse_msgs%"
    if defined debug_h2p_msgs call :func_h2p_dump_debug_msg  "" " Dumping Vars %~0"

    if defined _h2p_silent ( call %~0 %*
        goto :eof
    ) 2>nul 1>nul
    
    for %%V in ( _h2p_binary ; h2p_output ; h2p_url ) do if not defined %%~V goto :eof
    if /i "%~1" equ "norun" set "_h2p_norun=true" 
    
    if defined _h2p_norun (
        echo/ Info: NoRun: FinalCmd: "%_h2p_binary%" %_h2p_bin_opts% "%h2p_url%" "%h2p_output%"
        echo/ Info: NoRun: %_h2p_norun%.  leaving runner bunction
        goto :eof
    )

    "%_h2p_binary%" %_h2p_add_opts% %_h2p_bin_opts% "%h2p_url%" "%h2p_output%"
    if "1%errorlevel%" neq "10" echo/ Warning: dirty errlevel from binary "%_h2p_binary%"
    if exist "%h2p_output%" echo Info: File saved: "%h2p_output%"
    
goto :eof



::  Usage  ::  func_h2p_get_time_string   returnVar
rem  Returns string with YYYY.MM.DD.TimeInSecs
:func_h2p_get_time_string
    if defined debug_h2p_msgs call :func_h2p_dump_debug_msg  "time to string together time "     " %~0 - %~1 "           "%debug_h2p_terse_msgs%" 
    if "%~1" equ "" goto :eof

    call :func_h2p_calc_timestamp h2p_dtsecs_ "%time%"
    if not defined h2p_dtsecs_ ( set "%~1=%date:~-4,4%.%date:~4,2%.%date:~7,2%"
	) else set "%~1=%date:~-4,4%.%date:~4,2%.%date:~7,2%.%h2p_dtsecs_%"
    
    call :func_h2p_dump_debug_msg  "time to string together Result"     " %~0 - %date:~-4,4%.%date:~4,2%.%date:~7,2%.%h2p_dtsecs_% "           "%debug_h2p_terse_msgs%" 
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
        if "%~2" neq "" ( set "_scest=%~2"
        ) else set "_scest=%time%"
        
        set /a "%~1=((1%_scest:~-2% + 1%_scest:~-2%) / 300) + (1%_scest:~-5,2% - 100) + ((1%_scest:~3,2% - 100) * 60 ) + ((%_scest:~0,2% * 60) * 60)"
        set "_scest="
    goto :eof
    
    rem calc secs in today -- rounds 51ms+ to 1 sec and w/a for octals -- extra steps to round 51ms+ to secs
    :func_h2p_calc_time_nezrnd_ms
        if "%~1" equ "" goto :eof
        if "%~2" neq "" ( set "_scest=%~2"
        ) else set "_scest=%time%"

        set /a "%~1=(1%_scest:~-5,2% - 100) + ((1%_scest:~3,2% - 100) * 60 ) + ((%_scest:~0,2% * 60) * 60)"
        if defined %~1 if %_scest:~-2,2% gtr 50 set /a "%~1+=1"
        set "_scest="
    goto :eof

    rem calc secs in today -- archived 01/11/2018
    rem   works, has a issue when trying to work with non-octal numbers like: 07,08,09
    rem   no support for supplied time
    :func_h2p_01112018_calc_time_secs
        if "%~1" equ "" goto :eof
        set /a "%~1=%time:~-5,2% + (%time:~3,2% * 60 ) + ((%time:~0,2% * 60) * 60)"
    goto :eof
    
rem ~~~~~~~~~~~~ mss calc below ~~~~~~~~~~~~
    
    rem calc ms in today -- no support for supplied time
    :func_h2p_time_calc_today_ms
        if "%~1" equ "" goto :eof
        set /a "%~1=( 1%time:~-2% - 100 ) + (( 1%time:~-5,2% - 100 ) * 1000) + (( 1%time:~3,2% - 100 ) * 60000 ) + (( %time:~0,2% + 2 - 2) * 3600000)"
        set "%~1+=0"
    goto :eof

    rem calc ms in today OR a suppyled HH:MM:SS.MS time
    :func_h2p_time_calc_ms
        if "%~1" equ "" goto :eof
        if "%~2" neq "" ( set "_smst=%~2"
        ) else set "_smst=%time%"

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
        if defined debug_h2p_msgs call :func_h2p_dump_debug_msg  "User Input requested"     " %~0 - %~2 - %~1 Default - %~3"           "%debug_h2p_terse_msgs%" 

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
rem    3 - Generates and name with a timestamp
:func_h2p_guess_auto
    if "%~1" equ "" exit /b 456
    if defined debug_h2p_msgs call :func_h2p_dump_debug_msg  "auto filename suggestion"     " %~0 - %~1"           "%debug_h2p_terse_msgs%" 
    if "%~2" equ "" if defined h2p_url (
        call %~0   "%~1"   "%h2p_url%"
        goto :eof
    )
    
    call :func_h2p_get_time_string h2p_YyyyMmDdSecs
    set "%~1="
    
    rem timestamp -- leave early
    set "%~1=%h2p_YyyyMmDdSecs%.pdf"
    if "%~2" equ "" goto :eof
    
    rem url -- leave early
    call :func_h2p_guess_outname   "%~1"  "%~2"
    if "1%errorlevel%" equ "10" for /f "tokens=1,* delims==" %%A in ('set "%~1"') do set "%~1=%%~B.%h2p_YyyyMmDdSecs%.pdf"
    if defined %~1 goto :eof
    
    rem tld
    for /f "tokens=2 delims==/?!&,;@#" %%B in ("%~2") do set "%~1=%%~B.%h2p_YyyyMmDdSecs%.pdf"

    set "h2p_YyyyMmDdSecs="
goto :eof



::  Usage  :: func_h2p_guess_n_ask   returnVar   "url"
rem  Generates three names, then prompts user (once) if they want to change it
rem    1 - Generates a name based on the url.timestamp, then prompts user if they want to change it
rem    2 - Generates a name based on the tld.timestamp, then prompts user if they want to change it
rem    3 - Generates and name with a timestamp, then prompts user if they want to change it
:func_h2p_guess_n_ask
    if "%~1" equ "" exit /b 456
    if defined debug_h2p_msgs call :func_h2p_dump_debug_msg  "prompt user after filename suggestion"     " %~0 - %~1"           "%debug_h2p_terse_msgs%" 
    call :func_h2p_get_time_string h2p_YyyyMmDdSecs
    set "%~1="

    call :func_h2p_guess_outname   "%~1"  "%~2"
    if "1%errorlevel%" equ "10" for /f "tokens=1,* delims==" %%A in ('set "%~1"') do call :func_h2p_get_user_input  "%~1"  "&echo/  Input: User: Enter output path\filename"   "%%~B.%h2p_YyyyMmDdSecs%.pdf"
    if "1%errorlevel%" equ "10" set "h2p_YyyyMmDdSecs=" &goto :eof


    for /f "tokens=2 delims==/?!&,;@#" %%B in ("%~2") do call :func_h2p_get_user_input  "%~1"  "&echo/  Input: User: Enter output path\filename"   "%%~B.%h2p_YyyyMmDdSecs%.pdf"
    if "1%errorlevel%" equ "10" set "h2p_YyyyMmDdSecs=" &goto :eof
    
    call :func_h2p_get_user_input  "%~1"  "&echo/  Input: User: Enter output path\filename"   "%h2p_YyyyMmDdSecs%" 
    if "1%errorlevel%" equ "10" set "h2p_YyyyMmDdSecs=" &goto :eof
    
    set "h2p_YyyyMmDdSecs="

goto :eof


::  Usage  :: func_h2p_guess_outname  returnVar  "url"
rem  Creates a recommendation for an output file name
:func_h2p_guess_outname
    if defined debug_h2p_msgs call :func_h2p_dump_debug_msg  "using url for filename suggestion"     " %~0 - %~1 : %~2 "           "%debug_h2p_terse_msgs%" 
    if "%~2" equ "" exit /b 456
    if "%~1" equ "" exit /b 456
    set "%~1="
    set "h2p_clncntr=20"
    
    rem  Guesstimate ammount of crap to clean up
    set "h2p_clncntr=2"
    for /f "tokens=1-26 delims==/?!&,;@\" %%A in (
        "%~2"
    ) do set /a "h2p_clncntr+=1"
    
    for /f "tokens=1-26 delims==/?!&,;@\" %%A in (
        "%~2"
    ) do if "%%~A" neq "" if "%%~A" equ "file:"  ( 
           set "%~1=%~nx2.file"
           set "h2p_clncntr=5"
    ) else set "%~1=%%~C %%~D %%~E %%~F %%~G %%~H %%~I %%~J %%~K %%~L %%~M %%~N %%~O %%~P %%~Q %%~R %%~S %%~T %%~U %%~V %%~W %%~X %%~Y %%~Z.%%~B"
    if not defined %~1 exit /b 1

    rem  20x times - removing unwanted/duplicate symbols
    for /l %%A in (1,1,%h2p_clncntr%) do call :sub_chqNstrp__h2p_guess_outname "%~1"  "%%~A"
    
    for /f "tokens=1,* delims==" %%U in ('set "%~1"') do set "%~1=%%~V"
    exit /b 0
    
goto :eof


    ::  Usage  ::  guess_outname_chqNstrp   "keyVar"  "optional-loopDebugCount"
    rem  Janitor of "_.-?"
    :sub_chqNstrp__h2p_guess_outname
        if defined debug_h2p_msgs call :func_h2p_dump_debug_msg  "subroutine - scrubbing url"     " %~0 - %~1 - %~2"           "%debug_h2p_terse_msgs%" 
        rem insanity check
        if "1%~1" equ "1" exit /b 456
        
        rem  define, strip and clean -- characers/spaces can be weird and messy
        for /f "tokens=1,* delims==" %%U in ('set "%~1"') do set "h2p_go_sA_=%%~V"
        
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
        for %%E in ( "-";" ";" ";"_";".";"+") do if "%h2p_go_sA_:~0,1%" equ "%%~E" call set "h2p_go_sA_=%h2p_go_sA_:~1%"
        for %%E in ( "-";" ";" ";"_";".";"+") do if "%h2p_go_sA_:~-1,1%" equ "%%~E" call set "h2p_go_sA_=%h2p_go_sA_:~0,-1%"
        
        rem  rinse, toss var back on and done
        set "%~1=%h2p_go_sA_%"
        set "h2p_go_sA_="
    
    goto :eof

    
::  Usage  ::  func_h2p_where_bin  returnVar   "path\BinaryName.ext"   "onlyOne-trueBool-optional"
rem  returns param1 set to found path. Uses where.exe to locate the binary in param2
rem    Note:  Param3 is an optional Bool, Returns only first path when multiple are found
:func_h2p_where_bin
    if defined debug_h2p_msgs call :func_h2p_dump_debug_msg  "Looking for bins with where.exe"     " %~0 - %~1 - %~2 - Bool: %~3"           "%debug_h2p_terse_msgs%" 

    if "%~2" equ "" exit /b 456
    if "%~1" equ "" exit /b 456
    set "%~1="
    
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
    if not defined debug_h2p_msgs goto :eof
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
::: Unused bunctions -- included for edge case workarounds
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::


::  Usage  ::  func_h2p_fix_url
rem  This is to add an additional perc-sign per perc-sign.  Use ONLY when absolutly needed to "call" the url as this is a huge waste of time/resources
rem    Note:  Example: changes  http://123.abc/%something%else  to  http://123.abc/%%something%%else
:func_h2p_fix_url
    if defined debug_h2p_msgs call :func_h2p_dump_debug_msg  "Wow, um, so... um, you do hate yourself"      " sadist much? %~0"             "%debug_h2p_terse_msgs%" 
    if not defined h2p_url goto :eof
    
    for /f "tokens=1-26 delims=%%" %%A in ("%h2p_url%") do if "%%~Z" neq "" ( set "h2p_url=%%~A%%%%%%~B%%%%%%~C%%%%%%~D%%%%%%~E%%%%%%~F%%%%%%~G%%%%%%~H%%%%%%~I%%%%%%~J%%%%%%~K%%%%%%~L%%%%%%~M%%%%%%~N%%%%%%~O%%%%%%~P%%%%%%~Q%%%%%%~R%%%%%%~S%%%%%%~T%%%%%%~U%%%%%%~V%%%%%%~W%%%%%%~X%%%%%%~Y%%%%%%~Z"
    ) else if "%%~Y" neq "" ( set "h2p_url_percd=%%~A%%%%%%~B%%%%%%~C%%%%%%~D%%%%%%~E%%%%%%~F%%%%%%~G%%%%%%~H%%%%%%~I%%%%%%~J%%%%%%~K%%%%%%~L%%%%%%~M%%%%%%~N%%%%%%~O%%%%%%~P%%%%%%~Q%%%%%%~R%%%%%%~S%%%%%%~T%%%%%%~U%%%%%%~V%%%%%%~W%%%%%%~X%%%%%%~Y"
    ) else if "%%~X" neq "" ( set "h2p_url_percd=%%~A%%%%%%~B%%%%%%~C%%%%%%~D%%%%%%~E%%%%%%~F%%%%%%~G%%%%%%~H%%%%%%~I%%%%%%~J%%%%%%~K%%%%%%~L%%%%%%~M%%%%%%~N%%%%%%~O%%%%%%~P%%%%%%~Q%%%%%%~R%%%%%%~S%%%%%%~T%%%%%%~U%%%%%%~V%%%%%%~W%%%%%%~X"
    ) else if "%%~W" neq "" ( set "h2p_url_percd=%%~A%%%%%%~B%%%%%%~C%%%%%%~D%%%%%%~E%%%%%%~F%%%%%%~G%%%%%%~H%%%%%%~I%%%%%%~J%%%%%%~K%%%%%%~L%%%%%%~M%%%%%%~N%%%%%%~O%%%%%%~P%%%%%%~Q%%%%%%~R%%%%%%~S%%%%%%~T%%%%%%~U%%%%%%~V%%%%%%~W"
    ) else if "%%~V" neq "" ( set "h2p_url_percd=%%~A%%%%%%~B%%%%%%~C%%%%%%~D%%%%%%~E%%%%%%~F%%%%%%~G%%%%%%~H%%%%%%~I%%%%%%~J%%%%%%~K%%%%%%~L%%%%%%~M%%%%%%~N%%%%%%~O%%%%%%~P%%%%%%~Q%%%%%%~R%%%%%%~S%%%%%%~T%%%%%%~U%%%%%%~V"
    ) else if "%%~U" neq "" ( set "h2p_url_percd=%%~A%%%%%%~B%%%%%%~C%%%%%%~D%%%%%%~E%%%%%%~F%%%%%%~G%%%%%%~H%%%%%%~I%%%%%%~J%%%%%%~K%%%%%%~L%%%%%%~M%%%%%%~N%%%%%%~O%%%%%%~P%%%%%%~Q%%%%%%~R%%%%%%~S%%%%%%~T%%%%%%~U"
    ) else if "%%~T" neq "" ( set "h2p_url_percd=%%~A%%%%%%~B%%%%%%~C%%%%%%~D%%%%%%~E%%%%%%~F%%%%%%~G%%%%%%~H%%%%%%~I%%%%%%~J%%%%%%~K%%%%%%~L%%%%%%~M%%%%%%~N%%%%%%~O%%%%%%~P%%%%%%~Q%%%%%%~R%%%%%%~S%%%%%%~T"
    ) else if "%%~S" neq "" ( set "h2p_url_percd=%%~A%%%%%%~B%%%%%%~C%%%%%%~D%%%%%%~E%%%%%%~F%%%%%%~G%%%%%%~H%%%%%%~I%%%%%%~J%%%%%%~K%%%%%%~L%%%%%%~M%%%%%%~N%%%%%%~O%%%%%%~P%%%%%%~Q%%%%%%~R%%%%%%~S"
    ) else if "%%~R" neq "" ( set "h2p_url_percd=%%~A%%%%%%~B%%%%%%~C%%%%%%~D%%%%%%~E%%%%%%~F%%%%%%~G%%%%%%~H%%%%%%~I%%%%%%~J%%%%%%~K%%%%%%~L%%%%%%~M%%%%%%~N%%%%%%~O%%%%%%~P%%%%%%~Q%%%%%%~R"
    ) else if "%%~Q" neq "" ( set "h2p_url_percd=%%~A%%%%%%~B%%%%%%~C%%%%%%~D%%%%%%~E%%%%%%~F%%%%%%~G%%%%%%~H%%%%%%~I%%%%%%~J%%%%%%~K%%%%%%~L%%%%%%~M%%%%%%~N%%%%%%~O%%%%%%~P%%%%%%~Q"
    ) else if "%%~P" neq "" ( set "h2p_url_percd=%%~A%%%%%%~B%%%%%%~C%%%%%%~D%%%%%%~E%%%%%%~F%%%%%%~G%%%%%%~H%%%%%%~I%%%%%%~J%%%%%%~K%%%%%%~L%%%%%%~M%%%%%%~N%%%%%%~O%%%%%%~P"
    ) else if "%%~O" neq "" ( set "h2p_url_percd=%%~A%%%%%%~B%%%%%%~C%%%%%%~D%%%%%%~E%%%%%%~F%%%%%%~G%%%%%%~H%%%%%%~I%%%%%%~J%%%%%%~K%%%%%%~L%%%%%%~M%%%%%%~N%%%%%%~O"
    ) else if "%%~N" neq "" ( set "h2p_url_percd=%%~A%%%%%%~B%%%%%%~C%%%%%%~D%%%%%%~E%%%%%%~F%%%%%%~G%%%%%%~H%%%%%%~I%%%%%%~J%%%%%%~K%%%%%%~L%%%%%%~M%%%%%%~N"
    ) else if "%%~M" neq "" ( set "h2p_url_percd=%%~A%%%%%%~B%%%%%%~C%%%%%%~D%%%%%%~E%%%%%%~F%%%%%%~G%%%%%%~H%%%%%%~I%%%%%%~J%%%%%%~K%%%%%%~L%%%%%%~M"
    ) else if "%%~L" neq "" ( set "h2p_url_percd=%%~A%%%%%%~B%%%%%%~C%%%%%%~D%%%%%%~E%%%%%%~F%%%%%%~G%%%%%%~H%%%%%%~I%%%%%%~J%%%%%%~K%%%%%%~L"
    ) else if "%%~K" neq "" ( set "h2p_url_percd=%%~A%%%%%%~B%%%%%%~C%%%%%%~D%%%%%%~E%%%%%%~F%%%%%%~G%%%%%%~H%%%%%%~I%%%%%%~J%%%%%%~K"
    ) else if "%%~J" neq "" ( set "h2p_url_percd=%%~A%%%%%%~B%%%%%%~C%%%%%%~D%%%%%%~E%%%%%%~F%%%%%%~G%%%%%%~H%%%%%%~I%%%%%%~J"
    ) else if "%%~I" neq "" ( set "h2p_url_percd=%%~A%%%%%%~B%%%%%%~C%%%%%%~D%%%%%%~E%%%%%%~F%%%%%%~G%%%%%%~H%%%%%%~I"
    ) else if "%%~H" neq "" ( set "h2p_url_percd=%%~A%%%%%%~B%%%%%%~C%%%%%%~D%%%%%%~E%%%%%%~F%%%%%%~G%%%%%%~H"
    ) else if "%%~G" neq "" ( set "h2p_url_percd=%%~A%%%%%%~B%%%%%%~C%%%%%%~D%%%%%%~E%%%%%%~F%%%%%%~G"
    ) else if "%%~F" neq "" ( set "h2p_url_percd=%%~A%%%%%%~B%%%%%%~C%%%%%%~D%%%%%%~E%%%%%%~F"
    ) else if "%%~E" neq "" ( set "h2p_url_percd=%%~A%%%%%%~B%%%%%%~C%%%%%%~D%%%%%%~E"
    ) else if "%%~D" neq "" ( set "h2p_url_percd=%%~A%%%%%%~B%%%%%%~C%%%%%%~D"
    ) else if "%%~C" neq "" ( set "h2p_url_percd=%%~A%%%%%%~B%%%%%%~C"
    ) else if "%%~B" neq "" ( set "h2p_url_percd=%%~A%%%%%%~B"
    ) else if "%%~A" neq "" ( set "h2p_url_percd=%%~A"
    )
    
goto :eof

::  Usage  ::  func_h2p_fix_url_51x
rem  This is to add an additional perc-sign per perc-sign.  Use ONLY when absolutly needed to "call" the url as this is a huge waste of time/resources
rem    Note:  Example: changes  http://123.abc/%something%else  to  http://123.abc/%%something%%else
rem    Note:  can only change 51 instances per submission; why not 52, uses 26th instance to restart a loop.  Nothing is stopping YOU from creating a limitless shift loop instead ;]
:func_h2p_fix_url_51x
    
    for /f "tokens=1-26* delims=%%" %%A in ("%h2p_url%") do if "%%~Z" neq "" ( for /f "tokens=1-26* delims=%%" %%a in ("%%~Z") do if "%%~z" neq "" ( set "h2p_url=%%~A%%%%%%~B%%%%%%~C%%%%%%~D%%%%%%~E%%%%%%~F%%%%%%~G%%%%%%~H%%%%%%~I%%%%%%~J%%%%%%~K%%%%%%~L%%%%%%~M%%%%%%~N%%%%%%~O%%%%%%~P%%%%%%~Q%%%%%%~R%%%%%%~S%%%%%%~T%%%%%%~U%%%%%%~V%%%%%%~W%%%%%%~X%%%%%%~Y%%%%%%~a%%%%%%~b%%%%%%~c%%%%%%~d%%%%%%~e%%%%%%~f%%%%%%~g%%%%%%~h%%%%%%~i%%%%%%~j%%%%%%~k%%%%%%~l%%%%%%~m%%%%%%~n%%%%%%~o%%%%%%~p%%%%%%~q%%%%%%~r%%%%%%~s%%%%%%~t%%%%%%~u%%%%%%~v%%%%%%~w%%%%%%~x%%%%%%~y%%%%%%~z"
    ) else if "%%~y" neq "" ( set "h2p_url_percd=%%~A%%%%%%~B%%%%%%~C%%%%%%~D%%%%%%~E%%%%%%~F%%%%%%~G%%%%%%~H%%%%%%~I%%%%%%~J%%%%%%~K%%%%%%~L%%%%%%~M%%%%%%~N%%%%%%~O%%%%%%~P%%%%%%~Q%%%%%%~R%%%%%%~S%%%%%%~T%%%%%%~U%%%%%%~V%%%%%%~W%%%%%%~X%%%%%%~Y%%%%%%~a%%%%%%~b%%%%%%~c%%%%%%~d%%%%%%~e%%%%%%~f%%%%%%~g%%%%%%~h%%%%%%~i%%%%%%~j%%%%%%~k%%%%%%~l%%%%%%~m%%%%%%~n%%%%%%~o%%%%%%~p%%%%%%~q%%%%%%~r%%%%%%~s%%%%%%~t%%%%%%~u%%%%%%~v%%%%%%~w%%%%%%~x%%%%%%~y"
    ) else if "%%~x" neq "" ( set "h2p_url_percd=%%~A%%%%%%~B%%%%%%~C%%%%%%~D%%%%%%~E%%%%%%~F%%%%%%~G%%%%%%~H%%%%%%~I%%%%%%~J%%%%%%~K%%%%%%~L%%%%%%~M%%%%%%~N%%%%%%~O%%%%%%~P%%%%%%~Q%%%%%%~R%%%%%%~S%%%%%%~T%%%%%%~U%%%%%%~V%%%%%%~W%%%%%%~X%%%%%%~Y%%%%%%~a%%%%%%~b%%%%%%~c%%%%%%~d%%%%%%~e%%%%%%~f%%%%%%~g%%%%%%~h%%%%%%~i%%%%%%~j%%%%%%~k%%%%%%~l%%%%%%~m%%%%%%~n%%%%%%~o%%%%%%~p%%%%%%~q%%%%%%~r%%%%%%~s%%%%%%~t%%%%%%~u%%%%%%~v%%%%%%~w%%%%%%~x"
    ) else if "%%~w" neq "" ( set "h2p_url_percd=%%~A%%%%%%~B%%%%%%~C%%%%%%~D%%%%%%~E%%%%%%~F%%%%%%~G%%%%%%~H%%%%%%~I%%%%%%~J%%%%%%~K%%%%%%~L%%%%%%~M%%%%%%~N%%%%%%~O%%%%%%~P%%%%%%~Q%%%%%%~R%%%%%%~S%%%%%%~T%%%%%%~U%%%%%%~V%%%%%%~W%%%%%%~X%%%%%%~Y%%%%%%~a%%%%%%~b%%%%%%~c%%%%%%~d%%%%%%~e%%%%%%~f%%%%%%~g%%%%%%~h%%%%%%~i%%%%%%~j%%%%%%~k%%%%%%~l%%%%%%~m%%%%%%~n%%%%%%~o%%%%%%~p%%%%%%~q%%%%%%~r%%%%%%~s%%%%%%~t%%%%%%~u%%%%%%~v%%%%%%~w"
    ) else if "%%~v" neq "" ( set "h2p_url_percd=%%~A%%%%%%~B%%%%%%~C%%%%%%~D%%%%%%~E%%%%%%~F%%%%%%~G%%%%%%~H%%%%%%~I%%%%%%~J%%%%%%~K%%%%%%~L%%%%%%~M%%%%%%~N%%%%%%~O%%%%%%~P%%%%%%~Q%%%%%%~R%%%%%%~S%%%%%%~T%%%%%%~U%%%%%%~V%%%%%%~W%%%%%%~X%%%%%%~Y%%%%%%~a%%%%%%~b%%%%%%~c%%%%%%~d%%%%%%~e%%%%%%~f%%%%%%~g%%%%%%~h%%%%%%~i%%%%%%~j%%%%%%~k%%%%%%~l%%%%%%~m%%%%%%~n%%%%%%~o%%%%%%~p%%%%%%~q%%%%%%~r%%%%%%~s%%%%%%~t%%%%%%~u%%%%%%~v"
    ) else if "%%~u" neq "" ( set "h2p_url_percd=%%~A%%%%%%~B%%%%%%~C%%%%%%~D%%%%%%~E%%%%%%~F%%%%%%~G%%%%%%~H%%%%%%~I%%%%%%~J%%%%%%~K%%%%%%~L%%%%%%~M%%%%%%~N%%%%%%~O%%%%%%~P%%%%%%~Q%%%%%%~R%%%%%%~S%%%%%%~T%%%%%%~U%%%%%%~V%%%%%%~W%%%%%%~X%%%%%%~Y%%%%%%~a%%%%%%~b%%%%%%~c%%%%%%~d%%%%%%~e%%%%%%~f%%%%%%~g%%%%%%~h%%%%%%~i%%%%%%~j%%%%%%~k%%%%%%~l%%%%%%~m%%%%%%~n%%%%%%~o%%%%%%~p%%%%%%~q%%%%%%~r%%%%%%~s%%%%%%~t%%%%%%~u"
    ) else if "%%~t" neq "" ( set "h2p_url_percd=%%~A%%%%%%~B%%%%%%~C%%%%%%~D%%%%%%~E%%%%%%~F%%%%%%~G%%%%%%~H%%%%%%~I%%%%%%~J%%%%%%~K%%%%%%~L%%%%%%~M%%%%%%~N%%%%%%~O%%%%%%~P%%%%%%~Q%%%%%%~R%%%%%%~S%%%%%%~T%%%%%%~U%%%%%%~V%%%%%%~W%%%%%%~X%%%%%%~Y%%%%%%~a%%%%%%~b%%%%%%~c%%%%%%~d%%%%%%~e%%%%%%~f%%%%%%~g%%%%%%~h%%%%%%~i%%%%%%~j%%%%%%~k%%%%%%~l%%%%%%~m%%%%%%~n%%%%%%~o%%%%%%~p%%%%%%~q%%%%%%~r%%%%%%~s%%%%%%~t"
    ) else if "%%~s" neq "" ( set "h2p_url_percd=%%~A%%%%%%~B%%%%%%~C%%%%%%~D%%%%%%~E%%%%%%~F%%%%%%~G%%%%%%~H%%%%%%~I%%%%%%~J%%%%%%~K%%%%%%~L%%%%%%~M%%%%%%~N%%%%%%~O%%%%%%~P%%%%%%~Q%%%%%%~R%%%%%%~S%%%%%%~T%%%%%%~U%%%%%%~V%%%%%%~W%%%%%%~X%%%%%%~Y%%%%%%~a%%%%%%~b%%%%%%~c%%%%%%~d%%%%%%~e%%%%%%~f%%%%%%~g%%%%%%~h%%%%%%~i%%%%%%~j%%%%%%~k%%%%%%~l%%%%%%~m%%%%%%~n%%%%%%~o%%%%%%~p%%%%%%~q%%%%%%~r%%%%%%~s"
    ) else if "%%~r" neq "" ( set "h2p_url_percd=%%~A%%%%%%~B%%%%%%~C%%%%%%~D%%%%%%~E%%%%%%~F%%%%%%~G%%%%%%~H%%%%%%~I%%%%%%~J%%%%%%~K%%%%%%~L%%%%%%~M%%%%%%~N%%%%%%~O%%%%%%~P%%%%%%~Q%%%%%%~R%%%%%%~S%%%%%%~T%%%%%%~U%%%%%%~V%%%%%%~W%%%%%%~X%%%%%%~Y%%%%%%~a%%%%%%~b%%%%%%~c%%%%%%~d%%%%%%~e%%%%%%~f%%%%%%~g%%%%%%~h%%%%%%~i%%%%%%~j%%%%%%~k%%%%%%~l%%%%%%~m%%%%%%~n%%%%%%~o%%%%%%~p%%%%%%~q%%%%%%~r"
    ) else if "%%~q" neq "" ( set "h2p_url_percd=%%~A%%%%%%~B%%%%%%~C%%%%%%~D%%%%%%~E%%%%%%~F%%%%%%~G%%%%%%~H%%%%%%~I%%%%%%~J%%%%%%~K%%%%%%~L%%%%%%~M%%%%%%~N%%%%%%~O%%%%%%~P%%%%%%~Q%%%%%%~R%%%%%%~S%%%%%%~T%%%%%%~U%%%%%%~V%%%%%%~W%%%%%%~X%%%%%%~Y%%%%%%~a%%%%%%~b%%%%%%~c%%%%%%~d%%%%%%~e%%%%%%~f%%%%%%~g%%%%%%~h%%%%%%~i%%%%%%~j%%%%%%~k%%%%%%~l%%%%%%~m%%%%%%~n%%%%%%~o%%%%%%~p%%%%%%~q"
    ) else if "%%~p" neq "" ( set "h2p_url_percd=%%~A%%%%%%~B%%%%%%~C%%%%%%~D%%%%%%~E%%%%%%~F%%%%%%~G%%%%%%~H%%%%%%~I%%%%%%~J%%%%%%~K%%%%%%~L%%%%%%~M%%%%%%~N%%%%%%~O%%%%%%~P%%%%%%~Q%%%%%%~R%%%%%%~S%%%%%%~T%%%%%%~U%%%%%%~V%%%%%%~W%%%%%%~X%%%%%%~Y%%%%%%~a%%%%%%~b%%%%%%~c%%%%%%~d%%%%%%~e%%%%%%~f%%%%%%~g%%%%%%~h%%%%%%~i%%%%%%~j%%%%%%~k%%%%%%~l%%%%%%~m%%%%%%~n%%%%%%~o%%%%%%~p"
    ) else if "%%~o" neq "" ( set "h2p_url_percd=%%~A%%%%%%~B%%%%%%~C%%%%%%~D%%%%%%~E%%%%%%~F%%%%%%~G%%%%%%~H%%%%%%~I%%%%%%~J%%%%%%~K%%%%%%~L%%%%%%~M%%%%%%~N%%%%%%~O%%%%%%~P%%%%%%~Q%%%%%%~R%%%%%%~S%%%%%%~T%%%%%%~U%%%%%%~V%%%%%%~W%%%%%%~X%%%%%%~Y%%%%%%~a%%%%%%~b%%%%%%~c%%%%%%~d%%%%%%~e%%%%%%~f%%%%%%~g%%%%%%~h%%%%%%~i%%%%%%~j%%%%%%~k%%%%%%~l%%%%%%~m%%%%%%~n%%%%%%~o"
    ) else if "%%~n" neq "" ( set "h2p_url_percd=%%~A%%%%%%~B%%%%%%~C%%%%%%~D%%%%%%~E%%%%%%~F%%%%%%~G%%%%%%~H%%%%%%~I%%%%%%~J%%%%%%~K%%%%%%~L%%%%%%~M%%%%%%~N%%%%%%~O%%%%%%~P%%%%%%~Q%%%%%%~R%%%%%%~S%%%%%%~T%%%%%%~U%%%%%%~V%%%%%%~W%%%%%%~X%%%%%%~Y%%%%%%~a%%%%%%~b%%%%%%~c%%%%%%~d%%%%%%~e%%%%%%~f%%%%%%~g%%%%%%~h%%%%%%~i%%%%%%~j%%%%%%~k%%%%%%~l%%%%%%~m%%%%%%~n"
    ) else if "%%~m" neq "" ( set "h2p_url_percd=%%~A%%%%%%~B%%%%%%~C%%%%%%~D%%%%%%~E%%%%%%~F%%%%%%~G%%%%%%~H%%%%%%~I%%%%%%~J%%%%%%~K%%%%%%~L%%%%%%~M%%%%%%~N%%%%%%~O%%%%%%~P%%%%%%~Q%%%%%%~R%%%%%%~S%%%%%%~T%%%%%%~U%%%%%%~V%%%%%%~W%%%%%%~X%%%%%%~Y%%%%%%~a%%%%%%~b%%%%%%~c%%%%%%~d%%%%%%~e%%%%%%~f%%%%%%~g%%%%%%~h%%%%%%~i%%%%%%~j%%%%%%~k%%%%%%~l%%%%%%~m"
    ) else if "%%~l" neq "" ( set "h2p_url_percd=%%~A%%%%%%~B%%%%%%~C%%%%%%~D%%%%%%~E%%%%%%~F%%%%%%~G%%%%%%~H%%%%%%~I%%%%%%~J%%%%%%~K%%%%%%~L%%%%%%~M%%%%%%~N%%%%%%~O%%%%%%~P%%%%%%~Q%%%%%%~R%%%%%%~S%%%%%%~T%%%%%%~U%%%%%%~V%%%%%%~W%%%%%%~X%%%%%%~Y%%%%%%~a%%%%%%~b%%%%%%~c%%%%%%~d%%%%%%~e%%%%%%~f%%%%%%~g%%%%%%~h%%%%%%~i%%%%%%~j%%%%%%~k%%%%%%~l"
    ) else if "%%~k" neq "" ( set "h2p_url_percd=%%~A%%%%%%~B%%%%%%~C%%%%%%~D%%%%%%~E%%%%%%~F%%%%%%~G%%%%%%~H%%%%%%~I%%%%%%~J%%%%%%~K%%%%%%~L%%%%%%~M%%%%%%~N%%%%%%~O%%%%%%~P%%%%%%~Q%%%%%%~R%%%%%%~S%%%%%%~T%%%%%%~U%%%%%%~V%%%%%%~W%%%%%%~X%%%%%%~Y%%%%%%~a%%%%%%~b%%%%%%~c%%%%%%~d%%%%%%~e%%%%%%~f%%%%%%~g%%%%%%~h%%%%%%~i%%%%%%~j%%%%%%~k"
    ) else if "%%~j" neq "" ( set "h2p_url_percd=%%~A%%%%%%~B%%%%%%~C%%%%%%~D%%%%%%~E%%%%%%~F%%%%%%~G%%%%%%~H%%%%%%~I%%%%%%~J%%%%%%~K%%%%%%~L%%%%%%~M%%%%%%~N%%%%%%~O%%%%%%~P%%%%%%~Q%%%%%%~R%%%%%%~S%%%%%%~T%%%%%%~U%%%%%%~V%%%%%%~W%%%%%%~X%%%%%%~Y%%%%%%~a%%%%%%~b%%%%%%~c%%%%%%~d%%%%%%~e%%%%%%~f%%%%%%~g%%%%%%~h%%%%%%~i%%%%%%~j"
    ) else if "%%~i" neq "" ( set "h2p_url_percd=%%~A%%%%%%~B%%%%%%~C%%%%%%~D%%%%%%~E%%%%%%~F%%%%%%~G%%%%%%~H%%%%%%~I%%%%%%~J%%%%%%~K%%%%%%~L%%%%%%~M%%%%%%~N%%%%%%~O%%%%%%~P%%%%%%~Q%%%%%%~R%%%%%%~S%%%%%%~T%%%%%%~U%%%%%%~V%%%%%%~W%%%%%%~X%%%%%%~Y%%%%%%~a%%%%%%~b%%%%%%~c%%%%%%~d%%%%%%~e%%%%%%~f%%%%%%~g%%%%%%~h%%%%%%~i"
    ) else if "%%~h" neq "" ( set "h2p_url_percd=%%~A%%%%%%~B%%%%%%~C%%%%%%~D%%%%%%~E%%%%%%~F%%%%%%~G%%%%%%~H%%%%%%~I%%%%%%~J%%%%%%~K%%%%%%~L%%%%%%~M%%%%%%~N%%%%%%~O%%%%%%~P%%%%%%~Q%%%%%%~R%%%%%%~S%%%%%%~T%%%%%%~U%%%%%%~V%%%%%%~W%%%%%%~X%%%%%%~Y%%%%%%~a%%%%%%~b%%%%%%~c%%%%%%~d%%%%%%~e%%%%%%~f%%%%%%~g%%%%%%~h"
    ) else if "%%~g" neq "" ( set "h2p_url_percd=%%~A%%%%%%~B%%%%%%~C%%%%%%~D%%%%%%~E%%%%%%~F%%%%%%~G%%%%%%~H%%%%%%~I%%%%%%~J%%%%%%~K%%%%%%~L%%%%%%~M%%%%%%~N%%%%%%~O%%%%%%~P%%%%%%~Q%%%%%%~R%%%%%%~S%%%%%%~T%%%%%%~U%%%%%%~V%%%%%%~W%%%%%%~X%%%%%%~Y%%%%%%~a%%%%%%~b%%%%%%~c%%%%%%~d%%%%%%~e%%%%%%~f%%%%%%~g"
    ) else if "%%~f" neq "" ( set "h2p_url_percd=%%~A%%%%%%~B%%%%%%~C%%%%%%~D%%%%%%~E%%%%%%~F%%%%%%~G%%%%%%~H%%%%%%~I%%%%%%~J%%%%%%~K%%%%%%~L%%%%%%~M%%%%%%~N%%%%%%~O%%%%%%~P%%%%%%~Q%%%%%%~R%%%%%%~S%%%%%%~T%%%%%%~U%%%%%%~V%%%%%%~W%%%%%%~X%%%%%%~Y%%%%%%~a%%%%%%~b%%%%%%~c%%%%%%~d%%%%%%~e%%%%%%~f"
    ) else if "%%~e" neq "" ( set "h2p_url_percd=%%~A%%%%%%~B%%%%%%~C%%%%%%~D%%%%%%~E%%%%%%~F%%%%%%~G%%%%%%~H%%%%%%~I%%%%%%~J%%%%%%~K%%%%%%~L%%%%%%~M%%%%%%~N%%%%%%~O%%%%%%~P%%%%%%~Q%%%%%%~R%%%%%%~S%%%%%%~T%%%%%%~U%%%%%%~V%%%%%%~W%%%%%%~X%%%%%%~Y%%%%%%~a%%%%%%~b%%%%%%~c%%%%%%~d%%%%%%~e"
    ) else if "%%~d" neq "" ( set "h2p_url_percd=%%~A%%%%%%~B%%%%%%~C%%%%%%~D%%%%%%~E%%%%%%~F%%%%%%~G%%%%%%~H%%%%%%~I%%%%%%~J%%%%%%~K%%%%%%~L%%%%%%~M%%%%%%~N%%%%%%~O%%%%%%~P%%%%%%~Q%%%%%%~R%%%%%%~S%%%%%%~T%%%%%%~U%%%%%%~V%%%%%%~W%%%%%%~X%%%%%%~Y%%%%%%~a%%%%%%~b%%%%%%~c%%%%%%~d"
    ) else if "%%~c" neq "" ( set "h2p_url_percd=%%~A%%%%%%~B%%%%%%~C%%%%%%~D%%%%%%~E%%%%%%~F%%%%%%~G%%%%%%~H%%%%%%~I%%%%%%~J%%%%%%~K%%%%%%~L%%%%%%~M%%%%%%~N%%%%%%~O%%%%%%~P%%%%%%~Q%%%%%%~R%%%%%%~S%%%%%%~T%%%%%%~U%%%%%%~V%%%%%%~W%%%%%%~X%%%%%%~Y%%%%%%~a%%%%%%~b%%%%%%~c"
    ) else if "%%~b" neq "" ( set "h2p_url_percd=%%~A%%%%%%~B%%%%%%~C%%%%%%~D%%%%%%~E%%%%%%~F%%%%%%~G%%%%%%~H%%%%%%~I%%%%%%~J%%%%%%~K%%%%%%~L%%%%%%~M%%%%%%~N%%%%%%~O%%%%%%~P%%%%%%~Q%%%%%%~R%%%%%%~S%%%%%%~T%%%%%%~U%%%%%%~V%%%%%%~W%%%%%%~X%%%%%%~Y%%%%%%~a%%%%%%~b"
    ) else if "%%~a" neq "" ( set "h2p_url_percd=%%~A%%%%%%~B%%%%%%~C%%%%%%~D%%%%%%~E%%%%%%~F%%%%%%~G%%%%%%~H%%%%%%~I%%%%%%~J%%%%%%~K%%%%%%~L%%%%%%~M%%%%%%~N%%%%%%~O%%%%%%~P%%%%%%~Q%%%%%%~R%%%%%%~S%%%%%%~T%%%%%%~U%%%%%%~V%%%%%%~W%%%%%%~X%%%%%%~Y%%%%%%~a"
    )
    ) else if "%%~Y" neq "" ( set "h2p_url_percd=%%~A%%%%%%~B%%%%%%~C%%%%%%~D%%%%%%~E%%%%%%~F%%%%%%~G%%%%%%~H%%%%%%~I%%%%%%~J%%%%%%~K%%%%%%~L%%%%%%~M%%%%%%~N%%%%%%~O%%%%%%~P%%%%%%~Q%%%%%%~R%%%%%%~S%%%%%%~T%%%%%%~U%%%%%%~V%%%%%%~W%%%%%%~X%%%%%%~Y"
    ) else if "%%~X" neq "" ( set "h2p_url_percd=%%~A%%%%%%~B%%%%%%~C%%%%%%~D%%%%%%~E%%%%%%~F%%%%%%~G%%%%%%~H%%%%%%~I%%%%%%~J%%%%%%~K%%%%%%~L%%%%%%~M%%%%%%~N%%%%%%~O%%%%%%~P%%%%%%~Q%%%%%%~R%%%%%%~S%%%%%%~T%%%%%%~U%%%%%%~V%%%%%%~W%%%%%%~X"
    ) else if "%%~W" neq "" ( set "h2p_url_percd=%%~A%%%%%%~B%%%%%%~C%%%%%%~D%%%%%%~E%%%%%%~F%%%%%%~G%%%%%%~H%%%%%%~I%%%%%%~J%%%%%%~K%%%%%%~L%%%%%%~M%%%%%%~N%%%%%%~O%%%%%%~P%%%%%%~Q%%%%%%~R%%%%%%~S%%%%%%~T%%%%%%~U%%%%%%~V%%%%%%~W"
    ) else if "%%~V" neq "" ( set "h2p_url_percd=%%~A%%%%%%~B%%%%%%~C%%%%%%~D%%%%%%~E%%%%%%~F%%%%%%~G%%%%%%~H%%%%%%~I%%%%%%~J%%%%%%~K%%%%%%~L%%%%%%~M%%%%%%~N%%%%%%~O%%%%%%~P%%%%%%~Q%%%%%%~R%%%%%%~S%%%%%%~T%%%%%%~U%%%%%%~V"
    ) else if "%%~U" neq "" ( set "h2p_url_percd=%%~A%%%%%%~B%%%%%%~C%%%%%%~D%%%%%%~E%%%%%%~F%%%%%%~G%%%%%%~H%%%%%%~I%%%%%%~J%%%%%%~K%%%%%%~L%%%%%%~M%%%%%%~N%%%%%%~O%%%%%%~P%%%%%%~Q%%%%%%~R%%%%%%~S%%%%%%~T%%%%%%~U"
    ) else if "%%~T" neq "" ( set "h2p_url_percd=%%~A%%%%%%~B%%%%%%~C%%%%%%~D%%%%%%~E%%%%%%~F%%%%%%~G%%%%%%~H%%%%%%~I%%%%%%~J%%%%%%~K%%%%%%~L%%%%%%~M%%%%%%~N%%%%%%~O%%%%%%~P%%%%%%~Q%%%%%%~R%%%%%%~S%%%%%%~T"
    ) else if "%%~S" neq "" ( set "h2p_url_percd=%%~A%%%%%%~B%%%%%%~C%%%%%%~D%%%%%%~E%%%%%%~F%%%%%%~G%%%%%%~H%%%%%%~I%%%%%%~J%%%%%%~K%%%%%%~L%%%%%%~M%%%%%%~N%%%%%%~O%%%%%%~P%%%%%%~Q%%%%%%~R%%%%%%~S"
    ) else if "%%~R" neq "" ( set "h2p_url_percd=%%~A%%%%%%~B%%%%%%~C%%%%%%~D%%%%%%~E%%%%%%~F%%%%%%~G%%%%%%~H%%%%%%~I%%%%%%~J%%%%%%~K%%%%%%~L%%%%%%~M%%%%%%~N%%%%%%~O%%%%%%~P%%%%%%~Q%%%%%%~R"
    ) else if "%%~Q" neq "" ( set "h2p_url_percd=%%~A%%%%%%~B%%%%%%~C%%%%%%~D%%%%%%~E%%%%%%~F%%%%%%~G%%%%%%~H%%%%%%~I%%%%%%~J%%%%%%~K%%%%%%~L%%%%%%~M%%%%%%~N%%%%%%~O%%%%%%~P%%%%%%~Q"
    ) else if "%%~P" neq "" ( set "h2p_url_percd=%%~A%%%%%%~B%%%%%%~C%%%%%%~D%%%%%%~E%%%%%%~F%%%%%%~G%%%%%%~H%%%%%%~I%%%%%%~J%%%%%%~K%%%%%%~L%%%%%%~M%%%%%%~N%%%%%%~O%%%%%%~P"
    ) else if "%%~O" neq "" ( set "h2p_url_percd=%%~A%%%%%%~B%%%%%%~C%%%%%%~D%%%%%%~E%%%%%%~F%%%%%%~G%%%%%%~H%%%%%%~I%%%%%%~J%%%%%%~K%%%%%%~L%%%%%%~M%%%%%%~N%%%%%%~O"
    ) else if "%%~N" neq "" ( set "h2p_url_percd=%%~A%%%%%%~B%%%%%%~C%%%%%%~D%%%%%%~E%%%%%%~F%%%%%%~G%%%%%%~H%%%%%%~I%%%%%%~J%%%%%%~K%%%%%%~L%%%%%%~M%%%%%%~N"
    ) else if "%%~M" neq "" ( set "h2p_url_percd=%%~A%%%%%%~B%%%%%%~C%%%%%%~D%%%%%%~E%%%%%%~F%%%%%%~G%%%%%%~H%%%%%%~I%%%%%%~J%%%%%%~K%%%%%%~L%%%%%%~M"
    ) else if "%%~L" neq "" ( set "h2p_url_percd=%%~A%%%%%%~B%%%%%%~C%%%%%%~D%%%%%%~E%%%%%%~F%%%%%%~G%%%%%%~H%%%%%%~I%%%%%%~J%%%%%%~K%%%%%%~L"
    ) else if "%%~K" neq "" ( set "h2p_url_percd=%%~A%%%%%%~B%%%%%%~C%%%%%%~D%%%%%%~E%%%%%%~F%%%%%%~G%%%%%%~H%%%%%%~I%%%%%%~J%%%%%%~K"
    ) else if "%%~J" neq "" ( set "h2p_url_percd=%%~A%%%%%%~B%%%%%%~C%%%%%%~D%%%%%%~E%%%%%%~F%%%%%%~G%%%%%%~H%%%%%%~I%%%%%%~J"
    ) else if "%%~I" neq "" ( set "h2p_url_percd=%%~A%%%%%%~B%%%%%%~C%%%%%%~D%%%%%%~E%%%%%%~F%%%%%%~G%%%%%%~H%%%%%%~I"
    ) else if "%%~H" neq "" ( set "h2p_url_percd=%%~A%%%%%%~B%%%%%%~C%%%%%%~D%%%%%%~E%%%%%%~F%%%%%%~G%%%%%%~H"
    ) else if "%%~G" neq "" ( set "h2p_url_percd=%%~A%%%%%%~B%%%%%%~C%%%%%%~D%%%%%%~E%%%%%%~F%%%%%%~G"
    ) else if "%%~F" neq "" ( set "h2p_url_percd=%%~A%%%%%%~B%%%%%%~C%%%%%%~D%%%%%%~E%%%%%%~F"
    ) else if "%%~E" neq "" ( set "h2p_url_percd=%%~A%%%%%%~B%%%%%%~C%%%%%%~D%%%%%%~E"
    ) else if "%%~D" neq "" ( set "h2p_url_percd=%%~A%%%%%%~B%%%%%%~C%%%%%%~D"
    ) else if "%%~C" neq "" ( set "h2p_url_percd=%%~A%%%%%%~B%%%%%%~C"
    ) else if "%%~B" neq "" ( set "h2p_url_percd=%%~A%%%%%%~B"
    ) else if "%%~A" neq "" ( set "h2p_url_percd=%%~A"
    )
goto :eof
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::



::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::: Args Parse -- Extended
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:func_h2p_pargs_help
    if "-%~1" equ "-"  (
        call :func_h2p_ahelp_me
        goto :eof
    ) else if "-%~1" equ "-debug"  ( 
        call :func_h2p_ahelp_pebug
        goto :eof
    ) else if "-%~1" equ "-params" ( 
        call :func_h2p_ahelp_params
        goto :eof
    ) else if "-%~1" equ "-vars" ( 
        call :func_h2p_ahelp_pars
        goto :eof
    ) else if "-%~1" equ "-variables" ( 
        call :func_h2p_ahelp_pars
        goto :eof
    ) else if "-%~1" equ "-full"   ( 
        call :func_h2p_ahelp_me
        call :func_h2p_ahelp_params
        call :func_h2p_ahelp_pars
        call :func_h2p_ahelp_pebug
        goto :eof
    )
goto :eof

::  Usage  ::  func_h2p_pargs_debug    paramSwitches
rem  sets deubg config based on param switches.
rem  Note: ForVar to Param mapping:
rem       -debug:(b) -- -debug:(%~1%~2%~3) -debug:(%1%2%3) 
rem   -debug:(g,h,i) -- -debug:(%~1,%~2,%~3)
:func_h2p_pargs_debug
    if "%~1%~2%~3" equ "" set "debug_h2p_msgs=true" & goto :eof
    if "%~1" equ "" goto :eof

    set "debug_states_true= true  yes on  aye enable  + hecka-ya accepted surething IAlsoLikeTurtles"
    set "debug_states_false=false no  off nay disable - hecka-no denied IDontThinkSo under9000 NoMilk"
    
    rem quick quickies [-debug:bool(on):feature]
    rem Examples: -debug:true:terse
    rem           -debug:on
    for %%A in (%debug_states_true%) do if /i "%%~A" equ "%~1%~2%~3" (  
        set "debug_h2p_msgs=true" 
        goto :eof
    ) else if /i "%%~A" equ "%~1" (
               if "%~2%~3" equ    ""     ( set "debug_h2p_msgs=true"
        ) else if /i "%~2" equ "output"  ( set "debug_h2p_msgs=true"
        ) else if /i "%~2" equ "debug"   ( set "debug_h2p_msgs=true"
        ) else if /i "%~2" equ "lines"   ( set "debug_h2p_grab_lnum=true"
        ) else if /i "%~2" equ "terse"   ( set "debug_h2p_terse_msgs=true"
        ) else if /i "%~2" equ "verbose" ( set "debug_h2p_terse_msgs="
        ) else if /i "%~2" equ "all"     (
                                           set "debug_h2p_msgs=true"
                                           set "debug_h2p_grab_lnum=true"
                                           set "debug_h2p_terse_msgs="
                                           @echo on
        ) else if /i "%~2" equ "trace"  @( echo on
        )
        @goto :eof
    )
    
    rem quick quickies [-debug:bool(off):feature]
    rem Examples: -debug:disable:lines
    rem           -debug:off
    for %%A in (%debug_states_false%) do if /i "%%~A" equ "%~1%~2%~3" (
        @echo off & set "debug_h2p_msgs="
        goto :eof
    ) else if /i "%%~A" equ "%~1" (
               if "%~2%~3" equ    ""     ( set "debug_h2p_msgs="
        ) else if /i "%~2" equ "output"  ( set "debug_h2p_msgs="
        ) else if /i "%~2" equ "debug"   ( set "debug_h2p_msgs="
        ) else if /i "%~2" equ "lines"   ( set "debug_h2p_grab_lnum="
        ) else if /i "%~2" equ "terse"   ( set "debug_h2p_terse_msgs="
        ) else if /i "%~2" equ "verbose" ( set "debug_h2p_terse_msgs="
        ) else if /i "%~2" equ "all"     (
                                           set "debug_h2p_msgs="
                                           set "debug_h2p_grab_lnum="
                                           set "debug_h2p_terse_msgs=true"
                                           @echo off
        ) else if /i "%~2" equ "trace"  @( echo off 
        )
        @goto :eof
    )

    rem quick quickies [-debug:[outString]:featureOrBool:Bool]
    rem Examples: -debug:output:lines:off
    rem           -debug:debug:off
    for %%A in (output debug logging log out) do if /i "%%~A" equ "%~1" (
               if "%~2%~3" equ   ""             ( @echo off & set "debug_h2p_msgs=true"
        ) else if /i "%~2" equ  "on"            ( @echo off & set "debug_h2p_msgs=true"
        ) else if /i "%~2" equ "off"            ( @echo off & set "debug_h2p_msgs="
        ) else if /i "%~2" equ "info"           (
                               @echo off
            if "%~3" equ ""    set "debug_h2p_msgs=true"
            if "%~3" equ "on"  set "debug_h2p_msgs=true"
            if "%~3" equ "off" set "debug_h2p_msgs="
        
        ) else if /i "%~2" equ "terse"          (
                               @echo off
            if "%~3" equ ""    set "debug_h2p_terse_msgs=true"
            for %%u in (%debug_states_true%) do if /i "%~3" equ "%%~u" set "debug_h2p_terse_msgs=true"
            for %%u in (%debug_states_false%) do if /i "%~3" equ "%%~u" set "debug_h2p_terse_msgs="
        
        ) else if /i "%~2" equ "verbose"        (
                               @echo off
            if "%~3" equ ""    set "debug_h2p_terse_msgs="
            for %%u in (%debug_states_true%) do if /i "%~3" equ "%%~u" set "debug_h2p_terse_msgs="
            for %%u in (%debug_states_false%) do if /i "%~3" equ "%%~u" set "debug_h2p_terse_msgs=true"
        
        ) else if /i "%~2" equ "trace"          (
            if "%~3" equ ""    @echo on
            for %%u in (%debug_states_true%) do if /i "%~3" equ "%%~u" @echo on
            for %%u in (%debug_states_false%) do if /i "%~3" equ "%%~u" @echo off

        ) else if /i "%~2" equ "lines"          (
            if "%~3" equ ""    set "debug_h2p_grab_lnum=true"
            for %%u in (%debug_states_true%) do if /i "%~3" equ "%%~u" set "debug_h2p_grab_lnum=true"
            for %%u in (%debug_states_false%) do if /i "%~3" equ "%%~u" set "debug_h2p_grab_lnum="
        )
        @goto :eof
    )

    rem --debug:lines:undef(toogle(on,off))
    rem --debug:lines:bool(on,off)
    if /i "-%~1" equ "-lines" if "%~2" equ "" (
        if defined debug_h2p_grab_lnum ( echo/--debug:%~1:[on/off] Setting toggle: off
            set "debug_h2p_grab_lnum="  
        ) else                         ( echo/--debug:%~1:[on/off] Setting toggle: on
            set "debug_h2p_grab_lnum=true"
        )
        goto :eof
    ) else (
        for %%A in (%debug_states_true%) do if /i "%~2" equ "%%~A"  set "debug_h2p_grab_lnum=true"
        for %%A in (%debug_states_false%) do if /i "%~2" equ "%%~A"  set "debug_h2p_grab_lnum="
        goto :eof
    )

    rem --debug:trace:undef(toogle(on,off))
    rem --debug:trace:bool(on,off)
    if /i "-%~1" equ "-trace" if "%~2" equ "" (
        for /f "tokens=3 delims=. " %%E in ('echo') do @(
            if /i "%%~E" equ "on"         @( echo/--debug:%~1:[on/off] Setting toggle: off
                echo off
            ) else                        @( echo/--debug:%~1:[on/off] Setting toggle: on
                echo on
            )
        )
        @goto :eof
    ) else (
        @for %%u in (%debug_states_true%) do @if /i "%~2" equ "%%~u" @echo on
        @for %%u in (%debug_states_false%) do @if /i "%~2" equ "%%~u" @echo off
        @goto :eof
    )

    rem --debug:verbose:undef(toogle(on,off))
    rem --debug:verbose:bool(on,off)
    if /i "-%~1" equ "-verbose" if "%~2" equ "" (
        if defined debug_h2p_terse_msgs ( echo/--debug:%~1:[on/off] Setting toggle: off
            set "debug_h2p_terse_msgs="
        ) else                         ( echo/--debug:%~1:[on/off] Setting toggle: on
            set "debug_h2p_grab_lnum=true"
        )
        goto :eof
    ) else (
        for %%u in (%debug_states_true%) do if /i "%~2" equ "%%~u"  set "debug_h2p_terse_msgs="
        for %%u in (%debug_states_false%) do if /i "%~2" equ "%%~u"  set "debug_h2p_terse_msgs=true"
        goto :eof
    )

goto :eof
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
