# BatchMajeek
Mysterious Windows Batch/Cmd scripts -- My personal, public exposition.

## Please world, see my junk... No I don't care what you think. (unless you find issues)
Most scripts are agnostic to delayedExpansion, should be able to use "!"
- [ah.fu.cmd](./ah.fu.cmd ) -- Grossly overengineered process killer which reads a conf file to change behavior
  - [eph.u.conf](./eph.u.conf ) -- dubbed "process-hitlist" is an example of a conf for [ah.fu.cmd](./ah.fu.cmd )
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
  - string example: slength.cmd
  ```
  slength.cmd "this is my super long string"
  28
  ```
  - variable example:
  ```
  set "abc=0123456789"
  slength.cmd abc
  10
  ```
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
- [unixTime.bat](./unixTime.bat ) -- returns the current system time as unix time (01/01/1970 )
  - Adjusts to system timezone and DST (or any other time adjustments registered with windows)
  - Returns unixTime in Seconds OR milliseconds, option defined in 'user settings' inside the script
  - Auto calculates leap-year(s)
  - Optimized for quick execution. Runs 30%-50% faster when all comments/empty lines  are removed 
- [unixTimeFull.bat](./unixTimeFull.bat ) -- returns the current system time as unix time (01/01/1970 )
  - Same as [unixTime.bat](./unixTime.bat ), but without the optimizations.
  - Uses functions for further customization

## Other majeekal (and demoralizing) repos written by batchCraftsmen (or sorcerers)
- [https://github.com/FrankWestlake/CMD-scripts](https://github.com/FrankWestlake/CMD-scripts) - a repo by Frank Westlake that turned [me](https://github.com/1ijack) into a jellyfish of despair
