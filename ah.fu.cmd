::  By JaCk  |  Release 02/05/2017  |  https://github.com/1ijack/BatchMajeek/blob/master/ah.fu.cmd  |  ah.fu.cmd  --  f.u. m$, untel, dAMD and other assesholes... yes, assesholes.  To lazy to use taskscheduler/cron/"normal solution"?  Need a "custom" solution for a "custom" problem?  Well, you're in luck: from the backalleys of dwm, reppin the handles of "CMD-d.o.t.-EXE"; raised in the shady parts of the of the DOS console,  "shell-grown-fixer", aka "pro-check-this-proc", aka "no-cycle-runna", the one, the only "ah.fu.cmd" -- keeping all these procs in check.  Wrecking hardcore havoc, "git-shelfd" style by forcing sigterms on these youngprocs.
@echo off & setlocal DisableDelayedExpansion EnableExtensions & ((for /f "tokens=1 delims==" %%V in ('set afu_') do set "%%~V=" ) 2>nul 1>nul ) & title %~nx0: Killing em softly with this song

::::  User Settings
::
set "afu_process_list=igfxEM.exe;igfxHK.exe;igfxTray.exe;atbroker.exe;tabtip.exe"   rem  semi-colon separated list of processes

::::  Script Settings
::
rem  External - live config: dynamic, local file with a process list ---- conf syntax - a list (space,comma,semi-colon delimited)
 rem example:  (echo/afu_process_list=igfxEM.exe,igfxHK.exe,igfxTray.exe,atbroker.exe,tabclip.exe,adminservice.exe,PresentationFontCache.exe,SMSvcHost.exe,WUDFHost.exe) 1> "%afu_list_conf%"
 set "afu_list_conf=%userprofile%\eph.u.conf"

   ::   Example Config:  
   ::       $0  would see "mydumb.exe" and "other dump.exe" as processnames, but still see "kill_list" as a list label, with processnames: igfxEM.exe, "other with spaces.exe" and a.out 
   ::    
   ::    kill_list = igfxEM.exe ; "other with spaces.exe" ; a.out 
   ::    mydumb.exe
   ::    "other dump.exe"
    
rem  Treat isolated strings as processnames -- default: true
 set "afu_list_add_unvarred_keys=true"     rem  -- Set to [true]  if you want to have [afu_list_conf] add alienated keys as processnames to watch; 

rem  default: 3 --  integer, check conf for changes every after X tasklist checks
 set "afu_cycle_check_conf=5"

rem  Admin/Debug Bools 
 set "afu_sudo_admin_root_plus_ultra="     rem  -- Relaunch self in elevated env when not elevated --  true/undefined  --  although awesome, hard to remember
 set "afu_SanSudoSue="                     rem  -- Relaunch self in elevated env when not elevated --  true/undefined  -- ConfigFriendlier Name
 set "afu_debug_dump="                     rem  -- Dump More Msgs - print internal keys and values --  set to anything to see bunction and it's params

rem  wait to kill again; value in seconds; default: 360
 set "afu_tcntdwn_secs=360"
 set "afu_tcntdwn_secs=60"
 
::: GOGOGOOGOG
:: fun in circles 
::
 call :func_afu_adminCheck_net_session afu_shkala_su
 if not defined afu_shkala_su if defined afu_sudo_admin_root_plus_ultra call :func_afu_can_i_has_admin afu_shkala_su  "%temp%\sudo_make_me_a_sandwich.vbs"  afu_tacklebox
 set "afu_cntr=0"
 set "afu_chkcntr=0"
 set "afu_killcntr=0"
 if not defined afu_tcntdwn_secs set "afu_tcntdwn_secs=360"
 if not defined afu_cycle_check_conf set "afu_cycle_check_conf=3"
 
 if defined afu_list_conf call :func_afu_notifly Conf: Watching for changes [%%afu_cycle_^check_conf%%x%%afu_tcnt^dwn_secs%%secs]: "%afu_list_conf%"
 goto :lbl_afu_inf_to_inf
exit /b
 

:::::::::::::::::::::::::::::::::::::::
::                                   ::
::   Bunctions                       ::
::                                   ::
:::::::::::::::::::::::::::::::::::::::
                              goto :eof


