# Direnv: https://direnv.net/
(( ${+commands[direnv]} )) && emulate zsh -c "$(direnv export zsh)"

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

(( ${+commands[direnv]} )) && emulate zsh -c "$(direnv hook zsh)"

autoload -U add-zsh-hook

# Needs to be here for autojump to work with autojump
# To use GNU ls on OSX: brew install coreutils
alias ls='/usr/local/bin/gls --color -h --group-directories-first'
# Source aliases
source $HOME/dotfiles/zsh/alias-mac.sh

export EDITOR=nvim
# This turns on bash completion
autoload -U +X bashcompinit && bashcompinit

# This turns on zsh completion system - is it compatible with bash?
autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' special-dirs true

# Needed by alexdesousa/hab plugin
autoload -Uz compinit && compinit

# Lazyload command
source ~/dotfiles/zsh/zsh-lazyload/zsh-lazyload.zsh

# Fix locale sometimes not being set on Mac OSX
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"


# Work aliases
source $HOME/dotfiles/svv/svv.sh

# Move these to a separate utils file
alias new-html="cp $HOME/dotfiles/templates/index.html $PWD/ && cp $HOME/dotfiles/templates/style.css $PWD/"
alias run-http="npx http-server"

# Install/init zinit
source $HOME/dotfiles/zsh/zinit.sh

zinit snippet OMZ::plugins/autojump/autojump.plugin.zsh
zinit light zsh-users/zsh-autosuggestions

# Disable adding commands to history if they start with a space
setopt histignorespace
setopt HIST_IGNORE_SPACE


# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/Peder/Tools/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/Peder/Tools/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/Peder/Tools/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/Peder/Tools/google-cloud-sdk/completion.zsh.inc'; fi

# Added by terraform
# This turns on bash completion system
# autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/local/bin/terraform terraform

export PATH=$HOME/.dotnet/tools:$PATH
export PATH="/usr/local/sbin:$PATH"

export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"


export DOCKER_HOST="unix://$HOME/.colima/docker.sock"

# Jobbting
export GITHUB_OWNER=svvsaga
export GITHUB_TOKEN=$(cat $HOME/Secrets/gh-terraform-pat.txt)
#

# TODO: Bruk 1password
export CHAT_GPT_KEY=$(cat $HOME/Secrets/chatgpt_key.txt)
export OPENAI_API_KEY="${CHAT_GPT_KEY}"

# NVM config
export NVM_DIR=~/.nvm
source $(brew --prefix nvm)/nvm.sh

# To activate SDKMan and Conda
source ~/.bash_profile

BREW_PREFIX="/usr/local"
source "$BREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

export HOMEBREW_NO_GOOGLE_ANALYTICS=1

set -o emacs

source ~/dotfiles/zsh/powerlevel10k/powerlevel10k.zsh-theme
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

