#!/bin/bash

# run this file from the Arch ISO with:
# curl -LO carterprince.us/setup.sh && bash setup.sh

clear # for dramatic effect

set -e
set -o pipefail

# detect the distro
if [ -f /etc/os-release ]; then
    . /etc/os-release
    DISTRO=$ID
elif type lsb_release >/dev/null 2>&1; then
    DISTRO=$(lsb_release -si)
else
    echo "Cannot determine the distribution."
    exit 1
fi

# define packages based on distribution
case $DISTRO in
    arch)
        PACKAGE_MANAGER_CMD="pacman -Syu --noconfirm --needed"
        MISC="neovim curl git chromium mpv mpv-mpris nsxiv xsel nerd-fonts-sf-mono adobe-source-han-sans-jp-fonts adobe-source-han-sans-kr-fonts adobe-source-han-sans-cn-fonts man-db man-pages wikiman dashbinsh imagemagick htop neofetch expac bat gvfs-mtp android-tools fd baobab better-adb-sync-git gimp playerctl reflector cronie jdk-openjdk"
        LATEX="texlive-latex texlive-latexextra texlive-fontsrecommended"
        GNOME="gnome gnome-tweaks"
        ;;
    fedora)
        PACKAGE_MANAGER_CMD="dnf install -y"
        MISC="neovim curl git chromium mpv mpv-mpris sxiv xclip google-noto-sans-cjk-jp-fonts google-noto-sans-cjk-kr-fonts google-noto-sans-cjk-sc-fonts man-db man-pages wikiman dashbinsh ImageMagick htop neofetch expac bat gvfs-mtp android-tools findutils baobab gimp playerctl dnf-automatic java-latest-openjdk"
        LATEX="texlive-scheme-full"
        GNOME="gnome-desktop gnome-tweaks"
        ;;
    debian | ubuntu)
        PACKAGE_MANAGER_CMD="apt-get install -y"
        MISC="neovim curl git chromium mpv mpv-mpris sxiv xsel fonts-noto-cjk-extra man-db manpages wikiman imagemagick htop neofetch expac bat gvfs-backends adb findutils baobab gimp playerctl cron anacron openjdk-17-jdk"
        LATEX="texlive-full"
        GNOME="gnome gnome-tweaks"
        ;;
    *)
        echo "Unsupported distribution: $DISTRO"
        exit 1
        ;;
esac

PACKAGES="$MISC $LATEX $GNOME"

# install packages
${PACKAGE_MANAGER_CMD} $PACKAGES

# install my dotfiles
cd $HOME

git init
git remote add origin https://github.com/carterprince/dotfiles2.git
git fetch
git checkout -f main

git config --global user.email 'carteraprince@gmail.com'
git config --global user.name 'Carter Prince'

# btw, you may need to reboot again for chromium and some things to start properly
reboot
