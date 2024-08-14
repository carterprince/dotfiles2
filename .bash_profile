#
# ~/.bash_profile
#

export PATH="$PATH:$HOME/.local/bin"

export BROWSER="chromium"
export EDITOR="nvim"
export VISUAL="$EDITOR"
export SABRENT="/run/media/$USER/SABRENT"

# Manpages
export MANPAGER="less -R -M --use-color -Dd+y -Du+W -DPky +Gg"
export MANROFFOPT="-P -c"

# Pager
export LESS='-i -R'

[[ -f ~/.bashrc ]] && source ~/.bashrc
