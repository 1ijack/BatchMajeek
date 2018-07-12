::  By JaCk  |  Release 03/07/2018  |   https://github.com/1ijack/BatchMajeek/blob/master/gstr.cmd   |  gstr.cmd  --  Native "Random" string/number generator 
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
@echo off & setlocal DisableDelayedExpansion EnableExtensions & ( for /f "tokens=1 delims==" %%V in ('set ng_') do set "%%~V=" ) 2>nul 1>nul & goto :func_ng_mein

::::::::::::::::::::::::::::::::::::::::
::                                    ::
:::            OneLiners             :::
::                                    ::
::::::::::::::::::::::::::::::::::::::::
rem  Generate String Lengths: 1-99
@for /l %T in (     1, 1,   99 ) do @call powershell.exe -C "& echo $($dur = $(Measure-Command { $out = $(gstr.cmd %T) }).TotalSeconds) ""Length: %T, Duration: ${dur}, Output: ${out}"""
rem  Generate String Lengths: 100-1000 (10s)
@for /l %T in (  100, 10,  990 ) do @call powershell.exe -C "& echo $($dur = $(Measure-Command { $out = $(gstr.cmd %T) }).TotalSeconds) ""Length: %T, Duration: ${dur}, Output: ${out}"""
rem  Generate String Lengths: 1000-10000 (100s)
@for /l %T in ( 1000,100,10000 ) do @call powershell.exe -C "& echo $($dur = $(Measure-Command { $out = $(gstr.cmd %T) }).TotalSeconds) ""Length: %T, Duration: ${dur}, Output: ${out}"""


::::::::::::::::::::::::::::::::::::::::
::                                    ::
:::            Settings              :::
::                                    ::
::::::::::::::::::::::::::::::::::::::::

::  Usage  ::  func_ng_user_settings
rem  User script settings
:func_ng_user_settings

    rem  Integer Setting Variables: 
    set "ng_str_len=12"                 rem  Default: 12   -- Description: default amount of characters in the generated string

goto :eof


::  Usage  ::  func_ng_script_behavior
rem  Script behavior settings
:func_ng_script_behavior

    rem Character Pool
    rem  Broad scope
    set "ng_bool_use_hexOnly="          rem  Default:      -- Description: when 'true', uses Only the hexadecimal character pool
    set "ng_bool_use_similar="          rem  Default:      -- Description: when 'true', uses similar-looking characters

    rem  Quick Character Pool Selection: Boolean Settings: ['true'/'']
    set "ng_bool_use_lowerAlpha=true"   rem  Default: true -- Description: when 'true', uses alphabetic lowercase characters
    set "ng_bool_use_upperAlpha=true"   rem  Default: true -- Description: when 'true', uses alphabetic uppercase characters
    set "ng_bool_use_numberical=true"   rem  Default: true -- Description: when 'true', uses numerical characters
    set "ng_bool_use_hexadecimal=true"  rem  Default: true -- Description: when 'true', uses hexadecimal characters      
    set "ng_bool_use_specialChrA=true"  rem  Default: true -- Description: when 'true', uses Almost special characters   --  Possible time increase impact: minimum 
    set "ng_bool_use_specialChrB=true"  rem  Default: true -- Description: when 'true', uses Bretty special characters   --  Possible time increase impact: moderate
    set "ng_bool_use_specialChrC="      rem  Default:      -- Description: when 'true', uses Cuper  special characters   --  Possible time increase impact: high
    set "ng_bool_use_specialChrD="      rem  Default:      -- Description: when 'true', uses 'Dick' special characters   --  Possible time increase impact: great

    rem  debug/verbose Messages: Boolean Settings: ['true'/'']
    set  "ng_dump_debug="               rem  Default:      -- Description: dumps additional usage/waste/time stats


    rem Misc-Optimizations
    rem  Force Non-Octal Magic Numbers: Boolean Settings: ['true'/''] ;  Removes any leading '0's in the magic number: decreases errors and increase efficiency (paradox; using batch... joke).
    set "ng_magic_noOct=true"           rem  Default: true -- Description: forces the use of non-octal numbers, by removing any leading '0's in the magic number.  When script does not use octal-like numbers it can reduce the string generation time. non-octal numbers reduce the generation of bad strings.

goto :eof


