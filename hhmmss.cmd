:: By JaCk  |  Release 12/11/2017  |  https://github.com/1ijack/BatchMajeek/blob/master/hhmmss.cmd  |  hhmmss.cmd --- send time(s) in seconds as params and it will return HH:MM:SS.MS notation back
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
:: works with/without DelayedExpansion - Still need Extensions (for label calls, errorlevels, param features)
@echo off & setlocal DisableDelayedExpansion

::: User Vars
rem  Set to "true" when you want to print both values, orig secs, and new format
rem  Set to "" when you want to print only new format
set "hm2_print_secs_and_hhmmss="

:::::::::::::::::::::::::::::::::::::::
::: do not modify below :::
:::::::::::::::::::::::::::::::::::::::

rem  No question about it, it's one o'them nasty "question-marks".  Swap it out, stat.
if "%~1%~2%~3%~4%~5" equ "" (
    set "hms_pargs=/h"
) else set "hms_pargs=%*"
set "hms_pargs=%hms_pargs:?=[_mp0qm_]%"

::::::::::::::::::   ::::::::::::::::::
::                                   ::
::           Stario-gooooo           ::
::                                   ::
:: zoom zooosh zaaam, zreeech. vrooo ::
::                                   ::
:::::::::::  :::::::::::::  :::::::::::
::: Starting PVAR ArgFeeder ~~ L4G: Halp mae gnougn, pl9xyz
for %%Z in (
    %hms_pargs%
) do for /f "tokens=* delims=-/" %%V in (
    "/%%Z"
) do call :func_hms_args "%%~V"

::::::::::::::::::   ::::::::::::::::::
::                                   ::
::         -- fin-laundia --         ::
::               "End"               ::
:: too fast? Isn't that a good thing ::
::                                   ::
:::::::::::  :::::::::::::  :::::::::::
set "help_cntr="
goto :eof

::::::::::::::::::  :::::::::::::::::::
::                                   ::
::             Bunctions             ::
::                                   ::
::  [ ---  -----  >x<  -----  --- ]  ::
::::::::::::::::::   ::::::::::::::::::
                              goto :eof 

::  Usage  ::  func_hms_args  arg
rem  Speed-argumentor, scrubs input, looking for help, blanks, unknowns, and integers to process
rem   No Issues -- errorlevel 0
rem   When Unknown argument -- errorlevel is 1
:func_hms_args
    rem  Unfilter filtered
    set "args_parg=%~1"
    set "args_parg=%args_parg:[_mp0qm_]=?%"

    rem  Are you prefixed with a zero? if so, bad int, bad.  Back to the end of the line.
    if "%args_parg:~0,1%" equ "0" if "%args_parg:~1,1%" neq "" (
        call %~0  "%args_parg:~1%"
        goto :func_args_lower_intestine
    )
    
    rem  are you literally zero? ok, we'll run 'er through.  Don't be suprised if its 00:00:00
    if "1%~1" equ "10" (
        call :func_hms_minimain_lilscheeph  "hms_t"  "%~1"
        goto :func_args_lower_intestine
    )

    rem  Checq for halps
    for %%H in ("[_mp0qm_]"; "h"; "help") do if "/%%~H" equ "/%~1" (
        call :func_hms_halp_mae
        goto :func_args_lower_intestine
    ) 2>nul
    
    rem  are you a blank?
    if "1%args_parg%" equ "1[_mp0qm_]=?" (
        call :func_hms_halp_mae
        goto :func_args_lower_intestine
    )

    rem  are you an int? finally, lets do this
    set /a "nargs_parg=((%args_parg% -1)/1) +1"
    if "%nargs_parg%" gtr "0" (
        call :func_hms_minimain_lilscheeph  "hms_t"  "%nargs_parg%" 
        goto :func_args_lower_intestine
    )
    set "nargs_parg=" 

    rem  heck, I dont know what you is... sorry bub
    call :func_hms_halp_mae 2>nul
    ( echo/&echo/&echo/&echo/Error: %~nx0: Unrecognized Argument "%args_parg%" 
      echo/&echo/
    ) 1>&2
    call :func_args_lower_intestine
    exit /b 1

    rem ::  Usage  ::  func_args_lower_intestine
    rem  undefines args vars
    :func_args_lower_intestine
        set "args_parg=" 
        set "nargs_parg=" 
    goto :eof
goto :eof




