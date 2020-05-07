#!/bin/bash
set -e

if [[ -z "$DEV" || -z "$DM" ]]; then
	echo "Run the other script to get DEV/DM set"
	exit 1
fi

echo "Device: ${DEV}"
echo "    DM: ${DM}"

echo
echo "*** Mounting rootfs"
mount /dev/mapper/ubuntu--vg-root /target
for n in proc sys dev etc/resolv.conf; do mount --rbind /$n /target/$n; done

umount /target/boot/efi
umount /target/boot

mount /dev/mapper/LUKS_BOOT /target/boot

mount ${DEV}3 /target/boot/efi

echo
echo "Target mounts:"

mount | grep target

echo
echo "Backing up current GRUB config"
cp -a /target/boot/grub/{grub.cfg,grub-bak.cfg}
cp -a /target/boot/efi/EFI/BOOT/{grub.cfg,grub-bak.cfg}

echo
echo "Entering chroot..."
chroot /target


