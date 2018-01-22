# BatchMajeek
Mysterious Windows Batch/Cmd scripts -- My personal, public exposition.

## Please world, see my junk... No I don't care what you think.
Most scripts are agnostic to delayedExpansion, should be able to use "!"
- [md5.cmd](../master/md5.cmd ) -- hashes files and directories with optional recursion, unicode and logging options
- [ah.fu.cmd](../master/ah.fu.cmd ) -- Grossly overengineered process killer which reads a conf file to change behavior
  - [eph.u.conf](../master/eph.u.conf ) -- dubbed "process-hitlist" is an example of a conf for [ah.fu.cmd](../master/ah.fu.cmd )
- [h2p.cmd](../master/h2p.cmd ) -- grabs pdfs of url address using "wkhtmltopdf.exe".  
  - Names pdf file with urlstring+currentdate
  - Code still needs to be scrubbed as some bunctions are not needed.
  - This script was my arg parser stress-test and where I ironed out a bunch of issues with the arg parser.  Hence, why I'm sharing.
    - Please note, "%" and "?" are problematic in DosBatchlaundio
- [hhmmss.cmd](../master/hhmmss.cmd ) -- Converts time: from total-seconds into hh:mm:ss notation - "Complete Edition"
- [hhmmss.min.cmd](../master/hhmmss.min.cmd ) -- Converts time: from total-seconds into hh:mm:ss notation - without all the "tard" code
- [elevate/elevate.cmd](../master/elevate/elevate.cmd ) -- self-elevate using "bunction" labels
- [elevate/elvn.cmd](../master/elevate/elvn.cmd ) -- self-elevate using "bunction" oneliner; detection via "net session"
- [elevate/elvc.cmd](../master/elevate/elvc.cmd ) -- self-elevate using "bunction" oneliner; detection via "calcs"

