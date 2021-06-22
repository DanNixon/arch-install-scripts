#!/bin/sh

set -ex

PATH="$(dirname "$(realpath "$0")")/../scripts:$PATH"

disk='/dev/sda'

disk_clear "$disk"
disk_prepare_efi "$disk"

efi_part="${disk}1"
root_part="${disk}2"


cryptsetup \
  --cipher aes-xts-plain64 \
  --hash sha512 \
  --use-random \
  --verify-passphrase \
  luksFormat \
  "$root_part"
cryptsetup luksOpen "$root_part" root


rootfs_create '/dev/mapper/root'
efifs_mount "$efi_part"

pacman_mirrorlist

install_basic 'linux'

generate_fstab
