#!/bin/bash

# run this file from the Arch ISO with:
# curl -LO carterprince.us/install.sh && sh install.sh

clear # for dramatic effect

set -e
set -o pipefail

if [[ $1 == "--debug" ]]; then
    set -x
fi

get_input() {
    read -p "$1 (default: $2): " value
    echo "${value:-$2}"
}

HOSTNAME=$(get_input "Enter hostname" "desktop")

# define some packages
MISC="neovim curl git chromium mpv mpv-mpris nsxiv xsel nerd-fonts-sf-mono adobe-source-han-sans-jp-fonts adobe-source-han-sans-kr-fonts adobe-source-han-sans-cn-fonts man-db man-pages wikiman dashbinsh imagemagick htop neofetch expac bat gvfs-mtp android-tools fd baobab better-adb-sync-git gimp playerctl reflector cronie jdk-openjdk"
NETWORKING="dhcpcd networkmanager openssl"
# LATEX="texlive-latex texlive-latexextra texlive-fontsrecommended"
LATEX=""
# GNOME="gnome-shell nautilus gnome-tweaks gnome-control-center gdm xdg-user-dirs papirus-icon-theme gnome-shell-extension-dash-to-dock xdg-desktop-portal-gnome gnome-shell-extension-stealmyfocus-git" # more minimal GNOME install
GNOME=""
CHIPSET=$(lscpu | grep -iq "amd" && echo "amd" || echo "intel")
PACKAGES="$NETWORKING $CHIPSET-ucode $MISC $LATEX $GNOME" # this is what will be installed

TIMEZONE=$(curl -s http://ipinfo.io/timezone)

# show the user their drives
fdisk -l

DISK=$(get_input "Enter disk" "/dev/sda")
if [[ $DISK == *nvme* ]]; then
    PARTITION_PREFIX="p"
else
    PARTITION_PREFIX=""
fi
EFI="${DISK}${PARTITION_PREFIX}1"
SWAP="${DISK}${PARTITION_PREFIX}2"
ROOT="${DISK}${PARTITION_PREFIX}3"

ROOT_PASSWORD=$(get_input "Enter root password" "password")
USERNAME=$(get_input "Enter user" "user")
USER_PASSWORD=$(get_input "Enter $USERNAME's password" "password")

# partition the disks
parted $DISK --script -- mklabel gpt mkpart ESP fat32 1MiB 513MiB set 1 esp on mkpart primary linux-swap 513MiB 32513MiB mkpart primary 32513MiB 100%
# ^ this is a sane layout that should work for most purposes:
# Partition   Size  Type
# ---------   ----  ----------------
# /dev/sda1   512M  EFI System
# /dev/sda2   32G   Linux swap
# /dev/sda3   Rest  Linux filesystem

# format the partitions
mkfs.ext4 $ROOT
mkswap $SWAP
mkfs.fat -F 32 $EFI

# mount the partitions
mount $ROOT /mnt
mount --mkdir $EFI /mnt/boot
swapon $SWAP

# uncomment ParallelDownloads = 5 in /etc/pacman.conf
# just makes the installation a little faster
sed -i 's/#Pa/Pa/' /etc/pacman.conf

# get fastest mirrors
reflector --verbose --country US -l 50 -f 5 --sort score --save /etc/pacman.d/mirrorlist

# install base system, can take a few minutes depending on your download speed
pacstrap -K /mnt base linux linux-firmware sudo base-devel

# copy mirrors over to installed system
cp /etc/pacman.d/mirrorlist /mnt/etc/pacman.d/mirrorlist

# generate /etc/fstab
genfstab -U /mnt >> /mnt/etc/fstab

# set up a function to make this part faster
ch() {
    arch-chroot /mnt "$@"
}

chuser() {
    ch su - $USERNAME -c "$@"
}

# set the timezone
ch ln -sf "/usr/share/zoneinfo/$TIMEZONE" /etc/localtime

# generate /etc/adjtime
ch hwclock --systohc

# set up locale
echo 'en_US.UTF-8 UTF-8' > /mnt/etc/locale.gen
ch locale-gen
echo 'LANG=en_US.UTF-8' > /mnt/etc/locale.conf

# set the hostname, replace with your desired hostname
echo $HOSTNAME > /mnt/etc/hostname

# enable ParallelDownloads and Color on the installed system
sed -i 's/#Pa/Pa/' /mnt/etc/pacman.conf
sed -i "s/#Color/Color/" /mnt/etc/pacman.conf

# set the root password, you want to change this
echo -e "$ROOT_PASSWORD\n$ROOT_PASSWORD" | ch passwd

# add the user, set the user password
ch useradd -m $USERNAME
echo -e "$USER_PASSWORD\n$USER_PASSWORD" | ch passwd $USERNAME

# add user to sudoers
mkdir -p /mnt/etc/sudoers.d
echo "$USERNAME ALL=(ALL) NOPASSWD: ALL" | tee /mnt/etc/sudoers.d/00_$USERNAME

# install paru
URL=$(curl -s https://api.github.com/repos/Morganamilo/paru/releases/latest | grep "x86" | cut -d : -f 2,3 | tr -d \" | tail -1 | awk '{$1=$1};1')
curl -sL $URL | sudo tee /mnt/tmp/paru.tar.zst > /dev/null
tar -xvf /mnt/tmp/paru.tar.zst paru --to-stdout > /mnt/usr/bin/paru
chmod +x /mnt/usr/bin/paru

# install list of packages defined above
chuser "paru -S --noconfirm --needed $PACKAGES"

# install the bootloader
ch bootctl install
echo "title Arch Linux
linux /vmlinuz-linux
initrd $CHIPSET-ucode.img
initrd /initramfs-linux.img
options root=$ROOT rw" > /mnt/boot/loader/entries/arch.conf

# some services
# dhcpcd, needed for ethernet
ch systemctl enable dhcpcd
# NetworkManager, needed for wifi
ch systemctl enable NetworkManager
# gdm, for starting GNOME
ch systemctl enable gdm

# install my dotfiles
chuser "git init"
chuser "git remote add origin https://github.com/carterprince/dotfiles2.git"
chuser "git fetch"
chuser "git checkout -f main"

chuser "git config --global user.email 'carteraprince@gmail.com'"
chuser "git config --global user.name 'Carter Prince'"

# vim plugins
chuser "git clone --depth 1 https://github.com/jiangmiao/auto-pairs /home/$USERNAME/.local/share/nvim/site/pack/plugins/start/auto-pairs"

# st build
chuser "mkdir -p ~/.local/src"
chuser "git clone --depth 1 https://github.com/carterprince/st /home/$USERNAME/.local/src/st"
chuser "cd /home/$USERNAME/.local/src/st && sudo make clean install"

# add chromium policy symlink for automatic browser configuration
ch mkdir -p /etc/chromium/policies/managed
ch ln -sf /home/$USERNAME/.config/chromium-policy.json /etc/chromium/policies/managed/chromium-policy.json

reboot # btw, you may need to reboot again for chromium and some things to start properly
