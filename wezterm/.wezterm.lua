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

---- SCROLLBACK STUFF END ----
---- CLICKABLE THINGS START ----

local function should_open_in_idea(filename)
  local extension = filename:match("^.+%.(%w+)$")
  if extension then
    local editable_extensions = { kt = true, kts = true }
    return editable_extensions[extension] or false
  end
  return false
end

-- Attempts to extract a file path, perhaps with suffix ':lineNo:columnNo', from a file:// URI
local function extract_filepath_ish(uri)
  -- `file://hostname/path/to/file`
  local start, match_end = uri:find("file:");
  if start == 1 then
    -- skip "file://", -> `hostname/path/to/file`
    local host_and_path = uri:sub(match_end + 3)
    local start, match_end = host_and_path:find("/")
    if start then
      -- -> `/path/to/file`
      --
      -- TODO: encode spaces as '%20'
      return host_and_path:sub(match_end)
    end
  end

  return nil
end

-- E.g. `file:///Users/peder/Projects/idea-plugins/wezterm/src/main/kotlin/com/github/pederg/wezterm/wezterm.kt:10:20`
-- should become three parts:
-- - filename
-- - line number
-- - column number
local function extract_filepath_and_colon_parts(uri)
  local filename, line_number, column_number = uri:match("([^:]+):(%d+):(%d+)")

  -- Check if all variables are non-nil
  if filename and line_number and column_number then
    return filename, tonumber(line_number), tonumber(column_number)
  end

  return filename, nil, nil
end

wezterm.on("open-uri", function(window, pane, uri)
  wezterm.log_info(string.format("open-uri event: %s", uri))
  local path_like = extract_filepath_ish(uri)
  local filepath, line_number, column_number = extract_filepath_and_colon_parts(path_like)

  if filepath and should_open_in_idea(filepath) then
    local ideaLink = string.format("idea://open?file=%s", filepath)

    if line_number and column_number then
      ideaLink = string.format("%s&line=%d&column=%d", ideaLink, line_number, column_number)
    end

    wezterm.log_info(string.format("Opening in IDEA: %s", ideaLink))
    os.execute(string.format("open '%s'", ideaLink))

    -- Prevent default behavior of opening the URI in the browser
    return false
  end
end)

---- CLICKABLE THINGS END ----

local create_tab_after_current = {

  key = 't',
  mods = 'CMD',
  action = wezterm.action_callback(function(window, pane)
    local mux_window = window:mux_window()

    -- determine the index of the current tab
    -- https://wezfurlong.org/wezterm/config/lua/mux-window/tabs_with_info.html
    local tabs = mux_window:tabs_with_info()
    local current_index = 0
    for _, tab_info in ipairs(tabs) do
      if tab_info.is_active then
        current_index = tab_info.index
        break
      end
    end

    -- spawn a new tab; it will be made active
    -- https://wezfurlong.org/wezterm/config/lua/mux-window/spawn_tab.html
    mux_window:spawn_tab {}

    -- Move the new active tab to the right of the previously active tab
    window:perform_action(act.MoveTab(current_index + 1), pane)
  end)
}

config.keys = {
  {
    key = 'H',
    mods = 'CTRL',
    action = act.EmitEvent 'trigger-vim-with-scrollback',
  },
  -- Rebind OPT-Left, OPT-Right as ALT-b, ALT-f respectively to match Terminal.app behavior
  {
    key = 'LeftArrow',
    mods = 'OPT',
    action = act.SendKey {
      key = 'b',
      mods = 'ALT',
    },
  },
  {
    key = 'RightArrow',
    mods = 'OPT',
    action = act.SendKey { key = 'f', mods = 'ALT' },
  },
  {
    key = 'H',
    mods = 'CTRL',
    action = act.ActivateTabRelative(-1)
  },
  {
    key = 'L',
    mods = 'CTRL',
    action = act.ActivateTabRelative(1)
  },
  create_tab_after_current
}


return config
