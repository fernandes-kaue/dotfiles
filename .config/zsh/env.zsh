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
export PATH="$PATH:$HOME/flutter/bin"
