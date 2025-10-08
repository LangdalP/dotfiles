if status is-interactive
    # Commands to run in interactive sessions can go here
end

set -Ux nvm_default_version v22.20.0

# Note: Might not be necessary due to /opt/homebrew/share/fish/vendor_conf.d/direnv.fish
# But it is nice to be explicit
direnv hook fish | source
zoxide init fish | source

# Do I need this?
fzf --fish | source

# Aliases
alias vim="nvim"
alias vi="nvim"
alias lg="lazygit"
alias lsx="gls --color -h --group-directories-first"
alias lsh="ls -alh"
alias rgh="rg --hidden --no-ignore-vcs --glob '!.git'"
