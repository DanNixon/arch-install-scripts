#!/bin/sh

set -ex

DISK="$1"

TARGET_DIR='/mnt'
MIRRORLIST="https://archlinux.org/mirrorlist/?country=GB&protocol=http&protocol=https&ip_version=4&use_mirror_status=on"

# Clear partition table
sgdisk --zap "$DISK"

# Destroy magic strings and signatures
dd if=/dev/zero of="$DISK" bs=512 count=2048
wipefs --all "$DISK"

# Create boot partition
sgdisk --new=1:0:+1M "$DISK"
sgdisk --typecode=1:ef02 "$DISK"

# Create Btrfs filesystem
sgdisk --largest-new=2 "$DISK"
sgdisk --typecode=2:8304 "$DISK"
mkfs.btrfs -L archroot "${DISK}2"

# Mount Btrfs root
mount "${DISK}2" /mnt

# Create subvolumes
btrfs subvolume create /mnt/@root
btrfs subvolume create /mnt/@home
btrfs subvolume create /mnt/@var_log
btrfs subvolume create /mnt/@snapshots

# Unmount Btrfs root
umount /mnt

# Mount root subvolume
mount -o compress=zstd,subvol=@root "${DISK}2" /mnt

# Create mountpoints for additional subvolumes
mkdir -p \
  /mnt/home \
  /mnt/var/log \
  /mnt/.snapshots

# Mount additional subvolumes
mount -o compress=zstd,subvol=@home "${DISK}2" /mnt/home
mount -o compress=zstd,subvol=@var_log "${DISK}2" /mnt/var/log
mount -o compress=zstd,subvol=@snapshots "${DISK}2" /mnt/.snapshots

# Set mirror list
curl -s "$MIRRORLIST" | sed 's/^#Server/Server/' > /etc/pacman.d/mirrorlist

# Install
pacstrap "$TARGET_DIR" \
  base \
  base-devel \
  btrfs-progs \
  grub \
  gptfdisk \
  iptables-nft \
  linux-lts \
  openssh \
  parted

# Generate fstab
genfstab -U /mnt >> /mnt/etc/fstab
