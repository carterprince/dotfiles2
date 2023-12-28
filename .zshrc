#
# carter's .zshrc
#

PROMPT="%F{green}%m%f %F{blue}%~%f $ "

# vi mode
bindkey -v
KEYTIMEOUT=1
zstyle ':completion:*' menu select
zmodload zsh/complist
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char

# aliases
alias yay="paru"
alias bin="cd $HOME/.local/bin"
alias src="cd $HOME/.local/src"
alias ls="ls --color=yes"
alias nvimconf="nvim $HOME/.config/nvim/init.vim"

function e() {
    nvim $(find | grep "$@" | head -1)
}

# plugins
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
