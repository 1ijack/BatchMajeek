# BatchMajeek
Mysterious Windows Batch/Cmd scripts -- My personal, public exposition.

## Please world, see my junk... No I don't care what you think. (unless you find issues)
Most scripts are agnostic to delayedExpansion, should be able to use "!"
- [ah.fu.cmd](./ah.fu.cmd ) -- Grossly overengineered process killer which reads a conf file to change behavior
  - [eph.u.conf](./eph.u.conf ) -- dubbed "process-hitlist" is an example of a conf for [ah.fu.cmd](./ah.fu.cmd )
- [elevate](./elevate/) -- self-elevate scripts, functions and examples using "bunction" labels
  - [elevate/elevate.cmd](./elevate/elevate.cmd ) -- elevates all passed arguments or starts a elevated cmd console
  - [elevate/elvn.cmd](./elevate/elvn.cmd ) -- self-elevate using "bunction" oneliner; detection via "net session"
  - [elevate/elvc.cmd](./elevate/elvc.cmd ) -- self-elevate using "bunction" oneliner; detection via "calcs"
- [gstr.cmd](./gstr.cmd ) -- batch native random string genarator.
  - to generate 10 strings: for /l %Z in (1,1,10) do [gstr.cmd](./gstr.cmd )
  - to generate 3 strings, 12, 15, 50 characters: [gstr.cmd](./gstr.cmd ) 12 15 50 
- [h2p.cmd](./h2p.cmd ) -- grabs pdfs of url address using "[wkhtmltopdf.exe](https://wkhtmltopdf.org/downloads.html)".  
  - Names pdf file with urlstring+currentdate
  - Code still needs to be scrubbed as some bunctions are not needed.
  - This script was my arg parser stress-test and where I ironed out a bunch of issues with the arg parser.  Hence, why I'm sharing.
    - Please note, "%" and "?" are problematic at the moment, hopefully, I'll have a fix soon
	- Update - 02/01/2018 - the entire args parser has been replaced to a shift method (which is now being vetted for issues).
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
- [RemoveEmpties.bat](./RemoveEmpties.bat ) -- Removes Empty Files/SubDirectories from the defaulted/given path(s)
  - My use-case: remove leftover files/dirs from the temp directories
  - determines whether file is empty (by file size)
  - determines whether directory is empty.  This detection is somewhat slow at the moment, I may improve the detection at a later date.
- [unixTime.bat](./unixTime.bat ) -- returns the current system time as unix time (01/01/1970 )
  - Adjusts to system timezone and DST (or any other time adjustments registered with windows)
  - Returns unixTime in Seconds OR milliseconds, option defined in 'user settings' inside the script
  - Auto calculates leap-year(s)

## Other majeekal (and demoralizing) repos written by batchCraftsmen (or sorcerers)
- [https://github.com/FrankWestlake/CMD-scripts](https://github.com/FrankWestlake/CMD-scripts) - a repo by Frank Westlake that turned [me](https://github.com/1ijack) into a jellyfish of despair
