# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
    for rc in ~/.bashrc.d/*; do
        if [ -f "$rc" ]; then
            . "$rc"
        fi
    done
fi
unset rc

# If not running interactively, don't do anything
# [[ $- != *i* ]] && return

PS1="\[\033[38;5;75m\]\w\[\033[00m\] \[\033[00m\]\$ "

set -o vi

# aliases
alias ls='ls --color=auto --hyperlink=auto'
alias grep='grep --color=auto'
alias diff='diff --color'
alias yay="paru"
alias bin="cd $HOME/.local/bin"
alias src="cd $HOME/.local/src"
alias sudo="sudo "
alias dontsleep="setsid -f systemd-inhibit --what=handle-lid-switch --mode=block sleep 20m &"
alias dosleep="pkill systemd-inhibit"

# gnome-specific
alias dconf-dump="dconf dump / > $HOME/.config/dconf-settings.ini"
alias dconf-load="dconf load / < $HOME/.config/dconf-settings.ini"
alias nvimconf="nvim $HOME/.config/nvim/init.lua"
alias odin="ssh -q cap71920@odin.cs.uga.edu"
alias tree="tree -C"
alias open="xdg-open"

# fedora-specific
alias dnf="dnf5"

function git-login() {
    cd ~
    git remote set-url origin git@github.com:carterprince/dotfiles2.git
    git config --global user.email "carteraprince@gmail.com"
    git config --global user.name "Carter Prince"
    echo | ssh-keygen -t ed25519 -C "carteraprince@gmail.com"
    cat $HOME/.ssh/id_ed25519.pub | xsel -ib
    echo "Paste the clipboard here: https://github.com/settings/ssh/new"
}

function e() {
    nvim $(fd --type file --hidden --no-ignore "$@" | awk 'NR == 1 || length < length(shortest) { shortest = $0 } END { print shortest }')
}

function android-uninstall() {
    echo "Uninstalling $1..."
    adb shell pm uninstall -k --user 0 "$1"
    adb uninstall $1
}

./organize.bash 2> /dev/null
