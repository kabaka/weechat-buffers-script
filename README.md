# WeeChat Buffers Script (Ruby)

Similar to the well-known `buffers.pl` script, this adds a new bar which lists
your current buffers.

This was created out of necessity, as WeeChat instances with a very large
number of open buffers would use unreasonably huge amounts of CPU due to the
way `buffers.pl` works. `buffers.pl` could have been updated to be less
CPU-intensive, but this was a faster solution for me.

Presently, all configuration is done either through the hotlist color settings
or through editing the script directly. There is very little that can be
changed. It is only designed to display vertically.

*This is very young, very untested, and very limited. You are probably better
off using `buffers.pl`.*

