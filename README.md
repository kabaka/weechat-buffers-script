# WeeChat Buffers Script (Ruby)

Similar to the well-known `buffers.pl` script, this adds a new bar which lists
your current buffers.

This was created out of necessity, as WeeChat instances with a very large
number of open buffers would use unreasonably huge amounts of CPU due to the
way `buffers.pl` works. `buffers.pl` could have been updated to be less
CPU-intensive, but this was a faster solution for me.

**Note: This script is still quite young and has not been subjected to much
testing by users other than the author. Use it at your own risk -- but if you
do, let me know what you think.**

## Usage

Several settings and commands are provided by the script for minimal
customization. There are not presently any plans to expand much beyond these.

### Installation

1. Install the buffers.rb file to your ruby scripts directory.
2. Type `/ruby load buffers.rb` to load the script.

### Configuration

Upon loading the script, you will have a vertical buffers list on the left side
of your WeeChat instance. You may move this to the right side if you wish. No
tuning has been done for top and bottom configurations, so your mileage with
those will vary.

Many things are configurable. The settings listed here are found under
`plugins.var.ruby.buffers`.

* `current_bg` - Background color for the currently selected buffer.
* `current_fg` - Foreground color for the currently selected buffer.
* `default_bg` - Background color for buffers which are not selected and are
  not in the hotlist.
* `default_fg` - Foreground color for buffers which are not selected and are
  not in the hotlist.
* `inactive_bg` - Background color for buffers which are not active (not
  current merged buffer) and not in the hotlist.
* `inactive_fg` - Foreground color for buffers which are not active (not
  current merged buffer) and not in the hotlist.
* `lag_bg` - Background color for server latency.
* `lag_fg` - Foreground color for server latency.
* `lag_minimum` - Minimum value for which to display server latency. 0 to
  always display.
* `hotlist_only` - Only show buffers which appear in the hotlist (visibility
  toggled with `/buffers toggle` or `/buffers toggle hotlist`).

Colors for buffers which have activity are taken from WeeChat's hotlist color
settings, so use those.

You will also notice a `hidden` and `collapsed` setting. These are used by the
`/buffers hide` and `/buffers collapse` commands to persistently store your
layout configuration. Manually setting these is possible, but not encouraged.

### Commands

The command to interact with the script is `/buffers`. The available parameters
include:

* `toggle` - toggle visibility of some buffers
  * `collapsed` - collapse or expand server buffers
  * `hidden` - toggle buffers that have been individually hidden
  * `hotlist` - toggle buffers based on `hotlist_only` setting`
  * `all` - toggle all hidden and collapsed buffers (default behavior)
* `hide` - hide the current buffer from the buffers list
  * `buffer` - buffer name to hide from the buffers list
* `unhide` - allow the current buffer to be shown on the buffers list
  * `buffer` - buffer name to unhide from the buffers list
* `collapse` - only show the server buffer for the current server
  * `server` - server name to collapse
* `expand` - enable display of all buffers for the current server
  * `server` - server name to expand

For all of the `buffer` parameters, the *full name* is required (for example,
`irc.freenode.#Terminus-Bot`) and must match exactly with an existing buffer.
For this reason, it is recommended that you use tab completion for this
parameter, or use the command from the buffer you want to change. **This
limitation may be adjusted in the future.**

The `server` names must exactly match the name you have configured. This
parameter can also be tab-completed.

## Getting Help

Open an issue on the issue tracker, or highlight Kabaka in #weechat on
Freenode.

