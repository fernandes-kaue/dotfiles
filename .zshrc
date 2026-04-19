# Enable Powerlevel10k instant prompt.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# OMZ Setup
export ZSH="$HOME/.oh-my-zsh"
export EDITOR="nvim"
export VISUAL="nvim"
ZSH_THEME="powerlevel10k/powerlevel10k"

# NPM Global config
export PATH=$NODE_HOME/bin:$PATH
export PATH=~/.npm-global/bin:$PATH

# History & Behavior
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt autocd extendedglob
unsetopt beep
bindkey -e

# Plugins (Removed 'z' to avoid conflict with zoxide)
plugins=(
  zsh-autosuggestions
  zsh-syntax-highlighting
  history-substring-search
  you-should-use
  web-search
  docker
  colored-man-pages
  command-not-found
  git
  dotenv
  sudo
)

source "$ZSH/oh-my-zsh.sh"

# --- Custom Functions & Hooks ---

# Auto-eza after every directory change (The "Zsh Way")
autoload -U add-zsh-hook
eza_after_cd() {
  # -a: all files, --icons: glyphs, --group-directories-first: organized
  eza -a --icons --group-directories-first --color=always
}
add-zsh-hook chpwd eza_after_cd

# Dotfiles alias for your bare repo
alias dot='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# Core modern replacements
alias ls='eza -a --icons --group-directories-first --color=always'
alias ll='eza -al --icons --group-directories-first --color=always'
alias tree='eza --tree -a --icons --color=always'
alias cat='bat --style=plain --paging=never'
alias grep='rg'
alias find='fd'

# Directory navigation (zoxide supplements)
alias cd='z'
alias cdi='zi'
alias dot-update='dot add -A && dot commit -m "feat: update dotfiles" && dot push'
alias eou='eos-update'

# Gemini CLI
alias ask="gemini"
alias explain="gemini --system 'Explain the following code concisely:'"

# Quick Edit Shortcuts
hyprc() { nvim ~/.config/hypr/hyprland.conf }
zshc() { nvim ~/.zshrc }
zshe() { exec zsh }

# Brightness control function
b() {
    if [[ -z "$1" ]]; then
        local current=$(brightnessctl get)
        local max=$(brightnessctl max)
        local percent=$(( 100 * current / max ))
        echo "Current brightness: $percent% ($current/$max)"
    else
        # Accept values like "50" or "+10" or "-10"
        brightnessctl set "$1%"
    fi
}

function y() {

    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"

    yazi "$@" --cwd-file="$tmp"

    if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then

        builtin cd -- "$cwd"

    fi

    rm -f -- "$tmp"

} 

# Process Search
psg() { ps aux | grep -i "$1" | grep -v grep }

# --- Initialization ---

[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# Initialize Zoxide (Replaces cd and provides zi)
# Must be at the very bottom
eval "$(zoxide init zsh)"

# Created by `pipx` on 2026-04-15 01:10:14
export PATH="$PATH:/home/kaue/.local/bin"

# >>> codex-memory-vault >>>
export CODEX_MEMORY_VAULT="/home/kaue/Projetos/memoriasCodex"
# <<< codex-memory-vault <<<
