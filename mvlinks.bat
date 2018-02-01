::  by JaCk  |  Release 10/05/2017  |  https://github.com/1ijack/BatchMajeek/blob/master/mvlinks.bat  | mvlinks.bat -- uses sysinternals findlinks.exe to recursively dump linkcount and links from a root directory and then move entire structure to another root source directory.  Should handle almost all filenames thrown at it.
::::::::::  ::::  ::::  ::::  :::::::::
@echo off & setlocal DisableDelayedExpansion EnableExtensions & (for /f "tokens=1 delims==" %%V in ('set mlk_') do set "%%V=") 2>nul 1>nul

::: Settings and vars ::::::
::
rem Source directory tree, dir syntax is OK
 set "mlk_root_dirtree_src=%~1"
 
rem Target/New directory tree -- When just drive letter, append a colon, ie: "D:"
 set "mlk_root_dirtree_new=%~d2"

rem findlinks binary, add a path if it's not in %path% or %cd%
 set "mk_fln_bin=%ProgramData%\chocolatey\bin\FindLinks.exe"
 REM set "mk_fln_bin="

rem  Soon to be obsolete and removed...
    rem Filters for file types.  findstr syntax is OK  -- Currently Ignored
     REM set "mlk_filter_accepted_extensions=.avi$ .mkv$ .mpg$ .mpeg$ .webm$ .mp4$ .ogm$ .mov$ .flv$ .bik$"
     REM set "mlk_filter_ignore_list=.\-.Manga. .\-.Sound. Relation. .\\meta\\."
:::::::::::::::::::::::::::::::::::::::


::: Script internal settings ::::::
::
rem Type: bool: [true/undef] -- When set to true, script moves unlinked files as well as linked.  When undef, only linked files are moved/relinked.
 set "mlk_bool_mv_type_all=true"

rem Type: int: [0/1/etc] -- Internal Counter, do not modify unless you know what you're doing -- Count X links for the original file? When defined as "1", the lowest number of links would be 0, then 2.
 set "mlk_filesrc_as_link=1"
:::::::::::::::::::::::::::::::::::::::

::: Init - Check n Check :::  Run Main  ::: Deinit -- clean up and leave
call :func_mlk_init
if "%errorlevel%" neq "0" echo/Error: Too Lazy to print &goto :eof 
call :func_mlk_get_and_process_links "%mlk_root_dirtree_src%"
call :func_mlk_uninit
timeout /t 25
goto :eof


:::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::




:::::::::::::::::::::::::::::::::::::::
:::                                 :::
::             Bunctions             ::
::               -   -               ::
::        BatchLike-functions        ::
:::                                 :::
:::::::::::::::::::::::::::::::::::::::
goto :eof


rem   Unless Noted, the following applies to all "Bunctions"
rem     General:
rem      ~ Bunction names are to be unique, careful when nesting batchfiles so that the labels dont conflict
rem      ~ Prefixed with func_mlk_
rem     Parameters:
rem      ~ White-spaces ignored between params     whitespace   to   your   hearts   content
rem      ~ Double Quotes around bunction parameters, are dropped.  Therefore, quoting params are encouraged
rem      ~ Single Quotes around bunction parameters, are NOT dropped.
rem      ~ Back Quotes around bunction parameters, are NOT dropped.
rem      ~ First parameter [param1] is usually the name of the result variable [returnVar]
goto :eof
 
 
 
