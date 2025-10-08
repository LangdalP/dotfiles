if status is-interactive
    # Commands to run in interactive sessions can go here
end

# Note: Might not be necessary due to /opt/homebrew/share/fish/vendor_conf.d/direnv.fish
# But it is nice to be explicit
direnv hook fish | source

zoxide init fish | source

set -Ux nvm_default_version v22.20.0
