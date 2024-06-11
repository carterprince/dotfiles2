#!/bin/bash

# run this file from the Arch ISO with:
# curl -LO carterprince.us/install.sh && sh install.sh

clear # for dramatic effect

set -e
set -o pipefail

# define some packages
MISC="neovim curl git chromium mpv mpv-mpris nsxiv xsel nerd-fonts-sf-mono adobe-source-han-sans-jp-fonts adobe-source-han-sans-kr-fonts adobe-source-han-sans-cn-fonts man-db man-pages wikiman dashbinsh imagemagick htop neofetch expac bat gvfs-mtp android-tools fd baobab better-adb-sync-git gimp playerctl reflector cronie jdk-openjdk"
LATEX="texlive-latex texlive-latexextra texlive-fontsrecommended"
GNOME="gnome gnome-tweaks"
PACKAGES="$NETWORKING $MISC $LATEX $GNOME" # this is what will be installed

# set the above dynamically based on detected distro (Arch, Fedora, Debian)

# set PACKAGE_MANAGER_CMD dynamically

${PACKAGE_MANAGER_CMD} $PACKAGES

cd $HOME

# install my dotfiles
chuser "git init"
chuser "git remote add origin https://github.com/carterprince/dotfiles2.git"
chuser "git fetch"
chuser "git checkout -f main"

chuser "git config --global user.email 'carteraprince@gmail.com'"
chuser "git config --global user.name 'Carter Prince'"

reboot # btw, you may need to reboot again for chromium and some things to start properly
