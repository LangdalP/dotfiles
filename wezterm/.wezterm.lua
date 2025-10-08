-- Pull in the wezterm API
local wezterm = require 'wezterm'
local io = require 'io'
local os = require 'os'
local act = wezterm.action

-- This will hold the configuration.
local config = wezterm.config_builder()

-- It seems that the end_y is off by one, or it is exlusive, which means it does not work with get_text_from_semantic_zone
local function fix_semantic_zone_output(zone)
  local fixed_zone = {
    start_x = 0,
    start_y = zone.start_y,
    end_x = 0,
    end_y = zone.end_y + 1,
    semantic_type = zone.semantic_type
  }
  return fixed_zone
end

-- It seems when using multiline commands, there are multiple prompt zones for a single command
-- We need to first look at second last prompt zone, then the one before that, etc, until one zones end_y does not touch the next zones start_y
local function merge_prompt_zones(prompt_zones)
  if #prompt_zones < 2 then
    -- return only zone
    return prompt_zones[#prompt_zones]
  end

  local start_idx = #prompt_zones - 1
  local end_of_prompt_zone = prompt_zones[start_idx]
  local current_prompt_zone = {
    start_x = 0,
    start_y = end_of_prompt_zone.start_y,
    end_x = 0,
    end_y = end_of_prompt_zone.end_y + 1,
    semantic_type = end_of_prompt_zone.semantic_type
  }

  for i = start_idx, 0, -1 do
    local next_zone = prompt_zones[i - 1]

    if current_prompt_zone.start_y == next_zone.end_y + 1 then
      -- There is no gap, so we merge
      current_prompt_zone.start_y = next_zone.start_y
    else
      -- Gap exists, so we stop merging
      break
    end
  end

  return current_prompt_zone
end

-- Strategy: Find second last prompt, find last output zone, and get text between them
local function get_last_user_input2(window, pane)
  local prompt_zones = pane:get_semantic_zones("Prompt")

  if #prompt_zones > 1 then
    -- Merge prompt zones
    local merged = merge_prompt_zones(prompt_zones)

    local text = pane:get_text_from_semantic_zone(merged)
    print(text)
    return text
  else
    return ""
  end
end

local function get_last_user_output(window, pane)
  local output_zones = pane:get_semantic_zones("Output")

  -- Get last element if list is non-empty
  if #output_zones > 0 then
    local last_zone = output_zones[#output_zones]
    local zone_fixed = fix_semantic_zone_output(last_zone)

    local text = pane:get_text_from_semantic_zone(zone_fixed)
    return text
  else
    return ""
  end
end

local function get_last_input_and_output(window, pane)
  local input_text = get_last_user_input2(window, pane)
  local output_text = get_last_user_output(window, pane)

  print("Last input:")
  print(input_text)
  print("Last output:")
  print(output_text)

  -- local command = 'claude -p "This command did not work. Why?\n\n' .. input_text .. '\n' .. output_text .. '"'
  -- local command = '/Users/peder/.local/share/nvm/v22.20.0/bin/claude -p "What is 2 + 2?"'
  -- local command = "whoami"
  -- local command = "fish -l -c \"npm --version\""
  -- local command = 'fish -c "source ~/.config/fish/config.fish && npm --version"'
  -- local command = "/Users/peder/.local/share/nvm/v22.20.0/bin/npm --version"

  -- print("Executing command: " .. command)

  -- local return_code, a, b = os.execute(command .. " > ~/peder-log.txt")
  -- print("Return code from command: " .. tostring(return_code))
  -- print(a)
  -- print(b)

  local handle = io.popen("/Users/peder/.local/share/nvm/v22.20.0/bin/npm --version 2>&1")
  local result = handle:read("*a")
  local success = handle:close()
  print("Output:", result)
  print("Success:", success)
end

wezterm.on('debug', function(window, pane)
  print("SEPARATOR xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx")
  get_last_input_and_output(window, pane)
end)

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

  start, match_end = uri:find("diff:")
  if start == 1 then
    -- `diff:/path/to/file.kt`
    local path = uri:sub(match_end + 1)
    -- Add /Users/peder/Projects/Domstoladm/lovisa_core/ to start of path
    path = "/Users/peder/Projects/Domstoladm/lovisa_core/" .. path
    return path
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

  -- Check if uri contains http or https. If so, return true.
  if uri:match("^https?://") then
    return true
  end

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

config.hyperlink_rules = {

  -- URL with a protocol
  {
    regex = "\\bhttps?://(localhost|[\\w\\-\\.]+)(:\\d+)?(/[^\\s]*)?\\b",
    format = "$0",
  },

  -- file:// URIs
  {
    regex = "\\bfile://\\S*\\b",
    format = "$0"
  },

  -- absolute file paths without protocol, starting with /Users/ and ending with line and column numbers
  {
    regex = "/Users/[\\S ]+\\.kt:\\d+:\\d+",
    format = "file://$0"
  },
}

---- CLICKABLE THINGS END ----
---- TAB CREATION START ----

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

---- TAB CREATION END ----
---- RESIZE MODE START ----
local resizeMode = false

wezterm.on('toggle-resize-mode', function(window, pane)
  print('Toggling resize mode')
  resizeMode = not resizeMode
  print('Resize mode is now ' .. tostring(resizeMode))
end)
-- Retrieve the text from the pane
---- RESIZE MODE END ----


config.leader = { key = 'l', mods = 'CMD', timeout_milliseconds = 3000 }
config.keys = {
  {
    key = '/',
    mods = 'LEADER',
    action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
  },
  {
    key = 'o',
    mods = 'LEADER',
    action = wezterm.action.ShowDebugOverlay,
  },
  {
    key = 'd',
    mods = 'LEADER',
    action = act.EmitEvent 'debug',
  },
  {
    key = '-',
    mods = 'LEADER',
    action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' },
  },
  {
    key = 'h',
    mods = 'LEADER',
    action = act.EmitEvent 'trigger-vim-with-scrollback',
  },
  {
    key = 'RightArrow',
    mods = 'LEADER',
    action = act.AdjustPaneSize { 'Right', 20 },
  },
  {
    key = 'LeftArrow',
    mods = 'LEADER',
    action = act.AdjustPaneSize { 'Left', 20 },
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
    key = 'j',
    mods = 'CTRL|CMD',
    action = act.ActivateTabRelative(-1)
  },
  {
    key = 'k',
    mods = 'CTRL|CMD',
    action = act.ActivateTabRelative(1)
  },
  create_tab_after_current
}


return config