::  Usage  ::  func_ng_character_pools
rem  these are the available character pools that are sourced for the "random" string, alter to your liking
rem  Note: time to generate string is relative to the total size of the total character pool
:func_ng_character_pools

    rem  hex character pool definition
        if /i "%ng_bool_use_hexadecimal%" equ "true" set "ng_poolhex=0 1 2 3 4 5 6 7 8 9 A B C D E F "

    rem  when hex only, force character hex pool and leave function early
    if /i "%ng_bool_use_hexOnly%" equ "true" if /i "%ng_bool_use_hexadecimal%" neq "true" ( ( set "ng_bool_use_hexadecimal=true") & goto %~0 ) else goto :eof

    rem  when 'true' use character pools with all possibilities; replacing [vs adding] makes the generator run quicker
    if /i "%ng_bool_use_similar%" equ "true" (
        if /i "%ng_bool_use_lowerAlpha%"  equ "true" set "ng_poolLaz=a b c d e f g h i j k l m n o p q r s t u v w x y z "
        if /i "%ng_bool_use_upperAlpha%"  equ "true" set "ng_poolUaz=A B C D E F G H I J K L M N O P Q R S T U V W X Y Z "
        if /i "%ng_bool_use_numberical%"  equ "true" set "ng_poolNum=1 2 3 4 5 6 7 8 9 0 "
        if /i "%ng_bool_use_specialChrA%" equ "true" set "ng_poolSPa= [ _ / { # . @ } \ ] "
        if /i "%ng_bool_use_specialChrB%" equ "true" set "ng_poolSPb= = ~ $ ( ` , ' ) ; + - "
        if /i "%ng_bool_use_specialChrC%" equ "true" set "ng_poolSPc= ? ^ & < ! * | > : "
        if /i "%ng_bool_use_specialChrC%" equ "true" set "ng_poolSPd= %% """
    ) else (
        if /i "%ng_bool_use_lowerAlpha%"  equ "true" set "ng_poolLaz=a b c d e f h j k m n p q r s u v w x y z "
        if /i "%ng_bool_use_upperAlpha%"  equ "true" set "ng_poolUaz=A B C E F G H J K L M N P R S T U V W X Y Z "
        if /i "%ng_bool_use_numberical%"  equ "true" set "ng_poolNum=1 2 3 4 5 6 7 8 9 0 "
        if /i "%ng_bool_use_specialChrA%" equ "true" set "ng_poolSPa=[ / { @ # } \ ] "
        if /i "%ng_bool_use_specialChrB%" equ "true" set "ng_poolSPb=~ $ ( ` ' ) ; + - "
        if /i "%ng_bool_use_specialChrC%" equ "true" set "ng_poolSPc=? "
        if /i "%ng_bool_use_specialChrC%" equ "true" set "ng_poolSPd= %% """
    )

goto :eof



::::::::::::::::::::::::::::::::::::::::
::                                    ::
:::            Functions             :::
::                                    ::
::::::::::::::::::::::::::::::::::::::::
                               goto :eof

::  Usage  ::  func_ng_main
rem  Used as a main goto label
:func_ng_mein
    rem  Blank check; try 9 times
    set /a "ng_arg_cnt+=1"
    if "%~1" neq "" set "ng_bla_cnt=0" 
    if %ng_bla_cnt% geq 9 goto :func_ng_nein

    if not defined ng_flag_init call :func_ng_init

    rem  use params; or run once without params; uses only integers;  rem  generate a random string;  rem  print a random string
    if "%~1" neq "" if     "%~1"      lss "a" call :func_ng_gen_psuedo_psueded_psum   ng_rStr      "%~1"
    if "%~1" equ "" if "%ng_arg_cnt%" equ "1" call :func_ng_gen_psuedo_psueded_psum   ng_rStr  "%ng_str_len%"

    if not defined ng_rStr shift /1
    if not defined ng_rStr goto :func_ng_mein

    rem  Dumps generated string 
    if defined ng_rStr if not defined ng_dump_debug echo/|set /p "nope=%ng_rStr%"

    rem  Dumps extra info with generated string 
    if defined ng_rStr if defined ng_dump_debug if "%~1" equ "" echo/%~nx0: [%ng_str_len%]: gentime: [%ng_stime%^|%time%] "%ng_rStr%"
    if defined ng_rStr if defined ng_dump_debug if "%~1" neq "" echo/%~nx0: [%~1]: gentime: [%ng_stime%^|%time%] "%ng_rStr%"

    rem  Dumps wasted cycles stats when needed to remake strings
    if defined ng_rStr if defined ng_dump_debug set ng_ | findstr /ri "ng_[a-zA-Z_]*wasted[a-zA-Z_]*="

    shift /1

