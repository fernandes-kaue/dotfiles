export ZSH="$HOME/.oh-my-zsh"
export EDITOR="nvim"
export VISUAL="nvim"
ZSH_THEME="powerlevel10k/powerlevel10k"

if [[ -n "${NODE_HOME:-}" ]]; then
  export PATH="$NODE_HOME/bin:$PATH"
fi

export PATH="$HOME/.npm-global/bin:$PATH"
export PATH="$PATH:$HOME/.local/bin"
export CODEX_MEMORY_VAULT="/home/kaue/Projetos/memoriasCodex"
