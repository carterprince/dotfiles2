#!/bin/bash

# run this file from the Arch ISO with:
# curl -LO carterprince.us/install.sh && bash install.sh

MISC="neovim alacritty curl git chromium mpv mpv-mpris nsxiv xsel ttf-hack adobe-source-han-sans-jp-fonts man-db man-pages wikiman tealdeer zsh dash dashbinsh zsh-syntax-highlighting imagemagick htop neofetch expac transmission-gtk bat gvfs-mtp android-tools kiwix-tools kiwix-desktop fd baobab better-adb-sync-git"
NETWORKING="dhcpcd networkmanager"
UCODE="intel-ucode" # replace with amd-ucode if using AMD
GNOME="gnome-shell nautilus gnome-tweaks gnome-control-center gdm xdg-user-dirs papirus-icon-theme gnome-shell-extension-dash-to-dock xdg-desktop-portal-gnome" # more minimal GNOME install
PACKAGES="$NETWORKING $UCODE $MISC $GNOME" # this is what will be installed

clear # for dramatic effect

set -e
set -o pipefail

if [[ $1 == "--debug" ]]; then
    set -x
fi

# function to get input with default
get_input() {
    read -p "$1 (default: $2): " value
    echo "${value:-$2}"
}

# configuration with prompts
HOSTNAME=$(get_input "Enter hostname" "desktop")
TIMEZONE=$(get_input "Enter timezone" "America/New_York")

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
USER=$(get_input "Enter user" "user")
USER_PASSWORD=$(get_input "Enter $USER's password" "password")

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
ch() { arch-chroot /mnt "$@"; }
ch-user() { ch su - $USER -c "$@" ; }

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
ch useradd -m $USER
echo -e "$USER_PASSWORD\n$USER_PASSWORD" | ch passwd $USER

# add user to sudoers
mkdir -p /mnt/etc/sudoers.d
echo "$USER ALL=(ALL) NOPASSWD: ALL" | tee /mnt/etc/sudoers.d/00_$USER

# install paru
URL=$(curl -s https://api.github.com/repos/Morganamilo/paru/releases/latest | grep "x86" | cut -d : -f 2,3 | tr -d \" | tail -1 | awk '{$1=$1};1')
curl -sL $URL | sudo tee /mnt/tmp/paru.tar.zst > /dev/null
tar -xvf /mnt/tmp/paru.tar.zst paru --to-stdout > /mnt/usr/bin/paru
chmod +x /mnt/usr/bin/paru

# install list of packages defined above
ch-user "paru -S --noconfirm --needed $PACKAGES"

# install the bootloader
ch bootctl install
echo "title Arch Linux
linux /vmlinuz-linux
initrd intel-ucode.img
initrd /initramfs-linux.img
options root=$ROOT rw" > /mnt/boot/loader/entries/arch.conf

# recreate the initramfs image -- maybe we can skip this?
ch mkinitcpio -P

# some services
# dhcpcd, needed for ethernet
ch systemctl enable dhcpcd
# NetworkManager, needed for wifi
ch systemctl enable NetworkManager
# gdm, for starting GNOME
ch systemctl enable gdm

# update tldr cache
# I might remove this, I barely even use it
ch-user "tldr -u"

# install my dotfiles
ch-user "git init"
ch-user "git remote add origin https://github.com/carterprince/dotfiles2.git"
ch-user "git fetch"
ch-user "git checkout -f main"

# add chromium policy symlink for automatic browser configuration
ch mkdir -p /etc/chromium/policies/managed
ch ln -sf /home/$USER/.config/chromium-policy.json /etc/chromium/policies/managed/chromium-policy.json

# set the user shell to zsh
ch chsh -s /bin/zsh $USER

reboot
# btw, you may need to reboot again for chromium and some things to start properly
