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
export MOZ_LEGACY_PROFILES=1
export MOZ_ALLOW_DOWNGRADE=1
export MOZ_PROFILE="$HOME/.mozilla/firefox/90zxn11k.default"

# Compilation
export MAKEFLAGS="-j8"
export NINJA_JOBS=8
export MESON_TESTTHREADS=8

# Manpages
export MANPAGER="less -R -M --use-color -Dd+Y -Du+W -DPkY +Gg"
export MANROFFOPT="-P -c"

# Pager
export LESS='-i -R'

[[ $- == *i* && -f ~/.bashrc ]] && source ~/.bashrc
