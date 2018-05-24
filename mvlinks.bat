::  by JaCk  |  DevRelease 05/23/2018  |  https://github.com/1ijack/BatchMajeek/blob/master/mvlinks.bat  | mvlinks.bat -- uses sysinternals findlinks.exe or windows fsutil.exe to recursively dump linkcount and links from a root directory and then move entire structure to another root source directory.  Should handle almost all filenames thrown at it.
::::::::::  ::::  ::::  ::::  :::::::::
@echo off & setlocal DisableDelayedExpansion EnableExtensions & ( (for /f "tokens=1 delims==" %%V in ('set mlk_') do set "%%V=") 2>nul 1>nul )

::: Settings and vars ::::::
::
rem Source directory tree, dir syntax is OK
 set "mlk_root_dirtree_src=%~1"
 
rem Target/New directory tree -- When just drive letter, append a colon, ie: "D:"
 set "mlk_root_dirtree_new=%~d2"

rem findlinks binary, add a path if it's not in %path% or %cd%
 set "mk_fln_bin=%ProgramData%\chocolatey\bin\FindLinks.exe"
 REM set "mk_fln_bin="

rem fsutil binary, add a path if it's not in %path% or %cd%
 set "mk_fsu_bin=%SystemRoot%\System32\fsutil.exe"
 REM set "mk_fsu_bin="
:::::::::::::::::::::::::::::::::::::::


::: Script internal settings ::::::
::
rem Type: bool: [true/undef] -- When set to true, script moves unlinked files as well as linked.  When undef, only linked files are moved/relinked.
 set "mlk_bool_mv_type_all=true"

rem Type: int: [0/1/etc] -- Internal Counter, do not modify unless you know what you're doing -- Count X links for the original file? When defined as "1", the lowest number of links would be 0, then 2.
 set "mlk_filesrc_as_link=1"

rem  Type: String: [<	>] -- tab character.  This character is used further in the script as a string delimiter for findlinks
set "mlk_tab_char=	"

rem  Type: bool: [true/undef] -- force 'fsutil.exe' instead of 'findlinks.exe'-- regardless of the existence of the 'findlinks.exe' binary.  Note, 'fsutil.exe' must exist somewhere in the path or correctly defined path in variable 'mk_fsu_bin'
 set "mk_bool_fsutil_force=true"
:::::::::::::::::::::::::::::::::::::::

::: Init - Check n Check :::  Run Main  ::: Deinit -- clean up and leave
call :func_mlk_init
if "%errorlevel%" neq "0" ( ( echo/Error: Generic: Too Lazy to print details) & goto :eof )
call :func_mlk_get_and_process_links "%mlk_root_dirtree_src%"
call :func_mlk_check_hidden_paths    "%mlk_root_dirtree_new%"
call :func_mlk_uninit
if "%~1%~2%~3" equ "" timeout /t 25
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
  

    rem  fsutil resolution
    if not defined mk_fsu_bin ( for /f "delims=" %%F in ('"%SystemRoot%\System32\where.exe" fsutil.exe   ') do if not defined mk_fsu_bin set "mk_fsu_bin=%%~A"
    ) 2>nul 1>nul
    
    rem  findlinks resolution
    if not defined mk_fln_bin ( for /f "delims=" %%F in ('"%SystemRoot%\System32\where.exe" findlinks.exe') do if not defined mk_fln_bin set "mk_fln_bin=%%~A"
    ) 2>nul 1>nul

    rem  red ink
    if not defined mk_fln_bin if not defined mk_fsu_bin (
        echo/Error: Fatal: Unable to locate  "fsutil.exe"  and  variable "mk_fsu_bin" is undefined/incorrect.
        echo/Error: Fatal: Unable to locate "findlinks.exe" and variable "mk_fln_bin" is undefined/incorrect.
        echo/Error: Fatal: Please make sure "%~0" can see "fsutil.exe" or "findlinks.exe"
    ) 1>&2
    if "%mklink_cmd%" neq "true" (
        echo/Error: Fatal: unusable command 'mklink'... missing help text: "Creates a symbolic link." 
    ) 1>&2

    if "%mklink_cmd%" neq "true" exit /b 1
    set "mk_use_fln="
    set "mk_use_fsu="
    
    rem  which binary to use 'findlinks' or 'fsutil'
    if defined mk_bool_fsutil_force (
        set "mk_use_fsu=true"
    ) else if exist "%mk_fln_bin%" (
        set "mk_use_fln=true"
    ) else if exist "%mk_fsu_bin%" (
        set "mk_use_fsu=true"
    ) else exit /b 1

    rem  When no errors encountered, check/prompt for paths
    if not defined mlk_root_dirtree_src call :func_mlk_define_path  mlk_root_dirtree_src   "%~1"  "&echo/Input: Original Directory Tree"  "%cd%"
    if not defined mlk_root_dirtree_new call :func_mlk_define_path  mlk_root_dirtree_new   "%~2"  "&echo/Hint: Enter New Drive Letter:&echo/&echo/Input: New-Root: Directory/Drive" "N:"

    rem check, check-it-out, check, check-it-out
    call :func_path_walker %mlk_root_dirtree_src% %mlk_root_dirtree_new%