::  Usage  ::  func_hms_args  arg
rem  Speed-argumentor, scrubs input, looking for help, blanks, unknowns, and integers to process
rem   No Issues -- errorlevel 0
rem   When Unknown argument -- errorlevel is 1
:func_hms_args
    rem  driving blind, on the river, eh
    if "/%~1" equ "/" call :func_hms_halp_mae 2>nul &goto :eof

    rem  reaching out and around... helping me, help you
    if /i "/%~1" equ "/extracheese" call :func_extra_cheese 2>nul &goto :eof
    if /i "/%~1" equ "/[_mp0qm_]"   call :func_hms_halp_mae 2>nul &goto :eof
    if /i "/%~1" equ "/help"        call :func_hms_halp_mae 2>nul &goto :eof
    if /i "/%~1" equ "/h"           call :func_hms_halp_mae 2>nul &goto :eof
    
    rem  this almost makes sense [can't be bothered to 'splain-it]
    if    "1%~1" leq "1a"         call :func_hms_minimain_lilscheeph  "hms_t"  "%~1" &goto :eof

    rem  I know what im doing, duh
    call :func_hms_halp_mae 2>nul
    ( echo/&echo/&echo/&echo/%~nx0: Error: Unrecognized Argument "%~1" 
      echo/&echo/
    ) 1>&2
    exit /b 1
goto :eof


:: Usage :: func_hms_get_time_from_secs   returnVar    sendTime
rem  Converts from secs to HH:MM:SS notation 
rem    Note: param2-sendTime  -- Integer value: ammount of secs [Limit: 2147483647] [HumanReadable: 2,147,483,647]
rem    Note: param1-returnVar -- Returns param1 as HH:MM:SS 
rem    Note: Checks input for integer, when encountering errors sets returnVar to 00:00:00 and sets ErrLvl to 101
rem      Example:
rem        func  "varDuration" "6430"
:func_hms_get_time_from_secs
    if "%~1" equ "" exit /b 101
    if "%~2" equ "" exit /b 101
    set "%~1=00:00:00"
    
    rem verify - valid positive int 
    set /a "%~1=%~2 * 1" 2>nul
    if not 1%errorlevel% equ 10 set "%~1=00:00:00" & exit /b 101
    
    set "%~1=00:00:00"
    if not 1%~2 gtr 10 exit /b 101

    rem cheap, quick, and dirty -- fire and forget
                  set "%~1=00:00:%~2"
    if 1%~2 lss 110 set "%~1=00:00:0%~2"
    if 1%~2 lss 160 exit /b 0
    set "%~1=00:00:00"   rem reset -- just for [en]sanity
    
    
    rem not as cheap, but still quick, and dirty(4) -- calc(1), strip(3) padded(2) zeros
    2>nul set /a "hms_s2t_h=%~2/3600"
    2>nul set /a "hms_s2t_m=(%~2 - (%hms_s2t_h% * 3600))/60"
    2>nul set /a "hms_s2t_s=(%~2 - (%hms_s2t_m% * 60) - (%hms_s2t_h% * 3600))"
    
    set "hms_s2t_m=00%hms_s2t_m%"
    set "hms_s2t_s=00%hms_s2t_s%"

    set "%~1=%hms_s2t_h%:%hms_s2t_m:~-2%:%hms_s2t_s:~-2%"
    if 1%hms_s2t_h% lss 110 set "%~1=0%hms_s2t_h%:%hms_s2t_m:~-2%:%hms_s2t_s:~-2%"
    if 1%hms_s2t_h% equ 10  set "%~1=00:%hms_s2t_m:~-2%:%hms_s2t_s:~-2%"
    
    rem man, good thing I still have some time to clean this up
    set "hms_s2t_h="
    set "hms_s2t_m="
    set "hms_s2t_s="

    if defined %~1 exit /b 0
    
    rem this should never happen, but you never know
    set "%~1=00:00:00" & exit /b 101
    
goto :eof


:: Usage :: func_hms_halp_owedskool
rem  desp-lae halps to Owe-GEE-StSt-StAHN-DERD--aowette
:func_hms_halp_owedskool
    echo/   --    Home of the "We've'done'd de done'it"    -- 
    echo/
    echo/  %~nx0  -- Eats: Time(Secs)    Poops: Time(HH:MM:SS)
    echo/  %~nx0:       Secs    ^=^>      HH:MM:SS
    echo/ 
    echo/   Input: call %~nx0 420 123 [Secs3] [Secs4]...
    echo/          
    echo/   Output: 00:07:00
    echo/           00:02:03
    echo/            [Stnd3]
    echo/            [Stnd4]
    echo/               ...
    echo/
goto :eof


