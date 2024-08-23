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
MISC="neovim curl git chromium mpv mpv-mpris ttf-monaco-nerd-font-git nsxiv xsel nerd-fonts-sf-mono adobe-source-han-sans-jp-fonts adobe-source-han-sans-kr-fonts adobe-source-han-sans-cn-fonts man-db man-pages wikiman dashbinsh imagemagick htop neofetch expac bat gvfs-mtp android-tools fd baobab better-adb-sync-git gimp playerctl reflector cronie jdk-openjdk papirus-icon-theme tealdeer acpi wget python-pipx"
NETWORKING="dhcpcd networkmanager"
LATEX="texlive-latex texlive-latexextra texlive-fontsrecommended"
GNOME="gnome gnome-tweaks dconf-editor adw-gtk3"
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
EFI_PARTITION="${DISK}${PARTITION_PREFIX}1"
SWAP_PARTITION="${DISK}${PARTITION_PREFIX}2"
ROOT_PARTITION="${DISK}${PARTITION_PREFIX}3"

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
mkfs.ext4 $ROOT_PARTITION
mkswap $SWAP_PARTITION
mkfs.fat -F 32 $EFI_PARTITION

# mount the partitions
mount $ROOT_PARTITION $ROOT
mount --mkdir $EFI_PARTITION $ROOT/boot
swapon $SWAP_PARTITION

# root directory prefix
ROOT="/mnt"

# uncomment ParallelDownloads = 5 in /etc/pacman.conf
# just makes the installation a little faster
sed -i 's/#Pa/Pa/' /etc/pacman.conf

# get fastest mirrors
reflector --verbose --country US -l 50 -f 5 --sort score --save /etc/pacman.d/mirrorlist

# install base system, can take a few minutes depending on your download speed
pacstrap -K $ROOT base linux linux-firmware sudo base-devel openssl

# copy mirrors over to installed system
cp /etc/pacman.d/mirrorlist $ROOT/etc/pacman.d/mirrorlist

# generate /etc/fstab
genfstab -U $ROOT >> $ROOT/etc/fstab

# set up a function to make this part faster
ch() {
    arch-chroot $ROOT "$@"
}

chuser() {
    ch su - $USERNAME -c "$@"
}

# set the timezone
ch ln -sf "/usr/share/zoneinfo/$TIMEZONE" /etc/localtime

# generate /etc/adjtime
ch hwclock --systohc

# set up locale
echo 'en_US.UTF-8 UTF-8' > $ROOT/etc/locale.gen
ch locale-gen
echo 'LANG=en_US.UTF-8' > $ROOT/etc/locale.conf

# set the hostname, replace with your desired hostname
echo $HOSTNAME > $ROOT/etc/hostname

# enable ParallelDownloads and Color on the installed system
sed -i 's/#Pa/Pa/' $ROOT/etc/pacman.conf
sed -i "s/#Color/Color/" $ROOT/etc/pacman.conf

# set the root password, you want to change this
echo -e "$ROOT_PASSWORD\n$ROOT_PASSWORD" | ch passwd

# add the user, set the user password
ch useradd -m $USERNAME
echo -e "$USER_PASSWORD\n$USER_PASSWORD" | ch passwd $USERNAME

# add user to sudoers
mkdir -p $ROOT/etc/sudoers.d
echo "$USERNAME ALL=(ALL) NOPASSWD: ALL" | tee $ROOT/etc/sudoers.d/00_$USERNAME

# install paru
URL=$(curl -s https://api.github.com/repos/Morganamilo/paru/releases/latest | grep "x86" | grep https | head -1 | cut -d: -f2,3 | tr -d \" | awk '{$1=$1};1')
curl -sL $URL | sudo tee $ROOT/tmp/paru.tar.zst > /dev/null
tar -xvf $ROOT/tmp/paru.tar.zst paru --to-stdout > $ROOT/usr/bin/paru
chmod +x $ROOT/usr/bin/paru

# install list of packages defined above
chuser "paru -S --noconfirm --needed $PACKAGES"

# install the bootloader
ch bootctl install
echo "title Arch Linux
linux /vmlinuz-linux
initrd $CHIPSET-ucode.img
initrd /initramfs-linux.img
options root=$ROOT_PARTITION rw" > $ROOT/boot/loader/entries/arch.conf

# install hosts
curl -sL http://sbc.io/hosts/hosts | tee $ROOT/etc/hosts > /dev/null

# copy init.lua to root
mkdir -p /mnt/home/root/.config/nvim
cp /mnt/home/$USERNAME/.config/nvim/init.lua /mnt/home/root/.config/nvim/init.lua

# update tealdeer
chuser "tldr -u"

# flatpak gtk theming
chuser "flatpak install -y org.gtk.Gtk3theme.adw-gtk3 org.gtk.Gtk3theme.adw-gtk3-dark"
chuser "flatpak override --filesystem=xdg-config/gtk-3.0"
ch sudo flatpak override --filesystem=xdg-config/gtk-4.0

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

chuser 'dconf load / < $HOME/.config/dconf-settings.ini'

reboot # btw, you may need to reboot again for chromium and some things to start properly
