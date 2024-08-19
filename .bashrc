#
# ~/.bashrc
# 

# source global bashrc
[[ -f /etc/bashrc ]] && source /etc/bashrc

# source secret stuff
source $HOME/.credentials

PS1="\[\033[38;5;75m\]\w\[\033[00m\] \[\033[00m\]\$ "

set -o vi

# default util flags
alias ls='ls --color=auto --hyperlink=auto'
alias grep='grep --color=auto'
alias diff='diff --color=auto --unified'
alias tree="tree -C"

# shortcuts
alias bin="cd $HOME/.local/bin && ls"
alias src="cd $HOME/.local/src && ls"
nvimconf() {
    nvim $HOME/.config/nvim/init.lua
    sudo mkdir -p /root/.config/nvim
    sudo cp /home/$USER/.config/nvim/init.lua /root/.config/nvim/init.lua
}
alias odin="ssh -q cap71920@odin.cs.uga.edu"
alias dconf-dump="dconf dump / > $HOME/.config/dconf-settings.ini"
alias dconf-load="dconf load / < $HOME/.config/dconf-settings.ini"
alias vaultdl="spotdl https://open.spotify.com/playlist/3ocO2UJcCOdTdVsIjU6Jac"

# aliases
alias yay="paru"
alias open="xdg-open"
alias up="sudo pacman -Syyu"
alias aurup="yay -Syyu"

# make dnf5 default on fedora -- redundant when Fedora 40 releases
command -v dnf5 &> /dev/null && alias dnf='dnf5' && alias sudo="sudo "
