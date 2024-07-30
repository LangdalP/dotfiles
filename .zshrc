# Must be before direnv since it is used in a .envrc file
export PATH=$HOME/Projects/Misc/kvcache/target/release/:$PATH

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

if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
fi

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
bindkey '^j' autosuggest-accept # Ctrl-J to accept autosuggestion

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

# This should not be necessary, but I have not been able to make 1Password SSH work without it
export SSH_AUTH_SOCK="/Users/peder/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"

# Go
export PATH=$HOME/go/bin:$PATH

# bat theme
export BAT_THEME="Monokai Extended Bright"

# GNU Binutils are nice
export PATH="/opt/homebrew/opt/binutils/bin:$PATH"

# TODO: Move into own domstoladm setup file
export PATH="$HOME/dotfiles-private/domstoladm:$PATH"

# TODO: Move out to separate file
export KAGI_API_KEY=$(kvcache try kagi-api-key 'OP_ACCOUNT="my.1password.com" op read "op://Personal/Kagi/apikey"')


# End of powerlevel10k config
source ~/dotfiles/zsh/powerlevel10k/powerlevel10k.zsh-theme
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# For aliases ghce and ghcs
eval "$(gh copilot alias -- zsh)"
