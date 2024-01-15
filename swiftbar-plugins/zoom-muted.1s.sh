#!/usr/bin/env bash

num_zoom_procs="$(ps aux | grep -v grep | grep -ci "zoom.us")"

if [ $num_zoom_procs -gt 0 ]; then
  if [[ "$(osascript $SWIFTBAR_PLUGINS_PATH/zoom-mute-status.scpt)" == "Muted" ]]; then
    echo "⚫️"
    echo "---"
    echo "Open Ygg zoom | href=\"$(cat $HOME/dotfiles-private/saga-zoom-url.txt)\""
  else
    echo "🟢"
    echo "---"
    echo "Open Ygg zoom | href=\"$(cat $HOME/dotfiles-private/saga-zoom-url.txt)\""
  fi
else
  echo "zz"
  echo "---"
  echo "Open Ygg zoom | href=\"$(cat $HOME/dotfiles-private/saga-zoom-url.txt)\""
fi
