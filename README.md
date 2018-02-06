# BatchMajeek
Mysterious Windows Batch/Cmd scripts -- My personal, public exposition.

## Please world, see my junk... No I don't care what you think.
Most scripts are agnostic to delayedExpansion, should be able to use "!"
- [md5.cmd](./md5.cmd ) -- hashes files and directories with optional recursion, unicode and logging options
- [ah.fu.cmd](./ah.fu.cmd ) -- Grossly overengineered process killer which reads a conf file to change behavior
  - [eph.u.conf](./eph.u.conf ) -- dubbed "process-hitlist" is an example of a conf for [ah.fu.cmd](./ah.fu.cmd )
- [h2p.cmd](./h2p.cmd ) -- grabs pdfs of url address using "[wkhtmltopdf.exe](https://wkhtmltopdf.org/downloads.html)".  
  - Names pdf file with urlstring+currentdate
  - Code still needs to be scrubbed as some bunctions are not needed.
  - This script was my arg parser stress-test and where I ironed out a bunch of issues with the arg parser.  Hence, why I'm sharing.
    - Please note, "%" and "?" are problematic in DosBatchlaundio
	- Update - 02/01/2018 - the entire args parser has been replaced to a shift method (which is now being vetted for issues).
- [raw2res.bat](./raw2res.bat ) -- Uses ffmpeg.exe to duplicate same images with different base heights
- [hhmmss.cmd](./hhmmss.cmd ) -- Converts time: from total-seconds into hh:mm:ss notation - "Complete Edition"
- [hhmmss.min.cmd](./hhmmss.min.cmd ) -- Converts time: from total-seconds into hh:mm:ss notation - without all the "tard" code
- [elevate](./elevate/) -- self-elevate scripts, functions and examples using "bunction" labels
  - [elevate/elevate.cmd](./elevate/elevate.cmd ) -- self-elevate using "bunction" labels
  - [elevate/elvn.cmd](./elevate/elvn.cmd ) -- self-elevate using "bunction" oneliner; detection via "net session"
  - [elevate/elvc.cmd](./elevate/elvc.cmd ) -- self-elevate using "bunction" oneliner; detection via "calcs"
- [mvlinks.bat](./mvlinks.bat ) -- Recursively moves directory tree
  - Moves all: files, directories and all of their hardlinks
  - Unhide/Rehide objects during move.
  - Requires sysinternals "[findlinks.exe](https://docs.microsoft.com/en-us/sysinternals/downloads/findlinks )" to expose all hardlinks.
  - DOES NOT remove the old tree on purpose
  