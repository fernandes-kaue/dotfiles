alias dot='/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

alias ls='eza -a --icons --group-directories-first --color=always'
alias ll='eza -al --icons --group-directories-first --color=always'
alias tree='eza --tree -a --icons --color=always'
alias cat='bat --style=plain --paging=never'
unalias grep 2>/dev/null
unalias find 2>/dev/null
alias yaak-app="WEBKIT_DISABLE_COMPOSITING_MODE=1 yaak-app"
alias yaak="WEBKIT_DISABLE_COMPOSITING_MODE=1 yaak-app"

if (( $+commands[zoxide] )); then
  alias cd='z'
  alias cdi='zi'
fi

alias dot-update='dot add -A && dot commit -m "feat: update dotfiles" && dot push'
alias eou='eos-update'
alias lightsail='ssh -i ~/.ssh/lightsail.pem ubuntu@32.192.116.112'

# Hyprland window/workspace modes & tools
alias hypr-dev='$HOME/.local/bin/hypr-development-mode'
alias hypr-game='$HOME/.local/bin/hypr-game-stream-mode'
alias hypr-focus='$HOME/.local/bin/hypr-focus-mode'
alias hypr-present='$HOME/.local/bin/hypr-presentation-mode'
alias hypr-center='$HOME/.local/bin/hypr-control-center'
alias hypr-swap='$HOME/.local/bin/hypr-swap-monitors'
alias hypr-vibrance='hyprshade toggle vibrance-75'
