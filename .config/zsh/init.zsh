plugins=(
  zsh-autosuggestions
  history-substring-search
  you-should-use
  web-search
  docker
  colored-man-pages
  command-not-found
  git
  sudo
)

if (( $+commands[direnv] )); then
  plugins+=(direnv)
fi

plugins+=(zsh-syntax-highlighting)

source "$ZSH/oh-my-zsh.sh"

autoload -U add-zsh-hook

if (( $+commands[eza] )); then
  eza_after_cd() {
    eza -a --icons --group-directories-first --color=always
  }

  add-zsh-hook chpwd eza_after_cd
fi

[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

if (( $+commands[zoxide] )); then
  eval "$(zoxide init zsh)"
fi
