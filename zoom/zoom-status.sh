#!/bin/bash
while true; do
  if [[ "$(osascript zoom-mute-status.scpt)" == "Muted" ]]
  then
    echo -n "black" | nc -4u -w0 localhost 1738
  else
    echo -n "red" | nc -4u -w0 localhost 1738
  fi
sleep 1
done