goto :func_ng_mein


::  Usage  ::  func_ng_nein
rem  Clean up environment changes; usually called/run before exiting script
:func_ng_nein
    rem  unset all script vars and undo environment changes, then leave
    ( for /f "tokens=1 delims==" %%V in ('set ng_') do set "%%~V=" ) 2>nul 1>nul 
    endlocal
goto :eof


::  Usage  ::  func_ng_append_str2var   ReturnVar   StringToAdd
rem  Appends string to the tail of the variable expressed value
:func_ng_append_str2var
    if "%~2" equ "" goto :eof
    if "%~1" equ "" goto :eof

    if not defined %~1 (
        set "%~1=%~2"
    ) else for /f "tokens=1,* delims==" %%U in ('set "%~1"') do set "%%~U=%%~V%~2"

goto :eof


::  Usage  ::  func_ng_create_main_pool   ReturnVar    
rem   Return param1 set to a combination of all the character pools
rem   Note:  character sets are not separated by anything.
rem   Verbose Explanation:
rem     grab each pool and add it to the tempVar; suppress errors incase none are defined;  rem  quick error-check;  rem  Strip white-spaces, define returnVar and unset tempVar
:func_ng_character_cat
    if "%~1" equ "" goto :eof
    set "%~1="

    rem  the larger the character pool, the longer it takes to calculate
    ( for /f "tokens=1,* delims==" %%U in ('set ng_pool') do call :func_ng_append_str2var  "%~1" "%%%%U: =%%"
    ) 2>nul
goto :eof


::  Usage  ::  func_ng_check_dependencies
rem  Checks/resolves script dependencies
:func_ng_check_dependencies

    rem  Clear usable pools
    ( for /f "tokens=1 delims==" %%U in ('set ng_pool') do set "%%~U="
    ) 2>nul
    rem  var must be blank;  uses this varName for the new random string 
    set "ng_rStr="

    rem  must be set to a positive integer; defaults to '12' as outlined in 'func_ng_user_settings'
    if not defined ng_str_len set "ng_str_len=12"
    if "%ng_str_len%" geq "a" set "ng_str_len=12"
    if  %ng_str_len%  lss  0  set "ng_str_len=12"

goto :eof    


