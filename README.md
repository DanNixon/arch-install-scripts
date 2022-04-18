# Arch Linux installation scripts

[![Code Quality](https://github.com/DanNixon/arch-install-scripts/actions/workflows/code_quality.yml/badge.svg?branch=main)](https://github.com/DanNixon/arch-install-scripts/actions/workflows/code_quality.yml)

Bare minimum [Arch Linux](https://archlinux.org/) installation scripts.
Intended to create a system provisioned just enough to then be configured via [Ansible](https://www.ansible.com/).

Tested with [official Arch Linux](https://archlinux.org/) and [Arch Linux 32](https://archlinux32.org/).
Note that `pacman_mirrorlist` and `pacman_keys` steps can (and should) be omitted for Arch Linux 32.

## Instructions

- Setup
  - Boot live environment
  - `timedatectl set-ntp true`
  - `pacman-key --init`
  - `pacman-key --populate archlinux` (or `archlinux32`)
  - `pacman -Sy git`
- Installation
  - `git clone https://github.com/DanNixon/arch-install-scripts`
  - Make necessary changes to install stage
  - `./install.sh`
- Configuration
  - `arch-chroot /mnt`
  - `cd`
  - `git clone https://github.com/DanNixon/arch-install-scripts`
  - Make necessary changes to configuration stage
  - `./config.sh`
  - `cd`
  - `rm -rf arch-install-scripts`
  - Do anything else relevant inside the chroot (e.g. set user passwords)
- Finish
  - `exit`
  - `reboot`
