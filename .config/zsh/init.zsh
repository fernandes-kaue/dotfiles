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

# History substring search keybindings
if (( $+functions[history-substring-search-up] )); then
  bindkey '^[[A' history-substring-search-up
  bindkey '^[[B' history-substring-search-down
  bindkey '^[OA' history-substring-search-up
  bindkey '^[OB' history-substring-search-down
  bindkey '^P' history-substring-search-up
  bindkey '^N' history-substring-search-down
fi

# FZF keybindings and fuzzy tab completion
if (( $+commands[fzf] )); then
  [[ -r /usr/share/fzf/key-bindings.zsh ]] && source /usr/share/fzf/key-bindings.zsh
  [[ -r /usr/share/fzf/completion.zsh ]] && source /usr/share/fzf/completion.zsh
fi

# Yazi file manager inline launcher (Ctrl+O)
if (( $+commands[yazi] )); then
  yazi_widget() {
    local tmp cwd
    tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
    yazi "$@" --cwd-file="$tmp"
    if cwd="$(/bin/cat -- "$tmp")" && [[ -n "$cwd" ]] && [[ "$cwd" != "$PWD" ]]; then
      builtin cd -- "$cwd"
    fi
    rm -f -- "$tmp"
    zle reset-prompt
  }
  zle -N yazi_widget
  bindkey '^O' yazi_widget
fi
