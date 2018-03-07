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
:::            Settings              :::
::                                    ::
::::::::::::::::::::::::::::::::::::::::

::  Usage  ::  func_ng_user_settings
rem  User script settings
:func_ng_user_settings

    rem  Integer Setting Variables: 
    set "ng_int_newStringLength=15"     rem  Default: 12   -- Description: the length of characters in output string

goto :eof


::  Usage  ::  func_ng_script_behavior
rem  Script behavior settings
:func_ng_script_behavior

    rem  Boolean Setting Variables: 
    set "ng_bool_use_similar="          rem  Default:      -- Description: when 'true', uses similar-looking characters
    set "ng_bool_use_numberical=true"   rem  Default: true -- Description: when 'true', uses numerical characters
    set "ng_bool_use_lowerAlpha=true"   rem  Default: true -- Description: when 'true', uses alphabetic lowercase characters
    set "ng_bool_use_upperAlpha=true"   rem  Default: true -- Description: when 'true', uses alphabetic uppercase characters
    set "ng_bool_use_specialChrA=true"  rem  Default: true -- Description: when 'true', uses not-so special characters
    set "ng_bool_use_specialChrB=true"  rem  Default: true -- Description: when 'true', uses pretty special characters
    set "ng_bool_use_specialChrC=true"  rem  Default: true -- Description: when 'true', uses super special characters

goto :eof


::  Usage  ::  func_ng_character_pools
rem  these are the available character pools that are sourced for the "random" string, alter to your liking
rem  Note: time to generate string is relative to the total size of the total character pool
:func_ng_character_pools

    if /i "%ng_bool_use_lowerAlpha%"  equ "true" set "ng_pool_alphaLower=a b c d e f h j k m n p q r s u v w x y z"
    if /i "%ng_bool_use_upperAlpha%"  equ "true" set "ng_pool_alphaUpper=A B C E F G H J K L M N P R S T U V W X Y Z"
    if /i "%ng_bool_use_numberical%"  equ "true" set "ng_pool_numberical=2 3 4 5 7 9"
    if /i "%ng_bool_use_specialChrA%" equ "true" set "ng_pool_specialChrA=[ ~ @ ( , ) _   ]"
    if /i "%ng_bool_use_specialChrB%" equ "true" set "ng_pool_specialChrB=/ # $ { ' } ; + \"
    if /i "%ng_bool_use_specialChrC%" equ "true" set "ng_pool_specialChrC=? "

    rem  when 'not true' replace character pools with all possibilities
    if /i "%ng_bool_use_similar%"     neq "true" goto :eof

    if /i "%ng_bool_use_lowerAlpha%"  equ "true" set "ng_pool_alphaLower=a b c d e f g h i j k l m n o p q r s t u v w x y z"
    if /i "%ng_bool_use_upperAlpha%"  equ "true" set "ng_pool_alphaUpper=A B C D E F G H I J K L M N O P Q R S T U V W X Y Z"
    if /i "%ng_bool_use_numberical%"  equ "true" set "ng_pool_numberical=1 2 3 4 5 6 7 8 9 0"
    if /i "%ng_bool_use_specialChrA%" equ "true" set "ng_pool_specialChrA= : [ ~ @ ( , . ) _ - ] "
    if /i "%ng_bool_use_specialChrB%" equ "true" set "ng_pool_specialChrB= = / # $ { ` ' } ; + \"
    if /i "%ng_bool_use_specialChrC%" equ "true" set "ng_pool_specialChrC= | ? & ! < * ^ > %%"
    REM if /i "%ng_bool_use_specialChrC%" equ "true" set "ng_pool_specialChrC= | ? & ! < * ^ > %% """

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
    
    rem  parameters,when intergers change ng_int_newStringLength
    if "%~1" lss "a" set "ng_int_argStringLength=%~1"
    shift /1
    

    if "%~1" equ "" ( 
        set /a "ng_bla_cnt+=1"
    ) else set "ng_bla_cnt=0"

    if %ng_bla_cnt% geq 9 goto :eof
    if %ng_bla_cnt% gtr 1 goto :func_ng_mein

    rem  generate a random string, print string
    call :func_ng_gen_psuedo_psueded_psum   ng_random_string
    echo/"%ng_random_string%"

    goto :func_ng_mein
    
    rem  unset all script vars and undo environment changes, then leave
    ( for /f "tokens=1 delims==" %%V in ('set ng_') do set "%%~V=" ) 2>nul 1>nul 
    endlocal