::  Usage  :: func_extra_cheese
rem  When you need to make your day extra cheesy
:func_extra_cheese
    color E1
    echo/ Warning: ExtraCheese Exception: Overflowing console with cheesy cheese
    timeout /t 5 >nul 
    for /l %%c in (1,1,31) do (
        echo/
        echo/    Tasty N'Cheesy JaCk'd Quote Sandwich:
        call :func_hms_quote_cheese %%c
    )
    echo/
    echo/Burp!
    timeout /t 7 >nul 
    color
goto :eof


::  Usage  ::  func_hms_halp_mae
rem  Inconsistently consistant halps
rem   des-plae halps to StStSt-AHN-DARD aow-ette 
rem ("display help to StdOut". There; 'xplained it. Happy?.... I swear, people these days... and theiyr're..)
:func_hms_halp_mae
    if defined help_cntr goto :eof
    set /a "help_cntr+=1"
    echo/ 
    rem pick a halps damp - pseudo-randomly 
    if 2%random% lss 2%random% ( call :func_hms_halp_dump ) else call :func_hms_halp_owedskool
    rem leave pseudo-randomly or stick around for "just the tip"
    if 2%random% lss 2%random% call :func_hms_tipsy_tip
    echo/ 
    echo/    Tasty N'Cheesy JaCk'd Quote Sandwich:
    call :func_hms_quote_cheese
goto :eof


::  Usage  ::  func_hms_halp_dump
:func_hms_halp_dump
    echo/ 
    echo/help: %~nx0, Converts Secs to Expanded Time HH:MM:SS.MS
    echo/  Usage: %~nx0 [ --help^| secs ]  [secs2]  [etc]
    echo/
    echo/  Input Examples:
    echo/    %~nx0  --help
    echo/    %~nx0  61
    echo/    %~nx0  152320    51358
    echo/    %~nx0  1  75  53  230  5689  587950  20  56
    echo/  
    echo/  Examples: Input Cmd ~^>  Result 

    if not exist "%~f0" (
        echo/    %~nx0  65    ~^>  00:01:05
        echo/    %~nx0  122   ~^>  00:02:02
        echo/    %~nx0  1066  ~^>  00:17:46
    ) 

    rem  ooooweee.... lookie here, looks like we have ourselves one o'them "live examples" here, Yummmmmmie!!
    rem  A taste perhaps? .... [waiter approaches] ... "Localhost, we'll have the three seeded-psuedo-randoms... down two... center-left... those, in that for-tank"
    rem    * ima-muncher - yum yum yum *
    rem  oh oh, I think I'm done.... I need to take a dump. *runs console's stdout*
    if exist "%~f0" for %%r in (%RANDOM:~0,1%%RANDOM:~0,1%;%RANDOM:~0,1%%RANDOM:~0,2%;%RANDOM:~0,2%%RANDOM:~0,2%) do for /f %%A in ('%~f0 %%~r'
    ) do   if %%~r lss 100   ( echo/    %~nx0  %%~r    ~^>  %%~A
    ) else if %%~r lss 1000  ( echo/    %~nx0  %%~r   ~^>  %%~A
    ) else if %%~r lss 10000 ( echo/    %~nx0  %%~r  ~^>  %%~A
    ) else                     echo/    %~nx0  %%~r ~^> %%~A
    
    echo/
    echo/
goto :eof


:: Usage :: func_hms_minimain_lilscheeph   ReturnVar    sendTime-Seconds
rem  Sub-Process control -- Help faciliate improvements and help with DelayedExpansion being disabled
:func_hms_minimain_lilscheeph
    if "%~2" equ "" goto :eof
    if "%~1" equ "" goto :eof

    call :func_hms_get_time_from_secs "%~1"  "%~2"

    if defined hm2_print_secs_and_hhmmss call :func_hms_MisterDank_AB_reporter "%~1"  "%~2"
    if not defined hm2_print_secs_and_hhmmss call :func_hms_MisterDank_AB_reporter "%~1"
    
    set "%~1="
    
goto :eof


::  Usage  :: func_hms_MisterDank_AB_reporter   "varName"    "timeInSeconds-Optional"
rem  Writes to StndOut 
rem    Note: Param1 "varName" -- This is the varLabel/Name (not the value)
rem    Note: Param2 "timeInSeconds-Optional" -- Original Secs value 
:func_hms_MisterDank_AB_reporter
    if "%~1" equ ""    exit /b 101
    if not defined %~1 exit /b 101
    
    if "%~2" equ "" for /f "tokens=2 delims==" %%C in ('set %~1') do echo/%%~C
    if "%~2" equ "" goto :eof

    for /f "tokens=2 delims==" %%C in ('set %~1') do echo/%~2 ^*%%~C

goto :eof



