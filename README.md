# dotfiles2

electric boogaloo

## Install

From the Arch Linux ISO live environment, download and run the [install script](https://carterprince.us/install.sh) hosted on my website:

```zsh
curl -LO carterprince.us/install.sh && bash install.sh
```

If you have a working ethernet connection, the above command should work immediately. If you do not have access to an ethernet connection, you need to connect to WiFi using `iwctl`:

```zsh
iwctl station wlan0 connect <Network SSID>
```

`iwctl` will then prompt you for a password.

If `wlan0` does not work, replace it with your WiFi adapter's name which you can find with `ip link`.

If you've already installed the operating system and want to load the dotfiles, you can run the following:

```zsh
cd ~
git init
git remote add origin https://github.com/carterprince/dotfiles2.git
git fetch
git checkout -f main
```
