# dotfiles2

This is where I keep my dotfiles.

This is my second attempt (from scratch), where the focus is on making the configuation minimal and functional.

## Overview

List of software included:

- Terminal emulator: [GNOME Terminal](https://gitlab.gnome.org/GNOME/gnome-terminal)
- Text editor: [Neovim](https://neovim.io/)
- Desktop environment: [GNOME](https://www.gnome.org/)
- Media player: [mpv](https://mpv.io)
- Shell: [Bash](https://tiswww.case.edu/php/chet/bash/bashtop.html)
- Web browser: [Chromium](https://www.chromium.org/Home/) -- this is subject to change soon

## Install

```bash
curl -L carterprince.us/dotfiles | sh
```

or

```bash
cd ~
git init
git remote add origin https://github.com/carterprince/dotfiles2.git
git fetch
git checkout -f main
```
