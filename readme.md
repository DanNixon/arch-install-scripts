# Arch Linux installation scripts

[![Code Quality](https://github.com/DanNixon/arch_install_scripts/actions/workflows/code_quality.yml/badge.svg?branch=main)](https://github.com/DanNixon/arch_install_scripts/actions/workflows/code_quality.yml)

Bare minimum [Arch Linux](https://archlinux.org/) installation scripts.
Intended to create a system provisioned just enough to then be configured via [Ansible](https://www.ansible.com/).

Tested with [official Arch Linux](https://archlinux.org/) and [Arch Linux 32](https://archlinux32.org/).
Note that `pacman_mirrorlist` and `pacman_keys` steps can (and should) be omitted for Arch Linux 32.

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
