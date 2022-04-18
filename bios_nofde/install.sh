#!/bin/bash

set -ex

PATH="$(dirname "$(realpath "$0")")/../scripts:$PATH"

disk='/dev/sda'
root_part="${disk}2"

disk_clear "$disk"
disk_prepare_bios_nofde "$disk"

rootfs_create "$root_part"

pacman_mirrorlist

install_basic 'linux'

generate_fstab
