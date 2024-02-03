# Direnv: https://direnv.net/
# Initialized in a cryptic way to avoid output during powerlevek10k init
# https://github.com/romkatv/powerlevel10k#how-do-i-initialize-direnv-when-using-instant-prompt
(( ${+commands[direnv]} )) && emulate zsh -c "$(direnv export zsh)"

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

(( ${+commands[direnv]} )) && emulate zsh -c "$(direnv hook zsh)"

# Needs to be here for autojump to work with autojump
# To use GNU ls on OSX: brew install coreutils
alias ls='gls --color -h --group-directories-first'

# Source aliases
source $HOME/dotfiles/zsh/alias.sh

# Use nvim for commands that use this, like git commit
export EDITOR=nvim

# This turns on bash completion
autoload -U +X bashcompinit && bashcompinit

# This turns on zsh completion system - is it compatible with bash?
autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' special-dirs true

# Lazyload command
# source ~/dotfiles/zsh/zsh-lazyload/zsh-lazyload.zsh

# Fix locale sometimes not being set on Mac OSX
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# [[ -s $(brew --prefix)/etc/profile.d/autojump.sh ]] && . $(brew --prefix)/etc/profile.d/autojump.sh
[[ -s $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]] && source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Disable adding commands to history if they start with a space
setopt histignorespace
setopt HIST_IGNORE_SPACE

# Needed for terraform completions
# TODO: Move out
complete -o nospace -C /usr/local/bin/terraform terraform

# Pyenv
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# Needed for some programs to work with docker via colima (VSCode)
export DOCKER_HOST="unix://$HOME/.colima/docker.sock"

# NVM config
export NVM_DIR="$HOME/.nvm"
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

# Put homebrew bins on path
export PATH=/opt/homebrew/bin:$PATH

# Gives nice colors for parts of zsh commands
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Enable Emacs-style keybinds, such as Ctrl-A for start of line, Ctrl-E for end of line etc.
set -o emacs

source $(brew --prefix)/opt/fzf/shell/completion.zsh
source $(brew --prefix)/opt/fzf/shell/key-bindings.zsh

eval "$(zoxide init zsh)"


# Gcloud autocompletion
# TODO: Move out to separate file
source "$(brew --prefix)/share/google-cloud-sdk/path.zsh.inc"
source "$(brew --prefix)/share/google-cloud-sdk/completion.zsh.inc"

# Rust
source "$HOME/.cargo/env"

# End of powerlevel10k config
source ~/dotfiles/zsh/powerlevel10k/powerlevel10k.zsh-theme
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
