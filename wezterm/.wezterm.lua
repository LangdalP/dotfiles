-- Pull in the wezterm API
local wezterm = require 'wezterm'
local io = require 'io'
local os = require 'os'
local act = wezterm.action

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

config.font_size = 13.0
config.color_scheme = 'Galaxy'

config.use_fancy_tab_bar = true

-- TODO: Vurdere å bruke retro tab bar, men treng i så fall styling
config.window_frame = {
  font_size = 13.0,
  -- active_titlebar_bg = '#1d2837',
  active_titlebar_bg = '#ccc',
}

-- Needed for sane support for option key (like writing the pipe symbol or curly braces)
config.send_composed_key_when_left_alt_is_pressed = true

config.scrollback_lines = 20000

---- SCROLLBACK STUFF BEGIN ----

wezterm.on('trigger-vim-with-scrollback', function(window, pane)
  -- Retrieve the text from the pane
  -- local text = pane:get_lines_as_text(pane:get_dimensions().scrollback_rows)
  local text = pane:get_lines_as_escapes(pane:get_dimensions().scrollback_rows)

  -- Create a temporary file to pass to vim
  local name = os.tmpname()
  local f = io.open(name, 'w+')
  f:write(text)
  f:flush()
  f:close()

  -- Can be marginally improved by having a profile with a prettier color config
  local nvim_args = {
    '/opt/homebrew/bin/nvim',
    '-u', 'NONE',                                                                     -- Disable user profiles (and plugins)
    '-c', 'map q :qa!<CR>',                                                           -- Map q to quit without saving
    '-c', 'autocmd TermOpen * normal G',                                              -- Go to the end of the file
    '-c', 'set clipboard+=unnamedplus',                                               -- Use the system clipboard
    '-c', 'silent write! /tmp/wezterm_scrollback | te cat /tmp/wezterm_scrollback -', -- Use terminal trick (te) to enable support for ANSI escape codes (= colors)
    name
  }
  -- Open a new window running vim and tell it to open the file
  window:perform_action(
    act.SpawnCommandInNewTab {
      args = nvim_args,
    },
    pane
  )

  -- Wait "enough" time for vim to read the file before we remove it.
  -- The window creation and process spawn are asynchronous wrt. running
  -- this script and are not awaitable, so we just pick a number.
  --
  -- Note: We don't strictly need to remove this file, but it is nice
  -- to avoid cluttering up the temporary directory.
  wezterm.sleep_ms(1000)
  os.remove(name)
end)

config.keys = {
  {
    key = 'H',
    mods = 'CTRL',
    action = act.EmitEvent 'trigger-vim-with-scrollback',
  },
}

---- SCROLLBACK STUFF END ----

-- and finally, return the configuration to wezterm
return config
