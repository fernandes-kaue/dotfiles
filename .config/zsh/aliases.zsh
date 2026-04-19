alias dot='/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

alias ls='eza -a --icons --group-directories-first --color=always'
alias ll='eza -al --icons --group-directories-first --color=always'
alias tree='eza --tree -a --icons --color=always'
alias cat='bat --style=plain --paging=never'
alias grep='rg'
alias find='fd'

if (( $+commands[zoxide] )); then
  alias cd='z'
  alias cdi='zi'
fi

alias dot-update='dot add -A && dot commit -m "feat: update dotfiles" && dot push'
alias eou='eos-update'

alias ask='gemini'
alias explain="gemini --system 'Explain the following code concisely:'"
