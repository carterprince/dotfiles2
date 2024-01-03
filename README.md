# dotfiles2

electric boogaloo

This is where I keep my dotfiles and custom installation script. The [`carterprince.us/install.sh`](https://carterprince.us/install.sh) script on my website loads this repository -- basically [archinstall](https://archinstall.archlinux.page/) but it loads my personal config.

## Overview

List of software included:

- Terminal emulator: [Alacritty](https://github.com/alacritty/alacritty)
- Text editor: [Neovim](https://neovim.io/)
- Desktop environment: [GNOME](https://www.gnome.org/) (with some packages gutted for minimalism)
- Media player: [mpv](https://mpv.io)
- Shell: [zsh](https://www.zsh.org/)
- Web browser: [Chromium](https://www.chromium.org/Home/)

## Install

From the [Arch Linux ISO live environment](https://wiki.archlinux.org/title/installation_guide#Prepare_an_installation_medium) (NOT on an installed system), download and run the [install script](https://carterprince.us/install.sh) hosted on my website:

```zsh
curl -LO carterprince.us/install.sh && bash install.sh
```

If you have a working ethernet connection, the above command should work immediately. If you do not have access to an ethernet connection, you need to connect to WiFi using `iwctl`:

```zsh
iwctl station wlan0 connect <Network SSID>
```

`iwctl` will then prompt you for a password.

If `wlan0` does not work, replace it with your WiFi adapter's name which you can find with `ip link`.

If you've already installed the operating system and want to load only the dotfiles, you can run the following:

```zsh
cd ~
git init
git remote add origin https://github.com/carterprince/dotfiles2.git
git fetch
git checkout -f main
```