:: Do you like hampster-wheels?  Introducing the mein hampster
:lbl_afu_inf_to_inf
    if defined afu_debug_dump echo/debug: %~0 %*
    
    rem  finally, a reason
    if defined afu_tacklebox goto :func_afu_trout_fishing
    
    rem  checks conf every cycle reset
    call :func_afu_titlifli Status: Checking Conf: "%afu_list_conf%"
    if defined afu_list_conf call :func_afu_process_conf_file "%afu_list_conf%" "afu_process_list"
    
    for /l %%T in (1,1,%afu_cycle_check_conf%) do (
        set /a "afu_cntr+=1"
        if defined afu_tacklebox goto :func_afu_trout_fishing
        call :func_afu_send_eph_uoo "afu_process_list" 2>nul
        ( call timeout /t %afu_tcntdwn_secs% ) 2>nul 1>nul
    )

    goto :lbl_afu_inf_to_inf
goto :eof


:: butchler -- the task butcher
rem  'He's the "clean-up" man.  The best in town.'
:func_afu_send_eph_uoo
    if defined afu_debug_dump echo/debug: %~0 %*
    
    rem live debug dumps toggle -- [un]comment line below during script execution to toggle debug dumps
    REM set "afu_debug_dump=true"

    call :func_afu_titlifli Status: Checking process tasklist
    for /f "tokens=1,* delims==" %%Y in ('set %~1') do for %%A in (%%Z) do (
        set /a "afu_chkcntr+=1"
        call :func_afu_titlifli Status: Checking process tasklist: [%%afu_^chkcntr%%]: %%~A
        
       if defined afu_debug_dump echo/debug: taskkill /f /im "%%~A"
        
        for /f "delims=" %%T in ('taskkill /f /im "%%~A"') do for %%N in (%%T) do if /i "%%~N" equ "SUCCESS:" ( 
            set /a "afu_killcntr+=1"
            for /f "tokens=3,*" %%H in ("%%T") do call :func_afu_notifly %%I
        )
    )
    call :func_afu_titlifli Status: idle
        
goto :eof


::  Usage  ::  func_afu_process_conf_file    "%afu_list_conf%"   "afu_process_list"
:: Process local process list file
rem   leave ASAP when file size hasn't changed
rem   Note: when multiple updates from conf occur, notify may notify 
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
                call :func_afu_notifly Update: CheckConf: [%%~Bx%%afu_tcnt^dwn_secs%%secs]: Number of Cycles New: %%~B;  [Prev: %afu_cycle_check_conf%]
                set "afu_cycle_check_conf=%%~B"
            )
        ) else if /i "%%~A" equ "afu_tcntdwn_secs" (
            if 9%%~B neq 9%afu_tcntdwn_secs% (
                call :func_afu_notifly Update: CheckConf: [%%afu_cycle_^check_conf%%x%%~Bsecs]: Wait cycle time:  New: %%~B;  [Prev: %afu_tcntdwn_secs%]
                set "afu_tcntdwn_secs=%%~B"
            )
        ) else if /i "%%~A" equ "afu_sudo_admin_root_plus_ultra" (
            if not defined afu_shkala_su ( 
                call :func_afu_can_i_has_admin afu_shkala_su  "%temp%\sudo_make_me_a_sandwich.vbs"   afu_tacklebox
                goto :eof
            )
        ) else if /i "%%~A" equ "afu_SanSudoSue" (
            if not defined afu_shkala_su ( 
                call :func_afu_can_i_has_admin afu_shkala_su  "%temp%\sudo_make_me_a_sandwich.vbs"   afu_tacklebox
                goto :eof
            )
        ) else if "%%~B" neq "" (
            for %%P in (;%%B;) do call :func_afu_conf_condem "%%~A" %%P  "%~2"  "notify" 
        
        ) else if "%%~xA" neq "" (
               call :func_afu_conf_condem   ""    %%A  "%~2"  "notify"

        ) else call :func_afu_conf_condem   ""    %%A  "%~2"  "notify"
    )
    set "fsize=%~z1"
    
