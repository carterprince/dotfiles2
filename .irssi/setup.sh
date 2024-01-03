#!/bin/bash

source $HOME/.credentials

sed "s/USERNAME_HERE/$IRC_USERNAME/;s/PASSWORD_HERE/$IRC_PASSWORD/;s/NICK_HERE/$IRC_NICK/" config-template > config
