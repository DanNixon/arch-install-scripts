#!/bin/bash

set -ex

PATH="$(dirname $(realpath $0))/../scripts:$PATH"

disk='/dev/sda'

disk_clear "$disk"
disk_prepare_bios "$disk"

root_part="${disk}2"

rootfs_create "$root_part"

pacman_mirrorlist

install_basic 'linux-lts'

generate_fstab
