HISTFILE=~/.histfile
HISTSIZE=50000
SAVEHIST=50000

setopt autocd
setopt extendedglob
setopt appendhistory
setopt sharehistory
setopt histignorealldups
setopt histignorespace
setopt incappendhistory

unsetopt beep

bindkey -e
