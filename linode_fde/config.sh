#!/bin/sh

set -ex

PATH="$(dirname "$(realpath "$0")")/../scripts:$PATH"

disk='/dev/sda'
root_part="${disk}3"

set_hostname 'archymcarchface'

initramfs_fde

pacman --noconfirm -Syu grub

sed -i \
  "s|GRUB_CMDLINE_LINUX=\".*\"|GRUB_CMDLINE_LINUX=\"cryptdevice=${root_part}:luks:allow-discards root=/dev/mapper/luks rootflags=subvol=@root rd.luks.options=discard console=ttyS0,19200n8\"|g" \
  /etc/default/grub

mkdir -p /boot/grub
grub-mkconfig -o /boot/grub/grub.cfg
grub-install --target=i386-pc "$disk"

disable_root_login_via_password

user_add 'dan'
user_sudoer 'dan'

network_configuration

pacman_keys