goto :eof
:::::::::::::::::::::::::::::::::::::::


::  Usage  ::  func_path_walker  path1  "path2"  etc
rem  A shifter way to cycle through paths
:func_path_walker
    set /a "mlk_path_walker{counter{blank}}+=1"
    if "%~1" neq "" set "mlk_path_walker{counter{blank}}=0"
    if %mlk_path_walker{counter{blank}}%. geq 9. ( ( set "mlk_path_walker{counter{blank}}=" ) & goto :eof )

    if "%~1" neq "" call :func_mlk_check_path "" "%~1"

    shift /1
    goto %~0
    
goto :eof



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
    if "%~2" equ "" goto :eof
    if "%~1" neq "" set "%~1=true"
    
    if "%~a2" neq "" exit /b 0
    if exist "%~2"   exit /b 0
    for /f "tokens=1" %%Q in ('
        %SystemRoot%\System32\attrib.exe "%~2"
    ') do if "%%~Q" neq "" goto :eof
    
    2>nul 1>nul dir /b /a "%~2"
    if "%errorlevel%" equ "0" goto :eof

    if "%~1" neq "" set "%~1="
    if "%~3" neq "" exit /b 1
    
    1>&2 echo/ Error: Check Path: Unable to locate "%~2"
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

    if defined %~1 call :func_mlk_check_path "" "%%%~1%%"
    if defined %~1 ( ( call echo "%%%~1%%" ) & goto :eof )
    
    if "%~3" neq "" call :func_mlk_get_user_input "%~1"         "%~3"            "%~4"
    if "%~3" equ "" call :func_mlk_get_user_input "%~1"   "Input: Path of %~1"   "%~4"
    
goto :eof



:: Usage :: func_mlk_get_and_process_links    "Path"
rem  Process all objects found in directory tree
:func_mlk_get_and_process_links
    if "%~1" equ "" goto :eof

    if defined mk_use_fsu set "mlk_subr_link_process=:subr_mlk_links_process_fsutil"
    if defined mk_use_fln set "mlk_subr_link_process=:subr_mlk_links_process_findlinks"
    
    pushd "%~1"
    for /f "tokens=* delims=" %%F in (
        'dir /s /b /o /a "%~1"'
    ) do if "%%~nxF" neq "" call %mlk_subr_link_process%    "%%~F"
    popd

goto :eof


    :: Usage :: subr_mlk_links_process_fsutil    "Path"
    rem  Processes Object: unhides, Moves, removes, relinks, rehides objects from one dirtree to another
    rem  
    :subr_mlk_links_process_fsutil
        if "%~1" equ "" goto :eof
        call :func_mlk_unhide "%~1"

        rem  ignore processing directories
        set "mlk_pvar{One{attrib}}=%~a1"
        if /i "%mlk_pvar{One{attrib}}:~0,1%" equ "d" ( ( set "mlk_pvar{One{attrib}}=" ) & goto :eof )

        rem  match the link count to findlinks LINKCOUNT output
        set "mlk_process_file{count}=-1"
        
        rem  get hardlink count
        for /F "delims=" %%L in ('
            call "%mk_fsu_bin%" hardlink list "%~1"
        ') do set /a "mlk_process_file{count}+=1"

        rem  get a count of how many files have been processed
        set /a "mlk_object{counter}+=1"

        rem  forced to move ONLY hardlinked files, otherwise leave function when link count is 0
        if not defined mlk_bool_mv_type_all if "%mlk_process_file{count}%" equ "0" ( ( set "mlk_process_file{count}=" ) & goto :eof )

        rem  get/process hardlink files 
        for /F "delims=" %%L in ('
            call "%mk_fsu_bin%" hardlink list "%~1"
        ') do if exist "%~d1%%~L" call :func_mlk_floop_add_one   "%~d1%%~L"  "%mlk_process_file{count}%"  "%mlk_object{counter}%"

        if "%mlk_fvar{current_count}%" neq "" (
        REM echo/^|    \
        REM echo/^|_______________________________________
            echo/│    ▀
            echo/╘═══════════════════════════════════════
        )

        set "mlk_process_file{count}="

    goto :eof

    
    :: Usage :: subr_mlk_links_process_findlinks    "Path"
    rem  Processes Object: unhides, Moves, removes, relinks, rehides objects from one dirtree to another
    rem  
    :subr_mlk_links_process_findlinks
        if "%~1" equ "" goto :eof
        call :func_mlk_unhide "%~1"

        rem  ignore processing directories
        set "mlk_pvar{One{attrib}}=%~a1"
        if /i "%mlk_pvar{One{attrib}}:~0,1%" equ "d" ( ( set "mlk_pvar{One{attrib}}=" ) & goto :eof )
        
        rem  get a count of how many files have been processed
        set /a "mlk_object{counter}+=1"

        if not defined mlk_bool_mv_type_all for /f "tokens=2 delims=: " %%L in (
            'findlinks -nobanner "%~1" ^| findstr /i /C:"Links:"'
        ) do for %%l in ( 
            %%~L 
        ) do if %%~l. gtr 0. call :func_mlk_floop_add_one   "%~1"  "%%~l"  "%mlk_object{counter}%"
        if not defined mlk_bool_mv_type_all goto :eof

        
        for /f "tokens=2 delims=: " %%L in (
            'findlinks -nobanner "%~1" ^| findstr /i /C:"Links:"'
        ) do for %%l in ( 
            %%~L 
        ) do call :func_mlk_floop_add_one   "%~1" "%%~l"  "%mlk_object{counter}%"

        if "%mlk_fvar{current_count}%" neq "" (
        REM echo/^|    ^^
        REM echo/^|_______________________________________
            echo/│    ▀
            echo/╘═══════════════════════════════════════
        )
    goto :eof


    :: Usage :: func_mlk_floop_add_one  Path\File.Extension    TotalCount   CurrentCount
    rem  Processing the "self/main/source" file counter (mlk_filesrc_as_link)
    rem    Note: func exists mainly to circumvent delayed expansion
    rem    when var "mlk_filesrc_as_link" is undef in settings ("Script internal settings" Section), defaults to 0 ("Init" Section)
    rem    CurrentCount is the current unique file count, when it changes, function prints new table.
    :func_mlk_floop_add_one
        if "%~1" equ "" goto :eof

        set "mlk__lcnt=0"
        if "%~2" neq "" set /a "mlk__lcnt+=%~2"
        if defined mlk_filesrc_as_link set /a "mlk__lcnt+=%mlk_filesrc_as_link%"

        rem  Making sure that header text is printed once per linked file
        if "%~3" neq "" if "%~3" equ "%mlk_fvar{current_count}%" call :func_mlk_floop_cnt_vs_var  "%~1"  "%mlk_root_dirtree_new%%~pnx1"  "%mlk_root_dirtree_new%"
        if "%~3" neq "" if "%~3" equ "%mlk_fvar{current_count}%" goto :eof

        if "%~3" neq "" set "mlk_fvar{current_count}=%~3"
        echo/
    REM echo/     "%~nx1" : {
    REM echo/         "full path"  : "%~dpnx1",
    REM echo/         "date time"  : "%~t1",
REM if defined mlk__HVar (
REM     echo/         "attributes" : "%mlk__HVar%",
REM ) else (
REM     echo/         "attributes" : "%~a1",
REM )
    REM echo/         "byte count" : "%~z1",
    REM echo/         "link count" : "%mlk__lcnt%"
    REM echo/     }
    REM echo/ _______________________________________
    REM echo/^|
    REM echo/^|  "%~nx1"
    REM echo/^|    ^|--\
    REM echo/^|       \-- "full path"  : "%~dpnx1"
    REM echo/^|       \-- "date time"  : "%~t1"
    REM echo/^|       \-- "attributes" : "%~a1"
    REM echo/^|       \-- "byte count" : "%~z1"
    REM echo/^|       \-- "link count" : "%mlk__lcnt%"        echo/^|  "%~nx1"
        echo/╒═══════════════════════════════════════
        echo/│
        echo/│  "%~nx1"
        echo/│    ├─┬─» "full path"  : "%~dpnx1"
        echo/│    │ ├─» "date time"  : "%~t1"

    if defined mlk__HVar (
        echo/│    │ ├─» "attributes" : "%mlk__HVar%"
    ) else (
        echo/│    │ ├─» "attributes" : "%~a1"
    )
        echo/│    │ ├─» "byte count" : "%~z1"
        echo/│    │ └─» "link count" : "%mlk__lcnt%"
        call :func_mlk_floop_cnt_vs_var  "%~1"  "%mlk_root_dirtree_new%%~pnx1"  "%mlk_root_dirtree_new%"

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
    if not defined mlk__BoP ( ( set "%~1=" ) & exit /b 0 )
    
    set "%~1=true"
    for %%A in (1 y p a t) do if /i "j%mlk__BoP:~0,1%" equ "j%%~A" ( ( set "mlk__BoP=" ) & goto :eof )
    
    set "%~1="
    set "mlk__BoP="

goto :eof
    


:: Usage :: func_mlk_floop_mv_fpath   OriginalFilePath   NewFilePath
:func_mlk_floop_mv_fpath
    if "%~2" equ "" exit /b 1
    if "%~1" equ "" exit /b 1

    if exist "%~2" exit /b 101

REM echo/|set /p "blank=│    Moving ├───» "%~2""
REM echo/|set /p "blank=│    ├─■  Moving  ■─ "%~2""
    echo/|set /p "blank=│    ├─◘ Move to  ◘─ "%~2"        "

    
    for /f "tokens=1,2,*" %%A in ('2^>^&1 move "%~1" "%~2"') do if "%%~C" equ "moved." (
    REM echo/│    │ └─▌ %%~C
    REM echo/%%~C
        echo/[success]
    ) else if not exist "%~2" (
    REM echo/Error.
        echo/[error]
        echo/│    │ └─▌ Error: %%~A %%~B %%~C
        echo/│    │   └─■ Error: Move Failed, file not found
        exit /b 1
    ) 1>&2 

    REM echo/  Moved    -- "%~2"
    if not defined mlk__HVar goto :eof
    
    echo/|set /p "blank=│    ├─◘   hide   ◘─ "%~2"        "
    call :func_mlk_hide "%~2"
    if "%errorlevel%" equ "0" (
        echo/[success]
        REM echo/│    │ └─■ Done.
    ) else (
        echo/[error]
        REM echo/│    │ └─■ Error: Unable to ReHide file
    )
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
        echo/│    │ ├─■ Error: Cannot create link, destination file already exists
        echo/│    │ └─■ Error: Destination file: "%~3" 
        exit /b 1
    ) 1>&2 

    if "%~d1" neq "%~d3" (
        echo/│    │ └─▌ Error: Cannot create link, destination file must be on the same drive as source file
        echo/│    │   ├─■ Error: Destination file: "%~d3" 
        echo/│    │   └─■ Error:   Source    file: "%~d1" 
        exit /b 1
    ) 1>&2 
    
    if not exist "%~dp3" mkdir "%~dp3"

    echo/|set /p "blank=│    ├─◘   link   ◘─ "%~3"        "

    ( mklink /H "%~3" "%~1"
    ) 2>nul 1>nul

    if not exist "%~3" (
        echo/[error]
        echo/│    │ └─▌ Error: Linking files 
        echo/│    │   ├─■ Info: Destination file: "%~3" 
        echo/│    │   ├─■ Info:   Source    file: "%~1" 
        echo/│    │   ├─■   Info: Command: 
        echo/│    │   └─■   mklink /H "%~3" "%~1"
        exit /b 1
    ) 1>&2 else (
        echo/[success]
    )

    if exist "%~3" del /q "%~2"

goto :eof


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

    rem  default reloop -- missing param2 
    if defined mlk_root_dirtree_new if "%~2" equ "" call %~0   "%~1"   "%~dp2%~pnx1"   "%~3"
    if "%~2" equ "" goto :eof
    
    rem  default reloop -- missing param3
    if defined mlk_root_dirtree_new if "%~3" equ "" call %~0   "%~1"       "%~2"       "%mlk_root_dirtree_new%"   
    if "%~3" equ "" goto :eof

    if not exist "%~3" (
        echo/  Error: Source Path Not found: "%~3"
        exit /b 1
    ) 1>&2

    if not exist "%~dp2" (
        echo/|set /p "blank=│    ├─◘ Make dir ◘─ "%~dp2"        "
        ( mkdir "%~dp2" 
        ) && echo/[success]
    )
    if defined mk_use_fsu goto :subr_mlk_process_fsutil
    if defined mk_use_fln goto :subr_mlk_process_findlinks

goto :eof

    ::  Usage  ::   see 'func_mlk_floop_cnt_vs_var'
    :subr_mlk_process_fsutil
        rem  get all links and move them or relink them
        for /f "delims=" %%N in ('
            call "%mk_fsu_bin%" hardlink list "%~1"
        ') do for /f "delims=" %%O in ('
            dir /b /s /a "%~d1%%~N"
        ') do if "%%~aO" neq "" if not exist "%~2" (
            call :func_mlk_floop_mv_fpath   "%~1"     "%~2"
        ) else if not exist "%~3%%~pnxN" (
            call :func_mlk_lnkfile          "%~2"   "%~d1%%~N"  "%~3%%~pnxN"
        )

        if not exist "%~2" echo/│    │ └─■ Error: New Source Not found: "%~2"

    goto :eof


    ::  Usage  ::   see 'func_mlk_floop_cnt_vs_var'
    rem  last 'else' statement is a workaround for acsii/unicode non-english characters (this only works/applies when the link count is 0)
    :subr_mlk_process_findlinks
        rem  get all links and move them or relink them
        for /f "delims=" %%N in ('
            findlinks -nobanner "%~1"
        ') do if "%%~aN" equ "" (
            for /f "tokens=1,2 delims=:%mlk_tab_char%" %%O in ("%%~N") do for %%F in (%%~O) do if /i "%%~F" equ "Links" for %%F in (%%~P) do if "%%~F" equ "0" call :func_mlk_floop_mv_fpath "%~1" "%~2"
         ) else if not exist "%~2" (
            call :func_mlk_floop_mv_fpath "%~1" "%~2"
        ) else if not exist "%~3%%~pnxN" (
            call :func_mlk_lnkfile   "%~2"    "%%~N"  "%~3%%~pnxN"
        )

        if not exist "%~2" echo/│    │ └─■ Error: New Source Not found: "%~2"
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
    if /i "%mlk__HVar:~3,1%" neq "h" ( ( set "mlk__HVar=" ) & exit /b 0 )

    set /a "mlk_Obj{cntr}+=1"
    if /i "%mlk__HVar:~0,1%" equ "d" set "mlk_hidden_dir{%mlk_Obj{cntr}%}=%~1"
    
    2>nul 1>nul "%SystemRoot%\System32\attrib.exe" -H /L /S /D "%~1"
    if "%errorlevel%" neq "0" exit /b 2
    exit /b 0

goto :eof


:: Usage :: func_mlk_hide    "path"
rem  Checks var "mlk__HVar" and hides when needed
:func_mlk_hide
    if "%~1" equ "" exit /b 1
    
    if not defined mlk__HVar goto :eof
    set "mlk__HVar="
    
    2>nul 1>nul "%SystemRoot%\System32\attrib.exe" +H /L /S /D "%~1"
    
    exit /b 0

goto :eof



::  Usage  ::  func_mlk_check_hidden_paths   new_root_path
rem  Pulls all variables starting with string 'mlk_hidden_dir' and unhides the new directories 
:func_mlk_check_hidden_paths
    ( set mlk_hidden_dir 
    ) 2>nul 1>nul || goto :eof
    echo/
    echo/╒═══════════════════════════════════════
    echo/│  Rehide Directories
    for /f "tokens=1,* delims==" %%A in ('set mlk_hidden_dir') do if exist "%~1%%~pnxB" (
        echo/│    ├─■ "%~1%%~pnxB"
        ( "%SystemRoot%\System32\attrib.exe" +H /L /S /D "%~1%%~pnxB"
        ) 1>nul 
        set "%%~A="
    )
    echo/│    ▀
    echo/╘═══════════════════════════════════════
    
goto :eof
