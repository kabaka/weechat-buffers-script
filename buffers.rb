# Copyright (C) 2013 Kyle Johnson <kyle@vacantminded.com>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.)

def weechat_init
  Weechat.register 'buffers', 'Kabaka', '0.1', 'MIT',
    'High-Performance Buffers List', '', ''

  Weechat.bar_item_new 'ruby-buffers', 'generate', ''

  Weechat.bar_new 'ruby-buffers', '0', '0',
    'root', '', 'left', 'columns_vertical', 'vertical',
    '0', '0', 'default', 'default', 'default', '1', 'ruby-buffers'

  Weechat.bar_item_update 'ruby-buffers'

  Weechat.hook_timer 1000, 0, 0, 'generate_callback', ''

  hooks = %w[
    buffer_switch
    buffer_merged
    buffer_unmerged
    buffer_moved
    buffer_renamed
  ]

  hooks.each do |hook|
    Weechat.hook_signal hook, 'generate_callback', ''
  end

  Weechat::WEECHAT_RC_OK
end

# generic hook callback to update buffers bar
def generate_callback *args
  Weechat.bar_item_update 'ruby-buffers'

  Weechat::WEECHAT_RC_OK
end

def generate data, item, window
  output, last_number = [], 0

  hotlist = Weechat.infolist_get 'hotlist', '', ''
  hotlist_data = {}

  until Weechat.infolist_next(hotlist).zero? do
    buffer_name = Weechat.infolist_string hotlist, 'buffer_name'
    color       = Weechat.infolist_string hotlist, 'color'

    hotlist_data[buffer_name] = color
  end

  Weechat.infolist_free hotlist

  buffers = Weechat.infolist_get 'buffer', '', ''

  channel_chars = %w[# & + ! *]

  until Weechat.infolist_next(buffers).zero? do
    line = []

    current      = Weechat.infolist_integer buffers, 'current_buffer'
    number       = Weechat.infolist_integer buffers, 'number'
    name         = Weechat.infolist_string  buffers, 'short_name'
    buffer_name  = Weechat.infolist_string  buffers, 'name'
    plugin       = Weechat.infolist_string  buffers, 'plugin_name'

    color = hotlist_data[buffer_name] || '250'

    unless current.zero?
      color = "default,cyan"
    end

    line << Weechat.color(color) if color

    unless number == last_number
      line << number.to_s.rjust(3)
    else
      line << '   '
    end

    last_number = number

    if channel_chars.include? name.chr
      name = "  #{name}"
    elsif plugin == 'irc' and buffer_name.start_with? 'server.'

      name = "#{name} #{get_lag_s name}"
    end
    
    line << " #{name}"

    line << Weechat.color('default')

    output << line.join
  end

  Weechat.infolist_free buffers

  output.join "\n"
end


# helpers

def get_lag_s server
  server_infolist = Weechat.infolist_get 'irc_server', '', name

  Weechat.infolist_next server_infolist

  lag = Weechat.infolist_integer server_infolist, 'lag'

  Weechat.infolist_free server_infolist

  lag = lag.to_f / 1000

  "#{Weechat.color 'default'}(#{Weechat.color '250'}#{lag}#{Weechat.color 'default'})"
end
