#! /usr/bin/env bash

# Run with no args to start anybar and start polling zoom status
# Run with -q to kill anybar and zoom-status.sh

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

if [ "$1" == "-q" ]; then
	echo -e "${RED}Shutting down${NC} anybar and zoom-status.sh..."

	pkill AnyBar
	pkill -9 -f zoom-status.sh
elif [ "$#" -eq 0 ]; then
	echo -e "${GREEN}Starting${NC} anybar and zoom-status.sh..."

	open -a anybar
	nohup ./zoom-status.sh &
	sleep 1
fi
