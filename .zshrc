#
# carter's .zshrc
#

PROMPT="%F{green}%m%f %F{blue}%~%f $ "

[ -f $HOME/.cache/zsh/.histfile ] || touch $HOME/.cache/zsh/.histfile
HISTFILE="$HOME/.cache/zsh/hist"
HISTSAVE=100000000
HISTSIZE=100000000
HISTFILESIZE=100000000
HISTTIMEFORMAT="%F %T "
setopt EXTENDED_HISTORY
setopt SHARE_HISTORY
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt HIST_REDUCE_BLANKS

setopt autocd
stty stop undef
setopt interactive_comments
unsetopt nomatch
unsetopt PROMPT_SP

# vi mode
bindkey -v
KEYTIMEOUT=1
zmodload zsh/complist
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char
bindkey '^H' backward-kill-word

# aliases
alias yay="paru"
alias bin="cd $HOME/.local/bin"
alias src="cd $HOME/.local/src"
alias ls="ls --color=yes"
alias nvimconf="nvim $HOME/.config/nvim/init.vim"
function e() {
    nvim $(find | grep "$@" | head -1)
}
function libby-push() {
    libby "$@" && adbsync push $HOME/Books/ /sdcard/Books/
}

# plugins
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
