export ZSH="$HOME/.oh-my-zsh"
export EDITOR="nvim"
export VISUAL="nvim"
ZSH_THEME="powerlevel10k/powerlevel10k"

typeset -U path PATH

if [[ -n "${NODE_HOME:-}" ]]; then
  path=("$NODE_HOME/bin" $path)
fi

path=("$HOME/development/flutter/bin" "$HOME/.npm-global/bin" "$HOME/.local/bin" $path)
export CHROME_EXECUTABLE="/usr/bin/google-chrome-stable"
export CODEX_MEMORY_VAULT="/home/kaue/Projetos/memoriasCodex"
export GEMINI_MEMORY_VAULT="/home/kaue/Projetos/memoriasGemini"
export ANTIGRAVITY_WORKSPACE="/home/kaue/MACHINE RELATED ANTIGRAVITY"
export PATH="$PATH:$HOME/flutter/bin"

if (( $+commands[bat] )); then
  export MANPAGER="sh -c 'col -bx | bat -l man -p'"
  export MANROFFOPT="-c"
fi

if (( $+commands[fzf] )); then
  if (( $+commands[fd] )); then
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND='fd --type d --hidden --exclude .git'
  fi
  export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border --inline-info'
  if (( $+commands[bat] )); then
    export FZF_CTRL_T_OPTS="--preview 'bat --style=numbers --color=always --line-range :500 {} 2>/dev/null || cat {} 2>/dev/null'"
  fi
fi
