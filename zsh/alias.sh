# All the aliases that should work most places, included GH codespaces
#
alias vim="nvim"
alias vi="nvim"

alias vid="neovide"

alias lsh="ls -alh"
alias rgh="rg --hidden --no-ignore-vcs --glob '!.git'"

function b64url_encode() {
  # Base64url is just base64  with + and / replaced by - and _ and no padding
  echo "$1" | base64 | tr '+/' '-_' | tr -d '='
}

function b64url_decode() {
    local input="$1"
    # Convert URL-safe characters back
    input=$(echo "$input" | tr -- '-_' '+/')
    # Add padding
    case $((${#input} % 4)) in
        2) input="${input}==" ;;
        3) input="${input}=" ;;
    esac
    echo "$input" | base64 -d
}

function rgv() {
  fzf --bind "start:reload:rg --column --line-number --no-heading --color=always --smart-case ''" \
    --bind "change:reload:rg --column --line-number --no-heading --color=always --smart-case {q} || true" \
    --bind 'enter:become(nvim "+normal $(echo {1} | cut -d : -f2)G$(echo {1} | cut -d : -f3)|" $(echo {1} | cut -d : -f1))' \
    --ansi --disabled \
    --layout=reverse
}

function rgvh() {
  fzf --bind "start:reload:rg --no-ignore --hidden --column --line-number --no-heading --color=always --smart-case ''" \
    --bind "change:reload:rg --no-ignore --hidden --column --line-number --no-heading --color=always --smart-case {q} || true" \
    --bind 'enter:become(nvim "+normal $(echo {1} | cut -d : -f2)G$(echo {1} | cut -d : -f3)|" $(echo {1} | cut -d : -f1))' \
    --ansi --disabled \
    --layout=reverse
}

function cd() {
	builtin cd "$@"
	ls
}

function cd_git_root() {
	cd $(git rev-parse --show-toplevel)
}

function ffile() {
	find . -type f -iname "*$1*"
}

function fdir() {
	find . -type d -iname "*$1*"
}

alias ga="git add"
alias gs="git status"
alias gc="git checkout"
alias gcom="git commit"
alias gcoma="git commit --amend"
alias gcomane="git commit --amend --no-edit"
alias gpll="git pull"
alias gpllr="git pull --rebase"
alias gpsh="git push"
alias gpshor="git push -u origin HEAD"
alias gpshf="git push --force-with-lease"
alias gl="git log"
alias gd="git diff"
alias gds="git diff --staged"
alias gsub="git submodule update --init --recursive"
alias gbl="git branch --list"
alias groot="cd_git_root" # cd to git root
alias gclean='git for-each-ref --format "%(refname:short)" refs/heads | grep -v "master\|main" | xargs git branch -d'
alias gcleanf='git for-each-ref --format "%(refname:short)" refs/heads | grep -v "master\|main" | xargs git branch -D'
alias lg='lazygit'
alias ldo='lazydocker'

function git-contributors() {
  git shortlog --summary --numbered --email | awk '{$1=""}1'
}

function git-exclude() {

  # Find git root folder
  git_root=$(git rev-parse --show-toplevel)

  # Create exclude file if not exists
  if [ ! -f $git_root/.git/info/exclude ]; then
      touch $git_root/.git/info/exclude
  fi

  # Check if file exists
  if [ -f $1 ]; then
    # Check if file is already excluded
    if ! grep -q $1 $git_root/.git/info/exclude; then
      # Add file to exclude file
      echo $1 >> $git_root/.git/info/exclude
      echo "File $1 has been excluded"
    else
      echo "File $1 is already excluded"
    fi
  else
    echo "File $1 does not exist"
  fi
}


alias cfg-src="source ~/.zshrc"
alias cfg-edit="nvim ~/.zshrc"

# Merge pdfs
alias mergepdfs="gs -q -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -sOutputFile=merged.pdf"
