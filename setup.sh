#!/usr/bin/env bash

# Used for GitHub codespaces and similar general-purpose environments

# Check if .zshrc contains "alias.sh"
if grep -q "alias.sh" ~/.zshrc; then
	echo "alias.sh already sourced in .zshrc"
else
	echo "Sourcing alias.sh in .zshrc"
	mkdir -p ~/dotfiles/
	cp zsh/alias.sh ~/dotfiles/aliash.sh
	echo "source ~/dotfiles/alias.sh" >>~/.zshrc
fi