::  Usage  ::  func_mlk_init
rem  Basic script requirements/dependencies check 
:func_mlk_init
    rem process script booleans/Settings and check dependencies
    ( for /f "tokens=1,* delims==" %%A in ('set mlk_bool_') do if "%%~A" neq "" call :func_mlk_process_booleans "%%~A"  "%%~B"
    ) 2>nul
    
    set "mklink_cmd="
    ( for /f "eol= tokens=1 delims=" %%A in ('mklink /?') do if /i "%%~A" equ "Creates a symbolic link." set "mklink_cmd=true"
    ) 2>nul 1>nul 
  
    if "%mklink_cmd%" neq "true" exit /b 1
    
    REM ( mklink /? 
    REM ) | "%SystemRoot%\System32\findstr.exe" /r "\<Creates[^a-z0-9]a[^a-z0-9]symbolic.link\.\>" 2>nul 1>nul 
    REM if not 1%errorlevel% equ 10 exit /b 1
  
    if not defined mk_fln_bin ( for /f "delims=" %%F in ('"%SystemRoot%\System32\where.exe" findlinks.exe') do set "mk_fln_bin=%%~A"
    ) 2>nul 1>nul
    if not defined mk_fln_bin ( 
        echo/Error: Fatal: Unable to locate "findlinks.exe" or variable "mk_fln_bin" is undefined/incorrect.
        echo/Error: Fatal: Please make sure %~0 can see "findlinks.exe"
    ) 1>&2
    if not exist "%mk_fln_bin%" exit /b 1
    
  
    if not defined mlk_root_dirtree_src call :func_mlk_define_path  mlk_root_dirtree_src   "%~1"  "&echo/Input: Original Directory Tree"  "%cd%"
    if not defined mlk_root_dirtree_new call :func_mlk_define_path  mlk_root_dirtree_new   "%~2"  "&echo/Hint: Enter New Drive Letter:&echo/&echo/Input: New-Root: Directory/Drive" "N:"

    rem check, check-it-out, check, check-it-out
    for %%A in (
        %mlk_root_dirtree_src%
        %mlk_root_dirtree_new%
    ) do call :func_mlk_check_path "" "%%~A"

goto :eof
:::::::::::::::::::::::::::::::::::::::



::: Main - get links and move files
::
rem Recurse down a tree source with filters
REM archive1 -- 'dir /s /b /o /a:-h /a:-d "%mlk_root_dirtree_src%" ^| findstr /v /i "%mlk_filter_ignore_list%" ^| findstr /i "%mlk_filter_accepted_extensions%"'
REM archive2 -- call :func_mlk_get_and_process_links   "%mlk_root_dirtree_src%"

::  Usage  ::  func_mlk_subprocess  pathTo
:::::::::::::::::::::::::::::::::::::::

::  Usage  ::  func_mlk_uninit 
rem  Unsets env changes
:func_mlk_uninit
    ( for /f "tokens=1 delims==" %%V in ('set mlk_') do set "%%V="
    ) 2>nul 1>nul
    endlocal 
    exit /b
