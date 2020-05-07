#!/bin/bash
set -e

if [[ -z "$DEV" || -z "$DM" ]]; then
	echo "Run the other script to get DEV/DM set"
	exit 1
fi

echo "Device: ${DEV}"
echo "    DM: ${DM}"

apt install -y cryptsetup-initramfs

echo "KEYFILE_PATTERN=/etc/luks/*.keyfile" >> /etc/cryptsetup-initramfs/conf-hook
echo "UMASK=0077" >> /etc/initramfs-tools/initramfs.conf

mkdir /etc/luks
dd if=/dev/urandom of=/etc/luks/boot_os.keyfile bs=4096 count=1

chmod u=rx,go-rwx /etc/luks
chmod u=r,go-rwx /etc/luks/boot_os.keyfile

echo
echo "*** Adding key to LUKS"
echo
echo "    > /boot"
cryptsetup luksAddKey ${DEV}1 /etc/luks/boot_os.keyfile
echo
echo "    > /"
cryptsetup luksAddKey ${DEV}5 /etc/luks/boot_os.keyfile

echo
echo "*** Adding to crypttab"
echo "LUKS_BOOT UUID=$(blkid -s UUID -o value ${DEV}1) /etc/luks/boot_os.keyfile luks,discard" >> /etc/crypttab

echo "${DM}5_crypt UUID=$(blkid -s UUID -o value ${DEV}5) /etc/luks/boot_os.keyfile luks,discard" >> /etc/crypttab

update-initramfs -u -k all

echo "Done :)"
