#!/bin/bash
set -e

if [[ -z "$DEV" || -z "$DM" ]]; then
	echo "Run the other script to get DEV/DM set"
	exit 1
fi
if [ $(id -u) -ne 0 ]; then
	_echo_err "you missed the 'sudo -i' step in the README.md!"
	echo "You should stay in your superuser session the entire time while doing this!"
	exit 1
fi

echo "Device: ${DEV}"
echo "    DM: ${DM}"

_echo_title "Mounting rootfs"
mount /dev/mapper/ubuntu--vg-root /target
for n in proc sys dev etc/resolv.conf; do mount --rbind /$n /target/$n; done

umount /target/boot/efi
umount /target/boot

#mount /dev/mapper/LUKS_BOOT /target/boot
mount ${DEV}2 /target/boot
mount ${DEV}1 /target/boot/efi

_echo_title "Target mounts"

mount | grep target

#echo
#echo "Backing up current GRUB config"
#cp -a /target/boot/grub/{grub.cfg,grub-bak.cfg}
#cp -a /target/boot/efi/EFI/BOOT/{grub.cfg,grub-bak.cfg}
#
#set +e
#
#echo
#echo "Entering chroot..."
#chroot /target

echo
echo "Enter chroot with:"
echo "chroot /target"
echo
echo "While in chroot, fix grub with:"
echo "grub-install --target=x86_64-efi --removable --boot-directory=/boot --efi-directory=/boot/efi ${DEV}"


