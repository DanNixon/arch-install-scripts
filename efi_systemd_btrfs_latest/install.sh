#!/bin/sh

set -ex

DISK="$1"

TARGET_DIR='/mnt'
MIRRORLIST="https://archlinux.org/mirrorlist/?country=GB&protocol=http&protocol=https&ip_version=4&use_mirror_status=on"

# Clear partition table
sgdisk --zap "$DISK"

# Destroy magic strings and signatures
wipefs --all "$DISK"

# Create boot partition
sgdisk --new=1:0:+512M "$DISK"
sgdisk --typecode=1:ef00 "$DISK"
mkfs.vfat -F 32 -n EFI "${DISK}1"

# Create Btrfs filesystem
sgdisk --largest-new=2 "$DISK"
sgdisk --typecode=2:8304 "$DISK"
mkfs.btrfs --force -L archroot "${DISK}2"

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

# Create mountpoints for additional volumes
mkdir -p \
  /mnt/boot \
  /mnt/home \
  /mnt/var/log \
  /mnt/.snapshots

# Mount additional volumes
mount "${DISK}1" /mnt/boot
mount -o compress=zstd,subvol=@home "${DISK}2" /mnt/home
mount -o compress=zstd,subvol=@var_log "${DISK}2" /mnt/var/log
mount -o compress=zstd,subvol=@snapshots "${DISK}2" /mnt/.snapshots

# Set mirror list
curl -s "$MIRRORLIST" | sed 's/^#Server/Server/' > /etc/pacman.d/mirrorlist

# Install
pacstrap "$TARGET_DIR" \
  amd-ucode \
  base \
  base-devel \
  btrfs-progs \
  gptfdisk \
  intel-ucode \
  iptables-nft \
  linux \
  linux-firmware \
  openssh \
  parted \
  python

# Generate fstab
genfstab -U /mnt >> /mnt/etc/fstab
