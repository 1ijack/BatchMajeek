# What is BatchMajeek?
**description**: An expository collection of mysterious, and random Windows Batch/Cmd scripts which insight thought

__OR Choose your **own description**:__    
**description**: An `____` collection of `______` `Windows bat/cmd scripts` which insight `______`

Some Examples:    
- **description**: An `terrible` collection of `crappy, distasteful, obsurd` `Windows bat/cmd scripts` which insight `fearful awe`    
- **description**: An `superb` collection of `code-pron` `Windows bat/cmd scripts` which insight `clairvoyant clarity, and a sense of true freedom`     

## Can I contact you?
- Having Problems? [new issue](https://github.com/1ijack/BatchMajeek/issues/new) > Labels > "[bug](https://github.com/1ijack/BatchMajeek/labels/bug)"
- Send me message? [new issue](https://github.com/1ijack/BatchMajeek/issues/new) > Labels > "[question](https://github.com/1ijack/BatchMajeek/labels/question)"

## JusDaTip
- When are quotes required?: [`cmd.exe /?`]
````batch-file
        <space>
        &()[]{}^=;!'+,`~
````
- What math operations can I do with `set /a "result=math"`
  - for expanded info see: `set /?`.  Here is a summary: [`set/?|findstr/rC:" .[&-]"`]
````batch-file
    ()                  - grouping
    ! ~ -               - unary operators
    * / %               - arithmetic operators
    + -                 - arithmetic operators
    << >>               - logical shift
    &                   - bitwise and
    ^                   - bitwise exclusive or
    |                   - bitwise or
    = *= /= %= += -=    - assignment
      &= ^= |= <<= >>=
    ,                   - expression separator
````

## Bat/Cmd Scripts - notes and features
- Underwhelmed/Overwhelmed? [gist nibbles](https://gist.github.com/1ijack) 

__Most scripts are agnostic to delayedExpansion, should be able to use__ `!`    
- [ah.fu.cmd](./ah.fu.cmd ) -- Grossly overengineered process killer which reads a conf file to change behavior
  - [eph.u.conf](./eph.u.conf ) -- dubbed "process-hitlist" is an example of a conf for [ah.fu.cmd](./ah.fu.cmd )
- [compactor.cmd](./compactor.cmd ) -- wrapper around the windows binary compact.exe to compress/uncompress files via the NTFS filesystem
  - Can walk down a directory tree and uncompress all files with a 1.0 ratio
  - Full args parse
````batch-file
    compactor -i C:\Windows\Temp\PowerPlan.log -u
    compactor.cmd:unCompressExtensions: 05/28/18 23:28:34: PowerPlan.log: 0 files within 1 directories were uncompressed.
    
    compactor -i C:\Windows\Temp\PowerPlan.log -z
    compactor.cmd:unCompressRedundant: 05/28/18 23:28:47: PowerPlan.log: 0 files within 1 directories were uncompressed.
    
    compactor -i C:\Windows\Temp -r -e .log -c
    compactor.cmd:CompressExtensions: 05/28/18 23:31:13: C:\Windows\Temp\HighPerformancePlan.log: The compression ratio is 1.8 to 1.
    compactor.cmd:CompressExtensions: 05/28/18 23:31:14: C:\Windows\Temp\PowerPlan.log: The compression ratio is 1.0 to 1.
    compactor.cmd:CompressExtensions: 05/28/18 23:31:14: C:\Windows\Temp\vmware-SYSTEM\vmware-usbarb-1111.log: The compression ratio is 1.2 to 1.
    compactor.cmd:CompressExtensions: 05/28/18 23:31:15: C:\Windows\Temp\vmware-SYSTEM\vmware-usbarb-2222.log: The compression ratio is 1.2 to 1.
    compactor.cmd:CompressExtensions: 05/28/18 23:31:15: C:\Windows\Temp\vmware-SYSTEM-123456789\vmware-usbarb-3333.log: The compression ratio is 1.5 to 1.
    compactor.cmd:CompressExtensions: 05/28/18 23:31:16: C:\Windows\Temp\vmware-SYSTEM-123456789\vmware-usbarb-4444.log: The compression ratio is 1.1 to 1.
````
- [duration.cmd](./duration.cmd ) -- calculates execution duration and dumps summary
  - simple calling syntax such as: `duration.cmd timeout /t 5`
  - dumps results/summary as a json object.  Specific data/information is toggled via variables
  - no external dependencies required, but uses these standard windows binaries when found:
    - cmd.exe: launches command(s) as subprocess of cmd.exe
    - timeout.exe: optional script execution sleep
    - w32tm.exe: supplies timezone and DST
- [elevate](./elevate/) -- self-elevate scripts, functions and examples using "bunction" labels
  - [elevate/elevate.cmd](./elevate/elevate.cmd ) -- elevates all passed arguments or starts a elevated cmd console
  - [elevate/elvn.cmd](./elevate/elvn.cmd ) -- self-elevate using "bunction" oneliner; detection via "net session"
  - [elevate/elvc.cmd](./elevate/elvc.cmd ) -- self-elevate using "bunction" oneliner; detection via "calcs"
- [fLines.cmd](./fLines.cmd ) -- prints file line counts using native find.exe
  - runs fairly quick
  - when directory, prints line counts for all the normal files in that directory
  - simple syntax:
````batch-file
    flines.cmd "%SystemRoot%\DirectX.log" C:\Windows\Logs\CBS\CBS.log
    13967 : C:\Windows\DirectX.log
    6431 : C:\Windows\Logs\CBS\CBS.log
````
- [gmt.cmd](./gmt.cmd ) -- Display the current date and time in GMT (World Time).
  - queries wmic for time information
  - This is a simplified/modified version. Original script/code: [ss64.com](https://ss64.com/nt/syntax-gmt.html )
````batch-file
    gmt.cmd
    2018-07-21 13:54:07
````
- [gstr.cmd](./gstr.cmd ) -- batch native random string genarator.
  - to generate 10 strings: for /l %Z in (1,1,10) do [gstr.cmd](./gstr.cmd )
  - to generate 3 strings, 12, 15, 50 characters: [gstr.cmd](./gstr.cmd ) 12 15 50
- [h2p.cmd](./h2p.cmd ) -- grabs pdfs of url address using "[wkhtmltopdf.exe](https://wkhtmltopdf.org/downloads.html)".
  - Code has been mostly scrubbed and unused functions have been removed.
  - Names pdf file with urlstring+currentdateStamp
  - ASCII encoded URL names decoded for auto-filename generator
  - Support for special characters in URL namespace
- [hhmmss.cmd](./hhmmss.cmd ) -- Converts time: from total-seconds into hh:mm:ss notation - "Complete Edition"
- [hhmmss.min.cmd](./hhmmss.min.cmd ) -- Converts time: from total-seconds into hh:mm:ss notation - without all the "tard" code
- [lazyJson.bat](./lazyJson.bat) - Prints all key/value pairs to console
````batch-file
    example of a "working" json object: 
        echo/{ "myVariable" : "some kind of string or integer" }> lzj.json
        
        lazyJson.bat lzj.json
        "myVariable=some kind of string or integer"

        
    Usage: lazyJson.bat Summer\atLake\Jason.json  "SomeFile OuttaSpace.json"    fail3.json
    Prints all key/value pairs to console
    TL;DR -- NEEDS to have a whitespace on AT LEAST ONE side of the colon.  Each key/value pair needs to be on a separate line
      Note:
        a space before/after a colon, and brackets -- { "key" : "value" }
        \n and \r\n are considered end-of-key-value
        makes no distinction between an [array] and {key:value} and considers \r\n[array]\r\n as a valueless key
        commas outside double-quotes are ignored
````
- [md5.cmd](./md5.cmd ) -- hashes files and directories with optional recursion, unicode and logging options
- [mvlinks.bat](./mvlinks.bat ) -- Recursively moves directory tree
  - Moves all: files, directories and hardlinks
  - Recreates hardlinked files during move.
  - Unhide/Rehide objects during move.
  - For now, requires sysinternals "[findlinks.exe](https://docs.microsoft.com/en-us/sysinternals/downloads/findlinks )" to expose all hardlinks.
  - DOES NOT remove the old tree on purpose
  - DOES NOT move/update junctions or symlinks
- [pidme.cmd](./pidme.cmd ) -- Launches command and returns it's PID using powershell
- [raw2res.bat](./raw2res.bat ) -- Uses ffmpeg.exe to duplicate same images with different base heights
  - depends on [ffmpeg.exe](https://ffmpeg.org/download.html)
- [slength.cmd](./slength.cmd ) -- Uses findstr.exe to calculate length of a string or the length of a variable's value
  - [slen.cmd](./slen.cmd ) -- minimized version of [slength.cmd](./slength.cmd )
  - [slength.cmd](./slength.cmd ): string and variable examples:    
````batch-file
    slength.cmd "this is my super long string"
    28
    
    set "abc=0123456789"
    slength.cmd abc
    10
````
- [subExport.bat](./subExport.bat ) -- Uses ffmpeg.exe dump/export/save all textbased subtitles from video containers (like .mkv)
  - depends on [ffmpeg.exe](https://ffmpeg.org/download.html)
  - dump/clean ffmpeg subtitle error/export log files
  - no support for image-based subtitles
  - simple/efficient/robust args parser
  - simple file extension and subtitle type filtering
  - saves files as {vidoeFileName.extension}.{langId}.{streamId}.{subExtension}
    - when langId is undefined, uses 'und' as langId
    - creates the following subtitle files FOR EACH streamId: .ass, .srt, .vtt
  - default path recursion.  Unable to change this behavior at the moment.  Not super efficient, but works.
- [RemoveEmpties.bat](./RemoveEmpties.bat ) -- Removes Empty Files/SubDirectories from the defaulted/given path(s)
  - My use-case: remove leftover files/dirs from the temp directories
  - determines whether file is empty (by file size)
  - determines whether directory is empty.  This detection is somewhat slow at the moment, I may improve the detection at a later date.
````batch-file
    removeempties.bat -r "C:\dev\temp"
    Info: Checking: "C:\dev\temp\tinyMM\templates\TvShowDetailExampleXml"
    Info: Checking: "C:\dev\temp\tinyMM\templates\SimpleConfluence\include\images"
    Info: Checking: "C:\dev\temp\tinyMM\templates\SimpleConfluence\include"
    ...
    Del: Directory: "C:\dev\temp\nirsoft_logs"
    Info: Remove Count Summary:
       15 Dir(s)
       131 File(s)
````
- [unixTime.bat](./unixTime.bat ) -- returns the current system time as unix time (01/01/1970 )
  - Adjusts to system timezone and DST (or any other time adjustments registered with windows)
  - Returns unixTime in Seconds OR milliseconds, option defined in 'user settings' inside the script
  - Auto calculates leap-year(s)
  - Optimized for quick execution. Runs 30%-50% faster when all comments/empty lines  are removed
- [unixTimeFull.bat](./unixTimeFull.bat ) -- returns the current system time as unix time (01/01/1970 )
  - Same as [unixTime.bat](./unixTime.bat ), but without the optimizations.
  - Uses functions for further customization
- [uptime.cmd](./uptime.cmd ) -- returns system uptime
  - depends on wmic for boot and current time
  - quick customized output behavior (based on variables in the `User Config` section)
````batch-file
    uptime.cmd
    217:19:14
    
    uptime.cmd
    9d 01:19:14
    
    uptime.cmd
    9 days 1 hours 19 minutes 14 seconds    
````