goto :eof


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

    if /i "%~3" neq "notify" goto :eof   rem reporting -- hearhe hearhe
    if "%~4" equ "" call :func_afu_notifly Added to Kill list: %2 &goto :eof
    call :func_afu_notifly Added to Kill list: %~4: %2

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


::  Usage  :: func_afu_notifly  stringsToPrintToConsole with "qoStrings" and moStrings
rem  Prints to Console with current count status and any addition strings from params
rem  Note: Prints params raw : so if you add quotes, will print with said quotes
rem  Note: WTHeck Table:
rem    Total Killed:     K:  %afu_killcntr%
rem    Total Checked:    T:  %afu_chkcntr%
rem    Total Cycles:     C:  %afu_cntr%
rem    Total List Items: P:  %afu_lstcntr%
:func_afu_notifly
    if defined afu_debug_dump echo/debug: %~0 %*
    call :func_afu_titlifli %*
    echo/ %~nx0: %date:~4,-5% %time:~0,-3% [%afu_lstcntr%P][%afu_killcntr%K/%afu_chkcntr%T:%afu_cntr%C]: %*
goto :eof


::  Usage  :: func_afu_titlifli  stringsToPrintToConsole with "qoStrings" and moStrings
rem  Sets Title with current count status and any addition strings from params
rem  Note: displays params raw : so if you add quotes, will display with said quotes
rem  Note: WTHeck Table:
rem    Total Killed:     K:  %afu_killcntr%
rem    Total Checked:    T:  %afu_chkcntr%
rem    Total Cycles:     C:  %afu_cntr%
rem    Total List Items: P:  %afu_lstcntr%
:func_afu_titlifli
    if defined afu_debug_dump echo/debug: %~0 %*

    set "afu_lstcntr="
    for %%x in (%afu_process_list%) do set /a "afu_lstcntr+=1"
    title %~nx0: %date:~4,-5% %time:~0,-3% [%afu_lstcntr%P][%afu_killcntr%K/%afu_chkcntr%T:%afu_cntr%C]: %*
goto :eof


::  Usage  ::  func_afu_can_i_has_admin   returnVar   "path\file.name.vbs"   "afu_tacklebox"
rem  Elevates this script with administrator privledges -- param1: returnVar with true/undefined; -- param2: scriptname
:func_afu_can_i_has_admin
    if "%~1" equ "" ( goto :eof ) else ( ( if "%~2" equ "" ( goto :eof ) else if "%~x2" neq ".vbs" call %~0  %1  "%~2.vbs"  &goto :eof ) & set "%~1=" )
    if "%~3" equ "afu_tacklebox" set "afu_tacklebox=true"
    if not defined %~1 call :func_afu_adminCheck_net_session  %1
    if not defined %~1 call :func_afu_create_elevator  %2
    if exist %2 "%SYSTEMROOT%\system32\cscript.exe" //nologo //b %2 "%~f0"
    ( ( timeout /t 2 ) & del /q %2 
    ) 2>nul 1>nul 
goto :eof

::  Usage  ::  func_afu_create_elevator   path\file.name.vbs
rem  Creates a vbs script to param1, or "%temp%\getadmin.vbs". Note: extension needs to be .vbs
:func_afu_create_elevator
    if "%~1" equ "" ( call %~0  "%temp%\getadmin.vbs" &goto :eof ) else ( if "%~x1" neq ".vbs" ( call %~0  "%~1.vbs" &goto :eof ))
    ( echo/&echo/Set Admin = CreateObject^("Shell.Application"^)
      echo/Admin.ShellExecute WScript.Arguments^(0^), "", "", "runas", 1) > "%~1"
goto :eof

::  Usage  ::  func_afu_adminCheck_net_session  returnVar
rem  Returns (Err0) param1 set to true when elevated, otherwise undefines param1 (Err2)
:func_afu_adminCheck_net_session
    if "%~1" neq "" ( set "%~1=true" ) else goto :eof
    for /f "tokens=3" %%A in ('net session 2^>^&1') do if /i "%%~A" equ "denied." set "%~1="
goto :eof


:: outliketrout
rem  I gots me a tacklebox and fishing rod but no cycletime to fish.....
:func_afu_trout_fishing
    if defined afu_debug_dump echo/debug: %~0 %*
    set "afu_process_list="
goto :eof
