#!/usr/bin/env bash

################################################################################
# My personal script to bootstrap a ubuntu machine with everything I need to   #
# work.                                                                        #
# In continuous update :)                                                      #
################################################################################

#solve timezone problem during dual boot with windows
timedatectl set-local-rtc 1 --adjust-system-clock

my config install vscode
code --install-extension Shan.code-settings-sync