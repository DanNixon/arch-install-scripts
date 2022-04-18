#!/bin/sh

set -ex

PATH="$(dirname "$(realpath "$0")")/../scripts:$PATH"

disk='/dev/sda'
boot_part="${disk}2"
root_part="${disk}3"

disk_clear "$disk"
disk_prepare_bios_fde "$disk"

luks_create "$root_part" root
rootfs_create '/dev/mapper/root'
boot_mount "$boot_part"

pacman_mirrorlist

install_basic 'linux'

generate_fstab
