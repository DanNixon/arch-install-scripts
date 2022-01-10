#!/bin/sh

set -ex

PATH="$(dirname "$(realpath "$0")")/../scripts:$PATH"

disk='/dev/mmcblk2'
efi_part="${disk}p1"
root_part="${disk}p2"

disk_clear "$disk"
disk_prepare_efi "$disk" "$efi_part"

luks_create "$root_part" root
rootfs_create '/dev/mapper/root'
efifs_mount "$efi_part"

pacman_mirrorlist

install_basic 'linux'

generate_fstab
