#!/bin/bash

set -ex

PATH="$(dirname "$(realpath "$0")")/../scripts:$PATH"

set_hostname 'archymcarchface'

initramfs_nofde
bootloader_efi_nofde '/dev/sda'

disable_root_login_via_password

user_add 'automation'
user_passwordless_sudoer 'automation'

network_configuration

pacman_keys
