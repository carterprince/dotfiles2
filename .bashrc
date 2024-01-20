#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

schedule

PS1="\[\033[01;32m\]\u@\h\[\033[00m\] \[\033[38;5;75m\][\w]\[\033[00m\] \[\033[00m\]\$ "

set -o vi

# aliases
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias yay="paru"
alias wget="curl -LO" # all my homies hate wget
alias bin="cd $HOME/.local/bin"
alias src="cd $HOME/.local/src"
alias dconf-dump="dconf dump / > $HOME/.config/dconf-settings.ini"
alias dconf-load="dconf load / < $HOME/.config/dconf-settings.ini"
alias nvimconf="nvim $HOME/.config/nvim/init.vim"
function git-login() {
    git config --global user.email "carteraprince@gmail.com"
    git config --global user.name "Carter Prince"
}
function ssh-gen() {
    git-login
    echo | ssh-keygen -t ed25519 -C "carteraprince@gmail.com"
    cat $HOME/.ssh/id_ed25519.pub | xsel -ib
    echo "Paste the clipboard here: https://github.com/settings/ssh/new"
}
function e() {
    nvim $(find | grep "$@" | head -1)
}
function libby-push() {
    libby "$@" && adbsync push $HOME/Books/ /sdcard/Books/
}
function uninstall() {
    echo "Uninstalling $1..."
    adb shell pm uninstall -k --user 0 "$1"
    adb uninstall $1
}
function note() {
    nvim "$(date +'%Y-%M-%d_%_I:%M_%p').md"
}
function fd() {
    find | grep -i "$@"
}