goto :eof


 
:: Usage :: func_mlk_check_path   optional-ReturBoolVar  "path"    "optional-Bool-silent"
rem  Checks if path exists 
rem  Note: param2: optional-Bool-silent -- when passed in, will suppress script msgs
rem  Errlvl returns codes:
rem    0 -- Path Exists
rem    1 -- Path Inaccessible or Does not exist
:func_mlk_check_path
    if "1%~2" equ "1" goto :eof
    if "1%~1" neq "1" set "%~1=true"
    
    if "%~a2" neq "" exit /b 0
    if exist "%~2" exit /b 0
    for /f "tokens=1" %%Q in ('
        %SystemRoot%\System32\attrib.exe "%~2"
    ') do if "%%~Q" neq "" goto :eof
    
    2>nul 1>nul dir /b /a "%~2"
    if "%errorlevel%" equ "0" goto :eof

    if "1%~1" neq "1" set "%~1="
    if "1%~3" neq "1" exit /b 1
    
    1>&2 echo/ Error: Check Path: Unable to locate "%~3"
    
    exit /b 1

goto :eof



::  Usage  :: func_mlk_define_path   returnVar   "optionalPath"   "optionalPromptMsg"    "optionalPromptDefaultPath"
rem  Check definition and validity of path, prompts user when needed 
rem  Misc: %~dp1 -- returns cd 
rem  Notes: 
rem             returVar -- sets path to this param
rem         optionalPath -- checks this path, sets to returnVar when valid
rem    optionalPromptMsg -- When needed to promp user, Use this text
:func_mlk_define_path
    if "%~1" equ "" goto :eof 
    if "%~2" neq "" set "%~1=%~2"

    if defined %~1 call :func_mlk_check_path "%%%~1%%"
    
    if defined %~1 call echo "%%%~1%%"
    REM pause
    
    if not defined %~1 if "%~3" neq "" call :func_mlk_get_user_input "%~1"         "%~3"            "%~4"
    if not defined %~1 if "%~3" equ "" call :func_mlk_get_user_input "%~1"   "Input: Path of %~1"   "%~4"
    
goto :eof



:: Usage :: func_mlk_get_and_process_links    "Path"
rem  Process all objects found in directory tree
:func_mlk_get_and_process_links
    if "%~1" equ "" goto :eof
    
    for /f "tokens=1* delims=" %%F in (
        'dir /s /b /o /a:-d "%~1"'
    ) do if "%%~nF" neq "" call :subr_mlk_links_process "%%~F"

goto :eof


    :: Usage :: subr_mlk_links_process    "Path"
    rem  Processes Object: unhides, Moves, removes, relinks, rehides objects from one dirtree to another
    rem  
    :subr_mlk_links_process
        if "%~1" equ "" goto :eof
        
        call :func_mlk_unhide "%~1"
        
        if not defined mlk_bool_mv_type_all for /f "tokens=2 delims=: " %%L in (
            'findlinks -nobanner "%~1" ^| findstr /i /C:"Links:"'
        ) do for %%l in ( 
            %%~L 
        ) do if 9%%~l gtr 90 call :func_mlk_floop_add_one   "%~1"  "%%~l"
        if not defined mlk_bool_mv_type_all goto :eof

        
        for /f "tokens=2 delims=: " %%L in (
            'findlinks -nobanner "%~1" ^| findstr /i /C:"Links:"'
        ) do for %%l in ( 
            %%~L 
        ) do call :func_mlk_floop_add_one   "%~1" "%%~l"

        
    goto :eof


    :: Usage :: func_mlk_floop_add_one  Path\File.Extension    TotalCount   
    rem  Processing the "self/main/source" file counter (mlk_filesrc_as_link)
    rem    Note: func exists mainly to circumvent delayed expansion
    rem    when var "mlk_filesrc_as_link" is undef in settings ("Script internal settings" Section), defaults to 0 ("Init" Section)
    :func_mlk_floop_add_one
        if "%~1" equ "" goto :eof
        
        set "mlk__lcnt=0"
        if "%~2" neq "" set /a "mlk__lcnt+=%~2"
        if defined mlk_filesrc_as_link set /a "mlk__lcnt+=%mlk_filesrc_as_link%"

        
        echo/-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~
        echo/
        echo/       Moving Source DirTree
        if 1%mlk__lcnt% leq 11 echo/ "%~nx1";
        if 1%mlk__lcnt% gtr 11 echo/ Links: %mlk__lcnt%;   "%~nx1";
        call :func_mlk_floop_cnt_vs_var  "%~1"  "%mlk_root_dirtree_new%%~pnx1"  "%mlk_root_dirtree_new%"
        echo/
        echo/-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~
        echo/

    goto :eof


    
:: Usage :: func_mlk_process_booleans   returBoolVar   setTestValue-Optional
rem  Sets returBoolVar:
rem    "true" - value of returBoolVar starts with "t","a","p","y" or "1" 
rem      ""   - [unsets the var] when not true
rem  Notes:
rem    - When param2 is defined - before param1 is evaluated - overwrites/sets param1 with param2
rem    - No need to pre-un-set the var as the var will be overwritten (when def)
rem    - Un/Pre-setting the var - param1s value can be passed as param2 - "setTestValue-Optional"
rem  Examples: 
rem    func  flag_overwrite   "true"
rem    func  flag_overread    "%user_overread%"
rem    func  flag_disable_state
:func_mlk_process_booleans
    if "%~1" equ "" exit /b 1
    if "%~2" neq "" set "%~1=%~2"
    
    set "mlk__BoP="
    for /f "tokens=1,* delims==" %%U in ('set "%~1"') do if "%%~U" neq "" set "mlk__BoP=%%V"
    if not defined mlk__BoP set "%~1=" & exit /b 0
    
    set "%~1=true"
    for %%A in (1 y p a t) do if /i "j%mlk__BoP:~0,1%" equ "j%%~A" ( set "mlk__BoP=" & goto :eof )
    
    set "%~1="
    set "mlk__BoP="

goto :eof
    rem Replaced block below with for loop - not sure why I didn't do that in the first place....
    rem 
    REM    if "%mlk__BoP:~0,1%" equ "1" set "mlk__BoP=" & goto :eof
    REM if /i "%mlk__BoP:~0,1%" equ "y" set "mlk__BoP=" & goto :eof
    REM if /i "%mlk__BoP:~0,1%" equ "p" set "mlk__BoP=" & goto :eof
    REM if /i "%mlk__BoP:~0,1%" equ "a" set "mlk__BoP=" & goto :eof 
    REM if /i "%mlk__BoP:~0,1%" equ "t" set "mlk__BoP=" & goto :eof
    


:: Usage :: func_mlk_floop_mv_fpath   OriginalFilePath   NewFilePath
:func_mlk_floop_mv_fpath
    if "%~1" equ "" exit /b 1
    if "%~2" equ "" exit /b 1

    if exist "%~2" exit /b 101

    ( move "%~1" "%~2"
    ) 1>nul 

    if not exist "%~2" (
        echo/ Error: Move Failed, file not found: "%~2"
        exit /b 1
    ) 1>&2 
    
    echo/  Moved    -- "%~2"
    if not defined mlk__HVar goto :eof
    
    echo/  Rehiding -- "%~2"
    call :func_mlk_hide "%~2"
    
goto :eof



:: Usage :: func_mlk_get_user_input  returnVar   msgText-Optional   defaultResponse-Optional
rem  Prompts User for input - sets Param1 with result;  prints Param2 and Param3 when provided
rem    Example usage: 
rem      func_mlk_get_user_input   varUserFeedback   "Input: User: Did you like %~nx0"   "N/A"
rem      func_mlk_get_user_input   varMySmexyLines   "&echo/&Input: User: Extra lines^?&echo/"   "check ;^)"
rem      func_mlk_get_user_input   userReponse       ""   ""
:func_mlk_get_user_input
    if "%~1" equ "" exit /b 1

    if "%~2" neq "" echo/%~2
    if "%~3" neq "" echo/   [Default: %~3]
    if "%~3" neq "" set "%~1=%~3"

    set /p "%~1= ~> "

goto :eof



:: Usage :: func_mlk_lnkfile   SourceFilePath   OldFilePath    DestFilePath 
rem  Links param1 with param2
rem    Example usage: 
rem      func_mlk_def_varpar   "C:\tools\bin\md5.cmd"   "C:\Users\Loser1\dropbox\backup\batch\PsMd5.cmd"
:func_mlk_lnkfile
    if "%~3" equ "" exit /b 1
    if "%~2" equ "" exit /b 1
    if "%~1" equ "" exit /b 1
    
    if exist "%~3" (
        echo/ Error: Cannot create link, destination file already exists
        echo/ Error: Destination file: "%~3" 
        exit /b 1
    ) 1>&2 
    
    if "%~d1" neq "%~d3" (
        echo/ Error: Cannot create link, destination file must be on the same drive as source file
        echo/ Error: Destination file: "%~d3" 
        echo/ Error:   Source    file: "%~d1" 
        exit /b 1
    ) 1>&2 
    
    if not exist "%~dp3" mkdir "%~dp3"
    
    ( mklink /H "%~3" "%~1"
    ) 2>nul 1>nul
    if not exist "%~3" (
        echo/ Error: Linking files 
        echo/  Info: Destination file: "%~3" 
        echo/  Info:   Source    file: "%~1" 
        echo/  Info: Command: 
        echo/    mklink /H "%~3" "%~1"
        exit /b 1
    ) 1>&2 
    
    echo/  ReLinked -- "%~3"

    if exist "%~3" del /q "%~2"

goto :eof
    REM 2>nul 1>nul findstr /r "[<][<][=][=][=][>][>]"



:: Usage :: func_mlk_floop_cnt_vs_var   Path\File.Extension     NewFilePath-Optional    NewRootPath-Optional    
rem  Displays the current Link Count and Links of File in param3.  This is used within a loop to display LinkCount and File Information on separate lines.
rem    Param1 - currentCount - this is the current link file count
rem    Param2 - integer - [default: 0] - Optional -- this is the link threshold -- when not def, defaults to 0
rem    Param3 - FilePath - "Source/Primary/Target" file to be processed
rem    Example:
rem      func_mlk_floop_cnt_vs_var  "C:\Dev\Scripts\PsMd5.cmd"
rem        Outputs:
rem             -- "C:\Dev\Scripts\PsMd5.cmd"
rem             -- "C:\Share\tools\scripts\md5.cmd"
rem             -- "C:\Users\Loser1\scripts\md5.bat"
rem             -- "C:\Users\Loser1\dropbox\backup\batch\PsMd5.cmd"
:func_mlk_floop_cnt_vs_var
    if "%~1" equ "" exit /b 101
    
    if "%~3" equ "" if defined mlk_root_dirtree_new call :nc_mlk_floop_cnt_vs_var "%~1"   "%~2"   "%mlk_root_dirtree_new%"   
    if "%~3" equ "" goto :eof
    if not exist "%~3" (
        echo/Error: Source Path Not found: "%~3"
        exit /b 1
    )
    
    if "%~2" equ "" if defined mlk_root_dirtree_new call :nc_mlk_floop_cnt_vs_var "%~1"   "%~dp2%~pnx1"   "%~3"
    if "%~2" equ "" goto :eof

    if not exist "%~dp2" (
        echo/Info: Creating Dir "%~dp2" 
        mkdir "%~dp2"
    )

    rem  dir /b /s /a:-d "%~1"
    for /f "tokens=1* delims=" %%N in ('
        findlinks -nobanner "%~1"
    ') do if "%%~aN" neq "" (
        if not exist "%~2" (
            call :func_mlk_floop_mv_fpath "%~1" "%~2"
        ) else if not exist "%~dp3%%~pnxN" (
            call :func_mlk_lnkfile   "%~2"    "%%~N"  "%~dp3%%~pnxN"
        )
    )
    
    if not exist "%~2" echo/ Error: New Source Not found: "%~2"
    echo/

goto :eof



:: Usage :: func_mlk_unhide    "path"    "optional-Bool-silent"
rem  Checks Hide flag and unhides when needed
rem  Note:  optional-Bool-silent -- when passed in, will suppress script msgs
rem  Errlvl returns codes:
rem    0 -- Not Hidden or unhidden without errors
rem    1 -- Path Inaccessible or Does not exist or Params empty
rem    2 -- Hidden cmd error
:func_mlk_unhide
    if "%~1" equ "" exit /b 1
    
    call :func_mlk_check_path "" "%~1"  "%~2"
    if not errorlevel 0 exit /b 1
    
    set "mlk__HVar=%~a1"
    if /i "%mlk__HVar:~3,1%" neq "h" ( set "mlk__HVar=" & exit /b 0 )

    2>nul 1>nul attrib -H /L /S /D "%~1"
    if "1%errorlevel%" neq "10" exit /b 2
    
    exit /b 0

goto :eof


:: Usage :: func_mlk_hide    "path"
rem  Checks var "mlk__HVar" and hides when needed
:func_mlk_hide
    if "%~1" equ "" exit /b 1
    
    if not defined mlk__HVar goto :eof
    set "mlk__HVar="
    
    2>nul 1>nul attrib +H /L /S /D "%~1"
    
    exit /b 0

goto :eof

