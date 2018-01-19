# BatchMajeek
Mysterious Windows Batch/Cmd scripts -- My personal, public exposition.

## Please world, see my junk... No I don't care what you think.
The scripts are agnostic to delayedExpansion, so "!" are not really an issue
- [md5.cmd](../master/md5.cmd ) -- hashes files and directories with optional recursion, unicode and logging options
- [ah.fu.cmd](../master/ah.fu.cmd ) -- Grossly overengineered process killer which reads a conf file to change behavior
  - [eph.u.conf](../master/eph.u.conf ) -- dubbed "process-hitlist" is an example of a conf for [ah.fu.cmd](../master/ah.fu.cmd )
- [h2p.cmd](../master/h2p.cmd ) -- grabs pdfs of url address using "wkhtmltopdf.exe".  
  - Names pdf file with urlstring+currentdate
  - Code still needs to be scrubbed as some bunctions are not needed.
  - This script was my arg parser stress-test and where I ironed out a bunch of issues with the arg parser.  Hence, why I'm sharing.
    - Please note, "%" and "?" are problematic in DosBatchlaundio