::  Usage  ::  func_ng_create_magic_number   ReturnVar   optional-intMaxLength   optional-intMinValue   optional-intMaxValue
rem  Creates a magic seed number based on seed, max-str-length [and max-value].  When no params passed in, returns a number between 0 and 9
rem  Note: default value(s) and description(s) for missing/blank/incorrect parameter(s):
rem     %~1 -- ReturnVar                   -- Required   -- Type: String  -- Name of the environment variable which will (eventually) contain the returned value(s)
rem     %~2 -- intMaxLength(ng_mgk_dcntr)  -- Default: 1 -- Type: Integer -- Maximum character count of string (aka string length); string consists only of numerical characters that should be within: 1 to 8096, or 1 to 10 (when providing mix and/or max)
rem     %~3 -- intMinValue(ng_mgk_mnval)   -- Default: 0 -- Type: Integer -- Minimum integer value of string.  Needs to be within 32bit range; from -2^(31-1) to 2^(31); [ or within -2147483647 and 2147483647 ]
rem     %~4 -- intMaxValue(ng_mgk_mxval)   -- Default: 9 -- Type: Integer -- Maximum integer value of string.  Needs to be within 32bit range; from -2^(31-1) to 2^(31); [ or within -2147483647 and 2147483647 ]
:func_ng_create_magic_number
    rem  Part1 - parameter error-check ;  following function rules
    if "%~1" equ "" goto :eof 
    if "%ng_mgk_dcntr%" equ "" if "%~2" equ "" ( set "ng_mgk_dcntr=1"  ) else if "%~2" geq "a" ( set "ng_mgk_dcntr=1"  ) else ( if 1%~2 gtr 18096 ( set "ng_mgk_dcntr=8096" ) else set "ng_mgk_dcntr=%~2" ) 2>nul
    if "%ng_mgk_mnval%" equ "" if "%~3" equ "" ( set "ng_mgk_mnval=0"  ) else if "%~3" geq "a" ( set "ng_mgk_mnval=0"  ) else set "ng_mgk_mnval=%~3"
    if "%ng_mgk_mxval%" equ "" if "%~4" equ "" ( set "ng_mgk_mxval=9"  ) else if "%~4" geq "a" ( set "ng_mgk_mxval=9"  ) else set "ng_mgk_mxval=%~4"
    if  %ng_mgk_dcntr%  gtr 10 if "%~4" neq "" ( set "ng_mgk_dcntr=10" ) else if "%~3" neq ""  ( set "ng_mgk_dcntr=10" )
    
    rem  Part2 - parameter error-check ;  scrubbing/tard-proofing inputs to prevent inf loops;  rem   making sure that number labels are correct, relative to one another, adjusting as needed;   rem   making sure that the minimum number is within the string length; sides with minimum number and adjusts max length accordantly
    if "%ng_mgk_tmp%" equ "" call set "ng_mindiff=%%ng_mgk_mnval:~%ng_mgk_dcntr%%%"
    if "%ng_mgk_tmp%" equ "" if %ng_mgk_mnval% gtr %ng_mgk_mxval% ( ( set "ng_mgk_mnval=%ng_mgk_mxval%" ) & set "ng_mgk_mxval=%ng_mgk_mnval%" )
    if "%ng_mgk_tmp%" equ "" if "%ng_mindiff%" neq "" call :func_ng_get_strlen  ng_mgk_dcntr  "%ng_mgk_mxval%"

    rem  get 'random' digit and decrease the character length value. Re-loop to generate more when needed;  rem  Only set returnVar when all requirements are met
    set "%~1="
    set /a "ng_mgk_lcntr+=1"
    set /a "ng_mgk_dcntr-=1"
    set "ng_mgk_tmp=%ng_mgk_tmp%%random:~-1%"

    rem  expedite the reseed; hopefully reducing cycle waste; usually helps small single/double digit magic numbers
    if %ng_mgk_lcntr% leq 1 if %ng_mgk_mxval:~0,1% neq 0 if %ng_mgk_mxval:~0,1% lss 5 if "%ng_mgk_mxval:~0,1%" equ "1" (

               if %ng_mgk_tmp:~0,1%  geq  5  ( set "ng_mgk_tmp=1%ng_mgk_tmp:~1%"
        ) else                                 set "ng_mgk_tmp=%ng_mgk_tmp:~1%"
    
    ) else if  "%ng_mgk_mxval:~0,1%" equ "2" ( 
               if %ng_mgk_tmp:~0,1%  gtr  6  ( set "ng_mgk_tmp=2%ng_mgk_tmp:~1%"
        ) else if %ng_mgk_tmp:~0,1%  gtr  3  ( set "ng_mgk_tmp=1%ng_mgk_tmp:~1%"
        ) else                                 set "ng_mgk_tmp=%ng_mgk_tmp:~1%"
    
    ) else if  "%ng_mgk_mxval:~0,1%" equ "3" (
               if %ng_mgk_tmp:~0,1%  gtr  7  ( set "ng_mgk_tmp=%ng_mgk_tmp:~1%"
        ) else if %ng_mgk_tmp:~0,1%  gtr  5  ( set "ng_mgk_tmp=3%ng_mgk_tmp:~1%"
        ) else if %ng_mgk_tmp:~0,1%  gtr  3  ( set "ng_mgk_tmp=2%ng_mgk_tmp:~1%"
        ) else if %ng_mgk_tmp:~0,1%  gtr  1  ( set "ng_mgk_tmp=1%ng_mgk_tmp:~1%"
        ) else                                 set "ng_mgk_tmp=%ng_mgk_tmp:~1%"
    
    ) else if  "%ng_mgk_mxval:~0,1%" equ "4" (
               if %ng_mgk_tmp:~0,1%  gtr  8  ( set "ng_mgk_tmp=4%ng_mgk_tmp:~1%"
        ) else if %ng_mgk_tmp:~0,1%  gtr  6  ( set "ng_mgk_tmp=3%ng_mgk_tmp:~1%"
        ) else if %ng_mgk_tmp:~0,1%  gtr  4  ( set "ng_mgk_tmp=2%ng_mgk_tmp:~1%"
        ) else if %ng_mgk_tmp:~0,1%  gtr  2  ( set "ng_mgk_tmp=1%ng_mgk_tmp:~1%"
        ) else                                 set "ng_mgk_tmp=%ng_mgk_tmp:~1%"
    )

    rem  leading zero removal; final number can be 0, but preceding numbers cannot
    if /i "%ng_magic_noOct%" equ "true" if "%ng_mgk_dcntr%" neq "0" if "%ng_mgk_mxval:~0,1%" neq "0" if "%ng_mgk_tmp%" equ "0" set "ng_mgk_tmp="

    rem  re-loop to continue magic generation
    if %ng_mgk_dcntr% gtr 0 goto %~0

    rem  When all re-loops have been exhausted and the value is still blank, set to 0
    if "%ng_mgk_tmp%" equ "" set "ng_mgk_tmp=0"

    rem  no min/max: no checks;  otherwise check values before leaving
    if "%~4" equ "" if "%~3" equ "" set "%~1=%ng_mgk_tmp%"
    if not defined %~1 if %ng_mgk_dcntr% equ 0 if %ng_mgk_tmp% gtr %ng_mgk_mnval% if %ng_mgk_tmp% lss %ng_mgk_mxval% set "%~1=%ng_mgk_tmp%"

    rem  clear ng_mgk vars;  rem  reseed/recreate/reloop when failed min/max/length string check
    for %%T in ( ng_mindiff; ng_mgk_dcntr; ng_mgk_lcntr; ng_mgk_mnval; ng_mgk_mxval; ng_mgk_tmp ) do set "%%T="
    if defined %~1 goto :eof

    rem  debug stat counter
    set /a "ng_mgk_wasted_cycle+=1"
