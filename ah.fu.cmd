:: By JaCk | Release 10/02/2017 | ah.fu.cmd  --  fu m$, untel and other asssholes
@echo off & setlocal DisableDelayedExpansion EnableExtensions & title Killing em softly with this sung

::: User Settings
::
rem  semi-colon separated list of processes
 set "afu_process_list=igfxHK.exe;igfxTray.exe;atbroker.exe;tabtip.exe"

::: Script Settings
::
 set "afu_debug_dump="   rem set to anything to see bunction and it's params
rem  dynamic, local file with a process list ---- conf syntax - a list (space,comma,semi-colon delimited)
 rem example:  (echo/afu_process_list=igfxEM.exe,igfxHK.exe,igfxTray.exe,atbroker.exe,tabclip.exe,adminservice.exe,PresentationFontCache.exe,SMSvcHost.exe,WUDFHost.exe) 1> "%afu_list_conf%"
 set "afu_list_conf=%userprofile%\eph.u.conf"
 set "afu_list_add_unvarred_keys=true"       rem Set to [true]  if you want to have afu_list_conf add keys as processes; 
    rem Example:
    rem  afu_process_list=igfxEM.exe,"other with spaces.exe"
    rem 
    rem mydumb.exe
    rem "other dump.exe"
 
rem  wait to kill again; value in seconds; default: 360
 set "afu_tcntdwn_secs=360"
 set "afu_tcntdwn_secs=60"

rem  default: 3 --  integer, check conf for changes every after X tasklist checks
 set "afu_cycle_check_conf=5"

  
 
::: GOGOGOOGOG
:: fun in circles 
::
 set "afu_cntr=0"
 set "afu_chkcntr=0"
 set "afu_killcntr=0"
 if not defined afu_cycle_check_conf set "afu_cycle_check_conf=3"
  if defined afu_list_conf (
    call :func_afu_notifly watching for changes: "%afu_list_conf%"
    call :func_afu_notifly Check conf every %afu_cycle_check_conf% cycles of %afu_tcntdwn_secs%secs
 )
 goto :lbl_afu_inf_to_inf
exit /b
 

:::::::::::::::::::
::               ::
::   Bunctions   ::
::               ::
:::::::::::::::::::
goto :eof


:: Do you like hampster-wheels?
:lbl_afu_inf_to_inf
    if defined afu_debug_dump echo/debug: %~0 %*
    
    rem  checks conf every cycle reset
    if defined afu_list_conf call :func_afu_process_conf_file "%afu_list_conf%" "afu_process_list"
    
    for /l %%T in (1,1,%afu_cycle_check_conf%) do (
        set /a "afu_cntr+=1"
        call :func_afu_send_eph_uoo "afu_process_list" 2>nul
        ( call timeout /t %afu_tcntdwn_secs% ) 2>nul 1>nul
    )

    goto :lbl_afu_inf_to_inf
goto :eof


:: buntchler -- the task butcher
:func_afu_send_eph_uoo
    if defined afu_debug_dump echo/debug: %~0 %*
    
    rem  for live debug dumps toggle
    REM set "afu_debug_dump=true"
    
    call :func_afu_titlifli
    for /f "tokens=1,* delims==" %%Y in ('set %~1') do for %%A in (%%Z) do (
        set /a "afu_chkcntr+=1"
        
       if defined afu_debug_dump echo/debug: taskkill /f /im "%%~A"
        
        for /f "delims=" %%T in ('taskkill /f /im "%%~A"') do for %%N in (%%T) do if /i "%%~N" equ "SUCCESS:" ( 
            set /a "afu_killcntr+=1"
            for /f "tokens=3,*" %%H in ("%%T") do call :func_afu_notifly %%I
        )
    )
        
goto :eof

