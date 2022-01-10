# Linx8 tablet

A lot of information was taken from [this](https://www.reddit.com/r/archlinux/comments/m1jfec/booting_arch_linux_on_the_linx_8_64bit_os_with/) Reddit post.

## Initial boot

- Take [`bootia32.efi`](https://raw.githubusercontent.com/jfwells/linux-asus-t100ta/master/boot/bootia32.efi) and put it `/EFI/BOOT/bootia32.efi`.
- Boot the Linx8 and press Esc for boot menu (or hold Vol+ when booting).
- Run `bootia32.efi`.
- Use the following on the GRUB shell to start ArchISO.

```
insmod part_gpt
insmod part_msdos
insmod fat
search --no-floppy --set=root --label ARCH_YYYYMM
linux /arch/boot/x86_64/vmlinuz-linux archisobasedir=arch archisolabel=ARCH_YYYYMM add_efi_memmap
initrd /arch/boot/intel-ucode.img /arch/boot/x86_64/initramfs-linux.img
boot
```
