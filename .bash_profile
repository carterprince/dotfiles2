#
# ~/.bash_profile
#

export PATH="$PATH:$HOME/.local/bin"
export SABRENT="/run/media/$USER/SABRENT"

export BROWSER="chromium"
export TERMINAL="st"
export EDITOR="nvim"

# Color in man
export LESS_TERMCAP_mb=$'\e[1;31m'     # begin bold
export LESS_TERMCAP_md=$'\e[1;33m'     # begin blink
export LESS_TERMCAP_so=$'\e[01;44;37m' # begin reverse video
export LESS_TERMCAP_us=$'\e[01;37m'    # begin underline
export LESS_TERMCAP_me=$'\e[0m'        # reset bold/blink
export LESS_TERMCAP_se=$'\e[0m'        # reset reverse video
export LESS_TERMCAP_ue=$'\e[0m'        # reset underline
export GROFF_NO_SGR=1                  # for konsole and gnome-terminal

export __NV_PRIME_RENDER_OFFLOAD=1

[[ -f ~/.bashrc ]] && . ~/.bashrc
