::  Modified By JaCk  |  Release 07/11/2018  |  https://github.com/1ijack/BatchMajeek/blob/master/gmt.cmd  |  gmt.cmd -- Display the current date and time in GMT (World Time)
:::
:: This script is a highly modified/trimmed version of sourced
::  By Unknown  |  Release Unknown  |  https://ss64.com/nt/syntax-gmt.html  |  gmt.cmd -- Display the current date and time in GMT (World Time)
:::
@echo off &Setlocal EnableExtensions
for /f "tokens=1,2 delims==" %%G in ('wmic path Win32_UTCTime get /value') do @call set "g%%G=0000%%H"
Echo/%gYear:~-4%-%gMonth:~-2%-%gDay:~-2% %gHour:~-2%:%gMinute:~-2%:%gSecond:~-2%
REM @for /f "tokens=1,2 delims==" %%G in ('wmic path Win32_LocalTime get /value') do @call set "l%%G=0000%%H"
REM @Echo/%lYear:~-4%-%lMonth:~-2%-%lDay:~-2% %lHour:~-2%:%lMinute:~-2%:%lSecond:~-2%
endlocal