goto %~0



::  Usage  ::  func_ng_gen_psuedo_psueded   ReturnVar  stringLengthInteger
rem   Return param1 set to a random selection of characters from the character pool
:func_ng_gen_psuedo_psueded_psum
    if "%~1" equ ""  goto :eof 
    if "%~2" equ ""  goto :eof 
    if "%~2" geq "a" goto :eof
    set "%~1="

    call :func_ng_character_cat                   ng_character_pool
    set "ng_character_pool=#%ng_character_pool%"

    call :func_ng_get_strlen      ng_len_pool   "%ng_character_pool%"
    call :func_ng_get_strlen     ng_count_seed     "%ng_len_pool%"

    if not defined ng_count_seed goto :eof
    if not defined ng_len_pool   goto :eof
    if "%ng_count_seed%" geq "a" goto :eof
    if  "%ng_len_pool%"  geq "a" goto :eof

    if defined ng_dump_debug set "ng_stime=%time%"
    call :func_ng_gen_value_reloop   "%~1"   ng_character_pool  "%~2"
    if defined ng_dump_debug set "ng_etime=%time%"

goto :eof


::  Usage  ::  func_ng_get_strlen  ReturnVar  String
rem  Concept source  [url="https://stackoverflow.com/a/19101275"]{"Determine string length"}
rem    DisableDelayedExpansion rewrite by JaCk on 03/05/2018  -  although the commands are different, the structure is pretty much the same
rem  Calculates string length upto a maximum of 8191 characters (windows limitation)
rem  When problem calculating length, exits with errorlevel 456
rem  disabled delayed expansion friendly.  Actually, this why it was written in the first place.   Darn-it MS, you gave us hope with that feature, but the hope was shattered because it is buggy as heck.
:func_ng_get_strlen 
    if "%~2" equ "" goto :eof
    if "%~1" equ "" goto :eof 

    set "%~1=0"
    set "ng_SLn=%~2#"
    
    if "%ng_SLn:~4096,1%" neq "" ( ( set /a "%~1+=4096" ) & set "ng_SLn=%ng_SLn:~4096%" )
    if "%ng_SLn:~2048,1%" neq "" ( ( set /a "%~1+=2048" ) & set "ng_SLn=%ng_SLn:~2048%" )
    if "%ng_SLn:~1024,1%" neq "" ( ( set /a "%~1+=1024" ) & set "ng_SLn=%ng_SLn:~1024%" )
    if  "%ng_SLn:~512,1%" neq "" ( ( set /a "%~1+=512"  ) & set "ng_SLn=%ng_SLn:~512%"  )
    if  "%ng_SLn:~256,1%" neq "" ( ( set /a "%~1+=256"  ) & set "ng_SLn=%ng_SLn:~256%"  )
    if  "%ng_SLn:~128,1%" neq "" ( ( set /a "%~1+=128"  ) & set "ng_SLn=%ng_SLn:~128%"  )
    if   "%ng_SLn:~64,1%" neq "" ( ( set /a "%~1+=64"   ) & set "ng_SLn=%ng_SLn:~64%"   )
    if   "%ng_SLn:~32,1%" neq "" ( ( set /a "%~1+=32"   ) & set "ng_SLn=%ng_SLn:~32%"   )
    if   "%ng_SLn:~16,1%" neq "" ( ( set /a "%~1+=16"   ) & set "ng_SLn=%ng_SLn:~16%"   )
    if    "%ng_SLn:~8,1%" neq "" ( ( set /a "%~1+=8"    ) & set "ng_SLn=%ng_SLn:~8%"    )
    if    "%ng_SLn:~4,1%" neq "" ( ( set /a "%~1+=4"    ) & set "ng_SLn=%ng_SLn:~4%"    )
    if    "%ng_SLn:~2,1%" neq "" ( ( set /a "%~1+=2"    ) & set "ng_SLn=%ng_SLn:~2%"    )
    if    "%ng_SLn:~1,1%" neq "" ( ( set /a "%~1+=1"    ) & set "ng_SLn=%ng_SLn:~1%"    )

    set "ng_SLn=%ng_SLn:#=%"
    if not defined ng_SLn goto :eof

    set "%~1="
    set "ng_SLn="
    exit /b 456

