#
# ~/.profile
#

export PATH="$PATH:$HOME/.local/bin"

# General variables
export BROWSER="chromium"
export EDITOR="nvim"
export VISUAL="$EDITOR"
export SABRENT="/run/media/$USER/SABRENT"
export WEBKIT_DISABLE_DMABUF_RENDERER=1

# Manpages
export MANPAGER="less -R -M --use-color -Dd+Y -Du+W -DPkY +Gg"
export MANROFFOPT="-P -c"

# Pager
export LESS='-i -R'

[[ $- == *i* && -f ~/.bashrc ]] && source ~/.bashrc