goto :eof


::  Usage  ::  func_ng_append_str2var   ReturnVar   StringToAdd
rem  Appends string to the tail of the variable expressed value
:func_ng_append_str2var
    if "%~2" equ "" ( goto :eof ) else if "%~1" equ "" goto :eof

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
    if "%~1" equ "" ( goto :eof ) else set "%~1="

    rem  the larger the character pool, the longer it takes to calculate
    ( for /f "tokens=1,* delims==" %%U in ('set ng_pool_') do call :func_ng_append_str2var  "%~1" "%%%%U: =%%"
    ) 2>nul

goto :eof


::  Usage  ::  func_ng_create_magic_number   ReturnVar   maxStrLen   optional-maxValue
rem  Creates a magic seed number based on seed, maxlength and maxvalue
:func_ng_create_magic_number
    if "%~2" equ  "" ( goto :eof ) else if "%~1" equ "" ( goto :eof ) else if "%~2" geq "a" goto :eof
    if "%~3" equ  "" (
        call %~0   "%~1"   "%~2"   0
        goto :eof 
    )
    if not defined ng_mgk_count set "ng_mgk_count=%~2"
    set /a "ng_mgk_count-=1"

    set "ng_rnd=%random:~-1%"
    if "%ng_rnd%" equ "0" goto %~0

    if defined ng_mgk_tmp set "ng_mgk_tmp=%ng_mgk_tmp%%ng_rnd%"
    if not defined ng_mgk_tmp set "ng_mgk_tmp=%ng_rnd%"
    if %ng_mgk_count% gtr 0 goto %~0

    if %~3 equ 0 (
        set "%~1=%ng_mgk_tmp%"
        set "ng_mgk_count="
        set "ng_mgk_tmp=
        set "ng_rnd="
        goto :eof
    ) else if %ng_mgk_tmp% gtr %~3 (
        set "ng_mgk_count=%~2"
        set "ng_mgk_tmp="
        set "ng_rnd="
        goto %~0
    ) else (
        set "%~1=%ng_mgk_tmp%"
        set "ng_mgk_count="
        set "ng_mgk_tmp=
        set "ng_rnd="
        goto :eof
    )

goto :eof


::  Usage  ::  func_ng_gen_psuedo_psueded   optional-ReturnVar
rem   Return param1 set to a random selection of characters from the character pool
:func_ng_gen_psuedo_psueded_psum
    if "%~1" equ "" goto :eof 
    set "%~1="

    call :func_ng_user_settings
    call :func_ng_script_behavior

    if defined ng_int_argStringLength (
        set "ng_int_newStringLength=%ng_int_argStringLength%"
        set "ng_int_argStringLength="
    )
    
    call :func_ng_character_pools
    call :func_ng_character_cat                   ng_character_pool
    call :func_ng_get_strlen      ng_len_pool   "%ng_character_pool%"
    call :func_ng_get_strlen     ng_count_seed     "%ng_len_pool%"

    if not defined ng_count_seed goto :eof
    if not defined ng_len_pool   goto :eof
    if "%ng_len_pool%" geq "a"   goto :eof

    call :func_ng_gen_value_reloop   "%~1"   ng_character_pool

goto :eof


