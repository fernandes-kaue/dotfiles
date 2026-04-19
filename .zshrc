# Enable Powerlevel10k instant prompt.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

typeset -a zsh_modules=(
  "$HOME/.config/zsh/env.zsh"
  "$HOME/.config/zsh/options.zsh"
  "$HOME/.config/zsh/aliases.zsh"
  "$HOME/.config/zsh/functions.zsh"
  "$HOME/.config/zsh/init.zsh"
)

for zsh_module in "${zsh_modules[@]}"; do
  [[ -r "$zsh_module" ]] && source "$zsh_module"
done

unset zsh_module
unset zsh_modules
