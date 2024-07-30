#!/usr/bin/env bash

ping -c1 domstolatsql107.at.domstol.no &> /dev/null

if [ $? -gt 0 ]; then
  echo ⬇️
  echo "---"
  echo "Start VPN | bash=vpn-up.sh terminal=true"
else
  echo 🆙
  echo "---"
  echo "Terminate VPN | bash=vpn-down.sh terminal=true"
fi