::  Usage  ::  func_afu_process_conf_file    "%afu_list_conf%"   "afu_process_list"
:: Process local process list file
rem   leave ASAP when file size hasn't changed
:func_afu_process_conf_file
    if defined afu_debug_dump echo/debug: %~0 %*
    if  "%~1"   equ   ""  exit /b 456
    if not exist "%~1"    exit /b 1
    if 9%fsize% equ 9%~z1 exit /b 0
    
    rem check for unique varkey, then populated varkeys, then any listed binaries
    for /f "eol=# tokens=1,* delims==:" %%A in (%~1) do if "%%~A" neq "" (
        
        if /i "%%~A" equ "unkill_list" (
            if "%%~B" neq "" for %%P in (;%%B;) do call :func_afu_conf_pardon "%%~A" %%P  "%~2"  "notify" 
            
        ) else if /i "%%~A" equ "afu_cycle_check_conf" (
            if 9%%~B neq 9%afu_cycle_check_conf% (
                call :func_afu_notifly Update: Conf: Check: Cycles: To: %%~B; Prev: %afu_cycle_check_conf%;
                call :func_afu_notifly Check conf every %%~B cycles of %afu_tcntdwn_secs%secs
                set "afu_cycle_check_conf=%%~B"
            )
        ) else if /i "%%~A" equ "afu_tcntdwn_secs" (
            if 9%%~B neq 9%afu_tcntdwn_secs% (
                call :func_afu_notifly Update: Timer: Wait: ProcessCheck: To: %%~B; Prev: %afu_tcntdwn_secs%;
                call :func_afu_notifly Check conf every %afu_cycle_check_conf% cycles of %%~Bsecs
                set "afu_tcntdwn_secs=%%~B"
            )

        ) else if "%%~B" neq "" (
            for %%P in (;%%B;) do call :func_afu_conf_condem "%%~A" %%P  "%~2"  "notify" 
        
        ) else if "%%~xA" neq "" call :func_afu_conf_condem   ""    %%A  "%~2"  "notify"
    )
    set "fsize=%~z1"
    
goto :eof

