# Arch Linux installation scripts

[![Code Quality](https://github.com/DanNixon/arch_install_scripts/actions/workflows/code_quality.yml/badge.svg?branch=main)](https://github.com/DanNixon/arch_install_scripts/actions/workflows/code_quality.yml)

## Instructions

- Setup
  - Boot live environment
  - `timedatectl set-ntp true`
  - `pacman -Sy git`
- Installation
  - `git clone https://github.com/DanNixon/arch_install_scripts`
  - Make necessary changes to install stage
  - `./install.sh`
- Configuration
  - `arch-chroot /mnt`
  - `git clone https://github.com/DanNixon/arch_install_scripts`
  - Make necessary changes to configuration stage
  - `./config.sh`
- Finish
  - `exit`
  - `reboot`
