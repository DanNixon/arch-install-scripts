# Linode with full disk encryption

See also: https://www.linode.com/docs/guides/use-luks-for-full-disk-encryption/

## Installation

1. Create Linode
  - Select the correct size and location, everything else will be overwritten in step 9
2. Disable Shutdown Watchdog/Lassie
3. Power off Linode
4. Disks
  - Remove existing disks
  - Create 900MB raw disk named *installer*
  - Using all remaining space create raw disk named *root*
5. Boot configurations
  - Remove existing configurations
  - Create *installer* configuration
    - Kernel: *Direct Disk*
    - `/dev/sda`: *root* disk
    - `/dev/sdb`: *installer* disk
    - Boot device: `/dev/sdb`
    - Disable all *Filesystem/Boot Helpers*
  - Create *normal* configuration
    - Kernel: *Direct Disk*
    - `/dev/sda`: *root* disk
    - Boot device: `/dev/sda`
    - Disable all *Filesystem/Boot Helpers*
6. If using the "Nanode 1GB" plan, resize it to the "Linode 2GB" (required to ensure rescue image has a large enough overlay FS to download the Arch ISO)
7. Boot into [Rescue Mode](https://www.linode.com/docs/guides/rescue-and-rebuild/#booting-into-rescue-mode) with *installer* disk mounted as `/dev/sda`
  - Download Arch ISO, e.g. `https://mirrors.melbourne.co.uk/archlinux/iso/2022.04.05/archlinux-2022.04.05-x86_64.iso`
  - Copy to *installer* disk, e.g. `dd if=archlinux-2022.04.05-x86_64.iso of=/dev/sda`
8. If you resized the Linode in step 6, resize it back to the desired size
9. Boot using the *installer* configuration
  - Carry out installation as per [README](../README.md)
10. Boot using the *normal* configuration
