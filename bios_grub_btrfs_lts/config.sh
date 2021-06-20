#!/bin/bash

set -ex

PATH="$(dirname $(realpath $0))/../scripts:$PATH"

disk='/dev/sda'

set_hostname 'archymcarchface'

initramfs_nofde
bootloader_bios '/dev/sda'

disable_root_login_via_password

user_add 'automation'
user_passwordless_sudoer 'automation'

network_configuration

pacman_keys