:func_hms_quote_cheese
    
    rem  welcome, would you like "params" or "secs" -- when param1 is not 1-31 ignores param1
    set "hms_now_sec="
    if 1%~1 gtr 10 if 1%~1 lss 132 set "hms_now_sec=%~1"
    if not defined hms_now_sec  set /a "hms_now_sec=1%time:~-5,2% - 100"

    rem  make sure number is a positive number between 1-31 [0 is 30]
    if 1%hms_now_sec% equ 10  set /a "hms_now_sec+=60"
    if 1%hms_now_sec% gtr 131 set /a "hms_now_sec-=30"

    rem  sumtingwong; either undefined or mats were messed up
    if 1%hms_now_sec% gtr 132 set "hms_now_sec="
    if not defined hms_now_sec (
        echo/        theiyr're sum rorre
        echo/            7102 exj-
        goto :eof
    )
    
    rem  quotes, padding numbers JUST incase
    if %hms_now_sec%1 equ  11  echo/  ^"Q^: When does TimeTravel-Train A meet with TimeTravel-Train B^?&echo/  A^: They don^'t, they^'re on different time tables^"
    if %hms_now_sec%1 equ  21  echo/          "'cause time, makes time"
    if %hms_now_sec%1 equ  31  echo/       "'cause making time, takes time"
    if %hms_now_sec%1 equ  41  echo/        "Got a sec? I'll give you time"
    if %hms_now_sec%1 equ  51  echo/    "Advancing time, one second at a time"
    if %hms_now_sec%1 equ  61  echo/           "One of these days..."
    if %hms_now_sec%1 equ  71  echo/     "With hhmmss, every second counts."
    if %hms_now_sec%1 equ  81  echo/"Here's an time order, five minutes and hold the ms"
    if %hms_now_sec%1 equ  91  echo/    "You're just in time! Here's your time"
    if %hms_now_sec%1 equ 101  echo/"If I had a second for everytime I heard you tick..."
    if %hms_now_sec%1 equ 111  echo/      "Your tocks are ticking me off"
    if %hms_now_sec%1 equ 121  echo/"Once I joined the military, I had no time for AmPm"
    if %hms_now_sec%1 equ 131  echo/"A Marshall max's at 11?  My clock can go up to 12!"
    if %hms_now_sec%1 equ 141  echo/        "Hey! Days need love too!"
    if %hms_now_sec%1 equ 151  echo/    "At odds with time? Give us a sec."
    if %hms_now_sec%1 equ 161  echo/"Dam you NTP, why is it everytime I get ahead..."
    if %hms_now_sec%1 equ 171  echo/      "The right time, all the time"
    if %hms_now_sec%1 equ 181  echo/   "I know what you did last leap year"
    if %hms_now_sec%1 equ 191  echo/     "Works every time, all the time"
    if %hms_now_sec%1 equ 201  echo/         "it's  420 every 7 mins"
    if %hms_now_sec%1 equ 211  echo/"Sorry Millie, but I hear seconds and speak days"
    if %hms_now_sec%1 equ 221  echo/"That magical second when a minute changes into an hour"
    if %hms_now_sec%1 equ 231  echo/"did you know, that a broken clock is right twice a day"
    if %hms_now_sec%1 equ 241  echo/"For a gay ol'time, hhmmss! (sounded good at the time)"
    if %hms_now_sec%1 equ 251  echo/"Need and hour? Give me a second, (and 3599 more)"
    if %hms_now_sec%1 equ 261  echo/"You dont understand Zero, what it feels like to always be a 9!"
    if %hms_now_sec%1 equ 271  echo/ ^"Sorry Millie, Second^'s a 100 times more time, &echo/         than you^'ll ever hope to be^!^"
    if %hms_now_sec%1 equ 281  echo/  ^"Get your hand off me, all you ever do is &echo/  tick tick tick, you never want to tock.^"
    if %hms_now_sec%1 equ 291  echo/      ^"Fact: Even in these modern times, &echo/   chronocide continues around the clock.&echo/   One minute passes away every 60 seconds^"
    if %hms_now_sec%1 equ 301  echo/        "taking the time for time"
    if %hms_now_sec%1 equ 311  echo/  "Changing the planet, one second at a time"
    echo/             - jxe 2017 q(%hms_now_sec%)
    
    set "hms_now_sec="
goto :eof


   
::  Usage  ::  func_hms_tipsy_tip
rem  Displays a tip
:func_hms_tipsy_tip
    echo/  Tipsy-tip: cmd window:
    echo/    1, [Win]^+[R]   2, Type: cmd   3, [Enter]  4, bake cookies
goto :eof


