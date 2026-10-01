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


