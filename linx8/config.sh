#!/bin/sh

set -ex

PATH="$(dirname "$(realpath "$0")")/../scripts:$PATH"

disk='/dev/mmcblk2'
root_part="${disk}p2"

set_hostname 'archymcarchface'

initramfs_fde
bootloader_grub_efi_fde 'linux' "$root_part"

disable_root_login_via_password

user_add 'dan'
user_sudoer 'dan'

network_configuration

pacman_keys

# Not entirely sure why the Linx8 tries to trigger a suspend every 10 seconds,
# but this is the solution.
cat > /etc/systemd/logind.conf <<EOF
[Login]
HandleSuspendKey=ignore
HandleLidSwitch=ignore
HandleLidSwitchExternalPower=ignore
EOF
