:: By JaCk  |  Release 06/23/2018  |  https://github.com/1ijack/BatchMajeek/blob/master/7z.association.fix.bat  | 7z.association.fix.bat  --  add/fix 7z file association commands
:: Note: due to the use of the 'assoc' command -- this script/commands need to be run with elevated (administrator) privileges -- script does NOT self elevate
::  
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
:::
:: 
:: @rem  Batch file: one-liner for adding extension associations which are not already assigned
::     @echo off & setlocal DisableDelayedExpansion EnableExtensions & @(if not exist "%ProgramFiles(x86)%\7-Zip\7zFM.exe" if not exist "%ProgramFiles%\7-Zip\7zFM.exe" @( ( echo/Error: Fatal: Missing 7z binaries, nothing to do.) & goto :eof ) 1>&2 else @(for %%A in ( .001 .002 .003 .004 .005 .006 .007 .008 .009 .010 .7z .a .apm .ar .arj .bz2 .bzip2 .cab .chi .chm .chq .chw .cpio .cramfs .deb .dmg .epub .esd .ext2 .ext3 .ext4 .ext .fat .gz .gzip .hfs .hfsx .hxi .hxq .hxr .hxs .hxw .ihex .img .iso .jar .lha .lib .lit .lzh .lzma .mbr .mslz .mub .nsis .ntfs .ods .odt .pkg .ppmd .qcow2 .qcow2c .qcow .r00 .r01 .r02 .r03 .r04 .r05 .r06 .r07 .r08 .r09 .r10 .r11 .r12 .r13 .r14 .r15 .r16 .r17 .r18 .r19 .r20 .r21 .r22 .r23 .r24 .r25 .r26 .r27 .r28 .r29 .rar .rpm .scap .squashfs .swm .tar .taz .tbz2 .tbz .tgz .txz .udf .uefif .vdi .vhd .vmdk .wim .xar .xpi .xz .z .zip .zipx ) do @(( assoc %%A ) 2>nul 1>nul || assoc %%A=7z)) & @((( ftype ) | findstr /i "7zFM" ) 2>nul 1>nul || ftype 7z="%ProgramFiles%\7-Zip\7zFM.exe" %1 %*)) & 1>nul @(endlocal & goto :eof || exit /b) 2>nul
:: 
:: @rem  if/when this batch file fails to run remove this line and the next two lines, save, and try again
:: @rem  Interactive command line console: one-liner for adding extension associations which are not already assigned
::     @setlocal DisableDelayedExpansion EnableExtensions & @(if not exist "%ProgramFiles(x86)%\7-Zip\7zFM.exe" if not exist "%ProgramFiles%\7-Zip\7zFM.exe" @( ( echo/Error: Fatal: Missing 7z binaries, nothing to do.) & goto :eof ) 1>&2 else @(for %A in ( .001 .002 .003 .004 .005 .006 .007 .008 .009 .010 .7z .a .apm .ar .arj .bz2 .bzip2 .cab .chi .chm .chq .chw .cpio .cramfs .deb .dmg .epub .esd .ext2 .ext3 .ext4 .ext .fat .gz .gzip .hfs .hfsx .hxi .hxq .hxr .hxs .hxw .ihex .img .iso .jar .lha .lib .lit .lzh .lzma .mbr .mslz .mub .nsis .ntfs .ods .odt .pkg .ppmd .qcow2 .qcow2c .qcow .r00 .r01 .r02 .r03 .r04 .r05 .r06 .r07 .r08 .r09 .r10 .r11 .r12 .r13 .r14 .r15 .r16 .r17 .r18 .r19 .r20 .r21 .r22 .r23 .r24 .r25 .r26 .r27 .r28 .r29 .rar .rpm .scap .squashfs .swm .tar .taz .tbz2 .tbz .tgz .txz .udf .uefif .vdi .vhd .vmdk .wim .xar .xpi .xz .z .zip .zipx ) do @(( assoc %A ) 2>nul 1>nul || assoc %A=7z)) & @((( ftype ) | findstr /i "7zFM" ) 2>nul 1>nul || ftype 7z="%ProgramFiles%\7-Zip\7zFM.exe" %1 %*)) & @endlocal
:: 
:: 
:::
@rem  Batch AND/OR Interactive Console: forcing/overwriting/adding extension associations
    @if exist "%ProgramFiles(x86)%\7-Zip\7zFM.exe" @(
        ftype 7z="%ProgramFiles(x86)%\7-Zip\7zFM.exe" %1 %*
    ) else @if exist "%ProgramFiles%\7-Zip\7zFM.exe" @(
        ftype 7z="%ProgramFiles%\7-Zip\7zFM.exe" %1 %*
    ) else @(
        echo/Error: Fatal: Missing 7z binaries, nothing to do.
        goto :eof
    ) 1>&2

    @assoc .001=7z
    @assoc .002=7z
    @assoc .003=7z
    @assoc .004=7z
    @assoc .005=7z
    @assoc .006=7z
    @assoc .007=7z
    @assoc .008=7z
    @assoc .009=7z
    @assoc .010=7z
    @assoc .7z=7z
    @assoc .a=7z
    @assoc .apm=7z
    @assoc .ar=7z
    @assoc .arj=7z
    @assoc .bz2=7z
    @assoc .bzip2=7z
    @assoc .cab=7z
    @assoc .chi=7z
    @assoc .chm=7z
    @assoc .chq=7z
    @assoc .chw=7z
    @assoc .cpio=7z
    @assoc .cramfs=7z
    @assoc .deb=7z
    @assoc .dmg=7z
    @assoc .epub=7z
    @assoc .esd=7z
    @assoc .ext2=7z
    @assoc .ext3=7z
    @assoc .ext4=7z
    @assoc .ext=7z
    @assoc .fat=7z
    @assoc .gz=7z
    @assoc .gzip=7z
    @assoc .hfs=7z
    @assoc .hfsx=7z
    @assoc .hxi=7z
    @assoc .hxq=7z
    @assoc .hxr=7z
    @assoc .hxs=7z
    @assoc .hxw=7z
    @assoc .ihex=7z
    @assoc .img=7z
    @assoc .iso=7z
    @assoc .jar=7z
    @assoc .lha=7z
    @assoc .lib=7z
    @assoc .lit=7z
    @assoc .lzh=7z
    @assoc .lzma=7z
    @assoc .mbr=7z
    @assoc .mslz=7z
    @assoc .mub=7z
    @assoc .nsis=7z
    @assoc .ntfs=7z
    @assoc .ods=7z
    @assoc .odt=7z
    @assoc .pkg=7z
    @assoc .ppmd=7z
    @assoc .qcow2=7z
    @assoc .qcow2c=7z
    @assoc .qcow=7z
    @assoc .r00=7z
    @assoc .r01=7z
    @assoc .r02=7z
    @assoc .r03=7z
    @assoc .r04=7z
    @assoc .r05=7z
    @assoc .r06=7z
    @assoc .r07=7z
    @assoc .r08=7z
    @assoc .r09=7z
    @assoc .r10=7z
    @assoc .r11=7z
    @assoc .r12=7z
    @assoc .r13=7z
    @assoc .r14=7z
    @assoc .r15=7z
    @assoc .r16=7z
    @assoc .r17=7z
    @assoc .r18=7z
    @assoc .r19=7z
    @assoc .r20=7z
    @assoc .r21=7z
    @assoc .r22=7z
    @assoc .r23=7z
    @assoc .r24=7z
    @assoc .r25=7z
    @assoc .r26=7z
    @assoc .r27=7z
    @assoc .r28=7z
    @assoc .r29=7z
    @assoc .rar=7z
    @assoc .rpm=7z
    @assoc .scap=7z
    @assoc .squashfs=7z
    @assoc .swm=7z
    @assoc .tar=7z
    @assoc .taz=7z
    @assoc .tbz2=7z
    @assoc .tbz=7z
    @assoc .tgz=7z
    @assoc .txz=7z
    @assoc .udf=7z
    @assoc .uefif=7z
    @assoc .vdi=7z
    @assoc .vhd=7z
    @assoc .vmdk=7z
    @assoc .wim=7z
    @assoc .xar=7z
    @assoc .xpi=7z
    @assoc .xz=7z
    @assoc .z=7z
    @assoc .zip=7z
    @assoc .zipx=7z
