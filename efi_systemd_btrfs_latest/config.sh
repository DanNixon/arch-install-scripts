#!/bin/sh

set -ex

DISK="$1"
HOSTNAME="$2"

# Set hostname
echo "$HOSTNAME" > /etc/hostname

# Create initramfs
sed -i 's/HOOKS=.*/HOOKS=(base udev autodetect modconf block filesystems keyboard fsck btrfs)/' /etc/mkinitcpio.conf
mkinitcpio -P

# Install bootloader
bootctl --path=/boot install

# Configure bootloader
cat > /boot/loader/loader.conf <<EOF
default arch.conf
timeout 3
console-mode max
editor no
EOF

# Configure OS bootloader entry
cat > /boot/loader/entries/arch.conf <<EOF
title Arch Linux
linux /vmlinuz-linux
initrd /amd-ucode.img
initrd /intel-ucode.img
initrd /initramfs-linux.img
options root=${DISK}2 rootflags=subvol=@root rw
EOF

# Disable root password login
passwd -d root
passwd -l root

# Add user
useradd \
  --password "$(openssl passwd -6 'please_change_me_i_am_not_safe')" \
  --user-group \
  --create-home \
  automation

# Make user a sudoer
echo 'automation ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers.d/automation
chmod u=r,g=r,o= /etc/sudoers.d/automation

# Add bare minimum systemd-networkd config
cat > /var/lib/systemd/network/20-ether.network << EOF
[Match]
Type=ether

[Network]
DHCP=yes
EOF

# Ensure required services are enabled
systemctl enable systemd-networkd.service
systemctl enable systemd-resolved.service
systemctl enable sshd.service

# Update pacman keys
pacman-key --init
pacman-key --populate archlinux