REM ) else if "%%~B" neq "" (
        REM for %%P in (;%%B;) do if "%%~P" neq "" for /f "tokens=1,* delims==" %%Y in ('set %~2') do for %%L in (%%Z) do if "%%~P" neq "%%~L" call :func_afu_add_to_list "%~2"  %%P  "notify" 
REM ) else if "%%~xA" neq "" (
        REM for %%P in (;%%A;) do if "%%~P" neq "" for /f "tokens=1,* delims==" %%Y in ('set %~2') do for %%L in (%%Z) do if "%%~P" neq "%%~L" call :func_afu_add_to_list "%~2"  %%P   "notify"


::  Usage  ::  func_afu_conf_condem    "keyName-Optional"  "proccessName"  "afu_process_list"  VarGroup
:func_afu_conf_condem
    if defined afu_debug_dump echo/debug: %~0 %*
    
    for /f "tokens=1,* delims==" %%Y in ('set %~3') do for %%L in (%%Z) do if "%~2" neq "%%~L" call :func_afu_add_to_list "%~3" "%~2" "%~4" "%~1"
goto :eof


::  Usage  ::  func_afu_conf_pardon    "keyName-Optional"  "proccessName"  "afu_process_list"  VarGroup
:func_afu_conf_pardon
    if defined afu_debug_dump echo/debug: %~0 %*
    for /f "tokens=1,* delims==" %%Y in ('set %~3') do for %%L in (%%Z) do if "%~2" equ "%%~L" call :func_afu_sub_of_list "%~3" "%~2" "%~4" "%~1"
goto :eof


::  Usage  ::  func_afu_add_to_list  listVar  "String to add" "notifyUserBool" "VarGroup"
rem  Adds only unique strings into list
:func_afu_add_to_list
    if defined afu_debug_dump echo/debug: %~0 %*
    if "%~2" equ "" exit /b 456
    if "%~1" equ "" exit /b 456
    
    rem check if not already in list; leave OR addto list and notify
    for /f "tokens=1,* delims==" %%a in ('set %~1') do for %%L in (%%b) do if %%L equ "%~2" goto :eof
    for /f "tokens=1,* delims==" %%a in ('set %~1') do set "%~1=%%b;%2"

    rem hearhe hearhe
    if /i "%~3" equ "notify" call :func_afu_notifly Added to Kill list: %~4 %2

goto :eof

::  Usage  ::  func_afu_sub_of_list  listVar  "String to remove"  "notifyUserBool" VarGroup
rem  Removes a unique string from list
:func_afu_sub_of_list
    if defined afu_debug_dump echo/debug: %~0 %*
    if "%~2" equ "" exit /b 456
    if "%~1" equ "" exit /b 456
    if not defined %~1 exit /b 456
    
    rem  Clear var and add strings that do not match, update param1 var when changes are found; var afu_sub_process_list cannot be empty 
    set "afu_sub_process_list=;"
    for /f "tokens=1,* delims==" %%a in ('set %~1') do for %%L in (%%b) do if /i "%%~L" neq "%~2" ( 
        call :func_afu_add_to_list  "afu_sub_process_list"  %%L  notify  %4
    ) else set /a "afu_cntrm+=1"

    if not defined afu_cntrm if defined afu_sub_process_list (
        set "afu_sub_process_list="
        goto :eof
    ) else goto :eof
    
    set "%~1=%afu_sub_process_list%"
    
    if "%~3" equ "" (
        set "afu_sub_process_list="
        set "afu_cntrm="
        goto :eof
    )
    
    if 9%afu_cntrm% equ 91 call :func_afu_notifly Removed: %2
    if 9%afu_cntrm% gtr 91 call :func_afu_notifly Removed: [%afu_cntrm% Entries]: %2

goto :eof


::  Usage  :: func_afu_notifly  "stringsToPrintToConsole"  "moreStrings"
rem  Prints to Console with current count status and any addition strings from params
rem  Note:
rem    Total Killed:     %afu_killcntr%
rem    Total Checked:    %afu_chkcntr%
rem    Total Cycles:     %afu_cntr%
rem    Total List Items: %afu_lstcntr%
:func_afu_notifly
    if defined afu_debug_dump echo/debug: %~0 %*
    call :func_afu_titlifli %*
    echo/ %~nx0: %date:~4,-5% %time:~0,-3% [%afu_lstcntr%P][%afu_killcntr%K/%afu_chkcntr%T:%afu_cntr%C]: %*
goto :eof


::  Usage  :: func_afu_incrementor  "integer"  "var1" "var2" "var3" "var4" "etcORinf"
rem  Increments the proceeding params by param1 OR 1 
rem  Note:
rem    When param1 is not integer, treats it as a string
REM :func_afu_incrementor
    REM if defined afu_debug_dump echo/debug: %~0 %*
    REM if "%~1" equ "" goto :eof
    REM if "%~2" equ "" goto :eof
    
    REM if defined _afu_am_ for %%A in (%*) do "set /a %%~A+=%_afu_am_%"
        REM set "_afu_am_="
        REM goto :eof 
    REM ) else set "_afu_am_=1"

    REM ( set /a "_afu_am_+=( %~1 ) / 1"
    REM ) 2>nul 1>nul
    
    REM if "%_afu_am_%" equ "0" set "_afu_am_=" &goto :eof
    
    REM if "%~1" equ "%_afu_am_%" shift \1
        REM call %~0 %
    
    
        REM for %%A in (%*) do "set /a %%~A+=%_afu_am_%"
        
    
    
    REM call :func_afu_titlifli %*
    REM echo/ %~nx0: %date:~4,-5% %time:~0,-3% [%afu_lstcntr%P][%afu_killcntr%K/%afu_chkcntr%T:%afu_cntr%C]: %*
REM goto :eof

::  Usage  :: func_afu_titlifli  "stringsToPrintToTitleBar"  "moreStrings"
rem  Sets Title with current count status and any addition strings from params
rem  Note:
rem    Total Killed:     %afu_killcntr%
rem    Total Checked:    %afu_chkcntr%
rem    Total Cycles:     %afu_cntr%
rem    Total List Items: %afu_lstcntr%
:func_afu_titlifli
    if defined afu_debug_dump echo/debug: %~0 %*

    set "afu_lstcntr="
    for %%x in (%afu_process_list%) do set /a "afu_lstcntr+=1"
    title %~nx0: %date:~4,-5% %time:~0,-3% [%afu_lstcntr%P][%afu_killcntr%K/%afu_chkcntr%T:%afu_cntr%C]: %*
goto :eof


:: outliketrout
:func_afu_trout_fishing
    if defined afu_debug_dump echo/debug: %~0 %*
    set "afu_process_list="
goto :eof
