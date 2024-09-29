#
# carter's ~/.bashrc
# 

# source global bashrc
[[ -f /etc/bashrc ]] && source /etc/bashrc

# source secret stuff
[[ -f $HOME/.credentials ]] && source $HOME/.credentials

PS1="\[\033[38;5;75m\]\w\[\033[00m\] \[\033[00m\]\$ "

set -o vi

# default flags for utilities
alias ls='ls --color=auto --hyperlink=auto'
alias grep='grep --color=auto'
alias diff='diff --color=auto --unified'
alias tree="tree -C"

# shortcuts and aliases
alias bin="cd $HOME/.local/bin && ls"
alias src="cd $HOME/.local/src && ls"
nvimconf() {
    nvim $HOME/.config/nvim/init.lua
    sudo mkdir -p /root/.config/nvim
    sudo -v && sudo cp /home/$USER/.config/nvim/init.lua /root/.config/nvim/init.lua
}
alias odin="ssh -q cap71920@odin.cs.uga.edu"
alias open="xdg-open"
alias update-mirrors="sudo reflector --verbose --country US --delay 0.25 --sort rate --save /etc/pacman.d/mirrorlist"
alias dconf-dump="dconf dump / > $HOME/.config/dconf-settings.ini"
alias dconf-load="dconf load / < $HOME/.config/dconf-settings.ini"
alias yay="paru"
alias up="sudo pacman -Syyu"
alias aurup="yay -Syyu"

# make dnf5 default on fedora -- redundant when Fedora 40 releases
command -v dnf5 &> /dev/null && alias dnf='dnf5' && alias sudo="sudo "