::  Usage  ::  func_ng_get_strlen  ReturnVar  String
rem  Concept source  [url="https://stackoverflow.com/a/19101275"]{"Determine string length"}
rem    DisableDelayedExpansion rewrite by JaCk on 03/05/2018  -  although the commands are different, the structure is pretty much the same
rem  Calculates string length upto a maximum of 8191 characters
rem  When problem calculating length, exits with errorlevel 456
rem  disabled delayed expansion friendly.  Actually, this why it was written in the first place.   Darn-it MS, you gave us hope with that feature, but the hope was shattered because it is buggy as heck.
:func_ng_get_strlen 
    if "%~1" equ "" goto :eof 
    if "%~2" equ "" (
        set "%~1=0"
        goto :eof
    ) else set "%~1="

    set "ng_SLn=%~2#"
    if "%ng_SLn:~4096,1%" neq "" ( set /a "%~1+=4096" ) & set "ng_SLn=%ng_SLn:~4096%"
    if "%ng_SLn:~2048,1%" neq "" ( set /a "%~1+=2048" ) & set "ng_SLn=%ng_SLn:~2048%"
    if "%ng_SLn:~1024,1%" neq "" ( set /a "%~1+=1024" ) & set "ng_SLn=%ng_SLn:~1024%"
    if  "%ng_SLn:~512,1%" neq "" ( set /a "%~1+=512"  ) & set "ng_SLn=%ng_SLn:~512%"
    if  "%ng_SLn:~256,1%" neq "" ( set /a "%~1+=256"  ) & set "ng_SLn=%ng_SLn:~256%"
    if  "%ng_SLn:~128,1%" neq "" ( set /a "%~1+=128"  ) & set "ng_SLn=%ng_SLn:~128%"
    if   "%ng_SLn:~64,1%" neq "" ( set /a "%~1+=64"   ) & set "ng_SLn=%ng_SLn:~64%"
    if   "%ng_SLn:~32,1%" neq "" ( set /a "%~1+=32"   ) & set "ng_SLn=%ng_SLn:~32%"
    if   "%ng_SLn:~16,1%" neq "" ( set /a "%~1+=16"   ) & set "ng_SLn=%ng_SLn:~16%"
    if    "%ng_SLn:~8,1%" neq "" ( set /a "%~1+=8"    ) & set "ng_SLn=%ng_SLn:~8%"
    if    "%ng_SLn:~4,1%" neq "" ( set /a "%~1+=4"    ) & set "ng_SLn=%ng_SLn:~4%"
    if    "%ng_SLn:~2,1%" neq "" ( set /a "%~1+=2"    ) & set "ng_SLn=%ng_SLn:~2%"
    if    "%ng_SLn:~1,1%" neq "" ( set /a "%~1+=1"    ) & set "ng_SLn=%ng_SLn:~1%"

    if "%ng_SLn%" equ "#" (
        set "ng_SLn="
        goto :eof
    )

    set "%~1="
    set "ng_SLn="
    exit /b 456

goto :eof


::  Usage  ::  func_ng_gen_value_reloop   ReturnVar   varPoolName   optional-reloopCount
rem  chooses one value per loop cycle from a pool of characters;
:func_ng_gen_value_reloop
    if "%~2" equ "" goto :eof
    if "%~1" equ "" goto :eof
    
    if not defined ng_get_str_count if "%~3" equ "" ( if defined ng_int_newStringLength ( set "ng_get_str_count=%ng_int_newStringLength%" ) else set "ng_get_str_count=10" ) else if "%~3" leq "a" set "ng_get_str_count+=%~3"
    if not defined ng_get_str_count ( goto :eof ) else if not defined ng_get_str_count_default set "ng_get_str_count_default=%ng_get_str_count%"

    rem  checks if the length of the string is correct; when correct length, returns defined
    if %ng_get_str_count% leq 0 ( 
        call :func_ng_isBlank_str   ng_blank_str  "%%%~1:~%ng_get_str_count_default%%%" 
    ) 2>nul

    rem  leave when string lengths match. otherwise, re-loop to regenerate a new string, 
    if %ng_get_str_count% leq 0 if defined ng_blank_str (
        set "ng_get_str_count="
        set "ng_get_str_count_default="
        goto :eof
    ) else (
        set "%~1="
        set "ng_get_str_count=%ng_get_str_count_default%"
        goto %~0
    )

    set /a "ng_get_str_count-=1"

    rem  seed random numbers to create the magic number
    set "ng_magic_number="
    call :func_ng_create_magic_number   ng_magic_number   %ng_count_seed%   %ng_len_pool%

    ( call :func_ng_append_str2var   "%~1"   "%%%~2:~-%ng_magic_number%,1%%%"
    ) 2>nul
    goto %~0

goto :eof


::  Usage  ::  func_ng_isBlank_str   ReturnVar   str
rem  Return param1 set to 'true' when param2 is blank
:func_ng_isBlank_str
    if "%~1" equ "" ( goto :eof ) else set "%~1="
    if "%~2" equ "" set "%~1=true"

goto :eof
