::  By JaCk  |  Release 05/30/2018  |  https://github.com/1ijack/BatchMajeek/blob/master/slen.cmd  |  slen.cmd  -- uses findstr to calculate and return string length
:::
:: General concept credit/inspiration/source for length calc
:: by Frank Westlake - RandomizeKey.cmd - lines 24-26
:: :: From the desk of Frank P. Westlake, 2013-01-03
:: :: Package not marked for individual sale.
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
@echo off &setlocal EnableExtensions DisableDelayedExpansion
:getLen
::: User Settings :::::::::::::::::::::
rem enable,  use "true"
rem disable, use   ""  -- [undefined]/blank
 rem dumps results as strings in a json object
 set "json{results}=true"
 set "json{escaped}=true"
 rem return string length
 set "text{results}="
::: main ::::::::::::::::::::::::::::::
set "{len}="
set "{str}=%~1"
(if defined %{str}% call set "{str}=%%{str}%%") 2>nul
rem General concept credit/inspiration/source for length calc
rem by Frank Westlake - RandomizeKey.cmd - lines 24-26
rem :: From the desk of Frank P. Westlake, 2013-01-03
rem :: Package not marked for individual sale.
for /f "skip=1 tokens=1 delims=:" %%O in ('"(echo/{str}&echo/{str})|findstr /boc:{str}"') do for /f "tokens=1 delims=:" %%L in ('"(set {str}&echo/{str})|findstr /boc:{str}"') do set /a "{len}=%%~L-%%~O"
rem print results
if defined text{results} echo/%{len}%
if defined json{escaped} set "{str}=%{str}:\=\\%"
if defined json{results} if defined json{escaped} ( echo/{ "length" : "%{len}%", "string" : "%{str}:"=\"%" }
) else echo/{ "length" : "%{len}%", "string" : "%{str}%" }
shift /1
if "%~1" neq "" goto :getLen
for %%V in ({str};{len};json{results};json{escaped};text{results};) do set "%%V="
endlocal
