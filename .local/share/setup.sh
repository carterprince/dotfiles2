#!/bin/sh

cd
git init
git remote add origin https://github.com/carterprince/dotfiles2.git
git fetch
git checkout -f main