goto :eof


::  Usage  ::  func_ng_gen_value_reloop   ReturnVar   varPoolName   integerReLoopCount
rem  chooses one value per loop cycle from a pool of characters;
rem  Note: re-runs itself when length check fails
:func_ng_gen_value_reloop
    if "%~1" equ  "" goto :eof
    if "%~2" equ  "" goto :eof
    if "%~3" equ  "" goto :eof
    if "%~3" geq "a" goto :eof
    if  %~3  lss  0  goto :eof
    if not defined ng_gnv_dcount  set "ng_gnv_dcount=%~3"
    set /a "ng_gnv_dcount-=1"
    set /a "ng_gnv_lcount+=1"

    rem  seed random numbers to create the magic number
    call :func_ng_create_magic_number   ng_magic_number   %ng_count_seed%   1   %ng_len_pool%

    rem  use magic number as character pool location offset
    ( call :func_ng_append_str2var   "%~1"   "%%%~2:~-%ng_magic_number%,1%%%"
    ) 2>nul

    rem  check string for corruption
    if defined ng_dump_debug ( call :func_ng_isStrBlank   ng_blank_str  "%%%~1:~%ng_gnv_lcount%%%"
    ) 2>nul
    if defined ng_dump_debug if "%ng_blank_str%" equ "" set /a "ng_gnv_wasted_cycle+=1"
    if defined ng_dump_debug if "%ng_blank_str%" equ "" call echo/%~nx0: %~0: strCorruption: "%%%~1:~%ng_gnv_lcount%%%"

    rem  reloop when string length has not been met
    if %ng_gnv_dcount% gtr 0 goto %~0
    
    rem  check string for corruption
    ( call :func_ng_isStrBlank   ng_blank_str  "%%%~1:~%~3%%"
    ) 2>nul

    rem  leave when string lengths match: ng_blank_str=true
    set "ng_gnv_dcount="
    set "ng_gnv_lcount="
    if "%ng_blank_str%" neq "" goto :eof

    rem  re-loop to regenerate a new string
    set "%~1="
    set /a "ng_gnv_wasted_str+=1"
    
goto %~0


::  Usage  ::  func_ng_init
rem  prepares the scripting env and resolves dependencies 
:func_ng_init
    call :func_ng_user_settings
    call :func_ng_script_behavior
    call :func_ng_check_dependencies
    call :func_ng_character_pools
    set "ng_flag_init=true"
goto :eof


::  Usage  ::  func_ng_isStrBlank   ReturnVar   str
rem  Return param1 set to 'true' when param2 is blank
:func_ng_isStrBlank
    if "%~1" equ "" goto :eof
    set "%~1="
    if "%~2" equ "" set "%~1=true"
goto :eof
